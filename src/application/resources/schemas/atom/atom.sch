<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.0" queryBinding="xpath2">
  
  <ns uri="http://www.w3.org/1999/XSL/Transform" prefix="xsl"/>
  <ns uri="http://www.studentlitteratur.se/word-roundtrip/styles/" prefix="sls"/>
  <title>Validates Context Annotations created in an XSLT transform.</title>
  
  <pattern>
    <title>Attribute Predicates</title>
    
    <rule context="/xsl:transform/xsl:template[@xml:id eq 'test0101']">
      <assert test="xsl:copy/sls:element">The sls:element must exist.</assert>
      <assert test="xsl:copy/sls:element[@name eq 'para']">Element's name attribute must equal 'para'.</assert>
      <assert test="count(xsl:copy/sls:element/sls:attribute) = 1">There must be only 1 sls:attribute element.</assert>
      <assert test="xsl:copy/sls:element/sls:attribute[@name eq 'id']">Element's 'id' attribute description must exist.</assert>
      <assert test="xsl:copy/sls:element/sls:attribute[@value eq 'x123']">Attribute's 'value' attribute must equal 'x123'.</assert>
    </rule>
  </pattern>
</schema>