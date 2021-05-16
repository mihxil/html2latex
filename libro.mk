
.PHONY: all latexclean clean docker-build
.INTERMEDIATE: %-a5.tex %-a4.tex %-epub.tex revisio.tex %-epub.metadata

HL=html2latex
DEFAULTDEPS=index.html Makefile $(HL)/libro.mk $(HL)/latehxigu.xslt eo.sed  titolpag.tex revisio.tex
PDFLATEX=latexmk -pdf

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))

all: $(TARGETS) latexclean

revisio.tex: .git
	git log -1 --date=iso  --format=%cd  > $@
	printf %% >> $@
	git rev-parse HEAD >> $@

%-a5.tex: $(DEFAULTDEPS) $(DEPS)
	echo $(DEPS)
	xsltproc -novalid --stringparam centering '$(CENTERING)' $(HL)/latehxigu.xslt index.html  \
	| sed -f eo.sed -f $(HL)/utf8-tex.sed \
	> $@

%-a4.tex: $(DEFAULTDEPS) $(DEPS)
	xsltproc -novalid --stringparam centering '$(CENTERING)' --stringparam geometry a4paper $(HL)/latehxigu.xslt index.html \
	| sed -f eo.sed -f  $(HL)/utf8-tex.sed \
	> $@

%-epub.tex: $(DEFAULTDEPS) $(DEPS)
	xsltproc -novalid --stringparam centering '$(CENTERING)' --stringparam geometry a4paper --stringparam titolpagxo titolpag_epub   $(HL)/latehxigu.xslt index.html \
	| sed -f eo.sed -f  $(HL)/utf8-tex.sed \
	> $@

%.dvi: %.tex
	latexmk -dvi $<

%.signature.ps: %-a5.ps
	psbook -s$(PAGES) $< $@

%.ps: %.dvi
	dvips $< -f > $@

%-libreto.ps:  %.signature.ps
	psnup -d -l -pa4 -Pa5 -2  $< $@

%.pdf: %.tex
	-$(PDFLATEX) $<

%.pdf: %.ps
	ps2pdf $<


%.ps.gz: %.ps
	gzip -f $<

%.eps: %.jpg
	convert $< $@

%.eps: %.jpeg
	convert $< $@

400px-%.jpg: %.jpg
	convert -geometry 400 $< $@

%.epub: %-epub.tex %-epub.metadata revisio.tex
	pandoc -o $@  --epub-metadata=$*-epub.metadata $<
	@#pandoc $< --metadata title="" -o $@



%-epub.metadata: index.html
	xsltproc -novalid   $(HL)/epub-metadata.xslt index.html  > $@

per-docker:
	docker run --rm -v `pwd`/..:/laboro mihxil/html2latex:latest make -C /laboro/$(notdir $(CURDIR))

per-docker-i386:
	docker run --rm -v `pwd`/..:/laboro mihxil/html2latex:i386 make -C /laboro/$(notdir $(CURDIR))

latexclean:
	latexmk -c

clean:
	rm -f  $(TARGETS) $(TARGETS:.pdf=.tex) $(TARGETS:.pdf=.aux) $(TARGETS:.pdf=.out) $(TARGETS:.pdf=.log) $(TARGETS:.pdf=.dvi) $(TARGETS:.epub=-epub.metadata) $(TARGETS:.epub=-epub.tex) revisio.tex *.eps
