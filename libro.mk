
.PHONY: all revisio clean
.PRECIOUS: %.tex %.eps

DEFAULTDEPS=index.html Makefile ../libro.mk ../latehxigu.xslt eo.sed  titolpag.tex revisio.tex
PDFLATEX=pdflatex

all: $(TARGETS)

revisio.tex: .svn
	-@svn up >/dev/null
	date +'%Y-%m-%d' | tr -d "\n" > revisio.tex
	svn info |  grep Revision | awk '{print " r" $$2}' >> revisio.tex

%-a5.tex: $(DEFAULTDEPS) $(DEPS)
	echo $(DEPS)
	xsltproc -novalid --stringparam centering '$(CENTERING)' ../latehxigu.xslt index.html  \
	| sed -f eo.sed -f ../utf8-tex.sed \
	> $@

%-a4.tex: $(DEFAULTDEPS) $(DEPS)
	xsltproc -novalid --stringparam centering '$(CENTERING)' --stringparam geometry a4paper ../latehxigu.xslt index.html \
	| sed -f eo.sed -f  ../utf8-tex.sed \
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


clean:
	rm -f  $(TARGETS) $(TARGETS:.pdf=.tex) $(TARGETS:.pdf=.aux) $(TARGETS:.pdf=.out) $(TARGETS:.pdf=.log) $(TARGETS:.pdf=.dvi) revisio.tex *.eps
