"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MethodRemoval,
	#superclass : #MethodChange,
	#instVars : [
		'prev'
	],
	#category : #ProjectChanges
}

{ #category : #testing }
MethodRemoval >> acceptsAsPrev: aChangeRecord [
	^className = aChangeRecord className
		and: [selector = aChangeRecord selector]
		and: [aChangeRecord isKindOf: MethodDefinition]]

{ #category : #perform }
MethodRemoval >> basicPerform [
	| class cm category signature |
	class := self resolveClass.
	class isNil ifTrue: [^self].
	cm := class compiledMethodAt: selector.
	cm notNil
		ifTrue: [
			prev := cm sourceReference changeLink.
			signature := cm signature]
		ifFalse: [signature := class -> selector].
	category := class categoryFor: selector.
	class removeSelector: selector.
	(class selectorsInCategory: category) isEmptyOrNil
		ifTrue: [class organization removeCategory: category].
	self project methodRemoved: signature]

{ #category : #perform }
MethodRemoval >> canOverride: aChangeRecord [
	^aChangeRecord isMethodChange
		and: [className = aChangeRecord className]
		and: [selector = aChangeRecord selector]]

{ #category : #accessing }
MethodRemoval >> changeForCurrentVersion [
	| mth |
	mth := self currentVersion.
	^mth isNil
		ifTrue: [self]
		ifFalse: [MethodDefinition fromCompiledMethod: mth]]

{ #category : #accessing }
MethodRemoval >> changeLink [
	prev isInteger ifTrue: [^{self project id. prev}].
	^prev]

{ #category : #testing }
MethodRemoval >> changesSomething [
	| class |
	(class := self resolveClass) isNil ifTrue: [^true].
	^class includesSelector: selector]

{ #category : #accessing }
MethodRemoval >> completeHeaderSpec [
	| spec |
	spec := super completeHeaderSpec.
	spec add: #prev.
	^spec]

{ #category : #accessing }
MethodRemoval >> currentVersion [
	| result |
	result := Compiler silentlyEvaluate: className.
	result isNil ifTrue: [^nil].
	^result >> self selector]

{ #category : #accessing }
MethodRemoval >> method [
	^self currentVersion]

{ #category : #accessing }
MethodRemoval >> prev [
	^prev]

{ #category : #accessing }
MethodRemoval >> prev: ref [
	prev := ref]

{ #category : #accessing }
MethodRemoval >> sourceCode [
	^className asString , ' removeSelector: ' , selector storeString]

{ #category : #accessing }
MethodRemoval >> sourceReference [
	^self]

{ #category : #undo }
MethodRemoval >> tip [
	^'Removal of ' , className , '>>' , self selector]

{ #category : #testing }
MethodRemoval >> tracksHistory [
	^true]

{ #category : #undo }
MethodRemoval >> undo [
	self prevChange ifNotNil: [:change | 
		self projectChanges
			compile: change sourceCode
			in: self resolveClass
			category: change category]]

