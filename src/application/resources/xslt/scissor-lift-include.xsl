<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform 
    xmlns:xslt="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:iso="http://purl.oclc.org/dsdl/schematron"
    xmlns:nvdl="http://purl.oclc.org/dsdl/nvdl"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:schold="http://www.ascc.net/xml/schematron"
    xmlns:crdl="http://purl.oclc.org/dsdl/crepdl/ns/structure/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:dtll="http://www.jenitennison.com/datatypes"
    xmlns:dsdl="http://www.schematron.com/namespace/dsdl"
    xmlns:relax="http://relaxng.org/ns/structure/1.0"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:sch-check="http://www.schematron.com/namespace/sch-check"
    version="2.0">
  
  <xsl:import href="iso-schematron-xslt2/iso_dsdl_include.xsl"/>
  
  <xsl:output encoding="UTF-8" indent="yes" media-type="application/xml" method="xml"/>
  
  <xsl:strip-space elements="*"/>
  
  <xsl:template match="iso:extends[@rule]" mode="dsdl:go">
    <xsl:copy-of select="//iso:rule[@abstract eq 'true'][@id eq current()/@rule]/*"/>
  </xsl:template>
  
</xsl:transform>