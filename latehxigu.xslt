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
\usepackage{charter}
\usepackage{graphicx}
\usepackage{wrapfig}
\usepackage[pdftex]{hyperref}

\hypersetup{
  bookmarks=true,
  bookmarksopen=true,
  pdfauthor={</xsl:text><xsl:value-of select="/h:html/h:head/h:meta[@name='author']/@content" /><xsl:text>},
  pdftitle={</xsl:text>
  <xsl:choose>
    <xsl:when test="/h:html/h:head/h:meta[@name='x-pdftitle']">
      <xsl:value-of select="/h:html/h:head/h:meta[@name='x-pdftitle']/@content" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="normalize-space(/h:html/h:head/h:title/text())" />
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>},
  pdfkeywords={</xsl:text><xsl:value-of select="/h:html/h:head/h:meta[@name='keywords']/@content" /><xsl:text>},
  pdfsubject={</xsl:text><xsl:value-of select="/h:html/h:head/h:meta[@name='description']/@content" /><xsl:text>},
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

\begin{document}
\input{titolpag.tex}
</xsl:text>

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

  <xsl:template match="h:img[@class='right']">
    <xsl:text>
      \begin{wrapfigure}{r}{0.5\textwidth}
      \centering
      \includegraphics[width=0.5\textwidth]{</xsl:text>
      <xsl:value-of select="substring-before(@src, '.jpg')" />
      <xsl:text>}
      \em{</xsl:text><xsl:value-of select="@alt" /><xsl:text>}
      \end{wrapfigure}
      </xsl:text>
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
    <xsl:apply-templates select="text()|h:em|h:br|h:span|h:a" />
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
    <xsl:text>\footnote{</xsl:text><xsl:apply-templates select="text()|h:span|h:a" /><xsl:text>} </xsl:text>
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

  <xsl:template match="h:a" >
    <xsl:value-of select="text()" />
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
