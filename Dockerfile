FROM ubuntu
RUN apt-get update
RUN apt-get install -y apache2 jekyll curl > /dev/null
RUN mkdir ~/jekyll && jekyll new ~/jekyll
COPY ./generate-markdown.sh /root/
COPY ./readme-list.tsv /root/
# TODO share readme-list.tsv
COPY ./src/ /root/jekyll/
RUN cd ~/ && bash generate-markdown.sh
# TODO add crontab
# RUN apt-get install
# RUN crontab -l > tmpcron
# RUN echo "* 0 * * * /root/generate-markdown.sh" >> tmpchron
# RUN crontab tmpcron
CMD cd ~/jekyll/ && jekyll serve -H 0.0.0.0 -P 4000 
