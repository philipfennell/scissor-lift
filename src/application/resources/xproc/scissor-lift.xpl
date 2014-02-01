<?xml version="1.0" encoding="UTF-8"?>
<p:pipeline
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:sl="https://github.com/philipfennell/scissor-lift"
    xml:base="../"
    name="scissor-lift"
    version="1.0">
  
  <p:import href="xproc/scissor-lift-compile.xpl"/>
  <p:import href="xproc/scissor-lift-serialize.xpl"/>
  
  <p:documentation>Takes a source XML and a scissor-lift mapping, compiles the mapping and applies it to the source document.</p:documentation>
  
  <p:option name="representation" select="'ntriples'">
    <p:documentation>Defines the output graph representation and accepts values of: (ntriples | rdfxml | trix). Default is trix.</p:documentation>
  </p:option>
  <p:option name="outputPath" select="'graphs/'">
    <p:documentation>Defines the output path for the chosen serialisation format</p:documentation>
  </p:option>
  
  <p:input port="mapping"/>
  
  <p:serialization port="result" encoding="UTF-8" indent="true" 
      media-type="application/xml" method="xml" omit-xml-declaration="false"/>
  
  
  <sl:compile name="compile">
    <p:documentation>Translates and compiles a scissor-lift description.</p:documentation>
    <p:input port="source">
      <p:pipe port="mapping" step="scissor-lift"/>
    </p:input>
  </sl:compile>
  
  <p:xslt name="graph">
    <p:documentation>Apply the scissor-lift mapping..</p:documentation>
    <p:input port="source">
      <p:pipe port="source" step="scissor-lift"/>
    </p:input>
    <p:input port="stylesheet">
      <p:pipe port="result" step="compile"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:xslt>
  
  <sl:serialize>
    <p:documentation>Transforms the default TriX representation into the chosen output serialization.</p:documentation>
    <p:with-option name="representation" select="$representation"/>
    <p:with-option name="outputPath" select="$outputPath"/>
  </sl:serialize>
  
  <p:identity>
    <p:documentation>Always output the TriX graph.</p:documentation>
    <p:input port="source">
      <p:pipe port="result" step="graph"/>
    </p:input>
  </p:identity>
</p:pipeline>