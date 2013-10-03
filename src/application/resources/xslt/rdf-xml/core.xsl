<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
		xmlns:eoi="http://www.oecd.org/eoi"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		exclude-result-prefixes="xs"
		version="2.0">
	
	<xsl:import href="trix-to-rdf-xml.xsl"/>
	
	<xsl:output encoding="UTF-8" indent="yes" media-type="application/rdf+xml" 
			method="xml"/>
	
</xsl:stylesheet>