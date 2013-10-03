<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform 
		xmlns:gsp="http://www.w3.org/TR/sparql11-http-rdf-update/"
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		exclude-result-prefixes="#all"
		version="2.0"
		xpath-default-namespace="http://www.w3.org/2004/03/trix/trix-1/">
	
	<xsl:strip-space elements="*"/>
	
	<xsl:output encoding="UTF-8" indent="yes" media-type="application/rdf+xml" method="xml"/>
	
	
	
	
	<xsl:template match="/">
		<xsl:apply-templates select="*"/>
	</xsl:template>
	
	
	<xsl:template match="trix/graph">
		<!-- In-document namespaces. -->
		<xsl:variable name="namespaces" as="element(gsp:namespaces)">
			<gsp:namespaces>
				<xsl:for-each select="../namespace::*">
					<gsp:namespace prefix="{name()}" uri="{.}"/>
				</xsl:for-each>
			</gsp:namespaces>
		</xsl:variable>
		
		<rdf:RDF>
			<!-- Insert the namespace declarations into the RDF/XML serialisation. -->
			<xsl:for-each select="$namespaces/*">
				<xsl:if test="string(@uri) ne 'http://www.w3.org/2004/03/trix/trix-1/'">
					<xsl:namespace name="{@prefix}"><xsl:value-of select="@uri"/></xsl:namespace>
				</xsl:if>
			</xsl:for-each>
			
			<xsl:for-each-group select="triple" group-by="rdf:subject(.)">
				<xsl:variable name="rdfDescription" as="element()">
					<rdf:Description>
						<xsl:choose>
							<xsl:when test="local-name(rdf:subject(.)) eq 'id'">
								<xsl:attribute name="rdf:nodeID" select="rdf:subject(.)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="rdf:about" select="rdf:subject(.)"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:apply-templates select="current-group()" mode="rdf-xml">
							<xsl:with-param name="namespaces" select="$namespaces" as="element()" tunnel="yes"/>
						</xsl:apply-templates>
					</rdf:Description>
				</xsl:variable>
				
				<!-- Re-process the new Description to deal with typed nodes. -->
				<xsl:apply-templates select="$rdfDescription" mode="nodes">
					<xsl:with-param name="namespaces" select="$namespaces" as="element()" tunnel="yes"/>
				</xsl:apply-templates>
			</xsl:for-each-group>
		</rdf:RDF>
	</xsl:template>
	
	
	<!--  -->
	<xsl:template match="rdf:Description[rdf:type]" mode="nodes" priority="1">
		<xsl:param name="namespaces" as="element()" tunnel="yes"/>
		<xsl:variable name="localName" as="xs:string" select="gsp:get-name(rdf:type/@rdf:resource)"/>
		<xsl:variable name="namespace" as="xs:string" select="gsp:get-namespace(rdf:type/@rdf:resource)"/>
		<xsl:variable name="prefix" as="xs:string?" select="gsp:get-namespace-prefix($namespaces, $namespace)"/>
		
		<xsl:element name="{concat($prefix, ':', $localName)}" namespace="{$namespace}">
			<xsl:copy-of select="@*"/>
			<xsl:copy-of select="* except (rdf:type)"/>
		</xsl:element>
	</xsl:template>
	
	
	<!--  -->
	<xsl:template match="rdf:Description" mode="nodes">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	
	<!-- Creates the predicate/object pair. -->
	<xsl:template match="triple" mode="rdf-xml" priority="3">
		<xsl:param name="namespaces" as="element()" tunnel="yes"/>
		<xsl:variable name="localName" as="xs:string" select="gsp:get-name(string(rdf:predicate(.)))"/>
		<xsl:variable name="prefix" as="xs:string?" select="gsp:get-namespace-prefix($namespaces, gsp:get-namespace(string(rdf:predicate(.))))"/>
		
		<xsl:element name="{concat($prefix, if (string-length($prefix) gt 0) then ':' else '', $localName)}" 
				namespace="{gsp:get-namespace(string(rdf:predicate(.)))}">
			<xsl:next-match/>
		</xsl:element>
	</xsl:template>
	
	
	<!-- Resources -->
	<xsl:template match="triple[uri[not(following-sibling::*)]]" mode="rdf-xml" priority="2">
		<xsl:attribute name="rdf:resource" select="rdf:object(.)"/>
	</xsl:template>
	
	
	<!-- Blank Node Refs -->
	<xsl:template match="triple[id[not(following-sibling::*)]]" mode="rdf-xml" priority="2">
		<xsl:attribute name="rdf:nodeID" select="rdf:object(.)"/>
	</xsl:template>
	
	
	<!-- Typed Literals. -->
	<xsl:template match="triple" mode="rdf-xml">
		<xsl:param name="namespaces" as="element()" tunnel="yes"/>
		
		<xsl:copy-of select="rdf:object(.)/@xml:lang"/>
		<xsl:if test="rdf:object(.)/@datatype">
			<xsl:attribute name="rdf:datatype" select="concat(gsp:get-namespace-prefix($namespaces, gsp:get-namespace(rdf:object(.)/@datatype)), ':', gsp:get-name(rdf:object(.)/@datatype))"/>
		</xsl:if>
		<xsl:value-of select="rdf:object(.)"/>
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
	
	
	<!-- Returns the local-name for the predicate. -->
	<xsl:function name="gsp:get-name" as="xs:string">
		<xsl:param name="predicateURI" as="xs:string"/>
		<xsl:variable name="lastStep" as="xs:string" 
				select="if (contains($predicateURI, '/')) then subsequence(reverse(tokenize($predicateURI, '/')), 1, 1) else $predicateURI"/>
		
		<xsl:value-of select="if (contains($lastStep, '#')) then substring-after($lastStep, '#') else $lastStep"/>
	</xsl:function>
	
	
	<!-- Returns the namespace URI for the predicate. -->
	<xsl:function name="gsp:get-namespace" as="xs:string">
		<xsl:param name="predicateURI" as="xs:string"/>
		
		<xsl:value-of select="substring-before($predicateURI, gsp:get-name($predicateURI))"/>
	</xsl:function>
	
	
	<!-- Returns the namespace prefix for the namespace URI. -->
	<xsl:function name="gsp:get-namespace-prefix" as="xs:string?">
		<xsl:param name="namespaces" as="element()"/>
		<xsl:param name="namespaceURI" as="xs:string"/>
		
		<xsl:value-of select="$namespaces/gsp:namespace[@uri eq $namespaceURI]/@prefix"/>
	</xsl:function>
</xsl:transform>