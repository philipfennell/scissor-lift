<?xml version="1.0" encoding="UTF-8"?>
<p:pipeline
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:sl="https://github.com/philipfennell/scissor-lift"
    xml:base="../"
    name="scissor-lift-compile"
    type="sl:compile"
    version="1.0">
  
  <p:documentation>Translates and compiles a scissor-lift 'lift' description to an executable XSLT transform.</p:documentation>
  
  <p:output port="translate">
    <p:pipe port="result" step="translate"/>
  </p:output>
  <p:output port="include">
    <p:pipe port="result" step="include"/>
  </p:output>
  <p:output port="expand">
    <p:pipe port="result" step="expand"/>
  </p:output>
  <p:output port="compile">
    <p:pipe port="result" step="compile"/>
  </p:output>
  
  <p:serialization port="translate" encoding="UTF-8" indent="true" 
      media-type="application/xml" method="xml"/>
  <p:serialization port="include" encoding="UTF-8" indent="true" 
      media-type="application/xml" method="xml"/>
  <p:serialization port="expand" encoding="UTF-8" indent="true" 
      media-type="application/xml" method="xml"/>
  <p:serialization port="compile" encoding="UTF-8" indent="true" 
      media-type="application/xml" method="xml"/>
  
  
  <p:xslt name="translate">
    <p:documentation>Translate the LiftML mapping to the augmented ISO Schematron.</p:documentation>
    <p:input port="stylesheet">
      <p:document href="xslt/sl-lift-to-iso-sch.xsl"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:xslt>
  
  <p:xslt name="include">
    <p:documentation>First, preprocess your Schematron schema with iso_dsdl_include.xsl.</p:documentation>
    <p:input port="stylesheet">
      <p:document href="xslt/scissor-lift-include.xsl"/>
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
  
</p:pipeline>