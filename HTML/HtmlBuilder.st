"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlBuilder,
	#superclass : #Object,
	#instVars : [
		'document',
		'current'
	],
	#category : #HTML
}

{ #category : #'instance creation' }
HtmlBuilder class >> new [
	^super new initialize]

{ #category : #private }
HtmlBuilder >> add: anHtmlElement [
	^current add: anHtmlElement]

{ #category : #private }
HtmlBuilder >> add: anHtmlElement with: aBlock [
	current add: anHtmlElement.
	self current: anHtmlElement while: aBlock.
	^anHtmlElement]

{ #category : #services }
HtmlBuilder >> anchor: class with: aBlock [
	| a |
	a := HtmlAElement new href: ''; class: class.
	^self add: a with: aBlock]

{ #category : #services }
HtmlBuilder >> anchorWith: aBlock [
	| link |
	link := HtmlAElement new href: ''.
	^self add: link with: aBlock]

{ #category : #accessing }
HtmlBuilder >> body [
	^document body]

{ #category : #services }
HtmlBuilder >> bodyWith: aBlock [
	self current: document body while: aBlock]

{ #category : #services }
HtmlBuilder >> break [
	^current addBreak]

{ #category : #services }
HtmlBuilder >> button: class with: aBlock [
	| button |
	button := HtmlButtonElement new class: class.
	^self add: button with: aBlock]

{ #category : #services }
HtmlBuilder >> cell: aString [
	^current addCell: aString]

{ #category : #services }
HtmlBuilder >> cellWith: aBlock [
	| cell |
	self ASSERT: current class == HtmlTrElement.
	cell := current isHeader
		ifTrue: [HtmlThElement new]
		ifFalse: [HtmlTdElement new].
	^self add: cell with: aBlock]

{ #category : #accessing }
HtmlBuilder >> current [
	^current]

{ #category : #private }
HtmlBuilder >> current: anHtmlElement while: aBlock [
	| previous |
	previous := current.
	current := anHtmlElement.
	[
		aBlock argumentCount = 1
			ifTrue: [aBlock evaluateWith: anHtmlElement]
			ifFalse: [aBlock evaluate]]
		ensure: [current := previous]]

{ #category : #services }
HtmlBuilder >> customWith: aBlock [
	^self add: HtmlCustomElement new with: aBlock]

{ #category : #services }
HtmlBuilder >> div: class with: aBlock [
	| div |
	div := HtmlDivElement new class: class.
	^self add: div with: aBlock]

{ #category : #services }
HtmlBuilder >> divWith: aBlock [
	^self add: HtmlDivElement new with: aBlock]

{ #category : #accessing }
HtmlBuilder >> document [
	^document]

{ #category : #services }
HtmlBuilder >> form: class with: aBlock [
	| form |
	form := HtmlFormElement new class: class.
	^self add: form with: aBlock]

{ #category : #services }
HtmlBuilder >> formWith: aBlock [
	^self add: HtmlFormElement new with: aBlock]

{ #category : #services }
HtmlBuilder >> h: aString level: anInteger class: anotherString [
	| class h |
	self ASSERT: (anInteger between: 1 and: 6).
	class := Smalltalk at: ('HtmlH' , anInteger asString , 'Element') asSymbol.
	h := class new with: aString; class: anotherString.
	^current add: h]

{ #category : #services }
HtmlBuilder >> h: aString level: anInteger with: aBlock [
	| class h |
	self ASSERT: (anInteger between: 1 and: 6).
	class := Smalltalk at: ('HtmlH' , anInteger asString , 'Element') asSymbol.
	h := class new class: aString.
	^self add: h with: aBlock]

{ #category : #services }
HtmlBuilder >> h: anInteger with: aBlock [
	| class |
	self ASSERT: (anInteger between: 1 and: 6).
	class := Smalltalk at: ('HtmlH' , anInteger asString , 'Element') asSymbol.
	^self add: class new with: aBlock]

{ #category : #services }
HtmlBuilder >> h1: aString [
	^current h1: aString]

{ #category : #services }
HtmlBuilder >> h1: aString class: class [
	^self h: aString level: 1 class: class]

{ #category : #services }
HtmlBuilder >> h1: class with: aBlock [
	^self h: class level: 1 with: aBlock]

{ #category : #services }
HtmlBuilder >> h1With: aBlock [
	^self h: 1 with: aBlock]

{ #category : #services }
HtmlBuilder >> h2: aString [
	^current h2: aString]

{ #category : #services }
HtmlBuilder >> h2: aString class: class [
	^self h: aString level: 2 class: class]

{ #category : #services }
HtmlBuilder >> h2: class with: aBlock [
	^self h: class level: 2 with: aBlock]

{ #category : #services }
HtmlBuilder >> h2With: aBlock [
	^self h: 2 with: aBlock]

{ #category : #services }
HtmlBuilder >> h3: aString [
	^current h3: aString]

{ #category : #services }
HtmlBuilder >> h3: aString class: class [
	^self h: aString level: 3 class: class]

{ #category : #services }
HtmlBuilder >> h3: class with: aBlock [
	^self h: class level: 3 with: aBlock]

{ #category : #services }
HtmlBuilder >> h4: aString [
	^current h4: aString]

{ #category : #services }
HtmlBuilder >> h4: class with: aBlock [
	^self h: class level: 4 with: aBlock]

{ #category : #services }
HtmlBuilder >> h4With: aBlock [
	^self h: 4 with: aBlock]

{ #category : #accessing }
HtmlBuilder >> head [
	^document head]

{ #category : #services }
HtmlBuilder >> headerWith: aBlock [
	| header |
	header := HtmlTrElement new beHeader.
	current head: header.
	self current: header while: aBlock.
	^header]

{ #category : #services }
HtmlBuilder >> headWith: aBlock [
	self current: document head while: aBlock]

{ #category : #services }
HtmlBuilder >> highchartWith: aBlock [
	^self add: HtmlHighchartElement new with: aBlock]

{ #category : #services }
HtmlBuilder >> imageWith: aBlock [
	^self add: HtmlImgElement new with: aBlock]

{ #category : #initialization }
HtmlBuilder >> initialize [
	super initialize.
	document := current := HtmlDocument new]

{ #category : #services }
HtmlBuilder >> input: class with: aBlock [
	| input |
	input := HtmlInputElement new class: class.
	^self add: input with: aBlock]

{ #category : #services }
HtmlBuilder >> inputWith: aBlock [
	^self add: HtmlInputElement new with: aBlock]

{ #category : #services }
HtmlBuilder >> italic: aString [
	| i |
	i := HtmlIElement with: aString.
	^current add: i]

{ #category : #services }
HtmlBuilder >> italicWith: aBlock [
	^self add: HtmlIElement new with: aBlock]

{ #category : #services }
HtmlBuilder >> item: class with: aBlock [
	| item |
	item := HtmlLiElement new class: class.
	^self add: item with: aBlock]

{ #category : #services }
HtmlBuilder >> itemWith: aBlock [
	| item |
	item := HtmlLiElement new.
	^self add: item with: aBlock]

{ #category : #services }
HtmlBuilder >> label: class with: aBlock [
	| label |
	label := HtmlLabelElement new class: class.
	^self add: label with: aBlock]

{ #category : #services }
HtmlBuilder >> labelWith: aBlock [
	^self add: HtmlLabelElement new with: aBlock]

{ #category : #services }
HtmlBuilder >> link: class with: aBlock [
	| link |
	link := HtmlAElement new class: class.
	^self add: link with: aBlock]

{ #category : #services }
HtmlBuilder >> linkTo: uri with: aBlock [
	| link |
	link := HtmlAElement new href: uri.
	^self add: link with: aBlock]

{ #category : #services }
HtmlBuilder >> linkWith: aBlock [
	| link |
	link := HtmlLinkElement new href: ''.
	^self add: link with: aBlock]

{ #category : #services }
HtmlBuilder >> nav: class with: aBlock [
	| nav |
	nav := HtmlNavElement new class: class.
	^self add: nav with: aBlock]

{ #category : #services }
HtmlBuilder >> navWith: aBlock [
	^self add: HtmlNavElement new with: aBlock]

{ #category : #services }
HtmlBuilder >> paragraph: aString [
	| p |
	p := HtmlPElement with: aString.
	^current add: p]

{ #category : #services }
HtmlBuilder >> paragraph: class with: aBlock [
	| p |
	p := HtmlPElement new class: class.
	^self add: p with: aBlock]

{ #category : #services }
HtmlBuilder >> paragraphWith: aBlock [
	^self add: HtmlPElement new with: aBlock]

{ #category : #services }
HtmlBuilder >> rawHtml: aString [
	^current add: aString]

{ #category : #services }
HtmlBuilder >> row: class with: aBlock [
	| row |
	row := HtmlTrElement new class: class.
	^self add: row with: aBlock]

{ #category : #services }
HtmlBuilder >> rowWith: aBlock [
	^self add: HtmlTrElement new with: aBlock]

{ #category : #services }
HtmlBuilder >> select: class with: aBlock [
	| select |
	select := HtmlSelectElement new class: class.
	^self add: select with: aBlock]

{ #category : #services }
HtmlBuilder >> selectWith: aBlock [
	^self add: HtmlSelectElement new with: aBlock]

{ #category : #services }
HtmlBuilder >> small: class with: aBlock [
	| small |
	small := HtmlSmallElement new class: class.
	^self add: small with: aBlock]

{ #category : #services }
HtmlBuilder >> smallWith: aBlock [
	^self add: HtmlSmallElement new with: aBlock]

{ #category : #services }
HtmlBuilder >> span: aString [
	| span |
	span := HtmlSpanElement with: aString.
	^self add: span]

{ #category : #services }
HtmlBuilder >> span: class with: aBlock [
	| span |
	span := HtmlSpanElement new class: class.
	^self add: span with: aBlock]

{ #category : #services }
HtmlBuilder >> spanWith: aBlock [
	^self add: HtmlSpanElement new with: aBlock]

{ #category : #services }
HtmlBuilder >> strong: aString [
	| s |
	s := HtmlStrongElement with: aString.
	^current add: s]

{ #category : #services }
HtmlBuilder >> table: class with: aBlock [
	| table |
	table := HtmlTableElement new class: class.
	^self add: table with: aBlock]

{ #category : #services }
HtmlBuilder >> tableHeaderWith: aBlock [
	| header |
	header := HtmlTrElement new.
	header beHeader.
	self current: header while: aBlock.
	current header: header.
	^header]

{ #category : #services }
HtmlBuilder >> tableWith: aBlock [
	^self add: HtmlTableElement new with: aBlock]

{ #category : #services }
HtmlBuilder >> textArea: class with: aBlock [
	| text |
	text := HtmlTextareaElement new class: class.
	^self add: text with: aBlock]

{ #category : #services }
HtmlBuilder >> textAreaWith: aBlock [
	^self add: HtmlTextareaElement new with: aBlock]

{ #category : #services }
HtmlBuilder >> uibProgressbarWith: aBlock [
	| progress |
	progress := HtmlUIBProgressbar new.
	^self add: progress with: aBlock]

{ #category : #services }
HtmlBuilder >> uibTabHeadingWith: aBlock [
	| heading |
	heading := HtmlUIBTabHeading new.
	^self add: heading with: aBlock]

{ #category : #services }
HtmlBuilder >> uibTabsetWith: aBlock [
	| tabset |
	tabset := HtmlUIBTabset new.
	^self add: tabset with: aBlock]

{ #category : #services }
HtmlBuilder >> uibTabWith: aBlock [
	| tab |
	tab := HtmlUIBTab new.
	^self add: tab with: aBlock]

{ #category : #'ui-select' }
HtmlBuilder >> uiSelectChoicesWith: aBlock [
	^self add: HtmlUISelectChoices new with: aBlock]

{ #category : #'ui-select' }
HtmlBuilder >> uiSelectMatchWith: aBlock [
	^self add: HtmlUISelectMatch new with: aBlock]

{ #category : #'ui-select' }
HtmlBuilder >> uiSelectWith: aBlock [
	^self add: HtmlUISelect new with: aBlock]

{ #category : #services }
HtmlBuilder >> unorderedList: class with: aBlock [
	| list |
	list := HtmlUlElement new class: class.
	^self add: list with: aBlock]

{ #category : #services }
HtmlBuilder >> unorderedListWith: aBlock [
	^self add: HtmlUlElement new with: aBlock]

