"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssStyleSheet,
	#superclass : #CssElement,
	#instVars : [
		'imports',
		'content',
		'url'
	],
	#category : #CSS
}

{ #category : #'class initialization' }
CssStyleSheet class >> fromUrl: aStringOrUrl [
	| doc url |
	url := aStringOrUrl asString.
	doc := InternetFile
		httpGetDocument: url
		args: nil
		accept: 'text/css'
		request: ''.
	^doc isString
		ifFalse: ["life is good"
	
			self new
				content: doc content;
				start: 0;
				end: doc content size;
				url: url]
		ifTrue: [nil]]

{ #category : #'class initialization' }
CssStyleSheet class >> fromUrl: aStringOrUrl parent: aDOMNode [
	| doc href url |
	href := aStringOrUrl asString.
	((href beginsWith: 'http:')
		or: [(href beginsWith: 'https:') or: [href beginsWith: 'ftp:']])
		ifFalse: [url := URL
			combine: aDOMNode document responseUrl asString
			withRelative: href]
		ifTrue: [url := href].
	doc := InternetFile
		httpGetDocument: url
		args: nil
		accept: 'text/css'
		request: ''.
	^doc isString
		ifFalse: [
			"life is good"
	
			self new
				content: doc content;
				start: 0;
				end: doc content size;
				parent: aDOMNode;
				url: url;
				parseContents: doc content readStream]
		ifTrue: [nil]]

{ #category : #parsing }
CssStyleSheet class >> parse: aString [
	^CssStyleSheet new
		content: aString;
		parseStyles: aString readStream media: #('all')]

{ #category : #parsing }
CssStyleSheet class >> parse: aString for: anObject [
	^self parse: aString]

{ #category : #visiting }
CssStyleSheet >> acceptVisitor: aCssElementVisitor [
	aCssElementVisitor visitCssStyleSheet: self]

{ #category : #'adding / removing' }
CssStyleSheet >> addImportedStyleSheet: aCssStyleSheet [
	imports add: aCssStyleSheet]

{ #category : #accessing }
CssStyleSheet >> content [
	^content isNil ifTrue: [self document content] ifFalse: [content]]

{ #category : #accessing }
CssStyleSheet >> content: aString [
	content := aString]

{ #category : #accessing }
CssStyleSheet >> docType [
	^'Content-Type: text/css']

{ #category : #testing }
CssStyleSheet >> endTagMissing [
	^false]

{ #category : #services }
CssStyleSheet >> findLiteral: anObject [
	^nil]

{ #category : #accessing }
CssStyleSheet >> imports [
	^imports]

{ #category : #initialization }
CssStyleSheet >> initialize [
	super initialize.
	imports := OrderedCollection new]

{ #category : #testing }
CssStyleSheet >> isComment [
	^false]

{ #category : #testing }
CssStyleSheet >> isInline [
	^url isNil]

{ #category : #testing }
CssStyleSheet >> isStyleSheet [
	^true]

{ #category : #accessing }
CssStyleSheet >> media [
	| media |
	self parent isNil ifTrue: [^'all'].
	media := self parent attributeAt: 'media'.
	media isNil ifTrue: [^'all'].
	^', ' split: media]

{ #category : #parsing }
CssStyleSheet >> parseAtRule: aStream media: anArray [
	| label child s |
	label := '' writeStream.
	aStream peek = $@ ifFalse: [self halt] ifTrue: [
		s := aStream position.
		aStream next; skipSeparators.
		aStream peek isLetter
			ifTrue: [label nextPut: aStream next]
			ifFalse: [self halt].
		[
			aStream peek isLetter
				or: [aStream peek isDigit or: ['-_' includes: aStream peek]]]
			whileTrue: [label nextPut: aStream next].
		label contents asLowercase = 'media'
			ifTrue: [| media array |
				media := aStream upTo: ${.
				array := (media substringsDelimitedBy: ', ') asArray.
				self parseStyles: aStream media: array]
			ifFalse: [
				child := CssAtRule named: label contents.
				child start: s; media: anArray.
				self addChild: child.
				child parseContents: aStream]]]

{ #category : #parsing }
CssStyleSheet >> parseContents: aStream [
	| reader |
	aStream upToAll: '<!--'.
	aStream position >= self end
		ifTrue: [
			reader := (aStream reset next: self end) readStream.
			reader position: self start]
		ifFalse: [| end |
			aStream position: self end - 1.
			[aStream position > stretch start and: [aStream peek ~= $>]]
				whileTrue: [aStream skip: -1].
			(aStream position > stretch start and: [aStream peek = $>])
				ifTrue: [aStream skip: -1].
			[aStream position > stretch start and: [aStream peek = $-]]
				whileTrue: [aStream skip: -1].
			end := aStream position.
			reader := (aStream reset next: end) readStream.
			reader position: self start; upToAll: '<!--'].
	reader skipSeparators.
	self parseStyles: reader media: self media]

{ #category : #parsing }
CssStyleSheet >> parseStyles: aStream media: anArray [
	aStream skipSeparators.
	[aStream atEnd] whileFalse: [
		aStream skipSeparators.
		aStream peek = $} ifTrue: [
			aStream next.
			^self].
		(aStream peek = $/ and: [
			aStream next.
			aStream peek = $*])
			ifTrue: [| child |
				aStream skip: -1.
				child := CssComment new start: aStream position.
				self addChild: child.
				child parseContents: aStream]
			ifFalse: [
				aStream peek = $@
					ifTrue: [self parseAtRule: aStream media: anArray]
					ifFalse: [
						aStream atEnd ifFalse: [| child |
							child := CssStyleRule new start: aStream position; media: anArray.
							self addChild: child.
							child parseContents: aStream]]]]]

{ #category : #accessing }
CssStyleSheet >> tag [
	^'css-stylesheet']

{ #category : #accessing }
CssStyleSheet >> url [
	^url isNil ifTrue: [self document url] ifFalse: [url]]

{ #category : #accessing }
CssStyleSheet >> url: anURL [
	url := anURL]

