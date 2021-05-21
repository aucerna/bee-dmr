"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ClassDuplicate,
	#superclass : #ClassChange,
	#instVars : [
		'duplicate'
	],
	#category : #ProjectChanges
}

{ #category : #perform }
ClassDuplicate >> addToProject: aBeeModule [
	| class |
	class := Smalltalk at: duplicate asSymbol ifAbsent: [^self].
	aBeeModule addClass: class]

{ #category : #private }
ClassDuplicate >> basicPerform [
	| class |
	class := self resolveClass.
	class isNil ifTrue: [^self].
	(Smalltalk includesKey: duplicate asSymbol) ifTrue: [^self].
	^class duplicateWithName: duplicate]

{ #category : #testing }
ClassDuplicate >> canPerform [
	self resolveClass ifNil: [^false].
	(Smalltalk includesKey: duplicate asSymbol) ifTrue: [^false].
	^true]

{ #category : #testing }
ClassDuplicate >> changesSomething [
	^self resolveClass notNil]

{ #category : #accessing }
ClassDuplicate >> duplicateAs: aString [
	duplicate := aString]

{ #category : #'filein/out' }
ClassDuplicate >> readFrom: aStream [
	| ast statement |
	ast := self parse: aStream nextChunk.
	statement := ast statements anyone.
	duplicate := statement arguments anyone value.
	className := statement receiver value]

{ #category : #accessing }
ClassDuplicate >> refersTo [
	^{self class. duplicate}]

{ #category : #accessing }
ClassDuplicate >> sourceCode [
	^className , ' duplicateWithName: ' , duplicate storeString]

{ #category : #private }
ClassDuplicate >> tip [
	^'Duplicate ' , className , ' as ' , duplicate]

{ #category : #undo }
ClassDuplicate >> undo [
	| class |
	class := Smalltalk classNamed: duplicate.
	class isNil ifTrue: [^self].
	self projectChanges forgetClass: class]

