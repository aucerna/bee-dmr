"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlTableElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #'adding/removing' }
HtmlTableElement >> add: anHtmlElement [
	anHtmlElement class == HtmlCaptionElement
		ifTrue: [^self caption: anHtmlElement].
	anHtmlElement class == HtmlColgroupElement
		ifTrue: [^self colgroup: anHtmlElement].
	anHtmlElement class == HtmlTheadElement ifTrue: [^self head: anHtmlElement].
	anHtmlElement class == HtmlTfootElement
		ifTrue: [^self footer: anHtmlElement].
	anHtmlElement class == HtmlTbodyElement ifTrue: [^self body: anHtmlElement].
	anHtmlElement isRow ifTrue: [^self addRow: anHtmlElement].
	^super add: anHtmlElement]

{ #category : #'adding/removing' }
HtmlTableElement >> addRow [
	^self addRow: HtmlTrElement new]

{ #category : #'adding/removing' }
HtmlTableElement >> addRow: anObject [
	| row body |
	row := anObject isCollection
		ifTrue: [HtmlTrElement cells: anObject]
		ifFalse: [anObject].
	body := self body.
	body notNil ifTrue: [^body add: row].
	row parent: self.
	^children add: row]

{ #category : #accessing }
HtmlTableElement >> body [
	^self detect: [:e | e class == HtmlTbodyElement]]

{ #category : #accessing }
HtmlTableElement >> body: anHtmlTableBody [
	^self childrenAt: #body put: anHtmlTableBody]

{ #category : #accessing }
HtmlTableElement >> caption [
	^(children notEmpty and: [children first class == HtmlCaptionElement])
		ifTrue: [^children first]]

{ #category : #accessing }
HtmlTableElement >> caption: anHtmlCaptionElement [
	^self childrenAt: #caption put: anHtmlCaptionElement]

{ #category : #private }
HtmlTableElement >> childrenAt: aSymbol put: anHtmlElement [
	| current order index |
	current := self perform: aSymbol.
	current notNil ifTrue: [^current add: anHtmlElement].
	order := self childrenOrder.
	index := order indexOf: aSymbol.
	index - 1 to: 1 by: -1 do: [:i | | part previous |
		part := order at: i.
		previous := self perform: part.
		previous notNil ifTrue: [^self add: anHtmlElement after: previous]].
	^self addFirst: anHtmlElement]

{ #category : #private }
HtmlTableElement >> childrenOrder [
	^#(#caption #colgroup #head #footer #body)]

{ #category : #accessing }
HtmlTableElement >> colgroup [
	^self detect: [:e | e class == HtmlColgroupElement]]

{ #category : #accessing }
HtmlTableElement >> colgroup: anHtmlColgroupElement [
	^self childrenAt: #colgroup put: anHtmlColgroupElement]

{ #category : #accessing }
HtmlTableElement >> footer [
	^self detect: [:e | e class == HtmlTfootElement]]

{ #category : #accessing }
HtmlTableElement >> footer: anHtmlTableBody [
	^self childrenAt: #footer put: anHtmlTableBody]

{ #category : #accessing }
HtmlTableElement >> head [
	^self detect: [:e | e class == HtmlTheadElement]]

{ #category : #accessing }
HtmlTableElement >> head: anHtmlHeadElement [
	^self childrenAt: #head put: anHtmlHeadElement]

{ #category : #accessing }
HtmlTableElement >> header: anObject [
	| row |
	row := anObject isCollection
		ifTrue: [HtmlTrElement cells: anObject]
		ifFalse: [anObject].
	self head: row beHeader]

{ #category : #initialization }
HtmlTableElement >> initialize [
	super initialize.
	self add: HtmlTheadElement new; add: HtmlTbodyElement new]

{ #category : #'adding/removing' }
HtmlTableElement >> remove: anHtmlElement [
	self shouldNotImplement]

{ #category : #accessing }
HtmlTableElement >> rows [
	| body |
	body := self body.
	^body notNil
		ifTrue: [body children]
		ifFalse: [self select: [:child | child isRow]]]

{ #category : #accessing }
HtmlTableElement >> rows: aCollection [
	self body with: aCollection]

