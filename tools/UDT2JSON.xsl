<?xml version="1.0" encoding="US-ASCII"?>
<?xml-stylesheet type="text/xsl" href="../xslstyle/xslstyle-docbook.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:c="urn:X-Crane"
                xmlns:ccts="urn:un:unece:uncefact:documentation:2"
                exclude-result-prefixes="xs xsd c ccts"
                version="2.0">

<xsl:import href="RawXML2JSON.xsl"/>

<xs:doc info="$Id: UDT2JSON.xsl,v 1.3 2020/04/11 01:48:26 admin Exp $"
        filename="CCT2JSON.xsl" vocabulary="DocBook">
  <xs:title>Convert UDT XSD to JSON Schema</xs:title>
  <para>
    Create a JSON schema fragment from the BDNDR UDT XSD schema fragment.
  </para>
</xs:doc>

<!--========================================================================-->
<xs:doc>
  <xs:title>Invocation parameters and input file</xs:title>
  <para>
    The input is the XSD for BDNDR (originally from the UBL project)
  </para>
</xs:doc>

<xs:variable>
  <para>The CCTS CCT module</para>
</xs:variable>
<xsl:variable name="c:ccts-cct" as="document-node()"
              select="document(/*/xsd:import/@schemaLocation,/)"/>

<!--========================================================================-->
<xs:doc>
  <xs:title>Main logic</xs:title>
</xs:doc>

<xs:template>
  <para>
    Create the required information in XML and then serialize it as JSON. The
    two-step approach makes the serialization easier.
  </para>
</xs:template>
<xsl:template match="/*">
  <xsl:variable name="xml" as="document-node()">
    <xsl:document>
  <title>OASIS Business Document Naming and Design Rules (BDNDR) Unqualified Types</title>
  <description>
This is an expression of OASIS Unqualified Data Types as a JSON schema
following the OASIS Business Document Naming and Design Rules Version 1.1.

Version: $Date: 2020/04/11 01:48:26 $UTC

Copyright (c) OASIS Open 2016-2020. All Rights Reserved.

OASIS takes no position regarding the validity or scope of any 
intellectual property or other rights that might be claimed to pertain 
to the implementation or use of the technology described in this 
document or the extent to which any license under such rights 
might or might not be available; neither does it represent that it has 
made any effort to identify any such rights. Information on OASIS's 
procedures with respect to rights in OASIS specifications can be 
found at the OASIS website. Copies of claims of rights made 
available for publication and any assurances of licenses to be made 
available, or the result of an attempt made to obtain a general 
license or permission for the use of such proprietary rights by 
implementors or users of this specification, can be obtained from 
the OASIS Executive Director.

OASIS invites any interested party to bring to its attention any 
copyrights, patents or patent applications, or other proprietary 
rights which may cover technology that may be required to 
implement this specification. Please address the information to the 
OASIS Executive Director.

This document and translations of it may be copied and furnished to 
others, and derivative works that comment on or otherwise explain 
it or assist in its implementation may be prepared, copied, 
published and distributed, in whole or in part, without restriction of 
any kind, provided that the above copyright notice and this 
paragraph are included on all such copies and derivative works. 
However, this document itself may not be modified in any way, 
such as by removing the copyright notice or references to OASIS, 
except as needed for the purpose of developing OASIS 
specifications, in which case the procedures for copyrights defined 
in the OASIS Intellectual Property Rights document must be 
followed, or as required to translate it into languages other than 
English. 

The limited permissions granted above are perpetual and will not be 
revoked by OASIS or its successors or assigns. 

This document and the information contained herein is provided on 
an "AS IS" basis and OASIS DISCLAIMS ALL WARRANTIES, 
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO ANY 
WARRANTY THAT THE USE OF THE INFORMATION HEREIN 
WILL NOT INFRINGE ANY RIGHTS OR ANY IMPLIED 
WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A 
PARTICULAR PURPOSE.
</description>
      <definitions>
        <xsl:for-each select="xsd:complexType">
          <xsl:element name="{@name}">
            <xsl:for-each select="xsd:annotation/xsd:documentation">
              <title>
                <xsl:value-of select="ccts:DictionaryEntryName"/>
              </title>
              <description>
                <xsl:value-of select="ccts:Definition"/>
              </description>
            </xsl:for-each>
            <xsl:variable name="c:udtAttributes"
                          select="xsd:simpleContent/
                                  (xsd:extension,xsd:restriction)/
                                  xsd:attribute"/>
            <xsl:variable name="c:udtBaseXSD"
                          select="xsd:simpleContent/
                                  (xsd:extension,xsd:restriction)/
                                  starts-with(@base,'xsd:') "/>
            <xsl:if test="not($c:udtAttributes or $c:udtBaseXSD)">
              <__ref>
                <xsl:value-of select="concat(
                  replace(document-uri($c:ccts-cct),'^(.+/)*(.+)\.xsd$','$2'),
                                               '.json#/definitions/',
                 substring-after(xsd:simpleContent/
                                 (xsd:extension,xsd:restriction)/@base,':'))"/>
              </__ref>
            </xsl:if>
            <xsl:if test="$c:udtAttributes or $c:udtBaseXSD">
              <xsl:for-each select="xsd:simpleContent/
                                    (xsd:extension,xsd:restriction)">
                <xsl:variable name="c:ccts-decl" 
                              select="$c:ccts-cct[not($c:udtBaseXSD)]
              /*/xsd:complexType[@name=substring-after(current()/@base,':')]"/>
                <xsl:variable name="c:decl" 
                              select=" (.,$c:ccts-decl/xsd:simpleContent/
                                          (xsd:extension,xsd:restriction))"/>
                <xsl:variable name="c:attrs" 
                              select="$c:decl/xsd:attribute
                                      [root(.) is root(current()) or
         not(@name=$c:decl/xsd:attribute[root(.) is root(current())]/@name)]"/>
                <required>
                  <_array>
                  <xsl:value-of select="if( 1=1 ) then '_' else
                    replace(($c:ccts-decl,../..)[1]/@name,'Type$','Content')"/>
                  </_array>
                  <xsl:for-each select="$c:attrs[@use='required']">
                    <_array><xsl:value-of select="if( 1=1 ) then @name else
      translate($c:ccts-decl/xsd:simpleContent/(xsd:extension,xsd:restriction)/
                    xsd:attribute[@name=current()/@name]/xsd:annotation/
                    xsd:documentation/ccts:DictionaryEntryName,'. ','')
                    "/></_array>
                  </xsl:for-each>
                </required>
                 <properties>
                   <xsl:element name="{if( 1=1 ) then '_' else
                               replace(../../@name,'Type$','Content')}">
                      <type>
                        <xsl:value-of select="
                        for $base in if( $c:udtBaseXSD ) then @base else
           $c:ccts-decl/xsd:simpleContent/(xsd:restriction,xsd:extension)/@base
                         return if( $base = 'xsd:decimal' ) then 'number'
                                else if( $base='xsd:boolean' ) then 'boolean'
                                else 'string'"/>
                      </type>
                      <xsl:if test="contains(../../@name,'Date') or
                                    contains(../../@name,'Time')">
                        <format>
                          <xsl:value-of 
           select="if( ../../@name='DateType' ) then 'date' else
                   if( ../../@name='TimeType' ) then 'time' else 'date-time'"/>
                        </format>
                      </xsl:if>
                    </xsl:element>
                    <xsl:for-each select="$c:attrs">
                      <xsl:sort select="@name"/>
                      <xsl:element name="{if( 1=1 ) then @name else
translate(xsd:annotation/xsd:documentation/ccts:DictionaryEntryName,'. ','')}">
                       <type>string</type>
                     </xsl:element>
                   </xsl:for-each>
                 </properties>
               <additionalProperties>false</additionalProperties>
               <type>object</type>
             </xsl:for-each>
            </xsl:if>
          </xsl:element>
        </xsl:for-each>
      </definitions>
    </xsl:document>
  </xsl:variable>
  <xsl:apply-templates select="$xml" mode="c:json"/>
</xsl:template>

</xsl:stylesheet>