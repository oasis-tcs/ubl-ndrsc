<?xml version="1.0" encoding="US-ASCII"?>
<?xml-stylesheet type="text/xsl" href="../xslstyle/xslstyle-docbook.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:c="urn:X-Crane"
                exclude-result-prefixes="xs xsd c"
                version="2.0">

<xs:doc info="$Id: RawXML2JSON.xsl,v 1.4 2020/04/09 21:42:17 admin Exp $"
        filename="XMLJSON.xsl" vocabulary="DocBook">
  <xs:title>Convert raw XML to simplified JSON Schema</xs:title>
  <para>
    This is a simple serialization of an XML structure into JSON syntax
    based on primitive rules: elements with element children are objects
    with properties, and elements without element children are properties
    with values.
  </para>
  <para>
    This is assumed to be imported into another stylesheet and not run
    standalone.
  </para>
</xs:doc>

<!--========================================================================-->
<xs:doc>
  <xs:title>Invocation parameters</xs:title>
</xs:doc>

<xs:param ignore-ns="yes">
<para>The output can be indented if desired; set to "no" for continuous</para>
</xs:param>
<xsl:param name="indent" select="'yes'" as="xsd:string"/>

<!--========================================================================-->
<xs:doc>
  <xs:title>Output support</xs:title>
</xs:doc>

<xs:output>
  <para>
    JSON is serialized in text.
  </para>
</xs:output>
<xsl:output method="text"/>

<xs:template>
  <para>Handle an object assuming the top-level is an object</para>
</xs:template>
<xsl:template match="/ | _array" mode="c:json" priority="1">
  <xsl:if test="1=0 and not(parent::node())">
    <xsl:result-document href="debug.xml" indent="yes" method="xml">
      <top>
        <xsl:copy-of select="."/>
      </top>
    </xsl:result-document>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="*">
      <xsl:value-of select='concat("{",c:nl())'/>
      <xsl:apply-templates select="*" mode="c:json"/>
      <xsl:value-of select='concat("}",c:nl())'/>  
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select='concat(c:indent(.),"""",c:escape(.),"""",
                            if(position()=last()) then "" else ",",
                            c:nl())'/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xs:template>
  <para>Handle an array of other objects</para>
</xs:template>
<xsl:template match="*[_array]" mode="c:json" priority="1">
  <xsl:value-of select='concat(c:indent(.),"""",name(.),""": [",c:nl())'/>
  <xsl:apply-templates mode="c:json"/>
  <xsl:value-of select='concat(c:indent(.),"]",
                               if(position()=last()) then "" else ",",
                               c:nl())'/>  
</xsl:template>

<xs:template>
  <para>Handle an object assuming the top-level is an object</para>
</xs:template>
<xsl:template match="*[*]" mode="c:json">
  <xsl:value-of select='concat(c:indent(.),"""",name(.),""": {",c:nl())'/>
  <xsl:apply-templates select="*" mode="c:json"/>
  <xsl:value-of select='concat(c:indent(.),"}",
                               if(position()=last()) then "" else ",",
                               c:nl())'/>  
</xsl:template>

<xs:template>
  <para>Handle property</para>
  <para>Note that the sequence "__" in a name is replaced with "$".</para>
</xs:template>
<xsl:template match="*[not(*)]" mode="c:json">
  <xsl:value-of select='concat(
                            c:indent(.),"""",replace(name(.),"__","\$"),""": ",
                            if( .=("true","false") )
                            then . 
                            else concat("""",c:escape(.),""""),
                            if( position()=last() ) then "" else ",",
                            c:nl())'/>
</xsl:template>

<xs:function>
  <para>Indent the result if requested</para>
  <xs:param name="node">
    <para>Where am I in the source nesting to determine depth?</para>
  </xs:param>
</xs:function>
<xsl:function name="c:indent" as="xsd:string">
  <xsl:param name="node" as="node()"/>
  <xsl:value-of>
    <xsl:if test="lower-case(substring($indent,1,1))='y'">
     <xsl:for-each select="$node/ancestor-or-self::*">
       <xsl:text>  </xsl:text>
     </xsl:for-each>
    </xsl:if>
  </xsl:value-of>
</xsl:function>
  
<xs:function>
  <para>Output a newline sequence if requested</para>
</xs:function>
  <xsl:function name="c:nl" as="xsd:string?">
  <xsl:if test="lower-case(substring($indent,1,1))='y'"><xsl:text>
</xsl:text></xsl:if>
</xsl:function>
  
<xs:function>
  <para>Escape JSON text on the way out</para>
  <xs:param name="node">
    <para>The node whose text value is to be emitted.</para>
  </xs:param>
</xs:function>
<xsl:function name="c:escape" as="text()*">
  <xsl:param name="node" as="node()"/>
  <xsl:value-of select='replace(replace(replace(replace(replace($node,
                                                                "\\","\\\\"),
                                                        "&#x9;","\\t"),
                                                "&#xa;","\\n"),
                                        "&#xd;","\\r"),
                                """","\\""")'/>
</xsl:function>

</xsl:stylesheet>