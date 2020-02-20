Class {
	#name : #OUseVariable,
	#superclass : #OInstruction,
	#instVars : [
		'#binding'
	],
	#category : #IR
}

{ #category : #unclassified }
OUseVariable >> binding [
	^binding
]

{ #category : #unclassified }
OUseVariable >> binding: aBinding [
	binding := aBinding
]

