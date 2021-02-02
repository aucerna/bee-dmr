"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #Validations,
	#requires : [
		'Kernel',
		'SUnit'
	]
	#classes : [
		'DomainValidator',
		'UIValidator',
		'ValidationBreak',
		'ValidationError',
		'ValidationFailure',
		'ValidationFailureException',
		'ValidationInfo',
		'ValidationInfoException',
		'ValidationResult',
		'ValidationSuite',
		'ValidationWarning',
		'ValidationWarningException',
		'Validator'
	]
}

