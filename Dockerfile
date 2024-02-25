FROM --platform=${TARGETPLATFORM} debian:bullseye

# xstlproc is still installed, but lets go to saxon 
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install -y git pandoc make imagemagick latexmk default-jre libsaxon-java xsltproc texlive-lang-other texlive-latex-extra psutils texlive-xetex texlive-fonts-extra  &&\
    rm /etc/ImageMagick-6/policy.xml
