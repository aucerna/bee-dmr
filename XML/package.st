"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #XML,
	#requires : [
		'GUIbase',
		'Kernel',
		'PetitParser',
		'PetitParser\Parsers',
		'PetitParser\Tools'
	],
	#classes : [
		'PPXmlAttribute',
		'PPXmlComment',
		'PPXmlData',
		'PPXmlDoctype',
		'PPXmlDocument',
		'PPXmlElement',
		'PPXmlGrammar',
		'PPXmlMacro',
		'PPXmlName',
		'PPXmlNode',
		'PPXmlParent',
		'PPXmlParser',
		'PPXmlProcessing',
		'PPXmlText',
		'XmlFormattingVisitor',
		'XmlNodeVisitor',
		'XmlPaintingVisitor'
	]
}

