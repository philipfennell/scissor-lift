<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform 
    xmlns="https://github.com/philipfennell/scissor-lift"
    xmlns:iso="http://purl.oclc.org/dsdl/schematron"
    xmlns:sl="https://github.com/philipfennell/scissor-lift"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="#all"
    version="2.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Oct 9, 2013</xd:p>
      <xd:p><xd:b>Author:</xd:b> pfennell</xd:p>
      <xd:p>Converts a scissor-lift 'lift' mapping to an augmented Schematron schema.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:strip-space elements="*"/>
  
  <xsl:output encoding="UTF-8" indent="yes" media-type="application/xml" method="xml"/>
  
  
  <xd:doc>Document root.</xd:doc>
  <xsl:template match="/">
    <xsl:apply-templates select="*" mode="sl:translate"/>
  </xsl:template>
  
  
  <xd:doc>Root element.</xd:doc>
  <xsl:template match="sl:lift" mode="sl:translate">
    <iso:schema queryBinding="xpath">
      <xsl:namespace name="sl">https://github.com/philipfennell/scissor-lift</xsl:namespace>
      <xsl:for-each select="namespace::*[not(. = ('http://www.w3.org/XML/1998/namespace', 'https://github.com/philipfennell/scissor-lift'))]">
        <iso:ns prefix="{name()}" uri="{.}"/>
      </xsl:for-each>
      <xsl:apply-templates select="* | text()" mode="#current"/>
    </iso:schema>
  </xsl:template>
  
  
  <xd:doc>Copy similarly named elements.</xd:doc>
  <xsl:template match="sl:assert | sl:extends | sl:pattern | sl:phase | sl:rule | sl:title" mode="sl:translate">
    <xsl:element name="iso:{local-name()}" namespace="http://purl.oclc.org/dsdl/schematron">
      <xsl:apply-templates select="@*" mode="sl:attributes"/>
      <xsl:apply-templates select="* | text()" mode="#current"/>
    </xsl:element>
  </xsl:template>
  
  
  <xd:doc>Converts a variable to a let instruction.</xd:doc>
  <xsl:template match="sl:variable" mode="sl:translate">
    <iso:let name="{@name}" value="{@select}"/>
  </xsl:template>
  
  
  <xd:doc>Translate a match attribute to test.</xd:doc>
  <xsl:template match="@match" mode="sl:attributes" priority="1">
    <xsl:attribute name="test" select="."/>
  </xsl:template>
  
  
  <xd:doc>Attributes.</xd:doc>
  <xsl:template match="@*" mode="sl:attributes">
    <xsl:attribute name="{name()}" select="."/>
  </xsl:template>
  
  
  <xd:doc>Triple patterns.</xd:doc>
  <xsl:template match="sl:triple" mode="sl:translate">
    <iso:report>
      <xsl:apply-templates select="@*" mode="sl:attributes"/>
      <xsl:apply-templates select="* | text()" mode="sl:triples"/>
    </iso:report>
  </xsl:template>
  
  
  <xd:doc>Triple child elements.</xd:doc>
  <xsl:template match="*" mode="sl:triples">
    <xsl:element name="sl:{local-name()}" namespace="https://github.com/philipfennell/scissor-lift">
      <xsl:apply-templates select="@*" mode="sl:attributes"/>
      <xsl:apply-templates select="* | text()" mode="#current"/>
    </xsl:element>
  </xsl:template>
  
</xsl:transform>