<?xml version="1.0" encoding="US-ASCII"?>
<?xml-stylesheet type="text/xsl" href="../../xslstyle/xslstyle-docbook.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
                xmlns:c="urn:X-Crane"
                exclude-result-prefixes="xs xsd c"
                version="2.0">

<xs:doc info="$Id: CCTSXML2JSON.xsl,v 1.11 2020/04/12 16:40:00 admin Exp $"
        filename="CCTSXML2JSON.xsl" vocabulary="DocBook">
  <xs:title>
    Sample conversion of an instance of CCTS XML to JSON format
  </xs:title>
  <para>
    This is not to be considered final in any way.  This is an exercise
    used in the prototyping of potential JSON serializations of CCTS
    documents by converting their XML to JSON syntax.
  </para>
</xs:doc>

<!--========================================================================-->
<xs:doc>
  <xs:title>Invocation parameters and input file</xs:title>
  <para>
    Use the following invocation:
  </para>
  <programlisting>saxon9he -xsl:CCTSXML2JSON.xsl
         {+gc=UBL-Entities-2.1.gc}
         -s:inputXML
         -o:outputJSON</programlisting>
  <para>
    The <literal>+gc=</literal> argument is optional. When supplied, the
    program leverages the type information available in the model definition
    as required by BDNDR 1.0.
    Without such information, the serialization uses anonymous typed content
    and preserves the attribute names from the XML (which are assumed in all
    cases to have been pre-validated with project schemas) as required by
    BDNDR 1.1.
  </para>
</xs:doc>

<xs:output>
  <para>The output is simple text without XML escaping.</para>
</xs:output>
<xsl:output method="text"/>

<xs:param ignore-ns="yes">
<para>The output can be indented if desired; set to "no" for continuous</para>
</xs:param>
<xsl:param name="indent" select="'yes'" as="xsd:string"/>

<xs:param ignore-ns="yes">
<para>The name for extension content</para>
</xs:param>
<xsl:param name="extension-content-regex" select="'^Extension.*$'"/>

<xs:param ignore-ns="yes">
  <para>
    The CCTS dictionary is expressed as a genericode file of properties such
    as the example for UBL found at <ulink url=
      "http://docs.oasis-open.org/ubl/os-UBL-2.1/mod/UBL-Entities-2.1.gc"/>.
  </para>
  <para>
    When this file is absent, the serialization presumes the use of CEFACT
    Unqualified Data Type attribute names and anonymous-typed content.
  </para>
</xs:param>
<xsl:param name="gc" as="document-node(element(gc:CodeList))?"/>

<!--========================================================================-->
<xs:doc>
  <xs:title>Serializing the XML as JSON</xs:title>
</xs:doc>
  
<xs:key>
  <para>Keep track of each BBIE by its XML element name in GC file</para>
</xs:key>
<xsl:key name="c:BBIEbyName"
         match="Row[Value[@ColumnRef='ComponentType']/SimpleValue='BBIE']"
         use="Value[@ColumnRef=('ComponentName','UBLName')]/SimpleValue"/>

<xs:template>
  <para>Getting started...</para>
</xs:template>
<xsl:template match="/*" priority="1">
  <xsl:value-of
        select='concat("{""_D"":""",namespace::*[not(name(.))],""",",c:nl())'/>
  <xsl:value-of select='concat(" ""_A"":""",namespace::cac,""",",c:nl())'/>
  <xsl:value-of select='concat(" ""_B"":""",namespace::cbc,""",",c:nl())'/>
  <xsl:for-each select="namespace::ext">
    <xsl:value-of select='concat(" ""_E"":""",.,""",",c:nl())'/>
  </xsl:for-each>
  <xsl:value-of select='concat(" """,local-name(.),""":[{",c:nl())'/>
  <xsl:call-template name="c:abie"/>
  <xsl:text>}]}</xsl:text>
</xsl:template>

<xs:template>
  <para>Handle an ABIE by grouping its members by their name</para>
</xs:template>
<xsl:template name="c:abie">
  <xsl:for-each-group select="*" group-adjacent="name(.)">
    <xsl:value-of select='concat(c:indent(.),"""",local-name(.),""":[")'/>
    <xsl:apply-templates select="current-group()" mode="#current"/>
    <xsl:value-of select='concat("]",
                                 if(position()=last()) then "" else ",",
                                 c:nl())'/>
  </xsl:for-each-group>
</xsl:template>
  
<xs:template>
  <para>Catch an extension</para>
</xs:template>
<xsl:template match="*[matches(local-name(.),$extension-content-regex)]"
              priority="1">
  <xsl:apply-templates select="." mode="c:extension"/>
</xsl:template>

<xs:template>
  <para>Handle an ASBIE (assumed by having element children)</para>
</xs:template>
<xsl:template match="*[*]" mode="#all">
  <xsl:value-of select='concat("","{",c:nl())'/>
  <xsl:call-template name="c:abie"/>
  <xsl:value-of select='concat(c:indent(.),"}",
                               if(position()=last()) then "" else ",")'/>  
</xsl:template>

<xs:template>
  <para>Handle an extension BBIE</para>
</xs:template>
<xsl:template match="*[not(*)]" mode="c:extension">
  <xsl:text>{"</xsl:text>
  <xsl:if test="exists($gc)">
    <xsl:for-each select="name(.)">
      <xsl:choose>
        <xsl:when test="ends-with(.,'ID') or ends-with(.,'URI')"
                                                         >Identifier</xsl:when>
        <xsl:when test="ends-with(.,'Name')">Name</xsl:when>
        <xsl:when test="ends-with(.,'Code')">Code</xsl:when>
        <xsl:otherwise>Text</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:if>
  <xsl:text>_": "</xsl:text>
  <xsl:value-of select="c:escape(.)"/>
  <xsl:value-of select='concat("""}",
                        if( position()=last() ) then "" else
                            concat(",",c:nl(),c:indent(.)) )'/>
</xsl:template>

<xs:template>
  <para>Handle a BBIE (assumed by having no element children)</para>
</xs:template>
<xsl:template match="*[not(*)]">
  <xsl:variable name="base"
        select="key('c:terms',key('c:BBIEbyName',local-name(.),$gc)/
                Value[@ColumnRef='RepresentationTerm']/SimpleValue,$c:cctInfo)/
                ancestor::type/@base"/>
  <xsl:if test="exists($gc)">
    <xsl:if test="not($base)">
      <xsl:message terminate="yes" select="local-name(.),name($gc/*),
                          count(key('c:BBIEbyName',local-name(.),$gc)),
                          key('c:BBIEbyName',local-name(.),$gc)/
                          Value[@ColumnRef='RepresentationTerm']/SimpleValue"/>
    </xsl:if>
  </xsl:if>  
  <xsl:text>{"</xsl:text>
    <xsl:value-of select="concat(if( exists( $gc ) ) 
                                 then translate($base,'. ','')
                                 else '',
                                 '_')"/>
  <xsl:text>":</xsl:text>
  <xsl:choose>
    <xsl:when test="if( exists( $gc ) ) 
                    then key('c:BBIEbyName',local-name(.),$gc)/
                             Value[@ColumnRef='DataType']/SimpleValue=
                             ('Amount. Type','Measure. Type','Numeric. Type',
                              'Percent. Type','Quantity. Type','Rate. Type')
                    else some $suffix in ( 'Amount', 'Measure', 'Numeric',
                                           'Percent', 'Quantity', 'Rate' )
                         satisfies ends-with( local-name(.), $suffix )">
      <xsl:value-of select="."/>
    </xsl:when>
    <xsl:when test="if( exists( $gc ) ) 
                    then key('c:BBIEbyName',local-name(.),$gc)/
                         Value[@ColumnRef='DataType']/SimpleValue=
                         ('Indicator. Type')
                    else ends-with( local-name(.), 'Indicator' )">
      <xsl:choose>
        <xsl:when test=".=('true','1')">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select='concat("""",c:escape(.),"""")'/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:for-each select="@*">
    <xsl:value-of select='concat(",",c:nl(),c:indent(.),"""",
  if( exists($gc) ) then key("c:cctsAttr",name(.),$base/..)/@name else name(.),
                                 """:""",c:escape(.),"""")'/>
  </xsl:for-each>
  <xsl:value-of select='concat("}",
                               if( position()=last() ) then "" else
                                   concat(",",c:nl(),c:indent(.)) )'/>
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
     <xsl:for-each select="$node/ancestor::*">
       <xsl:text> </xsl:text>
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

<!--========================================================================-->
<xs:doc>
  <xs:title>Interpreting the CCTS properties</xs:title>
</xs:doc>

<xs:key>
  <para>Find CCTS metadata name from attribute name</para>
</xs:key>
<xsl:key name="c:cctsAttr" match="suppl" use="@attr"/>

<xs:key>
  <para>Find CCTS representation term information for BBIE</para>
</xs:key>  
<xsl:key name="c:terms" match="term" use="."/>

<xs:variable>
  <para>
    A distillation of attribute and metadata information distilled from
    <ulink url=
"http://docs.oasis-open.org/ubl/os-UBL-2.1/xsd/common/CCTS_CCT_SchemaModule-2.1.xsd"/>
  </para>
</xs:variable>
<xsl:variable name="c:cctInfo" as="document-node()">
<xsl:document>
 <types>
   <type base="Amount">
      <terms>
         <term>Amount</term>
      </terms>
      <suppls>
         <suppl attr="currencyID" name="AmountCurrencyIdentifier"/>
         <suppl attr="currencyCodeListVersionID"
                name="AmountCurrencyCodeListVersionIdentifier"/>
      </suppls>
   </type>
   <type base="Binary Object">
      <terms>
         <term>Binary Object</term>
         <term>Graphic</term>
         <term>Picture</term>
         <term>Sound</term>
         <term>Video</term>
      </terms>
      <suppls>
         <suppl attr="format" name="BinaryObjectFormatText"/>
         <suppl attr="mimeCode" name="BinaryObjectMimeCode"/>
         <suppl attr="encodingCode" name="BinaryObjectEncodingCode"/>
         <suppl attr="characterSetCode" name="BinaryObjectCharacterSetCode"/>
         <suppl attr="uri" name="BinaryObjectUniformResourceIdentifier"/>
         <suppl attr="filename" name="BinaryObjectFilenameText"/>
      </suppls>
   </type>
   <type base="Code">
      <terms>
         <term>Code</term>
      </terms>
      <suppls>
         <suppl attr="listID" name="CodeListIdentifier"/>
         <suppl attr="listAgencyID" name="CodeListAgencyIdentifier"/>
         <suppl attr="listAgencyName" name="CodeListAgencyNameText"/>
         <suppl attr="listName" name="CodeListNameText"/>
         <suppl attr="listVersionID" name="CodeListVersionIdentifier"/>
         <suppl attr="name" name="CodeNameText"/>
         <suppl attr="languageID" name="LanguageIdentifier"/>
         <suppl attr="listURI" name="CodeListUniformResourceIdentifier"/>
         <suppl attr="listSchemeURI" name="CodeListSchemeUniformResourceIdentifier"/>
      </suppls>
   </type>
   <type base="Date Time">
      <terms>
         <term>Date Time</term>
      </terms>
      <suppls>
         <suppl attr="format" name="DateTimeFormatText"/>
      </suppls>
   </type>
   <type base="Date">
      <terms>
         <term>Date</term>
      </terms>
      <suppls>
         <suppl attr="format" name="DateFormatText"/>
      </suppls>
   </type>
   <type base="Time">
      <terms>
         <term>Time</term>
      </terms>
      <suppls>
         <suppl attr="format" name="TimeFormatText"/>
      </suppls>
   </type>
   <type base="Identifier">
      <terms>
         <term>Identifier</term>
      </terms>
      <suppls>
         <suppl attr="schemeID" name="IdentificationSchemeIdentifier"/>
         <suppl attr="schemeName" name="IdentificationSchemeNameText"/>
         <suppl attr="schemeAgencyID" name="IdentificationSchemeAgencyIdentifier"/>
         <suppl attr="schemeAgencyName" name="IdentificationSchemeAgencyNameText"/>
         <suppl attr="schemeVersionID" name="IdentificationSchemeVersionIdentifier"/>
         <suppl attr="schemeDataURI"
                name="IdentificationSchemeDataUniformResourceIdentifier"/>
         <suppl attr="schemeURI" name="IdentificationSchemeUniformResourceIdentifier"/>
      </suppls>
   </type>
   <type base="Indicator">
      <terms>
         <term>Indicator</term>
      </terms>
      <suppls>
         <suppl attr="format" name="IndicatorFormatText"/>
      </suppls>
   </type>
   <type base="Measure">
      <terms>
         <term>Measure</term>
      </terms>
      <suppls>
         <suppl attr="unitCode" name="MeasureUnitCode"/>
         <suppl attr="unitCodeListVersionID"
                name="MeasureUnitCodeListVersionIdentifier"/>
      </suppls>
   </type>
   <type base="Numeric">
      <terms>
         <term>Numeric</term>
         <term>Value</term>
         <term>Rate</term>
         <term>Percent</term>
      </terms>
      <suppls>
         <suppl attr="format" name="NumericFormatText"/>
      </suppls>
   </type>
   <type base="Quantity">
      <terms>
         <term>Quantity</term>
      </terms>
      <suppls>
         <suppl attr="unitCode" name="QuantityUnitCode"/>
         <suppl attr="unitCodeListID" name="QuantityUnitCodeListIdentifier"/>
         <suppl attr="unitCodeListAgencyID" name="QuantityUnitCodeListAgencyIdentifier"/>
         <suppl attr="unitCodeListAgencyName" name="QuantityUnitCodeListAgencyNameText"/>
      </suppls>
   </type>
   <type base="Text">
      <terms>
         <term>Text</term>
         <term>Name</term>
      </terms>
      <suppls>
         <suppl attr="languageID" name="LanguageIdentifier"/>
         <suppl attr="languageLocaleID" name="LanguageLocaleIdentifier"/>
      </suppls>
   </type>
 </types>
</xsl:document>
</xsl:variable>

</xsl:stylesheet>