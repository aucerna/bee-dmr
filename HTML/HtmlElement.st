"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlElement,
	#superclass : #Object,
	#instVars : [
		'attributes',
		'parent',
		'children',
		'styles',
		'stretch'
	],
	#category : #HTML
}

{ #category : #services }
HtmlElement class >> classForTag: aString [
	^self allSubclasses
		detect: [:c | c tag = aString]
		ifNone: [HtmlCustomElement]]

{ #category : #'instance creation' }
HtmlElement class >> new [
	^super new initialize]

{ #category : #'instance creation' }
HtmlElement class >> newForTag: aString [
	| class element |
	class := self classForTag: aString.
	element := class new.
	class == HtmlCustomElement ifTrue: [element tag: aString].
	^element]

{ #category : #parsing }
HtmlElement class >> parse: aString [
	| html |
	html := HtmlDocument new parseContents: aString readStream.
	(aString trimBlanks beginsWith: '<!DOCTYPE')
		ifFalse: [html := html notNil ifTrue: [html children anyone]].
	html errors notEmpty
		ifTrue: [(HtmlParseError on: html errors anyone) signal].
	^html]

{ #category : #parsing }
HtmlElement class >> parse: aString for: anObject [
	^self parse: aString]

{ #category : #parsing }
HtmlElement class >> parseTag: aStream [
	| tag element error |
	aStream skipSeparators.
	tag := aStream nextWhile: [:ch | ch isAlphanumeric].
	element := self newForTag: tag.
	tag asLowercase = element tag ifFalse: [
		error := HtmlTagNotLowerCaseError new tag: tag.
		element addError: error].
	element parseAttributes: aStream.
	^element]

{ #category : #'instance creation' }
HtmlElement class >> start: s end: e [
	^self new start: s; end: e]

{ #category : #accessing }
HtmlElement class >> tag [
	^((self name allButFirst: 'Html' size) allButLast: 'Element' size) asLowercase]

{ #category : #'instance creation' }
HtmlElement class >> with: anHtmlElement [
	^self new with: anHtmlElement; yourself]

{ #category : #'instance creation' }
HtmlElement class >> withAll: aCollection [
	^self new with: aCollection]

{ #category : #visiting }
HtmlElement >> acceptVisitor: anHtmlElementVisitor [
	anHtmlElementVisitor visitHtmlElement: self]

{ #category : #'adding/removing' }
HtmlElement >> add: anHtmlElement [
	^self add: anHtmlElement at: children size + 1]

{ #category : #'adding/removing' }
HtmlElement >> add: anHtmlElement after: anotherHtmlElement [
	| index |
	index := children indexOf: anotherHtmlElement.
	^self add: anHtmlElement at: index + 1]

{ #category : #'adding/removing' }
HtmlElement >> add: anHtmlElement at: anInteger [
	| child |
	child := (anHtmlElement isKindOf: HtmlElement)
		ifTrue: [anHtmlElement]
		ifFalse: [HtmlTextElement new text: anHtmlElement asString].
	child parent: self.
	^children add: child at: anInteger]

{ #category : #'adding/removing' }
HtmlElement >> add: anHtmlElement before: anotherHtmlElement [
	| index |
	index := children indexOf: anotherHtmlElement.
	^self add: anHtmlElement at: (index - 1 max: 1)]

{ #category : #'adding/removing' }
HtmlElement >> addAll: aCollection [
	aCollection do: [:element | self add: element]]

{ #category : #'adding/removing' }
HtmlElement >> addAnchor [
	^self add: HtmlAElement new]

{ #category : #'adding/removing' }
HtmlElement >> addAngularTemplate: aNgTemplate [
	| script |
	script := self addScript: aNgTemplate contents.
	script type: 'text/ng-template'; id: aNgTemplate id.
	^script]

{ #category : #'adding/removing' }
HtmlElement >> addBreak [
	^self add: HtmlBrElement new]

{ #category : #'adding/removing' }
HtmlElement >> addButton [
	^self add: HtmlButtonElement new]

{ #category : #'adding/removing' }
HtmlElement >> addCode [
	^self add: HtmlCodeElement new]

{ #category : #'adding/removing' }
HtmlElement >> addDiv [
	^self add: HtmlDivElement new]

{ #category : #'adding/removing' }
HtmlElement >> addDivision [
	^self add: HtmlDivElement new]

{ #category : #'adding/removing' }
HtmlElement >> addEm [
	^self add: HtmlEmElement new]

{ #category : #parsing }
HtmlElement >> addError: anHtmlError [
	anHtmlError parent: self.
	self errors add: anHtmlError]

{ #category : #'adding/removing' }
HtmlElement >> addFirst: anHtmlElement [
	anHtmlElement parent: self.
	^children addFirst: anHtmlElement]

{ #category : #'adding/removing' }
HtmlElement >> addGlyphicon: aString [
	^self addSpan glyphicon: aString]

{ #category : #'adding/removing' }
HtmlElement >> addI [
	^self add: HtmlIElement new]

{ #category : #'adding/removing' }
HtmlElement >> addImage [
	^self add: HtmlImgElement new]

{ #category : #'adding/removing' }
HtmlElement >> addInput [
	^self add: HtmlInputElement new]

{ #category : #'adding/removing' }
HtmlElement >> addItalic [
	^self add: HtmlIElement new]

{ #category : #'adding/removing' }
HtmlElement >> addJavascript: anHtmlScript [
	| script |
	script := self addScript: anHtmlScript.
	script type: 'text/javascript'.
	^script]

{ #category : #'adding/removing' }
HtmlElement >> addLabel [
	^self add: HtmlLabelElement new]

{ #category : #'adding/removing' }
HtmlElement >> addLabel: aString for: id [
	^self addLabel add: aString; for: id]

{ #category : #'adding/removing' }
HtmlElement >> addLinkTo: url [
	^self addLinkTo: url label: url]

{ #category : #'adding/removing' }
HtmlElement >> addLinkTo: uri icon: icon [
	| link |
	link := HtmlAElement to: uri glyphicon: icon.
	^self add: link]

{ #category : #'adding/removing' }
HtmlElement >> addLinkTo: url label: label [
	| link |
	link := HtmlAElement to: url label: label.
	^self add: link]

{ #category : #'adding/removing' }
HtmlElement >> addNavigation [
	^self add: HtmlNavElement new]

{ #category : #'adding/removing' }
HtmlElement >> addParagraph [
	^self add: HtmlPElement new]

{ #category : #'adding/removing' }
HtmlElement >> addPre [
	^self add: HtmlPreElement new]

{ #category : #'adding/removing' }
HtmlElement >> addScript: anHtmlScript [
	| script |
	script := anHtmlScript isString
		ifTrue: [HtmlScriptElement with: anHtmlScript]
		ifFalse: [anHtmlScript].
	^self add: script]

{ #category : #'adding/removing' }
HtmlElement >> addSelect [
	^self add: HtmlSelectElement new]

{ #category : #'adding/removing' }
HtmlElement >> addSmall [
	^self add: HtmlSmallElement new]

{ #category : #'adding/removing' }
HtmlElement >> addSpan [
	^self add: HtmlSpanElement new]

{ #category : #'adding/removing' }
HtmlElement >> addSpan: aString [
	^self addSpan class: aString]

{ #category : #'adding/removing' }
HtmlElement >> addStyle: style [
	self styles add: style]

{ #category : #'adding/removing' }
HtmlElement >> addTable [
	^self add: HtmlTableElement new]

{ #category : #'adding/removing' }
HtmlElement >> addUnorderedList [
	^self add: HtmlUlElement new]

{ #category : #inquiries }
HtmlElement >> allStyles [
	| rules |
	rules := OrderedCollection new.
	self stylesheets
		do: [:sheet | sheet children
			select: [:r | r isStyleRule]
			thenDo: [:r | rules add: r]].
	^rules asArray]

{ #category : #enumerating }
HtmlElement >> anySatisfy: aBlock [
	| element |
	element := self detect: aBlock.
	^element notNil]

{ #category : #attributes }
HtmlElement >> ariaHidden: aBoolean [
	self attributeAt: 'aria-hidden' put: aBoolean]

{ #category : #attributes }
HtmlElement >> attributeAt: aString [
	^attributes valueAt: aString]

{ #category : #attributes }
HtmlElement >> attributeAt: aString put: anObject [
	attributes at: aString put: anObject]

{ #category : #attributes }
HtmlElement >> attributes [
	^attributes]

{ #category : #accessing }
HtmlElement >> attributes: aDictionary [
	attributes := aDictionary]

{ #category : #attributes }
HtmlElement >> beHidden [
	self attributeAt: 'hidden' put: nil]

{ #category : #testing }
HtmlElement >> canContainTag: aString [
	^self isComment not and: [self dtd canTag: self dtdTag containTag: aString]]

{ #category : #accessing }
HtmlElement >> children [
	^children]

{ #category : #attributes }
HtmlElement >> class: aString [
	self attributeAt: 'class' put: aString]

{ #category : #attributes }
HtmlElement >> classes [
	| class |
	class := self attributeAt: 'class'.
	^class notNil ifTrue: [$  split: class]]

{ #category : #parsing }
HtmlElement >> closeTagIsOptional [
	^self dtd tagCloseIsOptional: self dtdTag]

{ #category : #contenteditable }
HtmlElement >> contentEditable [
	self attributeAt: 'contenteditable' put: nil]

{ #category : #contenteditable }
HtmlElement >> convertNewLines [
	self attributeAt: 'convert-new-lines' put: true]

{ #category : #attributes }
HtmlElement >> dataAt: aString [
	^attributes at: 'data-' , aString ifAbsent: nil]

{ #category : #attributes }
HtmlElement >> dataAt: aString put: anObject [
	^attributes at: 'data-' , aString put: anObject]

{ #category : #bootstrap }
HtmlElement >> dataTarget: aString [
	self attributeAt: 'data-target' put: aString]

{ #category : #bootstrap }
HtmlElement >> dataToggle: aString [
	self attributeAt: 'data-toggle' put: aString]

{ #category : #inquiries }
HtmlElement >> depth [
	^parent isNil ifTrue: [0] ifFalse: [parent depth + 1]]

{ #category : #enumerating }
HtmlElement >> detect: aBlock [
	self
		elementsDo: [:element | (aBlock evaluateWith: element) ifTrue: [^element]].
	^nil]

{ #category : #enumerating }
HtmlElement >> detectAncestor: aBlock [
	| p |
	p := parent.
	[p notNil] whileTrue: [
		(aBlock value: p) ifTrue: [^p].
		p := p parent].
	^p]

{ #category : #inquiries }
HtmlElement >> document [
	^self parent document]

{ #category : #attributes }
HtmlElement >> draggable [
	self attributeAt: 'draggable' put: 'true']

{ #category : #inquiries }
HtmlElement >> dtd [
	^parent notNil ifTrue: [parent dtd]]

{ #category : #inquiries }
HtmlElement >> dtdTag [
	^self dtd isXML ifFalse: [self tag asUppercase] ifTrue: [self tag]]

{ #category : #enumerating }
HtmlElement >> elementsDo: aBlock [
	aBlock value: self.
	children do: [:e | e elementsDo: aBlock]]

{ #category : #parsing }
HtmlElement >> end [
	^stretch end]

{ #category : #parsing }
HtmlElement >> end: anInteger [
	stretch end: anInteger]

{ #category : #parsing }
HtmlElement >> endTagMissing [
	^self propertyAt: #endTagMissing ifAbsent: false]

{ #category : #parsing }
HtmlElement >> endTagMissing: aBoolean [
	self propertyAt: #endTagMissing put: aBoolean]

{ #category : #parsing }
HtmlElement >> errors [
	^self propertyAt: #errors ifAbsentPut: [OrderedCollection new]]

{ #category : #services }
HtmlElement >> externalVariables [
	^#()]

{ #category : #accessing }
HtmlElement >> first [
	^children notEmpty ifTrue: [children first]]

{ #category : #printing }
HtmlElement >> format [
	^self asString]

{ #category : #bootstrap }
HtmlElement >> glyphicon: aString [
	self class: 'glyphicon glyphicon-' , aString]

{ #category : #'adding/removing' }
HtmlElement >> h1: aString [
	| h |
	h := HtmlH1Element with: aString.
	self add: h]

{ #category : #'adding/removing' }
HtmlElement >> h1: aString class: class [
	| h |
	h := HtmlH1Element with: aString.
	h class: class.
	self add: h]

{ #category : #'adding/removing' }
HtmlElement >> h2: aString [
	| h |
	h := HtmlH2Element with: aString.
	self add: h]

{ #category : #'adding/removing' }
HtmlElement >> h3: aString [
	| h |
	h := HtmlH3Element with: aString.
	self add: h]

{ #category : #'adding/removing' }
HtmlElement >> h4: aString [
	| h |
	h := HtmlH4Element with: aString.
	self add: h]

{ #category : #'adding/removing' }
HtmlElement >> h5: aString [
	| h |
	h := HtmlH5Element with: aString.
	self add: h]

{ #category : #'adding/removing' }
HtmlElement >> h6: aString [
	| h |
	h := HtmlH6Element with: aString.
	self add: h]

{ #category : #testing }
HtmlElement >> hasOnlyText [
	^children size = 1 and: [children anyone isKindOf: HtmlTextElement]]

{ #category : #parsing }
HtmlElement >> hasTrailingSlash [
	^self propertyAt: #trailingSlash ifAbsent: false]

{ #category : #parsing }
HtmlElement >> hasTrailingSlash: aBoolean [
	self propertyAt: #trailingSlash put: aBoolean]

{ #category : #attributes }
HtmlElement >> id [
	^self attributeAt: 'id']

{ #category : #attributes }
HtmlElement >> id: aString [
	self attributeAt: 'id' put: aString]

{ #category : #initialization }
HtmlElement >> initialize [
	super initialize.
	attributes := OrderedDictionary new.
	children := OrderedCollection new.
	stretch := Stretch new]

{ #category : #testing }
HtmlElement >> isBody [
	^false]

{ #category : #'adding/removing' }
HtmlElement >> isCaption [
	^false]

{ #category : #testing }
HtmlElement >> isCDATA [
	^false]

{ #category : #testing }
HtmlElement >> isComment [
	^false]

{ #category : #testing }
HtmlElement >> isEmpty [
	^children isEmpty]

{ #category : #testing }
HtmlElement >> isHead [
	^false]

{ #category : #testing }
HtmlElement >> isRow [
	^false]

{ #category : #testing }
HtmlElement >> isSelfClosing [
	^false]

{ #category : #parsing }
HtmlElement >> isSelfContained [
	^self hasTrailingSlash or: [self dtd tagIsEmpty: self dtdTag]]

{ #category : #testing }
HtmlElement >> isStyle [
	^false]

{ #category : #accessing }
HtmlElement >> label: aString [
	^self with: aString]

{ #category : #inquiries }
HtmlElement >> level [
	^self depth]

{ #category : #services }
HtmlElement >> literals [
	^#()]

{ #category : #attributes }
HtmlElement >> name [
	^self attributeAt: 'name']

{ #category : #attributes }
HtmlElement >> name: aString [
	self attributeAt: 'name' put: aString]

{ #category : #parsing }
HtmlElement >> nextStartIn: aStream [
	| p0 p |
	^children isEmpty
		ifTrue: [
			p0 := aStream position.
			aStream position: self start.
			p := aStream upTo: $>; position.
			aStream position: p0.
			^p]
		ifFalse: [children last end]]

{ #category : #testing }
HtmlElement >> notEmpty [
	^children notEmpty]

{ #category : #contenteditable }
HtmlElement >> onlyText [
	self attributeAt: 'only-text' put: true]

{ #category : #accessing }
HtmlElement >> parent [
	^parent]

{ #category : #accessing }
HtmlElement >> parent: anHtmlElement [
	parent := anHtmlElement]

{ #category : #parsing }
HtmlElement >> parseAttributes: aStream [
	"
	HtmlDivElement new parseAttributes: 'a1=''1'' a2=''2''' readStream
	"
	[aStream atEnd] whileFalse: [| p a v s |
		aStream skipSeparators.
		aStream peek = $/ ifTrue: [^self].
		p := aStream position.
		a := aStream upTo: $=.
		a := a trimBlanks.
		(a includes: $ )
			ifTrue: [
				aStream position: p.
				a := aStream upTo: $ .
				v := nil]
			ifFalse: [
				aStream skipSeparators.
				v := aStream atEnd ifFalse: [
					aStream nextQuotedString ifNil: [
						self addError: (HtmlAttributeValueNotQuotedError new attribute: a).
						aStream upTo: $ ]]].
		attributes at: a ifPresent: [:previous | 
			self addError: (HtmlAttributeMultiplySpecifiedError new
				attribute: a;
				value: v value: previous)].
		attributes at: a put: v]]

{ #category : #parsing }
HtmlElement >> parseContents: aStream [
	children := OrderedCollection new.
	self isSelfContained ifTrue: [
		self end: aStream position.
		^self endTagMissing: true].
	[self end isNil and: [aStream atEnd not]]
		whileTrue: [| raw child closing short |
			raw := aStream skipSeparators; upTo: $<.
			raw size > 0 ifTrue: [self add: raw].
			raw := aStream upTo: $>.
			(raw size > 0
				and: [raw first = $! or: [raw first = $? and: [raw last = $?]]])
				ifTrue: [
					raw first = $? ifFalse: [
						aStream skip: (raw size + 2) negated.
						child := (self dtd isXML and: [raw beginsWith: '<![CDATA['])
							ifTrue: [HtmlXMLCdataElement new]
							ifFalse: [HtmlCommentElement new].
						self add: child.
						child parseContents: aStream]]
				ifFalse: [
					(raw includes: $<)
						ifTrue: [raw := self recoverFromLTIn: raw stream: aStream].
					(raw trimBlanks beginsWith: '/')
						ifTrue: [
							closing := (raw substringsDelimitedBy: '/' , HtmlDTD separators) first asLowercase.
							closing = self tag
								ifTrue: [^self end: aStream position; endTagMissing: false]
								ifFalse: [
									(self detectAncestor: [:e | e tag = closing]) notNil
										ifTrue: [
											self addError: HtmlTagMissingEndError new.
											aStream skip: (raw size + 2) negated.
											self end: aStream position; endTagMissing: true]
										ifFalse: [
											child := (HtmlElement newForTag: raw)
												start: aStream position - raw size - 2;
												end: aStream position.
											self add: child.
											child addError: (HtmlTagMissingStartError new
												position: aStream position - raw size - 1;
												tag: raw)]]]
						ifFalse: [
							short := raw substringsDelimitedBy: '/' , HtmlDTD separators.
							short := short size > 0 ifTrue: [short first] ifFalse: [short].
							(aStream atEnd or: [
								(self canContainTag: short) not
									and: [self closeTagIsOptional]
									and: [| ancestor |
										ancestor := self detectAncestor: [:e | e canContainTag: short].
										(ancestor level > 0 and: [self level - ancestor level < 3])
											or: [short = self tag]]])
								ifTrue: [
									self
										end: (aStream atEnd
											ifTrue: [aStream position]
											ifFalse: [aStream position - raw size - 2]);
										endTagMissing: true.
									aStream atEnd ifFalse: [aStream skip: (raw size + 2) negated].
									^self]
								ifFalse: [
									(short size > 0 and: [short first isLetter])
										ifTrue: [
											child := (HtmlElement parseTag: raw readStream)
												start: aStream position - raw size - 2.
											self add: child.
											child parseContents: aStream]
										ifFalse: [
											child := HtmlCdataElement new
												start: (self nextStartIn: aStream);
												end: aStream position.
											self add: child]]]]].
	(aStream atEnd and: [self end isNil])
		ifTrue: [self end: aStream position; endTagMissing: true]]

{ #category : #printing }
HtmlElement >> printOn: aStream [
	self printOn: aStream indent: 0]

{ #category : #printing }
HtmlElement >> printOn: aStream indent: anInteger [
	| visitor |
	visitor := HtmlFormattingVisitor on: aStream.
	visitor indent: anInteger; visit: self]

{ #category : #printing }
HtmlElement >> printTextOn: rtf [
	self printTextOn: rtf indent: 0]

{ #category : #printing }
HtmlElement >> printTextOn: rtf indent: anInteger [
	| visitor |
	visitor := HtmlPaintingVisitor on: rtf.
	visitor indent: anInteger; visit: self]

{ #category : #parsing }
HtmlElement >> recoverFromLTIn: aString stream: aStream [
	| cdata |
	aStream skip: (aString size - (aString indexOfLastChar: $<)) negated - 1.
	(children isEmpty not and: [children last isCDATA])
		ifTrue: [children last end: aStream position - 1]
		ifFalse: [
			cdata := HtmlCdataElement new
				start: (self nextStartIn: aStream);
				end: aStream position - 1.
			self add: cdata].
	^aStream upTo: $>]

{ #category : #'adding/removing' }
HtmlElement >> remove: anHtmlElement [
	^children remove: anHtmlElement ifAbsent: nil]

{ #category : #'adding/removing' }
HtmlElement >> removeAll [
	children removeAll]

{ #category : #attributes }
HtmlElement >> removeAtrribute: aString [
	attributes removeKey: aString]

{ #category : #'adding/removing' }
HtmlElement >> replace: anHtmlElement with: anotherHtmlElement [
	| child |
	child := anotherHtmlElement isString
		ifTrue: [HtmlTextElement new text: anotherHtmlElement]
		ifFalse: [anotherHtmlElement].
	child parent: self.
	children replace: anHtmlElement with: child.
	^child]

{ #category : #enumerating }
HtmlElement >> select: aBlock [
	| selected |
	selected := OrderedCollection new.
	self
		elementsDo: [:element | (aBlock evaluateWith: element)
			ifTrue: [selected add: element]].
	^selected]

{ #category : #services }
HtmlElement >> selectors [
	^#()]

{ #category : #parsing }
HtmlElement >> start [
	^stretch start]

{ #category : #parsing }
HtmlElement >> start: anInteger [
	stretch start: anInteger]

{ #category : #parsing }
HtmlElement >> stretch [
	^stretch]

{ #category : #attributes }
HtmlElement >> style: aString [
	self attributeAt: 'style' put: aString]

{ #category : #accessing }
HtmlElement >> styles [
	styles isNil ifTrue: [styles := OrderedCollection new].
	^styles]

{ #category : #inquiries }
HtmlElement >> stylesheets [
	| stylesheets |
	stylesheets := OrderedCollection new.
	self elementsDo: [:e | 
		(e respondsTo: #stylesheet)
			ifTrue: [e stylesheet ifNotNil: [:s | stylesheets add: s]]].
	^stylesheets]

{ #category : #accessing }
HtmlElement >> tag [
	^self class tag]

{ #category : #attributes }
HtmlElement >> title: aString [
	self attributeAt: 'title' put: aString]

{ #category : #AngularUI }
HtmlElement >> uibCollapse: aString [
	self attributeAt: 'uib-collapse' put: aString]

{ #category : #AngularUI }
HtmlElement >> uibDropdown [
	self attributeAt: 'uib-dropdown' put: nil]

{ #category : #AngularUI }
HtmlElement >> uibDropdownMenu [
	self attributeAt: 'uib-dropdown-menu' put: nil]

{ #category : #AngularUI }
HtmlElement >> uibDropdownToggle [
	self attributeAt: 'uib-dropdown-toggle' put: nil]

{ #category : #AngularUI }
HtmlElement >> uibTooltip: aString [
	self attributeAt: 'uib-tooltip' put: aString]

{ #category : #AngularUI }
HtmlElement >> uibTooltipPlacement: aString [
	self attributeAt: 'tooltip-placement' put: aString]

{ #category : #'adding/removing' }
HtmlElement >> with: anObject [
	self removeAll.
	^(anObject isCollection andNot: [anObject isString])
		ifTrue: [self addAll: anObject]
		ifFalse: [self add: anObject]]

{ #category : #accessing }
HtmlElement >> withId: id [
	self id = id ifTrue: [^self].
	self children do: [:element | (element withId: id) ifNotNil: [:e | ^e]].
	^nil]

