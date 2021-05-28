<xsl:stylesheet
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://dublincore.org/documents/dcmi-namespace/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="h"
  version="1.0">
  <xsl:output method="xml" omit-xml-declaration="yes" indent="yes" />
  <xsl:strip-space elements="*"/>

  <xsl:include href="util.xslt" />
  <xsl:template match="/">
    <dc:language><xsl:value-of select="/h:html/@lang" /></dc:language>
    <xsl:text>
    </xsl:text>
    <dc:identifier><xsl:value-of select="/h:html/h:head/h:meta[@name='url']/@content" /></dc:identifier>
    <xsl:text>
    </xsl:text>
    <dc:title><xsl:call-template name="title" /></dc:title>
    <xsl:text>
    </xsl:text>
    <dc:rights>Creative Commons</dc:rights>
  </xsl:template>
</xsl:stylesheet>
