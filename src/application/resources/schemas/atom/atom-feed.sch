<?xml version="1.0" encoding="UTF-8"?>
<iso:schema xmlns:iso="http://purl.oclc.org/dsdl/schematron">
	<iso:ns prefix="atom" uri="http://www.w3.org/2005/Atom"/>
	<iso:title>Simple Atom Feed Rules</iso:title>
	<iso:pattern>
		<iso:title>Atom Feed Root</iso:title>
		<iso:rule context="/">
			<iso:assert test="atom:feed">The document root must be an atom:feed element.</iso:assert>
		</iso:rule>
	</iso:pattern>
	<iso:pattern>
		<iso:title>Required elements of an Atom Feed</iso:title>
		<iso:rule context="/atom:feed">
			<iso:assert test="atom:title">atom:title is missing, this is a required element.</iso:assert>
			<iso:assert test="atom:id">atom:id is missing, this is a required element.</iso:assert>
			<iso:assert test="atom:updated">atom:updated is missing, this is a required element.</iso:assert>
		</iso:rule>
	</iso:pattern>
</iso:schema>