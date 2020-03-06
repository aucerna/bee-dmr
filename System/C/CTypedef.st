Class {
	#name : #CTypedef,
	#superclass : #CType,
	#instVars : [
		'baseType',
		'name',
		'extraNames'
	],
	#classVars : [
		'Mapping'
	],
	#category : #C
}

{ #category : #accessing }
CTypedef >> alignment [
	^baseType alignment
]

{ #category : #inspecting }
CTypedef >> allFieldNamesDo: aBlock [
	baseType allFieldNamesDo: aBlock
]

{ #category : #inspecting }
CTypedef >> allFields [
	self ASSERT: self refersToStruct.
	^baseType allFields
]

{ #category : #converting }
CTypedef >> asField [
	^baseType asField
]

{ #category : #accessing }
CTypedef >> baseType [
	^baseType
]

{ #category : #accessing }
CTypedef >> baseType: aCType [
	baseType := aCType
]

{ #category : #accessing }
CTypedef >> classBinding [
	^binding ifNil: [baseType classBinding]
]

{ #category : #private }
CTypedef >> conflictiveFields [
	| groups |
	self refersToStruct ifFalse: [^super conflictiveFields].
	groups := self allFields groupBy: #name.
	^groups gather: [:group | group size > 1 ifTrue: [group] ifFalse: [#()]]
]

{ #category : #accessing }
CTypedef >> extraNames: aString [
	extraNames := aString
]

{ #category : #inspecting }
CTypedef >> fields [
	self ASSERT: self refersToStruct.
	^baseType fields
]

{ #category : #inspecting }
CTypedef >> generate [
	self ASSERT: self refersToStruct.
	^baseType generate
]

{ #category : #accessing }
CTypedef >> getterBodyFor: fieldName [
	^baseType getterBodyFor: fieldName
]

{ #category : #printing }
CTypedef >> initialize [
	super initialize.
	name := ''.
	extraNames := ''
]

{ #category : #testing }
CTypedef >> isUnresolved [
	^baseType isUnresolved
]

{ #category : #accessing }
CTypedef >> keyword [
	baseType isPointer ifFalse: [^baseType keyword].
	name == #address ifTrue: [^'addressAtOffset:'].
	name == #callback ifTrue: [^'callbackAtOffset:'].
	^'pointerAtOffset:'
]

{ #category : #services }
CTypedef >> literals [
	^baseType literals
]

{ #category : #inspecting }
CTypedef >> loadFields [
	^baseType loadFields
]

{ #category : #accessing }
CTypedef >> name [
	^name
]

{ #category : #accessing }
CTypedef >> name: aString [
	| class |
	name := aString.
	class := self classBindingFrom: name.
	class isNil ifTrue: [^self].
	baseType isStruct
		ifTrue: [baseType classBinding: class]
		ifFalse: [self classBinding: class]
]

{ #category : #accessing }
CTypedef >> naturalAlignment [
	^baseType naturalAlignment
]

{ #category : #offsets }
CTypedef >> offsets [
	| pool |
	pool := PoolDictionary new.
	self writeOffsetsOn: pool.
	^pool
]

{ #category : #services }
CTypedef >> offsets64 [
	^baseType writeOffsets64
]

{ #category : #printing }
CTypedef >> printMainOn: aStream indent: n [
	aStream nextPutAll: name
]

{ #category : #printing }
CTypedef >> printMainTextOn: rtf indent: n [
	rtf nextPutAll: name
]

{ #category : #printing }
CTypedef >> printOn: aStream [
	aStream nextPutAll: 'typedef '.
	baseType printMainOn: aStream indent: 0.
	aStream nextPutAll: ' ' , (name , extraNames) , ';'.
	baseType isUnresolved ifTrue: [aStream nextPutAll: ' // UNRESOLVED']
]

{ #category : #printing }
CTypedef >> printOn: aStream indent: n [
	self printOn: aStream
]

{ #category : #accessing }
CTypedef >> printSizeTextOn: rtf [
	self ASSERT: self refersToStruct.
	baseType printSizeTextOn: rtf
]

{ #category : #printing }
CTypedef >> printTextOn: rtf [
	self printTextOn: rtf indent: 0
]

{ #category : #printing }
CTypedef >> printTextOn: rtf indent: n [
	| painter |
	painter := PaintingVisitor new.
	rtf tab: n; nextPutAll: 'typedef '.
	rtf useColor: painter sharedVarColor while: [
		baseType printMainTextOn: rtf indent: n.
		rtf nextPutAll: ' ' , (name , extraNames) , ';'.
		self refersToStruct
			ifTrue: [baseType printSizeTextOn: rtf]
			ifFalse: [baseType isUnresolved
				ifTrue: [rtf nextPutAll: ' // UNRESOLVED']]]
]

{ #category : #inspecting }
CTypedef >> refersToStruct [
	^baseType refersToStruct
]

{ #category : #metaprograming }
CTypedef >> registerConflicts [
	baseType registerConflicts
]

{ #category : #services }
CTypedef >> selectors [
	^baseType selectors
]

{ #category : #accessing }
CTypedef >> sizeExpression [
	^baseType sizeExpression
]

{ #category : #accessing }
CTypedef >> sizeInBytes [
	^baseType sizeInBytes
]

{ #category : #services }
CTypedef >> writeOffsets64 [
	^baseType writeOffsets64
]

{ #category : #offsets }
CTypedef >> writeOffsetsOn: aPoolDictionary [
	^baseType writeOffsetsOn: aPoolDictionary
]

