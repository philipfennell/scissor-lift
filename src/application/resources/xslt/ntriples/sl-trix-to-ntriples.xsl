<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform 
    xmlns:err="http://www.marklogic.com/rdf/error"
    xmlns:gsp="http://www.w3.org/TR/sparql11-http-rdf-update/"
    xmlns:nt="http://www.w3.org/ns/formats/N-Triples"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:xdmp="http://marklogic.com/xdmp"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="#all"
    version="2.0"
    xpath-default-namespace="http://www.w3.org/2004/03/trix/trix-1/">
  
  <xsl:import href="trix-to-ntriples.xsl"/>
  
  <xsl:strip-space elements="*"/>
  
  <xsl:output encoding="ASCII" indent="yes" media-type="text/plain" method="xml"/>
  
  
  
  
  
  <xsl:template match="/">
    <output>
      <xsl:apply-templates select="*" mode="ntriples"/>
    </output>
  </xsl:template>
  
  
</xsl:transform>