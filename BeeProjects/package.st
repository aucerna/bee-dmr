"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Package {
	#name : #BeeProjects, 
	#requires : [
		'Development', 
		'GUI', 
		'Kernel', 
		'ProjectChanges', 
		'SUnit'
	], 
	#classes : [
		'BeeCluster', 
		'BeeModule', 
		'BeeProject'
	]
}