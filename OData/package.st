"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #OData,
	#requires : [
		'GUIbase',
		'Kernel',
		'PetitParser\Parsers',
		'PetitParser\Tools'
	]
	#classes : [
		'DataflowQuery',
		'ODataBinaryExpression',
		'ODataExpression',
		'ODataFunctionCall',
		'ODataKeyPredicate',
		'ODataLambdaOperator',
		'ODataPrimitiveLiteral',
		'ODataPropertyPath',
		'ODataQuery',
		'ODataQueryOption',
		'ODataURL',
		'ODataURLGrammar',
		'ODataURLParser',
		'WebServiceQuery'
	]
}

