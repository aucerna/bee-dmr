Class {
	#name : #CArgumentField,
	#superclass : #Object,
	#instVars : [
		'modes',
		'type',
		'name',
		'index'
	],
	#category : #C
}

{ #category : #printing }
CArgumentField >> cast [
	^nil
]

{ #category : #private }
CArgumentField >> index: anInteger [
	index := anInteger
]

{ #category : #printing }
CArgumentField >> mode [
	^String
		streamContents: [:strm | modes
			do: [:m | strm nextPutAll: m]
			separatedBy: [strm nextPut: $-]]
]

{ #category : #private }
CArgumentField >> modes: aString [
	| string |
	string := aString asLowercase.
	modes := OrderedCollection new.
	(string includesString: 'in') ifTrue: [modes add: #in].
	(string includesString: 'out') ifTrue: [modes add: #out].
	(string includesString: 'opt') ifTrue: [modes add: #opt]
]

{ #category : #accessing }
CArgumentField >> name [
	^name
]

{ #category : #accessing }
CArgumentField >> name: aString [
	name := aString
]

{ #category : #printing }
CArgumentField >> printAnnotationOn: rtf [
	rtf
		nextPutAll: name;
		fontSize: (rtf font pointSize * 0.75) asInteger while: [
			rtf
				nextPutAll: ' [';
				bold: self mode asUppercase;
				nextPut: $];
				tab;
				nextPutAll: '('.
			type name notNil ifTrue: [rtf nextPutAll: type name].
			rtf nextPutAll: ')'].
	rtf tab.
	type printTextOn: rtf.
	self cast ifNotNil: [:cast | 
		cast notNil ifTrue: [
			rtf nextPutAll: ' → '.
			cast printTextOn: rtf]]
]

{ #category : #printing }
CArgumentField >> printAnnotationOn: rtf indent: n [
	rtf
		nextPutAll: name;
		fontSize: (rtf font pointSize * 0.75) asInteger while: [
			rtf
				nextPutAll: ' [';
				bold: self mode asUppercase;
				nextPut: $];
				tab;
				nextPutAll: '('.
			type name notNil ifTrue: [rtf nextPutAll: type name].
			rtf nextPutAll: ')'].
	rtf tab.
	type printMainTextOn: rtf indent: n.
	self cast ifNotNil: [:cast | 
		cast notNil ifTrue: [
			rtf nextPutAll: ' → '.
			cast printTextOn: rtf]]
]

{ #category : #printing }
CArgumentField >> printOn: aStream [
	aStream
		nextPutAll: self mode;
		space;
		nextPutAll: type name;
		space;
		nextPutAll: name
]

{ #category : #printing }
CArgumentField >> printTextOn: rtf [
	| painter |
	painter := PaintingVisitor new.
	rtf
		nextPutAll: self mode;
		space;
		useColor: painter sharedVarColor while: [rtf nextPutAll: type name];
		space;
		nextPutAll: name
]

{ #category : #accessing }
CArgumentField >> type [
	^type
]

{ #category : #accessing }
CArgumentField >> type: aCType [
	type := aCType
]

