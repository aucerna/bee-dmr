"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #SUnit,
	#requires : [
		'GUIbase',
		'Kernel',
		'RTF'
	],
	#classes : [
		'GenericTestException',
		'SUnitNameResolver',
		'TestCase',
		'TestCounter',
		'TestFailure',
		'TestResource',
		'TestResult',
		'TestSkipped',
		'TestSuite'
	]
}

