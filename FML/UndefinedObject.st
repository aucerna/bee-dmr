"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #UndefinedObject }

{ #category : '*FML' }
UndefinedObject class >> fmlValueClass [
	^FmlUndefinedValue]

{ #category : '*FML' }
UndefinedObject >> asFmlValue [
	^self class fmlValueClass new]

{ #category : '*FML' }
UndefinedObject >> resultType [
	^FmlUndefinedValue]

