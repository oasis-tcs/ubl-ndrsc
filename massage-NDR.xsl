<?xml version="1.0" encoding="US-ASCII"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xsd"
                version="2.0">

<xsl:import href="check-UBL-NDR-3.0.xsl"/>

<xsl:output method="xml"/>

<xsl:template match="/">
  <xsl:call-template name="collectRulesNew"/>
  <!--
  <xsl:apply-templates mode="massage" select="//blockquote[@role='rule']">
    <xsl:sort select="informaltable/thead/tr/td"/>
  </xsl:apply-templates>
  -->
</xsl:template>

<xsl:template match="@*|node()"><!--identity for all other nodes-->
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>