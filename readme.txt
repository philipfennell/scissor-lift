# scissor-lift

Using the framework of Schematron rules based XML validation to define mappings between XML and RDF

As most people seem to want to avoid using schemas as a means of defining the context for mapping XML fragments to RDF I took another look at how you'd provide schema-less context for the mapping. XPath is, as other's have suggested, an obvious choice and it then occurred to me that Schematron has a good, and established, mechanism for doing just this sort of thing. Schematron defines contexts for assertions or reports about the content of an XML document. The output of a Schematron validation is a series of 'events' where either an assertion fails or a report is triggered. These 'events' could quite easily be a 'match' in a mapping from an XML element to an RDF triple. Further more, if you use the Schematron report to generate the triple then you could also utilise the Schematron assert to generate an exception if a validation assertion failed. This would enable you to test specific conditions as part of the mapping process and thereby safeguard from generating 'bad' triples by terminating the mapping.

Schematron is easily extended. I have done a very rough extension to the ISO Schematron transforms that override the basic 'skeleton' behaviour so that you can define a subject, predicate and object for a specific context/test and you get, as a result a TriX document that represents the mapped triples. You can define datatype and language on the object. Further work will look at how you define default subject IRI behaviour and how to extend that on a context-by-context basis.

My vision for this will be a pipelined XML to RDF mapping DSL which will be transformed into an augmented Schematron Schema that will be processed by the Schematron transforms plus the extended compiler. The output can then be transformed to the chosen triple representation e,g sem:triples or whatever. That may seem a bit long winded but I'm keeping the various steps simple for now, if it proves useful then we can always refactor later. You'd also be able to compile and reuse the resultant mapping transform.

Another feature of Schematron is validation phases. You would then be able to write simple initial mappings and then add additional phases that can be run separately, or together, that add additional triples that enhance to original dataset.




