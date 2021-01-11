"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #FML,
	#requires : [
		'Distributions',
		'Extensions',
		'GUIbase',
		'JSON',
		'NumericalMethods',
		'RTF',
		'Kernel',
		'Units',
		'Utilities'
	]
	#classes : [
		'CompiledTableFunction',
		'CompiledTableInterpolate',
		'CompiledTableLookup',
		'ContextRequest',
		'FmlArgumentDefinition',
		'FmlArityError',
		'FmlArray',
		'FmlBinaryExpression',
		'FmlBoolean',
		'FmlDate',
		'FmlDisentangler',
		'FmlEvaluationError',
		'FmlEvaluator',
		'FmlExpression',
		'FmlExpressionArray',
		'FmlExternalModelError',
		'FmlFactorizationAlgorithm',
		'FmlFullEvaluator',
		'FmlFunctionCall',
		'FmlFunctionCollector',
		'FmlFunctionDefinition',
		'FmlFunctionMutator',
		'FmlInactiveVariable',
		'FmlLatexPrinter',
		'FmlLazyEvaluationArg',
		'FmlMathPrinter',
		'FmlMissingVariable',
		'FmlNumber',
		'FmlParser',
		'FmlParserError',
		'FmlPlainPrinter',
		'FmlPrettyPrinter',
		'FmlPrinter',
		'FmlReachConditionFunction',
		'FmlRecursionTypeCalculator',
		'FmlRecursiveDefinition',
		'FmlScanner',
		'FmlSimplifier',
		'FmlString',
		'FmlSummationTerm',
		'FmlSynopsis',
		'FmlTable',
		'FmlUndefinedEvaluation',
		'FmlUndefinedValue',
		'FmlUnknownFunction',
		'FmlValue',
		'FmlVariableName',
		'FmlVisitor',
		'InvalidArgumentType',
		'OutOfRange'
	]
}

