"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #'JSON\Tests',
	#requires : [
		'Entity Data Model',
		'GUIbase',
		'JSON',
		'Scompiler',
		'Kernel',
		'SUnit'
	]
	#classes : [
		'JsonMappingTest',
		'JsonParserTest',
		'JsonSchemaTest',
		'JsonSerializationTest',
		'JsonWriterTest'
	]
}

