<xsl:stylesheet
    xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0" >
  <xsl:param name="geometry">a5paper</xsl:param>

  <xsl:output method="text" /> 
  

  <xsl:template match="/">
<xsl:text>\documentclass{article}
\usepackage[</xsl:text><xsl:value-of select="$geometry" /><xsl:text>]{geometry} <!-- # per tio ĉi eble fari a5libreton, sed bedaŭrinde ne eblas per mia printilo (ankaŭ ŝanĝu en makedvi) -->
%\usepackage[a4paper, twoside]{geometry}
\usepackage[esperanto,german]{babel}
\usepackage{/usr/local/latex/dotlessj}
\usepackage{charter}
<!--
#   ."\\usepackage{bookman}\n"
#    ."\\usepackage{utopia}\n"
#    ."\\usepackage{newcent}\n"
#    ."\\usepackage{palatcm}\n"
-->
\usepackage{/usr/local/latex/sectsty}
\allsectionsfont{\centering}
<!--
#    ."\\def\\jx{j\\hspace{-0.6ex}\\^{ }}\n"
-->
\def\rim#1{}  % `rimarko'
\def\a#1{
{\normalsize
\hspace*{-5em}\vspace*{-2.5ex}
{\tiny \parbox{5em}{\raggedleft\noindent #1}}
}

}

\def\ax#1{\a{#1}\noindent}

\begin{document}
\input{titolpag.tex}
</xsl:text>

    <xsl:apply-templates select="h:html/h:body" />
\end{document}
  </xsl:template>
  <xsl:template match="h:body">
    <xsl:apply-templates select="h:h1|h:h2|h:p|h:hr" />
  </xsl:template>
  <xsl:template match="h:p">
    <xsl:if test="@id">
      <xsl:text>\a{</xsl:text><xsl:value-of select="@id" /><xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:apply-templates select="text()|h:em" />
    <xsl:text>
    </xsl:text>
  </xsl:template>
  <xsl:template match="h:h2">
\section*{<xsl:apply-templates  select="text()" />}
  </xsl:template>
  <xsl:template match="h:h1">

  </xsl:template>
  <xsl:template match="h:em">
    <xsl:text>{\em </xsl:text><xsl:apply-templates  select="text()" /><xsl:text>}</xsl:text>
  </xsl:template>
  <xsl:template match="h:hr">
    <xsl:text>

      \vspace{2ex}\noindent
    </xsl:text>
  </xsl:template>
</xsl:stylesheet>