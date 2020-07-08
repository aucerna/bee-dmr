"
    Copyright (c) 2020 LabWare.
    See (MIT) license in root directory.
"

Class {
	#name : #Kernel,
	#superclass : #Module,
	#instVars : [
		'entryPointCode',
                'entryPointReceiver',
		'nilObj',
		'trueObj',
		'falseObj',
		'dlopenPtr',
		'dlsymPtr'
	],
	#category : #Kernel
}

Kernel >> entry: argc argv: argv [
	self halt.
]
