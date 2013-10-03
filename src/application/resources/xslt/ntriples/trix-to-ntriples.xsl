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
	
	<xsl:strip-space elements="*"/>
	
	<xsl:output encoding="ASCII" indent="yes" media-type="text/plain" method="text"/>
	<xsl:output name="escaped-xml" encoding="ASCII" indent="no" 
			media-type="application/xml" method="xml"/>
	
	<xsl:include href="ntriples.xsl"/>
	
	
	
	
	<xsl:template match="/">
		<xsl:apply-templates select="*" mode="ntriples"/>
	</xsl:template>
	
	
	<xsl:template match="trix/graph" mode="ntriples">
		<xsl:for-each-group select="triple" group-by="rdf:subject(.)">
			<xsl:apply-templates select="current-group()" mode="ntriples"/>
		</xsl:for-each-group>
	</xsl:template>
	
	
	<xsl:template match="triple" mode="ntriples">
		<xsl:apply-templates select="rdf:subject(.)" mode="#current"/>
		
		<xsl:value-of select="nt:ws()"/>
		
		<xsl:apply-templates select="rdf:predicate(.)" mode="#current"/>
		
		<xsl:value-of select="nt:ws()"/>
		
		<xsl:apply-templates select="rdf:object(.)" mode="#current"/>
		
		<xsl:value-of select="nt:ws()"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="nt:lf()"/>
	</xsl:template>
	
	
	<xsl:template match="uri" mode="ntriples">
		<xsl:value-of select="nt:uriref(.)"/>
	</xsl:template>
	
	
	<xsl:template match="id" mode="ntriples">
		<xsl:value-of select="nt:node-id(.)"/>
	</xsl:template>
	
	
	<xsl:template match="plainLiteral" mode="ntriples">
		<xsl:value-of select="nt:lang-string(string(), @xml:lang)"/>
	</xsl:template>
	
	
	<xsl:template match="typedLiteral" mode="ntriples">
		<xsl:variable name="outputFormat" as="element()">
			<options xmlns="xdmp:quote">
				<encoding>ASCII</encoding>
				<indent>no</indent>
				<media-type>application/xml</media-type>
				<method>xml</method>
			</options>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="ends-with(@datatype, '#XMLLiteral')">
				<xsl:value-of use-when="system-property('xsl:product-name') eq 'SAXON'"
						select="nt:datatype-string(substring-after(substring-before(nt:escape-string(saxon:serialize(., 'escaped-xml')), '&lt;/typedLiteral&gt;'), '&gt;'), @datatype)"/>
				<xsl:value-of use-when="system-property('xsl:product-name') eq 'MarkLogic Server'"
						select="nt:datatype-string(substring-after(substring-before(nt:escape-string(xdmp:quote(., $outputFormat)), '&lt;/typedLiteral&gt;'), '&gt;'), @datatype)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="nt:datatype-string(string(), @datatype)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- Returns the first node in the triple, the subject. -->
	<xsl:function name="rdf:subject" as="element()">
		<xsl:param name="context" as="element(triple)"/>
		
		<xsl:sequence select="$context/*[1]"/>
	</xsl:function>
	
	
	<!-- Returns the second node in the triple, the predicate. -->
	<xsl:function name="rdf:predicate" as="element()">
		<xsl:param name="context" as="element(triple)"/>
		
		<xsl:sequence select="$context/*[2]"/>
	</xsl:function>
	
	
	<!-- Returns the third node in the triple, the object. -->
	<xsl:function name="rdf:object" as="element()">
		<xsl:param name="context" as="element(triple)"/>
		
		<xsl:sequence select="$context/*[3]"/>
	</xsl:function>
	
	
	
	
	<!-- Returns the passed string as a langString.
		 '"' string '"' '^^' uriref -->
	<xsl:function name="nt:lang-string" as="xs:string">
		<xsl:param name="string" as="xs:string?"/>
		<xsl:param name="language" as="xs:string?"/>
		
		<xsl:choose>
			<xsl:when test="if (string-length($language) gt 0) then matches($language, '[a-z]+(-[A-Z0-9]+)*') else true()">
				<xsl:value-of select="concat('&quot;', nt:escape-string($string), '&quot;', if (string-length($language) gt 0) then concat('@', $language) else '')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="error(xs:QName('err:NT001'), concat('Invalid language code: ''', $language, ''''))"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	
	<!-- Returns the passed string as a datatypeString.
		 '"' string '"' '^^' uriref -->
	<xsl:function name="nt:datatype-string" as="xs:string">
		<xsl:param name="string" as="xs:string?"/>
		<xsl:param name="dataType" as="xs:string?"/>
		
		<xsl:value-of select="concat('&quot;', $string, '&quot;', '^^', nt:uriref($dataType))"/>
	</xsl:function>
	
	
	<!-- Returns the passed reference as a uriref
		 uriref	::=	'<' absoluteURI '>'. -->
	<xsl:function name="nt:uriref" as="xs:string">
		<xsl:param name="ref" as="xs:string"/>
		
		<xsl:value-of select="concat('&lt;', $ref, '&gt;')"/>
	</xsl:function>
	
	
	<!-- Returns the passed reference as a nodeID
		 nodeID	::=	'_:' name. -->
	<xsl:function name="nt:node-id" as="xs:string">
		<xsl:param name="ref" as="xs:string"/>
		
		<xsl:choose>
			<xsl:when test="matches($ref, '[A-Za-z][A-Za-z0-9]*')">
				<xsl:value-of select="concat('_:', if (matches($ref, '^[A-Za-z]')) then '' else 'A', $ref)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="error(xs:QName('err:NT001'), concat('Invalid nodeID: ''', $ref, ''''))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	
	<!-- Returns a line-feed character. -->
	<xsl:function name="nt:lf" as="xs:string">
		<xsl:value-of select="'&#10;'"/>
	</xsl:function>
	
	
	<!-- Returns a whitespace character. -->
	<xsl:function name="nt:ws" as="xs:string">
		<xsl:value-of select="'&#32;'"/>
	</xsl:function>
</xsl:transform>