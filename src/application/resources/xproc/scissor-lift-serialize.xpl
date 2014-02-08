<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:sl="https://github.com/philipfennell/scissor-lift"
    xml:base="../"
    name="scissor-lift-serialize"
    type="sl:serialize"
    version="1.0">
  
  <p:documentation>Translate a TriX graph into the chosen RDF representation.</p:documentation>
  
  <p:input port="source"/>
  
  <p:option name="representation" select="'trix'">
    <p:documentation>Defines the output graph representation and accepts values of: (ntriples | rdfxml | trix | semtriples). Default is trix.</p:documentation>
  </p:option>
  <p:option name="outputPath" select="'graphs/'">
    <p:documentation>Defines the output path for the chosen serialisation format</p:documentation>
  </p:option>
  
  
  <p:choose>
    <p:documentation>Select an output representation.</p:documentation>
    <p:when test="$representation eq 'ntriples'">
      <p:xslt name="n-triples">
        <p:documentation>Transform to N-Triples.</p:documentation>
        <p:input port="stylesheet">
          <p:document href="xslt/ntriples/sl-trix-to-ntriples.xsl"/>
        </p:input>
        <p:input port="parameters">
          <p:empty/>
        </p:input>
      </p:xslt>
      
      <p:store encoding="UTF-8" indent="true" media-type="text/plain" method="text">
        <p:with-option name="href" select="concat($outputPath, '/', substring-before(tokenize(base-uri(), '/')[last()], '.xml'), '.nt')"/>
        <p:documentation>XProc 1.0 cannot handle text output from a step so pushing the N-Triples to the file-system from here.</p:documentation>
      </p:store>
    </p:when>
    
    <p:when test="$representation eq 'semtriples'">
      <p:xslt name="sem-triples">
        <p:documentation>Transform to MarkLogic sem:triples.</p:documentation>
        <p:input port="stylesheet">
          <p:document href="xslt/marklogic/sl-trix-to-sem-triples.xsl"/>
        </p:input>
        <p:input port="parameters">
          <p:empty/>
        </p:input>
      </p:xslt>
      
      <p:store encoding="UTF-8" indent="true" media-type="application/xml" method="xml">
        <p:with-option name="href" select="concat($outputPath, '/', substring-before(tokenize(base-uri(), '/')[last()], '.xml'), '.xml')"/>
      </p:store>
    </p:when>
    
    <p:when test="$representation eq 'rdfxml'">
      <p:xslt name="rdf-xml">
        <p:documentation>Transform to RDF XML.</p:documentation>
        <p:input port="stylesheet">
          <p:document href="xslt/rdf-xml/core.xsl"/>
        </p:input>
        <p:input port="parameters">
          <p:empty/>
        </p:input>
      </p:xslt>
      
      <p:store encoding="UTF-8" indent="true" media-type="application/rdf+xml" 
        method="xml" omit-xml-declaration="false">
        <p:with-option name="href" select="concat($outputPath, '/', substring-before(tokenize(base-uri(), '/')[last()], '.xml'), '.rdf')"/>
        <p:documentation>Pushing the RDF/XML to the file-system from here.</p:documentation>
      </p:store>
    </p:when>
    
    <p:otherwise>
      <p:sink/>
    </p:otherwise>
  </p:choose>
  
</p:declare-step>