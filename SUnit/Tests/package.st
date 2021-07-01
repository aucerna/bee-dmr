"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #'SUnit\Tests',
	#requires : [
		'Kernel',
		'SUnit'
	],
	#classes : [
		'ExampleSetTest',
		'ResumableTestFailureTestCase',
		'SimpleTestResource',
		'SimpleTestResourceTestCase',
		'SUnitTest'
	]
}

