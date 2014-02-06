<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform 
		xmlns="http://www.w3.org/2004/03/trix/trix-1/"
		xmlns:err="http://www.marklogic.com/rdf/error"
		xmlns:gsp="http://www.w3.org/TR/sparql11-http-rdf-update/"
		xmlns:math="http://exslt.org/math"
		xmlns:nt="http://www.w3.org/ns/formats/N-Triples"
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
		xmlns:trix="http://www.w3.org/2004/03/trix/trix-1/"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		exclude-result-prefixes="#all"
		version="2.0">
	
	<xsl:strip-space elements="*"/>
	
	<xsl:character-map name="ntriples">
		<xsl:output-character character="&#9;" string="&amp;#9;"/>
		<xsl:output-character character="&#10;" string="&amp;#10;"/>
		<xsl:output-character character="&#13;" string="&amp;#13;"/>
		<!--<xsl:output-character character="&#38;" string="&amp;"/>-->
	</xsl:character-map>
	
	
	
	
	<!-- Escape special characters in a plain literal string. -->
	<xsl:function name="nt:escape-string" as="xs:string">
		<xsl:param name="unescapedString" as="xs:string"/>
		<xsl:variable name="escapeSequences" as="element()+">
			<escape match="\\"><xsl:text>\\\\</xsl:text></escape>
			<escape match="\t"><xsl:text>\\t</xsl:text></escape>
			<escape match="\n"><xsl:text>\\n</xsl:text></escape>
			<escape match="\r"><xsl:text>\\r</xsl:text></escape>
			<escape match='"'><xsl:text>\\"</xsl:text></escape>
		</xsl:variable>
		<xsl:value-of select="nt:escape-string($unescapedString, $escapeSequences)"/>
	</xsl:function>
	
	
	<!-- Escape special characters in a plain literal string. -->
	<xsl:function name="nt:escape-string" as="xs:string">
		<xsl:param name="unescapedString" as="xs:string"/>
		<xsl:param name="escapeSequences" as="element()*"/>
		
		<xsl:choose>
			<xsl:when test="exists(nt:head($escapeSequences))">
				<xsl:value-of select="nt:escape-string(
							replace($unescapedString, nt:head($escapeSequences)/@match, nt:head($escapeSequences)/text()), 
									nt:tail($escapeSequences))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="result">
					<xsl:analyze-string select="$unescapedString" regex="(&amp;#x)([0-9A-F]{{2,8}})" flags="i">
						<xsl:matching-substring><xsl:value-of select="concat('\u', regex-group(2))"/></xsl:matching-substring>
						<xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
					</xsl:analyze-string>
				</xsl:variable>
				<xsl:value-of select="nt:escape-non-ascii(string-join($result, ''))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	
	<!--  -->
	<xsl:function name="nt:unescape-string" as="xs:string">
		<xsl:param name="escapedString" as="xs:string"/>
		<xsl:variable name="escapeSequences" as="element()+">
			<escape match="\\t"><xsl:text>&#9;</xsl:text></escape>
			<escape match="\\n"><xsl:text>&#10;</xsl:text></escape>
			<escape match="\\r"><xsl:text>&#13;</xsl:text></escape>
			<escape match="\\u"><xsl:text>\\u</xsl:text></escape>
			<escape match='\\"'><xsl:text>"</xsl:text></escape>
			<escape match="\\\\"><xsl:text>\\</xsl:text></escape>
		</xsl:variable>
		<xsl:value-of select="nt:unescape-string($escapedString, $escapeSequences)"/>
	</xsl:function>
	
	
	<!--  -->
	<xsl:function name="nt:unescape-string" as="xs:string">
		<xsl:param name="escapedString" as="xs:string"/>
		<xsl:param name="escapeSequences" as="element()*"/>
		
		<xsl:choose>
			<xsl:when test="exists(nt:head($escapeSequences))">
				<xsl:value-of select="nt:unescape-string(
							replace($escapedString, nt:head($escapeSequences)/@match, nt:head($escapeSequences)/text()), 
									nt:tail($escapeSequences))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="result">
					<xsl:analyze-string select="$escapedString" regex="(\\u)([0-9A-F]{{2,8}})" flags="i">
						<xsl:matching-substring><xsl:value-of select="codepoints-to-string(nt:hex-to-int(regex-group(2)))"/></xsl:matching-substring>
						<xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
					</xsl:analyze-string>
				</xsl:variable>
				<xsl:value-of select="string-join($result, '')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	
	<!--  -->
	<xsl:function name="nt:head" as="item()?">
		<xsl:param name="sequence" as="item()*"/>
		
		<xsl:sequence select="subsequence($sequence, 1, 1)"/>
	</xsl:function>
	
	
	<!--  -->
	<xsl:function name="nt:tail" as="item()*">
		<xsl:param name="sequence" as="item()*"/>
		
		<xsl:sequence select="subsequence($sequence, 2)"/>
	</xsl:function>
	
	
	<xsl:function name="nt:escape-non-ascii" as="xs:string">
		<xsl:param name="unescapedString" as="xs:string?"/>
		
		<xsl:value-of select="nt:escape-non-ascii($unescapedString, '')"/>
	</xsl:function>
	
	
	<!-- Wrapper for recursive function that applies \u character escaping to non-ASCII characters. -->
	<xsl:function name="nt:escape-non-ascii" as="xs:string">
		<xsl:param name="unescapedString" as="xs:string?"/>
		<xsl:param name="escapedString" as="xs:string?"/>
		<xsl:variable name="head" as="xs:string?" select="substring($unescapedString, 1, 1)"/>
		<xsl:variable name="tail" as="xs:string?" select="substring($unescapedString, 2)"/>
		
		<xsl:choose>
			<xsl:when test="$head">
				<xsl:value-of select="nt:escape-non-ascii($tail, concat($escapedString, nt:u-escape-character($head)))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$escapedString"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	
	<!-- Apply \u escaping to the passed character if it's in the xF7 - xFFFC range. -->
	<xsl:function name="nt:u-escape-character" as="xs:string?">
		<xsl:param name="char" as="xs:string?"/>
		<xsl:variable name="charCode" as="xs:integer" select="string-to-codepoints($char)"/>
	  <xsl:variable name="unpaddedHexCode" as="xs:string" select="nt:int-to-hex($charCode)"/>
	  
		<xsl:value-of select="
			if ($charCode = ( for $n in 127 to 65533 return $n )) then 
				concat('\u', string-join(( for $n in (1 to (4 - string-length($unpaddedHexCode))) return '0' ), ''), $unpaddedHexCode)
			else
				$char"/>
	</xsl:function>
	
	
	<!-- Converts an xs:integer to a hexadecimal string.
		 Curtosy of M. Kay. -->
	<xsl:function name="nt:int-to-hex" as="xs:string">
		<xsl:param name="in" as="xs:integer"/>
		
		<xsl:sequence select="
			if ($in eq 0) then 
				'0' 
			else concat(
				if ($in gt 16) then 
					nt:int-to-hex($in idiv 16) 
				else 
					'',
           		substring('0123456789ABCDEF', ($in mod 16) + 1, 1))"/>
	</xsl:function>
	
	
	<!-- Converts a hexadecimal string to an xs:integer. -->
	<xsl:function name="nt:hex-to-int" as="xs:integer">
		<xsl:param name="in" as="xs:string"/>
		<xsl:variable name="head" as="xs:string?" select="substring($in, 1, 1)"/>
		<xsl:variable name="tail" as="xs:string?" select="substring($in, 2)"/>
		<xsl:variable name="multiplier" as="xs:integer" select="nt:power(16,  string-length($tail))"/>
		<xsl:variable name="decimalValue" as="xs:integer" 
				select="index-of(('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'), $head) - 1"/>
		
		<xsl:value-of select="
			if (string-length($head) gt 0) then 
				($decimalValue * $multiplier) + nt:hex-to-int(string-join($tail, ''))
			else
				0"/>
	</xsl:function>
	
	
	<!-- Raises the first argument passed to the power of the second. -->
	<xsl:function name="nt:power" as="xs:integer">
		<xsl:param name="arg1" as="xs:integer"/>
		<xsl:param name="arg2" as="xs:integer"/>
		
		<xsl:value-of select="
			if ($arg2 ne 0) then  
				$arg1 * nt:power($arg1, $arg2 - 1)
			else 
				1"/>
	</xsl:function>
</xsl:transform>