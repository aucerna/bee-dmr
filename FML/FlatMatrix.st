"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #FlatMatrix }

{ #category : '*FML' }
FlatMatrix >> asFmlValue [
	^FmlTable on: self]

{ #category : '*FML' }
FlatMatrix >> hasUndefinedValues [
	self rowsDo: [:each | each hasUndefinedValues ifTrue: [^true]].
	^false]

{ #category : '*FML' }
FlatMatrix >> resultType [
	^FmlTable]

