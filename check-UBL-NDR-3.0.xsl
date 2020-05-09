<?xml version="1.0" encoding="US-ASCII"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xsd"
                version="2.0">

<xsl:output method="html"/>

<xsl:template match="/">
  <html>
    <body>
      <pre>
        <xsl:value-of select="/*/articleinfo/releaseinfo[@role='cvs']"/>
      </pre>
      <xsl:variable name="problems" as="element(p)*">
        <xsl:call-template name="checkRules"/>
      </xsl:variable>
      <xsl:copy-of select="$problems"/>
      <p>Summary of rules:</p>
      <xsl:variable name="rules" as="element(blockquote)*">
        <xsl:call-template name="collectRules"/>
      </xsl:variable>
      <xsl:apply-templates select="$rules" mode="trim"/>
    </body>
  </html>
</xsl:template>

<xsl:template name="checkRules">
  <xsl:for-each select="//blockquote[informaltable]">
    <xsl:sort select="@id"/>
    <xsl:if test="not(@role='rule') or not(@id) or
                  not(informaltable/@frame='all') or
                  not(informaltable/@border='1') or
                 informaltable/thead/tr/td[not(starts-with(.,current()/@id))]">
        <p>Inconsistent: <xsl:value-of select="(informaltable//td)[1]"/></p>
    </xsl:if>
  </xsl:for-each>
  <xsl:for-each-group select="//blockquote[informaltable]" group-by="@id">
    <xsl:sort select="@id"/>
    <xsl:if test="count(current-group())>1">
      <p>Shared identifier: <xsl:value-of select="(informaltable//td)[1]"/></p>
    </xsl:if>
  </xsl:for-each-group>
  <!--
  <xsl:for-each-group select="//blockquote[informaltable]"
                      group-by="substring(@id,1,3)">
    <xsl:sort select="@id"/>
    <xsl:for-each select="current-group()">
      <xsl:variable name="base" select="number(substring(@id,4,2)) idiv 20"/>
      <xsl:if test="not(position() mod 20 + $base * 20 =
                        number(substring(@id,4,2)))">
        <p>Out of position: <xsl:value-of select="$base, position() mod 20, $base * 20, number(substring(@id,4,2)), (informaltable//td)[1]"/></p>
      </xsl:if>
    </xsl:for-each>
  </xsl:for-each-group>
  -->
</xsl:template>
  
<!--short links only, no summary table-->

<xsl:template name="collectRulesNew">
  <xsl:if test="//section[@id='S-CONFORMANCE']/
                (count(preceding-sibling::section)+1 != @conformance)">
    <xsl:message terminate="yes"
      >Mismatched conformance numbering prefix.</xsl:message>
  </xsl:if>
  <xsl:variable name="confPrefix"
                select="//section[@id='S-CONFORMANCE']/@conformance"/>
  <xsl:for-each
    select="//blockquote[not(ancestor::appendix)][@role='rule']/informaltable/
            thead/tr/td">
    <xsl:sort select="ancestor::blockquote[1]/@id"/>
    <para>
      <xsl:value-of select="concat($confPrefix,'.',position()+1,' ')"/>
      <xsl:call-template name="ruleLinkage"/>
    </para>
  </xsl:for-each>
</xsl:template>

<!--"trim" mode to translate DocBook to HTML-->

<xsl:template name="collectRules">
  <xsl:apply-templates mode="massage"
    select="//blockquote[not(ancestor::appendix)][@role='rule']">
    <xsl:sort select="@id"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="@*|node()" mode="trim">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()" mode="trim"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="informaltable" mode="trim">
  <table>
    <xsl:apply-templates select="@*,node()" mode="trim"/>
  </table>
</xsl:template>

<xsl:template match="link" mode="trim">
  <xsl:apply-templates select="node()" mode="trim"/>
</xsl:template>

<!--"massage" mode to create summary of rules for inclusion-->
    
<xsl:template match="@*|node()" mode="massage">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()" mode="massage"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="blockquote[@role='rule']/@id" mode="massage"/>

<xsl:template match="blockquote/@role[.='rule']" mode="massage"/>

<xsl:template match="blockquote[@role='rule']/informaltable/tbody/tr/td"
              mode="massage">
  <xsl:copy>
    <xsl:apply-templates select="@*" mode="massage"/>
    <xsl:apply-templates select="*" mode="massageIgnoreNotes"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="note" mode="massageIgnoreNotes">
</xsl:template>

<xsl:template match="*" mode="massageIgnoreNotes">
  <xsl:copy>
    <xsl:apply-templates select="@*" mode="massage"/>
    <xsl:apply-templates mode="massageIgnoreNotes"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="blockquote[@role='rule']/informaltable/thead/tr/td"
              mode="massage">
  <xsl:copy>
    <xsl:apply-templates select="@*" mode="massage"/>
    <xsl:call-template name="ruleLinkage"/>
  </xsl:copy>
</xsl:template>

<xsl:template name="ruleLinkage">
  <xsl:if test="not(ancestor::blockquote[1]/@id)">
    <xsl:message select="'Missing blockquote id= attribute under id',
                         ancestor::*[@id][1]/@id/string(.)"/>
  </xsl:if>
  <link linkend="{ancestor::blockquote[1]/@id}">
    <xsl:apply-templates select="node()" mode="massage"/>
  </link>
  <xsl:text> </xsl:text>
  <xsl:for-each select="ancestor::section[1]">
    <link linkend="{@id}">
      <xsl:text>(</xsl:text>
      <xsl:number select="." level="multiple"/>
      <xsl:text>)</xsl:text>
    </link>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>