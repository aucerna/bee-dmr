"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OPrimitiveOperation,
	#superclass : #OInstruction,
	#instVars : [
		'name'
	],
	#category : #IR
}

{ #category : #printing }
OPrimitiveOperation >> basicPrintString [
	^self primitivePrintString
]

{ #category : #copying }
OPrimitiveOperation >> copyTo: copy with: map [
	super copyTo: copy with: map.
	copy name: name
]

{ #category : #testing }
OPrimitiveOperation >> isPrimitiveOperation [
	^true
]

{ #category : #accessing }
OPrimitiveOperation >> name [
	^name
]

{ #category : #accessing }
OPrimitiveOperation >> name: selector [
	name := selector
]

{ #category : #printing }
OPrimitiveOperation >> primitivePrintString [
	^'{#' , name , '}'
]

{ #category : #printing }
OPrimitiveOperation >> printStringUsing: names [
	^self primitivePrintString
]

