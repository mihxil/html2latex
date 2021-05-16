FROM debian:bullseye
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install -y git pandoc make imagemagick latexmk xsltproc  texlive-lang-other texlive-latex-extra psutils &&\
    rm /etc/ImageMagick-6/policy.xml


# docker build -t mihxil/html2latex .
