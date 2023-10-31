"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OTypeSwitch,
	#superclass : #Object,
	#instVars : [
		'cases'
	],
	#category : #IR
}

{ #category : #enumerating }
OTypeSwitch >> allButLastDo: aBlock finally: anotherBlock [
	cases allButLast do: aBlock.
	anotherBlock value: cases last
]

{ #category : #accessing }
OTypeSwitch >> needsBehavior [
	^cases size > 1
		and: [cases anySatisfy: [:case | case token class == Behavior]]
]

{ #category : #printing }
OTypeSwitch >> printOn: aStream [
	aStream nextPutAll: 'switch between:'; cr.
	cases ifNil: [^aStream nextPutAll: 'no cases'].
	cases do: [:case | aStream print: case] separatedBy: [aStream cr]
]

{ #category : #accessing }
OTypeSwitch >> staticDispatch: aCompiledMethod [
	cases := {OTypeCase new method: aCompiledMethod; probability: 1}
]

{ #category : #accessing }
OTypeSwitch >> types: aCollection [
	cases := aCollection
]

