"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlTrElement,
	#superclass : #HtmlElement,
	#instVars : [
		'header'
	],
	#category : #HTML
}

{ #category : #'instance creation' }
HtmlTrElement class >> cells: aCollection [
	^self new cells: aCollection]

{ #category : #'adding / removing' }
HtmlTrElement >> addCell [
	| cell |
	cell := header ifTrue: [HtmlThElement new] ifFalse: [HtmlTdElement new].
	^self addCell: cell]

{ #category : #'adding / removing' }
HtmlTrElement >> addCell: anObject [
	| class cell |
	class := header ifTrue: [HtmlThElement] ifFalse: [HtmlTdElement].
	cell := ((anObject isKindOf: HtmlTdElement)
		or: [anObject isKindOf: HtmlThElement])
		ifTrue: [
			self ASSERT: anObject class == class.
			anObject]
		ifFalse: [class with: anObject].
	^self add: cell]

{ #category : #'adding / removing' }
HtmlTrElement >> addCells: aCollection [
	^aCollection do: [:cell | self addCell: cell]]

{ #category : #accessing }
HtmlTrElement >> beHeader [
	| cells |
	header := true.
	cells := self cells collect: [:td | td asHeader].
	self cells: cells]

{ #category : #accessing }
HtmlTrElement >> cells [
	^children]

{ #category : #accessing }
HtmlTrElement >> cells: aCollection [
	self removeAll; addCells: aCollection]

{ #category : #initialization }
HtmlTrElement >> initialize [
	super initialize.
	header := false]

{ #category : #testing }
HtmlTrElement >> isHeader [
	^header]

{ #category : #testing }
HtmlTrElement >> isRow [
	^true]

