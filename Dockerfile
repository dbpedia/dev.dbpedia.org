FROM ubuntu
RUN apt-get update
RUN apt-get install -y jekyll curl > /dev/null
COPY . /root/
RUN cd ~/ && bash generate-markdown.sh
# TODO add crontab
# RUN apt-get install
# RUN crontab -l > tmpcron
# RUN echo "* 0 * * * /root/generate-markdown.sh" >> tmpchron
# RUN crontab tmpcron
CMD cd ~/ && jekyll serve -H 0.0.0.0 -P 80 
