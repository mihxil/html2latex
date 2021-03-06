ARG ARCH=
FROM ${ARG}debian:bullseye
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install -y git pandoc make imagemagick latexmk xsltproc  texlive-lang-other texlive-latex-extra psutils texlive-xetex texlive-fonts-extra  &&\
    rm /etc/ImageMagick-6/policy.xml
