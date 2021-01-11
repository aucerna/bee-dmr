"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #'JavaScript\Tests',
	#requires : [
		'Compiler',
		'JavaScript',
		'Kernel',
		'SUnit'
	]
	#classes : [
		'BasicJavascriptParserTest',
		'JavascriptCompilingTest',
		'JavascriptFormattingTest',
		'JavascriptLexicalTest',
		'JavascriptNodeTest',
		'JavascriptNumericConversionTest',
		'JavascriptParserTest',
		'JavascriptSyntaxTest',
		'JavascriptUnicodeTest',
		'JSETestFactory',
		'JSETestParserResource'
	]
}

