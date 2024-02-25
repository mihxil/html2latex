<xsl:stylesheet
    xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    expand-text="no"
   version="3.0" >
  <!--
      Converts an HTML file to LaTeX
  -->

  <xsl:param name="geometry">a5paper</xsl:param>
  <xsl:param name="centering"></xsl:param>
  <xsl:param name="language">esperanto</xsl:param>
  <xsl:param name="titolpagxo">titolpag</xsl:param>
  <xsl:param name="figure">wrapfigure</xsl:param>


  <xsl:include href="util.xslt" />

  <xsl:output method="text" />
  <xsl:strip-space  elements="*" />

  <xsl:template match="/">\documentclass{book}
%Auxtomate kreita de latehxigu.xslt
\usepackage[<xsl:value-of select="$geometry" />]{geometry}
\usepackage[esperanto]{babel}
\usepackage{charter}
\usepackage{graphicx}
\usepackage{wrapfig}
\usepackage{hyperref}
\usepackage{textcomp}

\newcommand{\email}[1]{\textlangle{}\href{mailto:#1}{\texttt{#1}}\textrangle{}}


\hypersetup{
  bookmarks=true,
  bookmarksopen=true,
  pdfauthor={<xsl:value-of select="/h:html/h:head/h:meta[@name='author']/@content" />},
  pdftitle={
  <xsl:call-template name="title" />
  },
  pdfkeywords={<xsl:value-of select="/h:html/h:head/h:meta[@name='keywords']/@content" />},
  pdfsubject={<xsl:value-of select="/h:html/h:head/h:meta[@name='description']/@content" />},
  colorlinks=true,
  pdfstartview=FitV,
  linkcolor=blue,
  citecolor=blue,
  urlcolor=blue,
}
<!--
#    ."\\def\\jx{j\\hspace{-0.6ex}\\^{ }}\n"
-->
%\setcounter{tocdepth}{4}
\title{<xsl:call-template name="title" />}
\author{<xsl:value-of select="/h:html/h:head/h:meta[@name='author']/@content" />}
\begin{document}
\input{<xsl:value-of select="$titolpagxo" />}
<xsl:apply-templates select="h:html/h:body" />
\end{document}
  </xsl:template>
  <xsl:template match="h:body">
    <xsl:apply-templates select="h:h1|h:h2|h:p|h:hr|h:div|h:img|h:object" />
  </xsl:template>

  <xsl:template match="h:div[@class='chapter']">
    <xsl:apply-templates select="h:h1|h:h2|h:p|h:hr|h:div|h:img|h:object" />
  </xsl:template>

  <xsl:template match="h:div[@class='par']">
    <xsl:apply-templates select="h:h1|h:h2|h:p|h:hr|h:div|h:img|h:object" />
    <xsl:text>\vspace{2ex}\noindent</xsl:text>
  </xsl:template>

  <xsl:template match="h:div">
  </xsl:template>
  <xsl:template match="h:img">

  </xsl:template>
  <xsl:template match="h:object">
 </xsl:template>

  <xsl:template match="h:img[@class='right' or @class='left']">
    <xsl:variable name="align">
      <xsl:choose>
        <xsl:when test="@class = 'right'">R</xsl:when>
        <xsl:when test="@class = 'left'">L</xsl:when>
      </xsl:choose>
      
    </xsl:variable>
    <xsl:text>
      \begin{</xsl:text><xsl:value-of select="$figure" /><xsl:text>}</xsl:text>
      <xsl:if test="$figure = 'wrapfigure'">
        <xsl:text>{</xsl:text><xsl:value-of select="$align" /><xsl:text>}{0.5\textwidth}</xsl:text>
     </xsl:if>
      <xsl:text>
      \centering
      \includegraphics[width=0.5\textwidth]{</xsl:text>
    <xsl:call-template name="substring-before-last">
      <xsl:with-param name="string1" select="@src" />
      <xsl:with-param name="string2" select="'.'" />
    </xsl:call-template>
      <xsl:text>}
      \em{</xsl:text><xsl:value-of select="@alt" /><xsl:text>}
    \end{</xsl:text><xsl:value-of select="$figure" /><xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="h:object[@class='right']">
    <xsl:text>
      \begin{wrapfigure}{r}{0.5\textwidth}
      \centering
      \includegraphics[width=0.5\textwidth]{</xsl:text>
      <xsl:value-of select="@data" />
      <xsl:text>}
      \em{</xsl:text><xsl:value-of select="@alt" /><xsl:text>}
      \end{wrapfigure}
      </xsl:text>
  </xsl:template>

  <xsl:template match="h:p[@class='kant']">
    <xsl:text>\vspace{1ex}\noindent </xsl:text>
    <xsl:call-template name="p" />
  </xsl:template>

  <xsl:template match="h:p[@class='sub']">
    <xsl:text>\vspace{3ex}\noindent </xsl:text>
    <xsl:call-template name="p" />
  </xsl:template>

  <xsl:template match="h:p">
   <xsl:call-template name="p" />
  </xsl:template>

  <xsl:template name="p">
    <xsl:if test="@id">
     <xsl:text>\phantomsection</xsl:text>
     <!--
     \label{</xsl:text>
      <xsl:value-of  select="substring(@id, 2)" />
      <xsl:text>}</xsl:text>
      -->
      <xsl:text>\addcontentsline{toc}{subsection}{</xsl:text><xsl:value-of  select="substring(@id, 2)" /><xsl:text>}</xsl:text>
     <!--
      <xsl:text>\textsuperscript{\tiny </xsl:text>
      <xsl:value-of select="substring(@id, 2)" />
      <xsl:text>}</xsl:text>
      -->
    </xsl:if>
    <xsl:apply-templates select="text()|h:em|h:br|h:span|h:a|h:img" />
    <xsl:text>

</xsl:text>
  </xsl:template>


  <xsl:template match="h:h2">
   <xsl:choose>
      <xsl:when test="$centering = 'yes'">
        <xsl:text>\section*{\centering </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>\section*{</xsl:text>
     </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates  select="text()|h:a" />
    <xsl:text>}</xsl:text>
    <xsl:text>\addcontentsline{toc}{section}{</xsl:text>
    <xsl:apply-templates  select="text()|h:a" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="h:h1">

  </xsl:template>

  <xsl:template name="normalize">
    <xsl:variable name="start"><xsl:choose><xsl:when test="preceding-sibling::* | preceding-sibling::comment()">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:variable>
    <xsl:variable name="end"><xsl:choose><xsl:when test="following-sibling::* | following-sibling::comment()">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:variable>
    <xsl:variable name="text">
      <xsl:if test="$start = 1">
          <xsl:text>|</xsl:text>
      </xsl:if>
      <xsl:value-of select="." />
      <xsl:if test="$end = 1">
        <xsl:text>|</xsl:text>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="normalized"><xsl:value-of select="normalize-space($text)" /></xsl:variable>
   <xsl:value-of select="substring($normalized, 1 + $start, string-length($normalized) - $start - $end)" />
  </xsl:template>

  <xsl:template match="text()">
    <xsl:call-template name="normalize" />
 </xsl:template>

  <xsl:template match="h:span[@class='noto']" >
    <xsl:text>\footnote{</xsl:text><xsl:apply-templates select="text()|h:span|h:a|h:em" /><xsl:text>} </xsl:text>
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
    <xsl:apply-templates select="text()|h:span|h:a|h:em" />
  </xsl:template>

 
  <xsl:template match="h:span[@class='klar']" >
    <xsl:text>{\textsc </xsl:text><xsl:apply-templates select="text()|h:span|h:a|h:em" /><xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="h:a" >
    <xsl:text>\href{</xsl:text>
    <xsl:call-template name="replace-string">
      <xsl:with-param name="text" select="@href"/>
      <xsl:with-param name="replace" select="'%'" />
      <xsl:with-param name="with" select="'\%'"/>
    </xsl:call-template>
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
  
  <xsl:template name="substring-before-last">
  <xsl:param name="string1" select="''" />
  <xsl:param name="string2" select="''" />

  <xsl:if test="$string1 != '' and $string2 != ''">
    <xsl:variable name="head" select="substring-before($string1, $string2)" />
    <xsl:variable name="tail" select="substring-after($string1, $string2)" />
    <xsl:value-of select="$head" />
    <xsl:if test="contains($tail, $string2)">
      <xsl:value-of select="$string2" />
      <xsl:call-template name="substring-before-last">
        <xsl:with-param name="string1" select="$tail" />
        <xsl:with-param name="string2" select="$string2" />
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
