
.PHONY: all latexclean clean docker-build
.INTERMEDIATE: %-a5.tex %-a4.tex %-epub.tex revisio.tex %-epub.metadata
.SECONDARY: revisio.txt

HL=html2latex
DEFAULTDEPS=index.html Makefile $(HL)/libro.mk $(HL)/latehxigu.xslt eo.sed  titolpag.tex revisio.tex
PDFLATEX=latexmk -lualatex

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))

all: $(TARGETS) revisio.txt latexclean

revisio.tex: revisio.txt
	cat $<  > $@
	printf %% >> $@
	git rev-parse HEAD >> $@

revisio.txt: .git $(HL)/libro.mk
	git log -1 --date=short  --format=%cd  > $@


%-a5.tex: $(DEFAULTDEPS) $(DEPS)
	echo $(DEPS)
	xsltproc -novalid --stringparam centering '$(CENTERING)' $(HL)/latehxigu.xslt index.html  \
	> $@

%-a4.tex: $(DEFAULTDEPS) $(DEPS)
	xsltproc -novalid --stringparam centering '$(CENTERING)' --stringparam geometry a4paper $(HL)/latehxigu.xslt index.html \
	> $@

%-epub.tex: $(DEFAULTDEPS) $(DEPS)
	xsltproc -novalid --stringparam centering '$(CENTERING)' --stringparam geometry a4paper --stringparam titolpagxo titolpag_epub   $(HL)/latehxigu.xslt index.html \
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

#%.pdf: %.ps
#	ps2pdf $<


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


latexclean:
	latexmk -c

clean:
	rm -f  $(TARGETS) $(TARGETS:.pdf=.tex) $(TARGETS:.pdf=.aux) $(TARGETS:.pdf=.out) $(TARGETS:.pdf=.log) $(TARGETS:.pdf=.dvi) $(TARGETS:.epub=-epub.metadata) $(TARGETS:.epub=-epub.tex) revisio.tex *.eps
