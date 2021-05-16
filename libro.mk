
.PHONY: all revisio clean
.INTERMEDIATE: %.tex
.PRECIOUS: %.eps

HL=html2latex
DEFAULTDEPS=index.html Makefile $(HL)/libro.mk $(HL)/latehxigu.xslt eo.sed  titolpag.tex revisio.tex
PDFLATEX=pdflatex

all: $(TARGETS)

revisio.tex: .git
	-@git pull >/dev/null
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
	latex $<

%.signature.ps: %-a5.ps
	psbook -s$(PAGES) $< $@

%.ps: %.dvi
	dvips $< -f > $@


%-libreto.ps:  %.signature.ps
	psnup -d -l -pa4 -Pa5 -2  $< $@


%.pdf: %.tex
	-$(PDFLATEX) $<
	-$(PDFLATEX) $< # another time for the table of contents


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


%.epub: %-epub.tex
	pandoc -o $@  --epub-metadata=epub.metadata $<
	@#pandoc $< --metadata title="" -o $@

%-epub.metadata: index.html

clean:
	rm -f  $(TARGETS) $(TARGETS:.pdf=.tex) $(TARGETS:.pdf=.aux) $(TARGETS:.pdf=.out) $(TARGETS:.pdf=.log) $(TARGETS:.pdf=.dvi) revisio.tex *.eps
