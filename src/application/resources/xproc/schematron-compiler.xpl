<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:p="http://www.w3.org/ns/xproc"
    xml:base="../"
    name="schematron-compiler"
    version="1.0">
  
  <p:documentation>Compiles a Schematron schema to an executable XSLT.</p:documentation>
  
  <p:input port="source"/>
  <p:output port="result"/>
  
  <p:serialization port="result" encoding="UTF-8" indent="true" 
      media-type="application/xml" method="xml"/>
  
  <p:xslt name="iso_dsdl_include">
    <p:documentation>First, preprocess your Schematron schema with iso_dsdl_include.xsl.</p:documentation>
    <p:input port="stylesheet">
      <p:document href="xslt/iso-schematron-xslt2/iso_dsdl_include.xsl"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:xslt>
  
  <p:xslt name="iso_abstract_expand">
    <p:documentation>Second, preprocess the output from stage 1 with iso_abstract_expand.xsl.</p:documentation>
    <p:input port="stylesheet">
      <p:document href="xslt/iso-schematron-xslt2/iso_abstract_expand.xsl"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:xslt>
  
  <p:xslt name="iso_svrl_for_xslt">
    <p:documentation>Third, compile the Schematron schema into an XSLT script. </p:documentation>
    <p:input port="stylesheet">
      <p:document href="xslt/iso-schematron-xslt2/iso_svrl_for_xslt2.xsl"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:xslt>
</p:declare-step>