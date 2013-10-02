<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:p="http://www.w3.org/ns/xproc"
    xml:base="../"
    name="scissor-lift"
    version="1.0">
  
  <p:documentation>Takes a source XML and a scissor-lift mapping, compiles the mapping and applies it to the source document.</p:documentation>
  
  <p:input port="source" primary="true"/>
  <p:input port="mapping"/>
  <p:output port="include">
    <p:pipe port="result" step="include"/>
  </p:output>
  <p:output port="expand">
    <p:pipe port="result" step="expand"/>
  </p:output>
  <p:output port="compile">
    <p:pipe port="result" step="compile"/>
  </p:output>
  <p:output port="result" primary="true"/>
  
  
  <p:serialization port="compile" encoding="UTF-8" indent="true" 
      media-type="application/xml" method="xml"/>
  <p:serialization port="result" encoding="UTF-8" indent="true" 
      media-type="application/xml" method="xml"/>
  
  
  <p:xslt name="include">
    <p:documentation>First, preprocess your Schematron schema with iso_dsdl_include.xsl.</p:documentation>
    <p:input port="source">
      <p:pipe port="mapping" step="scissor-lift"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="xslt/iso-schematron-xslt2/iso_dsdl_include.xsl"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:xslt>
  
  <p:xslt name="expand">
    <p:documentation>Second, preprocess the output from stage 1 with iso_abstract_expand.xsl.</p:documentation>
    <p:input port="stylesheet">
      <p:document href="xslt/iso-schematron-xslt2/iso_abstract_expand.xsl"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:xslt>
  
  <p:xslt name="compile">
    <p:documentation>Third, compile the Schematron schema into an XSLT script.</p:documentation>
    <p:input port="stylesheet">
      <p:document href="xslt/scissor-lift.xsl"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
    <p:with-param name="terminate" select="'assert'"/>
    <p:with-param name="generate-paths" select="'false'"/>
    <p:with-param name="generate-fired-rule" select="'false'"/>
  </p:xslt>
  
  <p:xslt name="graph">
    <p:documentation>Fourth, run the transform generated by stage 3 (compile) against the document to be transformed.</p:documentation>
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
</p:declare-step>