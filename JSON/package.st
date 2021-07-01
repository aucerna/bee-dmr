"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #JSON,
	#requires : [
		'Entity Data Model',
		'Extensions',
		'GUIbase',
		'PetitParser',
		'Kernel',
		'SUnit',
		'Validations'
	],
	#classes : [
		'BooleanAdaptor',
		'DataAdaptor',
		'IdAdaptor',
		'JsonAnySchema',
		'JsonArraySchema',
		'JsonBooleanSchema',
		'JsonCombinedSchema',
		'JsonDateFormat',
		'JsonDateTimeFormat',
		'JsonEmailFormat',
		'JsonError',
		'JsonFormat',
		'JsonImporter',
		'JsonImporterError',
		'JsonIntegerFormat',
		'JsonIntegerSchema',
		'JsonMapping',
		'JsonMappingRegistry',
		'JsonNotSchema',
		'JsonNullSchema',
		'JsonNumberFormat',
		'JsonNumberSchema',
		'JsonObject',
		'JsonObjectSchema',
		'JsonObjectValidator',
		'JsonOneSchema',
		'JsonPainter',
		'JsonParser',
		'JsonPrimitiveSchema',
		'JsonPropertyMap',
		'JsonSchema',
		'JsonSchemaReference',
		'JsonSerializer',
		'JsonStringFormat',
		'JsonStringSchema',
		'JsonUriFormat',
		'JsonWriter',
		'PPJsonGrammar',
		'PPJsonParser',
		'StringAdaptor',
		'SymbolAdaptor',
		'TimestampAdaptor',
		'TypeAdaptor'
	]
}

