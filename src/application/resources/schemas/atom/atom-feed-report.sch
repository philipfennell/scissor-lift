<?xml version="1.0" encoding="UTF-8"?>
<iso:schema xmlns:iso="http://purl.oclc.org/dsdl/schematron">
	<iso:ns prefix="atom" uri="http://www.w3.org/2005/Atom"/>
	<iso:title>Simple Atom Feed Rules</iso:title>
	<iso:pattern>
		<iso:title>Atom Feed Root</iso:title>
		<iso:rule context="/">
			<iso:report test="atom:feed">The document root has an atom:feed element.</iso:report>
		</iso:rule>
	</iso:pattern>
	<iso:pattern>
		<iso:title>Required elements of an Atom Feed</iso:title>
		<iso:rule context="/atom:feed">
		  <iso:report test="atom:title">atom:title is present.</iso:report>
		  <iso:report test="atom:id">atom:id is present.</iso:report>
		  <iso:report test="atom:updated">atom:updated is present.</iso:report>
		</iso:rule>
	</iso:pattern>
</iso:schema>