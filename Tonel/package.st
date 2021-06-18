"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Package {
	#name : #Tonel, 
	#requires : OrderedCollection [
		'Compiler', 
		'Kernel', 
		'STON', 
		'SUnit'
	], 
	#classes : OrderedCollection [
		'TonelReader', 
		'TonelTest', 
		'TonelWriter'
	]
}