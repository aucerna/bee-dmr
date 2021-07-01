"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #'ProjectChanges\Tests',
	#requires : [
		'ProjectChanges',
		'SUnit'
	],
	#classes : [
		'ChangeHeaderSpecTest',
		'ChangesetTest',
		'ClassRenameTest',
		'ProjectChangesTest'
	]
}

