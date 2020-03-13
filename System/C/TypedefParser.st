"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #TypedefParser,
	#superclass : #TypedefGrammar,
	#instVars : [
		'translationUnit'
	],
	#category : #C
}

{ #category : #'pm support' }
TypedefParser class >> aboutToSaveLibrary [
	current := nil
]

{ #category : #accessing }
TypedefParser class >> current [
	current isNil ifTrue: [self initialize].
	^current
]

{ #category : #accessing }
TypedefParser class >> ignoredNames [
	^super ignoredNames , #(#translationUnit)
]

{ #category : #initialization }
TypedefParser class >> initialize [
	current := self new
]

{ #category : #parsing }
TypedefParser class >> parse: aString [
	self error: 'parsing structures without context is not allowed'
]

{ #category : #parsing }
TypedefParser class >> parse: aString for: requestor [
	| unit class |
	unit := CTranslationUnit windows: WordSize.
	class := requestor compiler optionAt: #classBinding ifAbsent: nil.
	class notNil ifTrue: [class addDeclarationsTo: unit].
	^self parse: aString using: unit
]

{ #category : #parsing }
TypedefParser class >> parse: aString using: aCTranslationUnit [
	| preprocessed result |
	preprocessed := self preprocess: aString.
	result := self current
		translationUnit: aCTranslationUnit;
		parse: preprocessed.
	"self DENY: result isPetitFailure." 
	^result
]

{ #category : #parsing }
TypedefParser class >> parseTypedef: aString using: aCTranslationUnit [
	^(self parse: aString using: aCTranslationUnit) first
]

{ #category : #parsing }
TypedefParser class >> preprocess: aString [
	^String streamContents: [:out | | in |
		in := aString readStream.
		[in atEnd] whileFalse: [| peeked |
			peeked := in peek: 2.
			peeked = '//'
				ifTrue: [in nextLine]
				ifFalse: [peeked = '/*'
					ifTrue: [in upToAll: '*/']
					ifFalse: [out nextPut: in next]]]]
]

{ #category : #parsing }
TypedefParser >> arrayField [
	^super arrayField ==> [:nodes | | plus |
		plus := nodes fourth ifNil: ['0'] ifNotNil: [:c | c second].
		ArrayStructField new
			name: nodes first value;
			lengthDef: nodes third value -> plus]
]

{ #category : #accessing }
TypedefParser >> basicType [
	^super basicType ==> [:nodes | translationUnit typeNamed: nodes]
]

{ #category : #accessing }
TypedefParser >> bitField [
	^super bitField
		==> [:nodes | BitmapStructField new
			name: nodes first;
			length: nodes fifth asInteger]
]

{ #category : #accessing }
TypedefParser >> body [
	^super body ==> [:nodes | nodes third collect: #second]
]

{ #category : #accessing }
TypedefParser >> enum [
	^super enum ==> [:nodes | | name items |
		name := nodes third ifNil: ''.
		items := nodes sixth.
		CEnum new name: name; addAll: items; yourself]
]

{ #category : #accessing }
TypedefParser >> enumItem [
	^super enumItem ==> [:nodes | | value |
		value := nodes fourth ifNotNil: [:definition | definition third].
		nodes second -> value]
]

{ #category : #accessing }
TypedefParser >> enumItems [
	^super enumItems ==> [:nodes | | items |
		items := nodes first collect: [:sequence | sequence first].
		nodes second ifNotNil: [:item | items := items copyWith: item].
		items]
]

{ #category : #parsing }
TypedefParser >> field [
	^super field ==> [:nodes | nodes third type: nodes first]
]

{ #category : #accessing }
TypedefParser >> floatNumber [
	^super floatNumber ==> [:nodes | Float fromString: nodes]
]

{ #category : #accessing }
TypedefParser >> integerNumber [
	^super integerNumber ==> [:nodes | Number fromString: nodes]
]

{ #category : #accessing }
TypedefParser >> pointer [
	^super pointer ==> [:nodes | nodes first , nodes last]
]

{ #category : #accessing }
TypedefParser >> singleField [
	^super singleField ==> [:nodes | | name |
		name := nodes = #() ifTrue: [''] ifFalse: [nodes].
		SingleStructField new name: name]
]

{ #category : #accessing }
TypedefParser >> start [
	^super start ==> [:nodes | CStatementList on: nodes first]
]

{ #category : #accessing }
TypedefParser >> statement [
	^super statement ==> [:nodes | nodes second]
]

{ #category : #accessing }
TypedefParser >> struct [
	^super struct ==> [:nodes | | name fields s |
		name := nodes third ifNil: '' ifNotNil: [:array | array second].
		fields := nodes fifth collect: #asField.
		s := CStruct new
			translationUnit: translationUnit;
			name: name;
			fields: fields.
		s isUnnamed ifFalse: [translationUnit addType: s].
		s loadFields]
]

{ #category : #accessing }
TypedefParser >> translationUnit: aCTranslationUnit [
	translationUnit := aCTranslationUnit
]

{ #category : #accessing }
TypedefParser >> typedef [
	^super typedef ==> [:nodes | | type name typedef |
		type := nodes third.
		name := nodes fifth.
		typedef := translationUnit addTypedef: type as: name.
		typedef extraNames: nodes sixth value trimBlanks.
		type loadFields.
		typedef]
]

{ #category : #accessing }
TypedefParser >> typedefType [
	^super typedefType ==> [:node | translationUnit typeNamed: node value]
]

{ #category : #accessing }
TypedefParser >> union [
	^super union ==> [:nodes | | name fields u |
		name := nodes third ifNil: '' ifNotNil: [:array | array second].
		fields := nodes fifth collect: #asField.
		u := CUnion new
			translationUnit: translationUnit;
			name: name;
			fields: fields.
		u isUnnamed ifFalse: [translationUnit addType: u].
		u loadFields]
]

