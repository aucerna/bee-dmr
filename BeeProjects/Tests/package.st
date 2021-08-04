"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Package {
	#name : #Tests, 
	#requires : [
		'BeeProjects', 
		'Development', 
		'Kernel', 
		'ProjectChanges', 
		'Smalltalk browsers', 
		'SUnit'
	], 
	#classes : [
		'BeeModuleTest', 
		'ChangesetTest', 
		'ProjectChangesTest'
	]
}