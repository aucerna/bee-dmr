"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssProperty,
	#superclass : #CssElement,
	#instVars : [
		'name',
		'value',
		'string',
		'definition',
		'important',
		'derived'
	],
	#category : #CSS
}

{ #category : #'instance creation' }
CssProperty class >> propertyNamed: aString [
	^self new propertyName: aString]

{ #category : #visiting }
CssProperty >> acceptVisitor: aCssElementVisitor [
	aCssElementVisitor visitCssProperty: self]

{ #category : #accessing }
CssProperty >> definition [
	definition isNil
		ifTrue: [definition := CssPropertyDefinition
			named: name asLowercase trimBlanks].
	^definition]

{ #category : #accessing }
CssProperty >> definition: anObject [
	definition := anObject]

{ #category : #accessing }
CssProperty >> important [
	^important]

{ #category : #accessing }
CssProperty >> important: anObject [
	important := anObject]

{ #category : #accessing }
CssProperty >> isDerived [
	derived isNil ifTrue: [derived := false].
	^derived]

{ #category : #accessing }
CssProperty >> isDerived: aBoolean [
	derived := aBoolean]

{ #category : #testing }
CssProperty >> isProperty [
	^true]

{ #category : #accessing }
CssProperty >> name [
	^name]

{ #category : #parsing }
CssProperty >> parseContents: aStream [
	| s pos in |
	aStream skipSeparators.
	pos := aStream position.
	s := aStream upTo: $;.
	(s includes: $}) ifTrue: [
		aStream position: pos.
		s := aStream upTo: $}.
		self addError: CssUnterminatedPropertyError new].
	in := s readStream.
	self
		propertyString: (in upTo: $!);
		important: (in contents match: 'important')]

{ #category : #accessing }
CssProperty >> prefix [
	^self isDerived
		ifTrue: [| out |
			out := '' writeStream.
			out
				nextPutAll: '<<';
				nextPutAll: name;
				nextPutAll: '>>:'.
			self propertyValue do: [:v | out space; nextPutAll: v stringValue].
			out nextPut: $;.
			out contents]
		ifFalse: [super prefix]]

{ #category : #printing }
CssProperty >> printOn: aStream [
	aStream nextPutAll: self prefix]

{ #category : #accessing }
CssProperty >> propertyName [
	^name]

{ #category : #accessing }
CssProperty >> propertyName: aString [
	name := aString]

{ #category : #accessing }
CssProperty >> propertyString [
	^string]

{ #category : #accessing }
CssProperty >> propertyString: aString [
	string := aString]

{ #category : #accessing }
CssProperty >> propertyValue [
	^value]

{ #category : #accessing }
CssProperty >> propertyValue: anObject [
	value := anObject]

{ #category : #accessing }
CssProperty >> stringValue [
	^string]

{ #category : #accessing }
CssProperty >> tag [
	^name]

{ #category : #accessing }
CssProperty >> value [
	^value]

{ #category : #testing }
CssProperty >> valueIsValid [
	| in list |
	self definition isNil ifTrue: [^false].
	value notNil ifTrue: [^true].
	in := string readStream.
	list := OrderedCollection new.
	(self definition valueType addValues: list fromStream: in) ifFalse: [^false].
	in skipSeparators atEnd ifFalse: [^false].
	self propertyValue: list.
	list
		select: [:item | item isString not and: [item isProperty]]
		thenDo: [:item | 
			item start: self start; end: self end.
			self parent addProperty: item].
	^true]

