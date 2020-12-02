"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssElement,
	#superclass : #Object,
	#instVars : [
		'children',
		'parent',
		'errors',
		'stretch'
	],
	#category : #CSS
}

{ #category : #'instance creation' }
CssElement class >> new [
	^super new initialize]

{ #category : #accessing }
CssElement class >> separators [
	^String
		with: Space
		with: Tab
		with: Cr
		with: Lf
		with: Ff]

{ #category : #'instance creation' }
CssElement class >> start: s end: e [
	^self new start: s; end: e]

{ #category : #visiting }
CssElement >> acceptVisitor: aCssElementVisitor [
	aCssElementVisitor visitCssElement: self]

{ #category : #'adding / removing' }
CssElement >> addChild: aCssElement [
	aCssElement parent: self.
	self children add: aCssElement]

{ #category : #'adding / removing' }
CssElement >> addError: anHtmlError [
	anHtmlError parent: self.
	self errors add: anHtmlError]

{ #category : #inquiries }
CssElement >> allErrors [
	| all |
	self errors do: [:n | n position isNil ifTrue: [n position: self start]].
	all := OrderedCollection withAll: self errors.
	self children gather: [:n | n allErrors] in: all.
	^all asArray]

{ #category : #inquiries }
CssElement >> allErrorsMatching: aBlock [
	| matching |
	matching := OrderedCollection new.
	self elementsDo: [:n | n errors select: aBlock in: matching].
	^matching asArray]

{ #category : #converting }
CssElement >> asString [
	^self prefix , self innerContents , self suffix]

{ #category : #accessing }
CssElement >> children [
	^children]

{ #category : #accessing }
CssElement >> children: aCollection [
	children := aCollection.
	children do: [:child | child parent: self]]

{ #category : #inquiries }
CssElement >> content [
	^self parent ifNil: [''] ifNotNil: [self parent content]]

{ #category : #inquiries }
CssElement >> detectAncestor: aBlock [
	| p |
	p := self.
	[p notNil] whileTrue: [
		(aBlock evaluateWith: p) ifTrue: [^p].
		p := p parent].
	^p]

{ #category : #inquiries }
CssElement >> document [
	^self parent document]

{ #category : #enumerating }
CssElement >> elementsDo: aBlock [
	aBlock value: self.
	children do: [:e | e elementsDo: aBlock]]

{ #category : #accessing }
CssElement >> end [
	^stretch end]

{ #category : #accessing }
CssElement >> end: anInteger [
	stretch end: anInteger]

{ #category : #accessing }
CssElement >> errors [
	errors isNil ifTrue: [errors := OrderedCollection new].
	^errors]

{ #category : #accessing }
CssElement >> errors: aCollection [
	errors := aCollection]

{ #category : #services }
CssElement >> externalVariables [
	^#()]

{ #category : #inquiries }
CssElement >> firstAncestor: aString [
	^self detectAncestor: [:p | p !== self and: [p tag = aString]]]

{ #category : #printing }
CssElement >> format [
	^self asString]

{ #category : #testing }
CssElement >> hasAncestor: aString [
	^(self firstAncestor: aString) notNil]

{ #category : #initialization }
CssElement >> initialize [
	super initialize.
	children := OrderedCollection new.
	stretch := 0 thru: 1]

{ #category : #testing }
CssElement >> innerContents [
	| start |
	self children isEmpty ifTrue: [^''].
	start := self children first start.
	^self content readStream
		position: start;
		next: self children last end - start]

{ #category : #testing }
CssElement >> isAtImportRule [
	^false]

{ #category : #testing }
CssElement >> isCDATA [
	^false]

{ #category : #testing }
CssElement >> isComment [
	^false]

{ #category : #testing }
CssElement >> isDocument [
	^false]

{ #category : #testing }
CssElement >> isHTML [
	^false]

{ #category : #testing }
CssElement >> isImplied [
	^false]

{ #category : #testing }
CssElement >> isProperty [
	^false]

{ #category : #testing }
CssElement >> isStyleRule [
	^false]

{ #category : #testing }
CssElement >> isStyleSheet [
	^false]

{ #category : #inquiries }
CssElement >> level [
	| level p |
	level := 0.
	p := self.
	[p notNil] whileTrue: [
		p := p parent.
		p notNil ifTrue: [level := level + 1]].
	^level]

{ #category : #services }
CssElement >> literals [
	^#()]

{ #category : #accessing }
CssElement >> parent [
	^parent]

{ #category : #accessing }
CssElement >> parent: aCssElement [
	parent := aCssElement]

{ #category : #parsing }
CssElement >> parseContents: aStream [
	self subclassResponsibility]

{ #category : #inquiries }
CssElement >> prefix [
	| in e |
	in := self content readStream position: self start.
	e := self children isEmpty
		ifTrue: [self end]
		ifFalse: [self children first start].
	^in next: e - self start]

{ #category : #printing }
CssElement >> printOn: aStream [
	self printOn: aStream indent: 0]

{ #category : #printing }
CssElement >> printOn: aStream indent: anInteger [
	| visitor |
	visitor := CssFormattingVisitor on: aStream.
	visitor indent: anInteger; visit: self]

{ #category : #printing }
CssElement >> printTextOn: rtf [
	self printTextOn: rtf indent: 0]

{ #category : #printing }
CssElement >> printTextOn: rtf indent: anInteger [
	| visitor |
	visitor := CssPaintingVisitor on: rtf.
	visitor indent: anInteger; visit: self]

{ #category : #inquiries }
CssElement >> rawContent [
	| in start |
	start := self start.
	in := self document content readStream position: start.
	^in next: self end - start]

{ #category : #enumerating }
CssElement >> select: aBlock [
	| selected |
	selected := OrderedCollection new.
	self
		elementsDo: [:element | (aBlock evaluateWith: element)
			ifTrue: [selected add: element]].
	^selected]

{ #category : #services }
CssElement >> selectors [
	^#()]

{ #category : #accessing }
CssElement >> start [
	^stretch start]

{ #category : #accessing }
CssElement >> start: anInteger [
	stretch start: anInteger]

{ #category : #inquiries }
CssElement >> suffix [
	| reader node e |
	reader := self content readStream.
	node := self children isEmpty ifTrue: [self] ifFalse: [self children last].
	e := node end.
	reader position: e.
	^reader next: (0 max: self end - e)]

{ #category : #accessing }
CssElement >> tag [
	^'css']

{ #category : #inquiries }
CssElement >> uniqueId [
	| index |
	index := self parent children indexOf: self.
	^self parent uniqueId , '.' , index asString]

{ #category : #validation }
CssElement >> validateAgainstDTD: aDTD [
]

