Class {
	#name : #CUnresolvedType,
	#superclass : #CType,
	#instVars : [
		'name'
	],
	#category : #C
}

{ #category : #testing }
CUnresolvedType >> isUnresolved [
	^true
]

{ #category : #accessing }
CUnresolvedType >> name [
	^name
]

{ #category : #accessing }
CUnresolvedType >> name: aString [
	name := aString
]

{ #category : #printing }
CUnresolvedType >> printMainOn: aStream indent: n [
	aStream nextPutAll: name
]

{ #category : #printing }
CUnresolvedType >> printMainTextOn: rtf indent: n [
	| painter |
	painter := PaintingVisitor new.
	rtf useColor: painter undefinedColor while: [rtf nextPutAll: name]
]

{ #category : #printing }
CUnresolvedType >> printOn: aStream [
	aStream nextPutAll: '<' , name , ' (unresolved)>'
]

{ #category : #accessing }
CUnresolvedType >> sizeInBytes [
	^1
]

