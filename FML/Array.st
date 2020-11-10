"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Array }

{ #category : '*FML' }
Array >> isSingleValued [
	^false]

{ #category : '*FML' }
Array >> resultType [
	^FmlArray]

{ #category : '*FML' }
Array >> valueAt: index [
	^self at: index]

