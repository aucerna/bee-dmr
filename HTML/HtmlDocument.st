"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlDocument,
	#superclass : #HtmlElement,
	#instVars : [
		'docType',
		'dtd'
	],
	#category : #HTML
}

{ #category : #visiting }
HtmlDocument >> acceptVisitor: anHtmlElementVisitor [
	anHtmlElementVisitor visitHtmlDocument: self]

{ #category : #accessing }
HtmlDocument >> body [
	^self html body]

{ #category : #accessing }
HtmlDocument >> body: anHtmlBody [
	^self html body: anHtmlBody]

{ #category : #testing }
HtmlDocument >> canContainTag: aString [
	^true]

{ #category : #accessing }
HtmlDocument >> docType [
	docType isNil ifTrue: [docType := Html401Strict docType].
	^docType]

{ #category : #accessing }
HtmlDocument >> docType: aString [
	docType := aString.
	dtd := HtmlDTD forDocType: aString]

{ #category : #accessing }
HtmlDocument >> dtd [
	dtd isNil ifTrue: [dtd := HtmlDTD forDocType: self docType].
	^dtd]

{ #category : #accessing }
HtmlDocument >> dtd: anHtmlDTD [
	dtd := anHtmlDTD]

{ #category : #accessing }
HtmlDocument >> head [
	^self html head]

{ #category : #accessing }
HtmlDocument >> head: anHtmlHead [
	^self html head: anHtmlHead]

{ #category : #accessing }
HtmlDocument >> html [
	^self detect: [:e | e class == HtmlHtmlElement]]

{ #category : #initialization }
HtmlDocument >> initialize [
	super initialize.
	self add: HtmlHtmlElement new]

{ #category : #attributes }
HtmlDocument >> lang: aString [
	self attributeAt: 'lang' put: aString]

{ #category : #parsing }
HtmlDocument >> parseContents: aStream [
	| directive |
	children := OrderedCollection new.
	directive := false.
	self start: aStream position.
	[aStream atEnd not] whileTrue: [| start raw end child |
		start := aStream position.
		raw := aStream upTo: $<.
		raw trimBlanks size > 0 ifTrue: [
			end := aStream atEnd
				ifTrue: [aStream position]
				ifFalse: [aStream position - 1].
			child := HtmlCdataElement new
				start: start;
				end: (end max: start).
			self add: child].
		raw := aStream upTo: $>.
		(raw size > 0
			and: [raw first = $! or: [raw first = $? and: [raw last = $?]]])
			ifTrue: [
				raw first = $?
					ifTrue: [
						directive := true.
						self parseProcessingDirective: raw readStream]
					ifFalse: [
						(raw asUppercase beginsWith: '!DOCTYPE')
							ifTrue: [self docType: raw]
							ifFalse: [
								aStream skip: (raw size + 2) negated.
								child := self add: HtmlCommentElement new.
								child parseContents: aStream]]]
			ifFalse: [
				(docType isNil and: [directive])
					ifTrue: [self docType: XHtml1Transitional docType].
				raw := raw trimBlanks.
				raw size > 0 ifTrue: [
					raw first = $/
						ifTrue: [
							child := (HtmlElement newForTag: raw allButFirst)
								start: aStream position - raw size - 2;
								end: aStream position.
							self add: child.
							child addError: (HtmlTagMissingStartError new
								position: aStream position - raw size - 1;
								tag: raw)]
						ifFalse: [
							child := (HtmlElement parseTag: raw readStream)
								start: aStream position - raw size - 2.
							self add: child.
							child parseContents: aStream]]]].
	self end: aStream position.
	docType isNil ifTrue: [self addError: HtmlMissingDocTypeError new]]

{ #category : #parsing }
HtmlDocument >> parseProcessingDirective: aStream [
	aStream upTo: $?; skipSeparators.
	[HtmlDTD separators includes: aStream peek] whileFalse: [aStream next].
	aStream skipSeparators.
	self parseAttributes: (aStream upTo: $?)]

{ #category : #accessing }
HtmlDocument >> tag [
	^'html']

{ #category : #accessing }
HtmlDocument >> title [
	^self head title]

{ #category : #accessing }
HtmlDocument >> title: aString [
	self head title: aString]

