<xsl:stylesheet
    xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   version="1.0" >

  <xsl:template name="title">
    <xsl:choose>
      <xsl:when test="/h:html/h:head/h:meta[@name='title']">
        <xsl:value-of select="/h:html/h:head/h:meta[@name='title']/@content" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space(/h:html/h:head/h:title/text())" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
