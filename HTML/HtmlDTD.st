"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlDTD,
	#superclass : #Object,
	#instVars : [
		'url',
		'document',
		'errors',
		'dom',
		'content',
		'comments',
		'elements',
		'attLists',
		'entities'
	],
	#classVars : [
		'Cache'
	],
	#category : #HTML
}

{ #category : #accessing }
HtmlDTD class >> default [
	^self forDocType: self docType]

{ #category : #accessing }
HtmlDTD class >> defaultUrl [
	self subclassResponsibility]

{ #category : #accessing }
HtmlDTD class >> docType [
	^'abstract']

{ #category : #accessing }
HtmlDTD class >> forDocType: aString [
	| dt delims |
	delims := self separators , '<>'.
	dt := aString without: delims.
	Cache isNil ifTrue: [Cache := Dictionary new].
	^Cache
		at: dt
		ifAbsentPut: [(self allSubclasses
			detect: [:c | (c docType without: delims) = dt]
			ifNone: [Html401Strict]) new]]

{ #category : #'instance creation' }
HtmlDTD class >> new [
	^super new initialize]

{ #category : #'instance creation' }
HtmlDTD class >> on: aString [
	^self new content: aString]

{ #category : #accessing }
HtmlDTD class >> resetCache [
	"
	HtmlDTD resetCache
	"
	Cache := nil]

{ #category : #accessing }
HtmlDTD class >> separators [
	^String
		with: Character space
		with: Character tab
		with: Character cr
		with: Character lf
		with: Character ff]

{ #category : #services }
HtmlDTD class >> updateFromWeb [
	self
		compile: 'dtd' , Character cr asString , '^'
			, self defaultUrl retrieveContents contents printString
		classified: 'resources']

{ #category : #'adding / removing' }
HtmlDTD >> addAttList: aCollection [
	attLists add: aCollection]

{ #category : #'adding / removing' }
HtmlDTD >> addComment: comment [
	comments add: comment]

{ #category : #'adding / removing' }
HtmlDTD >> addElement: element [
	elements add: element]

{ #category : #'adding / removing' }
HtmlDTD >> addEntity: entity [
	entities add: entity]

{ #category : #accessing }
HtmlDTD >> attLists [
	^attLists isNil ifTrue: [#()] ifFalse: [attLists]]

{ #category : #inquiries }
HtmlDTD >> attrListForTag: aTag [
	^attLists detect: [:ea | ea tagMatches: aTag] ifNone: nil]

{ #category : #testing }
HtmlDTD >> canTag: tag1 containTag: tag2 [
	| element |
	element := self elementForTag: tag1 asUppercase.
	^element notNil and: [element allowsTag: tag2 asUppercase]]

{ #category : #accessing }
HtmlDTD >> comments [
	^comments]

{ #category : #accessing }
HtmlDTD >> comments: aCollection [
	comments := aCollection]

{ #category : #accessing }
HtmlDTD >> content [
	content isNil
		ifTrue: [content := (self respondsTo: #dtd)
			ifTrue: [self dtd]
			ifFalse: [self document content]].
	^content]

{ #category : #accessing }
HtmlDTD >> content: anObject [
	content := anObject]

{ #category : #accessing }
HtmlDTD >> defaultUrl [
	^self class defaultUrl]

{ #category : #accessing }
HtmlDTD >> document [
	^document isNil
		ifFalse: [document]
		ifTrue: [url isNil
			ifFalse: [document := url asURL retrieveContents]
			ifTrue: [nil]]]

{ #category : #accessing }
HtmlDTD >> document: anObject [
	document := anObject]

{ #category : #accessing }
HtmlDTD >> dom [
	^dom]

{ #category : #accessing }
HtmlDTD >> dom: anObject [
	dom := anObject]

{ #category : #inquiries }
HtmlDTD >> elementForTag: aString [
	^elements detect: [:e | e tagMatches: aString] ifNone: nil]

{ #category : #accessing }
HtmlDTD >> elements [
	^elements]

{ #category : #accessing }
HtmlDTD >> entities [
	^entities]

{ #category : #accessing }
HtmlDTD >> errors [
	^errors]

{ #category : #accessing }
HtmlDTD >> errors: anObject [
	errors := anObject]

{ #category : #private }
HtmlDTD >> expandAllTokens [
	self expandElementTokens; expandAttListTokens]

{ #category : #private }
HtmlDTD >> expandAttListTokens [
	| expanded changed |
	changed := true.
	expanded := attLists.
	[changed] whileTrue: [
		changed := false.
		expanded := expanded collect: [:item | 
			item collect: [:ea | | s |
				s := self expandTokensInLine: ea.
				s = ea ifFalse: [changed := true].
				s]]].
	^attLists := expanded]

{ #category : #private }
HtmlDTD >> expandElementTokens [
	| expanded changed |
	changed := true.
	expanded := elements.
	[changed] whileTrue: [
		changed := false.
		expanded := expanded collect: [:ea | | s |
			s := self expandTokensInLine: ea.
			s = ea ifFalse: [changed := true].
			s]].
	^elements := expanded]

{ #category : #private }
HtmlDTD >> expandTokensInLine: aString [
	| in out s |
	in := aString readStream.
	out := '' writeStream.
	[in atEnd] whileFalse: [| def |
		s := in upTo: $%.
		out nextPutAll: s.
		in atEnd ifFalse: [
			def := self tokenDefinition: (in upTo: $;).
			out nextPutAll: def]].
	^out contents]

{ #category : #initialization }
HtmlDTD >> initialize [
	super initialize.
	comments := OrderedCollection new.
	elements := OrderedCollection new.
	entities := OrderedCollection new.
	attLists := OrderedCollection new.
	self parse]

{ #category : #testing }
HtmlDTD >> isXML [
	^false]

{ #category : #private }
HtmlDTD >> objectifyAttLists [
	attLists := attLists collect: [:ea | HtmlDTDAttrList fromParsedArray: ea]]

{ #category : #private }
HtmlDTD >> objectifyElements [
	elements := elements collect: [:ea | HtmlDTDElement fromParsedString: ea].
	elements do: [:ea | ea cacheAllowedElementsForDTD: self]]

{ #category : #parsing }
HtmlDTD >> parse [
	| in s |
	self reset.
	in := self content readStream.
	[in atEnd] whileFalse: [
		in skipSeparators.
		in upTo: $<.
		s := in upTo: $ .
		(s beginsWith: '!--') ifTrue: [self readComment: in] ifFalse: [
			(s beginsWith: '!ELEMENT') ifTrue: [self readElement: in] ifFalse: [
				(s beginsWith: '!ATTLIST') ifTrue: [self readAttList: in] ifFalse: [
					(s beginsWith: '!ENTITY') ifTrue: [self readEntity: in] ifFalse: [
						(s beginsWith: '![')
							ifTrue: [self readConditionalElement: in]
							ifFalse: [s trimBlanks size > 0 ifTrue: [self halt]]]]]]].
	self expandAllTokens; objectifyAttLists; objectifyElements]

{ #category : #parsing }
HtmlDTD >> readAttList: aStream [
	| words list |
	words := (aStream upTo: $>) trimBlanks
		substringsDelimitedBy: self class separators.
	list := OrderedCollection with: words first.
	words := String
		streamContents: [:s | words allButFirst
			do: [:w | s nextPutAll: w]
			separatedBy: [s space]].
	list add: (self stripCommentsFrom: words).
	self addAttList: list asArray]

{ #category : #parsing }
HtmlDTD >> readComment: aStream [
	| s |
	s := aStream upTo: $>.
	[s endsWith: '--'] whileFalse: [s := s , '>' , (aStream upTo: $>)].
	self addComment: s]

{ #category : #parsing }
HtmlDTD >> readConditionalElement: aStream [
	| s |
	s := aStream upTo: $>.
	[s endsWith: ']]'] whileFalse: [s := s , '>' , (aStream upTo: $>)]]

{ #category : #parsing }
HtmlDTD >> readElement: aStream [
	| s |
	s := aStream upTo: $>.
	self addElement: (self stripCommentsFrom: s) trimBlanks]

{ #category : #parsing }
HtmlDTD >> readEntity: aStream [
	| s in out |
	out := (String new: 100) writeStream.
	s := (self stripCommentsFrom: (aStream upTo: $>)) trimBlanks.
	in := s readStream.
	in upTo: $%.
	out nextPutAll: '% '.
	in skipSeparators.
	[in peek isBlank] whileFalse: [out nextPut: in next].
	in skipSeparators.
	out nextPut: $ ; nextPutAll: in upToEnd.
	self addEntity: out contents trimBlanks]

{ #category : #private }
HtmlDTD >> reset [
	entities removeAll.
	comments removeAll.
	elements removeAll.
	attLists removeAll]

{ #category : #private }
HtmlDTD >> stripCommentsFrom: aString [
	| in out |
	in := aString readStream.
	out := (String new: aString size) writeStream.
	[in atEnd] whileFalse: [
		out nextPutAll: (in upToAll: '--').
		in upToAll: '--'].
	^out contents]

{ #category : #testing }
HtmlDTD >> tag: aTag allowsAttribute: anAttribute [
	| a |
	a := self attrListForTag: aTag.
	^a isNil ifFalse: [(a attributeNamed: anAttribute) notNil] ifTrue: [false]]

{ #category : #testing }
HtmlDTD >> tag: aTag attribute: anAttribute hasValidValue: aValue [
	| a adef |
	a := self attrListForTag: aTag.
	^a isNil ifTrue: [false] ifFalse: [
		adef := a attributeNamed: anAttribute.
		adef isNil
			ifTrue: [false]
			ifFalse: [adef type isString
				ifTrue: [true]
				ifFalse: [adef type allowsItem: aValue]]]]

{ #category : #testing }
HtmlDTD >> tag: aTag canContainTag: anotherTag [
	| element |
	element := self elementForTag: aTag asUppercase.
	^element notNil
		ifTrue: [element allowsTag: anotherTag asUppercase]
		ifFalse: [false]]

{ #category : #testing }
HtmlDTD >> tagCloseIsOptional: aString [
	| element |
	element := self elementForTag: aString.
	^element notNil and: [element endIsOptional]]

{ #category : #testing }
HtmlDTD >> tagIsEmpty: tag [
	^elements anySatisfy: [:e | (e tagMatches: tag) and: [e isEmpty]]]

{ #category : #testing }
HtmlDTD >> tagIsOptional: aTag [
	| decl |
	decl := self elements detect: [:ea | ea beginsWith: aTag asUppercase].
	^((Character space split: decl) at: 2) = 'O']

{ #category : #testing }
HtmlDTD >> tagIsReal: aTag [
	^(self elementForTag: aTag) notNil]

{ #category : #private }
HtmlDTD >> tokenDefinition: aString [
	| fmt def in |
	fmt := (aString copyWithout: $%) copyWithout: $;.
	fmt := '% ' , fmt , ' '.
	def := entities
		detect: [:e | e beginsWith: fmt]
		ifNone: ['"' , aString , '"'].
	in := def readStream.
	in upTo: $".
	^in upTo: $"]

{ #category : #accessing }
HtmlDTD >> url [
	url isNil ifTrue: [url := self defaultUrl].
	^url]

{ #category : #accessing }
HtmlDTD >> url: anURL [
	url := anURL]

{ #category : #validation }
HtmlDTD >> validateAttributesOfNode: aNode [
	aNode attributes copy keysAndValuesDo: [:k :v | | attList lck |
		attList := self attrListForTag: aNode dtdTag.
		lck := k asLowercase.
		(attList includesAttribute: lck)
			ifFalse: [aNode addError: (HtmlAttributeUnknownError new attribute: k)]
			ifTrue: [
				k = lck ifFalse: [
					aNode addError: (HtmlAttributeNotLowerCaseError new attribute: k).
					aNode attributes at: lck put: v.
					aNode attributes removeKey: k].
				v isNil
					ifTrue: [
						(self isXML or: [((attList attributeNamed: lck) allowsValue: lck) not])
							ifTrue: [aNode
								addError: (HtmlAttributeValueMissingError new attribute: k)]]
					ifFalse: [
						((attList attributeNamed: lck) allowsValue: v)
							ifFalse: [aNode
								addError: (HtmlAttributeValueNotValidError new attribute: k)]]]]]

{ #category : #validation }
HtmlDTD >> validateChildrenOfNode: aNode [
	| element children stream |
	(aNode isComment or: [aNode isCDATA]) ifTrue: [^self].
	element := self elementForTag: aNode dtdTag.
	children := aNode children reject: [:ea | ea isComment].
	stream := children readStream.
	(element contentRule validateChildren: stream ofNode: aNode)
		ifTrue: []
		ifFalse: [
			stream atEnd ifFalse: [
				(self tag: aNode dtdTag canContainTag: stream peek dtdTag)
					ifFalse: [stream peek addError: HtmlTagImproperlyNestedError new]]]]

