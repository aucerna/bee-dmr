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
	^Kernel new foo.

]

Kernel >> foo [
	| result |
	"self _halt."
	#(1 2 3 4 5) do: [:i | result := i].
	^result
]

