"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssSelector,
	#superclass : #Object,
	#instVars : [
		'valid'
	],
	#category : #CSS
}

{ #category : #'instance creation' }
CssSelector class >> fromString: aString [
	(aString includes: $,)
		ifTrue: [| in list |
			in := (aString , ' ') readStream.
			list := OrderedCollection new.
			[in atEnd] whileFalse: [| sel |
				sel := CssSelector oneSelectorFromString: (in upTo: $,).
				sel isNil ifTrue: [^CssInvalidSelector new selectorString: aString].
				list add: sel].
			^CssOrSelector new selectors: list asArray]
		ifFalse: [| selector |
			selector := CssSelector oneSelectorFromString: aString.
			^selector isNil
				ifTrue: [CssInvalidSelector new selectorString: aString]
				ifFalse: [selector]]]

{ #category : #'instance creation' }
CssSelector class >> new [
	^super new initialize]

{ #category : #'instance creation' }
CssSelector class >> oneSelectorFromString: aString [
	| reader sel lastOperator pos operators |
	operators := CssRelationshipSelector operators.
	reader := aString readStream.
	sel := nil.
	lastOperator := ' '.
	reader skipSeparators.
	pos := -5.
	[reader atEnd] whileFalse: [| c |
		reader position = pos
			ifTrue: [^CssInvalidSelector new selectorString: aString].
		pos := reader position.
		c := reader peek.
		('.[*#:' includes: c)
			ifTrue: [
				sel isNil
					ifTrue: [sel := CssUniversalSelector readFrom: reader]
					ifFalse: [sel := sel selectorForOperator: lastOperator from: reader]]
			ifFalse: [
				((operators includes: c) and: [sel notNil])
					ifTrue: [
						lastOperator := reader next asString.
						sel isRelationshipSelector
							ifFalse: [sel := (CssRelationshipSelector
								selectorForOperator: lastOperator)
								addSelector: sel]
							ifTrue: [
								sel operator = lastOperator
									ifFalse: [sel := sel selectorForOperator: lastOperator from: reader]]]
					ifFalse: [
						c isLetter
							ifTrue: [
								sel isNil
									ifTrue: [sel := CssTypeSelector readFrom: reader]
									ifFalse: [sel := sel
										selectorForTypeOperator: lastOperator
										from: reader]]
							ifFalse: [
								c = $/ ifTrue: [
									reader next.
									reader peek = $*
										ifTrue: [
											reader prev.
											CssComment new parseContents: reader]
										ifFalse: [reader skip: -1]]]]]].
	^sel]

{ #category : #initialization }
CssSelector >> initialize [
	super initialize.
	valid := true]

{ #category : #testing }
CssSelector >> isAdjacentSelector [
	^false]

{ #category : #testing }
CssSelector >> isAttributeSelector [
	^false]

{ #category : #testing }
CssSelector >> isChildSelector [
	^false]

{ #category : #testing }
CssSelector >> isCSS3 [
	^false]

{ #category : #testing }
CssSelector >> isDescendantSelector [
	^false]

{ #category : #testing }
CssSelector >> isRelationshipSelector [
	^false]

{ #category : #testing }
CssSelector >> isSimple [
	^false]

{ #category : #testing }
CssSelector >> isTypeSelector [
	^false]

{ #category : #testing }
CssSelector >> isValid [
	^valid]

{ #category : #accessing }
CssSelector >> keySelectors [
	^#()]

{ #category : #testing }
CssSelector >> matches: anHtmlElement [
	self subclassResponsibility]

{ #category : #printing }
CssSelector >> printOn: aStream [
	self subclassResponsibility]

{ #category : #parsing }
CssSelector >> selectorForOperator: aString from: aStream [
	| selector |
	selector := (CssRelationshipSelector selectorForOperator: aString)
		addSelector: self.
	selector addSelector: (CssUniversalSelector readFrom: aStream).
	^selector]

{ #category : #parsing }
CssSelector >> selectorForTypeOperator: aString from: aStream [
	| selector |
	selector := (CssRelationshipSelector selectorForOperator: aString)
		addSelector: self.
	selector addSelector: (CssTypeSelector readFrom: aStream).
	^selector]

{ #category : #inquiries }
CssSelector >> selectorsMatching: aBlock [
	^(aBlock value: self) ifTrue: [{self}] ifFalse: [#()]]

{ #category : #inquiries }
CssSelector >> typeSelectors [
	^self selectorsMatching: [:s | s isTypeSelector]]

