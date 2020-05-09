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

<xs:doc info="$Id: CCT2JSON.xsl,v 1.5 2020/04/09 14:55:13 admin Exp $"
        filename="CCT2JSON.xsl" vocabulary="DocBook">
  <xs:title>Convert CCT XSD to JSON Schema</xs:title>
  <para>
    Create a JSON schema fragment from the CEFACT CCT XSD schema fragment.
  </para>
</xs:doc>

<!--========================================================================-->
<xs:doc>
  <xs:title>Invocation parameters and input file</xs:title>
  <para>
    The input is the UN/CEFACT Core Component Type schema module 
    version 1.1 dated 14 January 2005.
  </para>
</xs:doc>

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
  <title>OASIS transliteration of UN/CEFACT Core Component Type schema to JSON</title>
  <description>
This is an expression of UN/CEFACT CCT types as a JSON schema following the
OASIS Business Document Naming and Design Rules Version 1.1.

Version: $Date: 2020/04/09 14:55:13 $UTC

The source XSD information from which this JSON fragment is created is from
the UN/CEFACT file with this metadata:

   Module of Core Component Type
   Agency: UN/CEFACT
   VersionID: 1.1
   Last change: 14 January 2005

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
            <xsl:variable name="c:content"
                     select="if( 1=1 ) then '_'
                                       else replace(@name,'Type$','Content')"/>
            <xsl:for-each select="xsd:simpleContent/xsd:extension">
              <required>
                <_array><xsl:value-of select="$c:content"/></_array>
              </required>
              <properties>
                <xsl:element name="{$c:content}">
                  <type>
                    <xsl:value-of select="
                     if( @base = 'xsd:decimal' ) then 'number' else 'string'"/>
                  </type>
                </xsl:element>
                <xsl:for-each select="xsd:attribute">
                  <xsl:element name="{if( 1=1 ) then @name
                            else translate(xsd:annotation/xsd:documentation/
                                           ccts:DictionaryEntryName,'. ','')}">
                    <type>string</type>
                  </xsl:element>
                </xsl:for-each>
              </properties>
            </xsl:for-each>
            <additionalProperties>false</additionalProperties>
            <type>object</type>
          </xsl:element>
        </xsl:for-each>
      </definitions>
    </xsl:document>
  </xsl:variable>
  <xsl:apply-templates select="$xml" mode="c:json"/>
</xsl:template>

</xsl:stylesheet>