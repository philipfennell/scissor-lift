<?xml version="1.0" encoding="UTF-8"?>
<iso:schema
    xmlns:sl="https://github.com/philipfennell/scissor-lift"
    xmlns:iso="http://purl.oclc.org/dsdl/schematron">
	<iso:ns prefix="atom" uri="http://www.w3.org/2005/Atom"/>
	<iso:title>Simple Atom Feed Rules</iso:title>
  
  <iso:let name="feedURI" value="concat('http://example.org/feeds/', substring-after(/atom:feed/atom:id, 'urn:uuid:'))"/>
  
  <iso:pattern id="abstract" abstract="true">
    <iso:title>Abstract Rules</iso:title>
    
    <iso:rule id="links" abstract="true">
      <iso:let name="entryURI" value="concat($feedURI, '/entries/', substring-after(../atom:id, 'urn:uuid:'))"/>
      
      <iso:report test=".">
        <sl:uri select="$entryURI"/>
        <sl:uri>http://bblfish.net/work/atom-owl/2006-06-06/#link</sl:uri>
        <sl:id select="."/>
      </iso:report>
      <iso:report test="." >
        <sl:id select="."/>
        <sl:uri>http://www.w3.org/1999/02/22-rdf-syntax-ns#type</sl:uri>
        <sl:uri>http://bblfish.net/work/atom-owl/2006-06-06/#Link</sl:uri>
      </iso:report>
      <iso:report test="." >
        <sl:id select="."/>
        <sl:uri>http://bblfish.net/work/atom-owl/2006-06-06/#to</sl:uri>
        <sl:id select="@href"/>
      </iso:report>
      <iso:report test="@href" >
        <sl:id select="@href"/>
        <sl:uri>http://bblfish.net/work/atom-owl/2006-06-06/#src</sl:uri>
        <sl:uri select="@href"/>
      </iso:report>
    </iso:rule>
    
    <iso:rule id="required" abstract="true">
      <iso:report test="atom:title">
        <sl:uri select="$feedURI"/>
        <sl:uri>http://bblfish.net/work/atom-owl/2006-06-06/#title</sl:uri>
        <sl:plainLiteral xml:lang="en-GB" select="atom:title"/>
      </iso:report>
      <iso:report test="atom:id">
        <sl:uri select="$feedURI"/>
        <sl:uri>http://bblfish.net/work/atom-owl/2006-06-06/#id</sl:uri>
        <sl:typedLiteral datatype="http://www.w3.org/2001/XMLSchema#anyURI" select="atom:id"/>
      </iso:report>
      <iso:report test="atom:updated">
        <sl:uri select="$feedURI"/>
        <sl:uri>http://bblfish.net/work/atom-owl/2006-06-06/#updated</sl:uri>
        <sl:typedLiteral datatype="http://www.w3.org/2001/XMLSchema#dateTime" select="atom:updated"/>
      </iso:report>
    </iso:rule>
  </iso:pattern>
  
	<iso:pattern>
		<iso:title>Atom Feed Root</iso:title>
		<iso:rule context="/">
		  <iso:report test="atom:feed">
		    <sl:uri select="$feedURI"/>
		    <sl:uri>http://www.w3.org/1999/02/22-rdf-syntax-ns#type</sl:uri>
		    <sl:uri>http://bblfish.net/work/atom-owl/2006-06-06/#Feed</sl:uri>
		  </iso:report>
		</iso:rule>
	  <iso:rule context="/atom:feed">
	    <iso:extends rule="required"/>
	    <iso:assert test="atom:title">This element must be present for the feed to be valid</iso:assert>
	  </iso:rule>
	  <iso:rule context="/atom:feed/atom:link">
		  <iso:extends rule="links"/>
		</iso:rule>
	</iso:pattern>
  
  <iso:pattern>
    <iso:title>Atom Entry</iso:title>
    <iso:rule context="/atom:feed/atom:entry">
      <iso:extends rule="required"/>
      
      <iso:let name="entryURI" value="concat($feedURI, '/entries/', substring-after(atom:id, 'urn:uuid:'))"/>
      
      <iso:report test=".">
        <sl:uri template="http://example.org/feeds/{feedID}/entries/{entryID}">
          <sl:param name="feedID" select="substring-after(/atom:feed/atom:id, 'urn:uuid:')" type="xs:string"/>
          <sl:param name="entryID" select="substring-after(atom:id, 'urn:uuid:')" type="xs:string"/>
        </sl:uri>
        <sl:uri>http://www.w3.org/1999/02/22-rdf-syntax-ns#type</sl:uri>
        <sl:uri>http://bblfish.net/work/atom-owl/2006-06-06/#Entry</sl:uri>
      </iso:report>
    </iso:rule>
    <iso:rule context="/atom:feed/atom:entry/atom:link">
      <iso:extends rule="links"/>
    </iso:rule>
  </iso:pattern>
</iso:schema>