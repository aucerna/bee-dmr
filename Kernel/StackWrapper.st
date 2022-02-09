"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #StackWrapper,
	#superclass : #Object,
	#instVars : [
		'process',
		'thread',
		'native',
		'base',
		'limit',
		'chunk'
	],
	#classVars : [
		'Instances'
	],
	#category : #Kernel
}
