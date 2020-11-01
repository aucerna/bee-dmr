"
    Copyright (c) 2020 LabWare.
    See (MIT) license in root directory.
"

Class {
	#name : #Kernel,
	#superclass : #Module,
	#instVars : [
		'runtime'
	],
	#category : #Kernel
}

Kernel >> entry: argc argv: argv [
	<callback: long (long, pointer)>
	"^Smalltalk startSession"
	^1 yourself
]

