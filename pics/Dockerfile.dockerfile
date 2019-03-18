FROM tenforce/virtuoso

ARG endpoint="https://databus.dbpedia.org/repo/sparql"
ARG default_graph="http://localhost:8890/dbpedia"
# memory in MByte
ARG buffer_memory="4096"

RUN apt-get update \
  && apt-get -y install curl lbzip2 pigz

RUN echo "ld_dir_all('toLoad', '*', '"$default_graph"');\n\
rdf_loader_run();\nexec('checkpoint');" > /load_data.sql

RUN echo 'response=$(curl -s \\\n\
  --data-urlencode format=text/tab-separated-values \\\n\
  --data-urlencode query="$*" '$endpoint')\n\
req_err=$(echo $response | grep "Virtuoso\|Error\SPARQL")\n\
if [ -z "$req_err" ]; then\n\
  echo "$response" | tail -n+2 | sed "s/\"//g"\n\
else\n\
  >&2 echo "$response"\n\
fi' > /sparql.sh

RUN echo 'for single_file_url in $*\n\
do\n\
  file_name=${single_file_url##*/}\n\
  tmp=${single_file_url%/*}\n\
  version=${tmp##*/}\n\
  tmp=${tmp%/*}\n\
  artifact=${tmp##*/}\n\
  if [ ! -d "/data/toLoad/$artifact/$version/" ]; then\n\
    mkdir -p "/data/toLoad/$artifact/$version/"\n\
  fi\n\
  if [ ! -f "/data/toLoad/$artifact/$version/$file_name.gz" ]; then\n\
    echo "download: $artifact $version $file_name"\n\
    curl $single_file_url | lbzip2 -dc | pigz > "/data/toLoad/$artifact/$version/$file_name.gz"\n\
  else\n\
    echo "skip: /data/toLoad/$artifact/$version/$file_name"\n\
  fi\n\
done' > /download.sh

RUN crudini --set /virtuoso.ini Parameters MaxDirtyBuffers $((62*$buffer_memory)) \
  && crudini --set /virtuoso.ini Parameters NumberOfBuffers $((84*$buffer_memory))

RUN echo 'if [ ! -f "/settings/.config_set" ] && [ -f /data/virtuoso.ini ]; then\n\
  echo "setting: NumberofBuffers $((84*'$buffer_memory'))"\n\
  crudini --set /data/virtuoso.ini Parameters NumberOfBuffers $((84*'$buffer_memory'))\n\
  echo "setting: MaxDirtyBuffers $((62*'$buffer_memory'))"\n\
  crudini --set /data/virtuoso.ini Parameters MaxDirtyBuffers $((62*'$buffer_memory'))\n\
fi\n\
bash /download.sh $(bash /sparql.sh "$*")\n\
bash /virtuoso.sh' > /run.sh

ENTRYPOINT ["/bin/bash","/run.sh"]
