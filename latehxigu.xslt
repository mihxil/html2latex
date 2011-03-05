<xsl:stylesheet
    xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0" >
  <!--
      Converts an HTML file to LaTeX
  -->

  <xsl:param name="geometry">a5paper</xsl:param>
  <xsl:param name="centering"></xsl:param>
  <xsl:param name="language">esperanto</xsl:param>

  <xsl:output method="text" />
  <xsl:strip-space  elements="*" />

  <xsl:template match="/">
    <xsl:text>\documentclass{article}
    %Auxtomate kreita de latehxigu.xslt
\usepackage[</xsl:text><xsl:value-of select="$geometry" /><xsl:text>]{geometry}
\usepackage[esperanto]{babel}
\usepackage{dotlessj}
\usepackage[colorlinks=true, pdfstartview=FitV, linkcolor=blue, citecolor=blue, urlcolor=blue]{hyperref}
\usepackage{charter}
\usepackage{graphicx}
\usepackage{wrapfig}

<!--
#\usepackage[utf8]{inputenc}
#   ."\\usepackage{bookman}\n"
#    ."\\usepackage{utopia}\n"
#    ."\\usepackage{newcent}\n"
#    ."\\usepackage{palatcm}\n"
-->
<!--
#    ."\\def\\jx{j\\hspace{-0.6ex}\\^{ }}\n"
-->
\def\rim#1{}  % `rimarko'
\def\a#1{
<!--
{\normalsize
\hspace*{-5em}\vspace*{-2.5ex}
{\tiny \parbox{5em}{\raggedleft\noindent #1}}

}
-->
}
\def\ax#1{\a{#1}\noindent} </xsl:text>
<xsl:choose>
  <xsl:when test="$centering = 'yes'">
    <xsl:text>\def\cxapitro#1{\section*{\centering #1}}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>\def\cxapitro#1{\section*{#1}}</xsl:text>
  </xsl:otherwise>
</xsl:choose>
<xsl:text>
\begin{document}

\input{titolpag.tex}
</xsl:text>

    <xsl:apply-templates select="h:html/h:body" />
\end{document}
  </xsl:template>
  <xsl:template match="h:body">
    <xsl:apply-templates select="h:h1|h:h2|h:p|h:hr|h:div|h:img" />
  </xsl:template>

  <xsl:template match="h:div[@class='chapter']">
    <xsl:apply-templates select="h:h1|h:h2|h:p|h:hr|h:div|h:img" />
  </xsl:template>
  <xsl:template match="h:div[@class='par']">
    <xsl:apply-templates select="h:h1|h:h2|h:p|h:hr|h:div|h:img" />
    <xsl:text>\vspace{3ex}</xsl:text>
  </xsl:template>
  <xsl:template match="h:div">
  </xsl:template>
  <xsl:template match="h:img">
  </xsl:template>
  <xsl:template match="h:p[@class='sub']">
    <xsl:if test="@id">
      <xsl:text>\a{</xsl:text><xsl:value-of select="@id" /><xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:text>\vspace{3ex}\noindent </xsl:text>
    <xsl:call-template name="p" />
  </xsl:template>
  <xsl:template match="h:img[@class='right']">
    <xsl:text>
      \begin{wrapfigure}{r}{0.5\textwidth}
      \includegraphics[width=0.5\textwidth]{</xsl:text>
      <xsl:value-of select="substring-before(@src, '.jpg')" />
      <xsl:text>}
      \end{wrapfigure}
      </xsl:text>
  </xsl:template>

  <xsl:template match="h:p[@class='kant']">
    <xsl:if test="@id">
      <xsl:text>\a{</xsl:text><xsl:value-of select="@id" /><xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:text>\vspace{1ex}\noindent </xsl:text>
    <xsl:call-template name="p" />
  </xsl:template>

  <xsl:template match="h:p">
    <xsl:if test="@id">
      <xsl:text>\a{</xsl:text><xsl:value-of select="@id" /><xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:call-template name="p" />
  </xsl:template>

  <xsl:template name="p">
    <xsl:apply-templates select="text()|h:em|h:br|h:span|h:a" />
    <xsl:text>

    </xsl:text>
  </xsl:template>


  <xsl:template match="h:h2">
    <xsl:text>\cxapitro{</xsl:text>
    <xsl:apply-templates  select="text()|h:a" />
    <xsl:text>}</xsl:text>
  </xsl:template>
  <xsl:template match="h:h1">

  </xsl:template>

  <xsl:template match="text()">
    <xsl:text> </xsl:text>
    <xsl:value-of select="normalize-space(.)" />
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="h:span[@class='noto']" >
    <xsl:text>\footnote{</xsl:text><xsl:apply-templates select="text()|h:span|h:a" /><xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="h:span[@class='kapo']" >

  </xsl:template>

  <xsl:template match="h:span[@class='kapo grava']" >
    <xsl:copy-of select="text()" /><xsl:text>: </xsl:text>
  </xsl:template>

  <xsl:template match="h:span[@class='ned']" >
  </xsl:template>

  <xsl:template match="h:span[@class='mal']" >
  </xsl:template>

  <xsl:template match="h:span" >
    <xsl:copy-of select="text()|h:a" />
  </xsl:template>

  <xsl:template match="h:a" >    <xsl:value-of select="text()" />
    <xsl:text>\href{</xsl:text>
    <xsl:value-of select="@href" />
    <xsl:text>}{</xsl:text>
    <xsl:value-of select="text()" />
    <xsl:text>}</xsl:text>
  </xsl:template>
  <xsl:template match="h:a[@name]" >
    <xsl:value-of select="text()" />
  </xsl:template>

  <xsl:template match="h:em">
    <xsl:text>{\em </xsl:text><xsl:apply-templates  select="text()|h:a" /><xsl:text>}</xsl:text>
  </xsl:template>
  <xsl:template match="h:br">
    <xsl:text>\\</xsl:text>
  </xsl:template>
</xsl:stylesheet>