"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlValidator,
	#superclass : #Object,
	#instVars : [
		'url',
		'document',
		'errors',
		'dom',
		'content',
		'loader'
	],
	#category : #HTML
}

{ #category : #'as yet unclassified' }
HtmlValidator class >> on: aString [

	^self new content: aString]

{ #category : #validation }
HtmlValidator >> bruteForceAnalyze [
	^self checkHtmlHeadBody]

{ #category : #validation }
HtmlValidator >> checkHtmlHeadBody [
	| structure in tags pos tag patterns |
	structure := OrderedCollection new.
	patterns := #( "These are the only valid combinations"
				#( '<html' '<head' '</head' '<body' '</body' '</html')
				#( '<html' '<body' '</body' '</html')
				#( '<html' '<head' '</head' '</html')
				#( '<html' '</html')
				#( '<body' '</body')
				#( '<head' '</head' )
				#( )
			).
	tags := patterns first.
	in := self content asLowercase readStream.
	[in atEnd] whileFalse: [| min locs |
		pos := in position.
		locs := tags collect: [:ea | in position: pos; upToAll: ea; position].
		(locs reject: [:ea | locs first = ea]) isEmpty
			ifFalse: [
				min := locs min.
				tag := tags at: (locs indexOf: min).
				structure add: tag.
				in position: min.
				in atEnd ifFalse: [in skip: 1]]
			ifTrue: [in upToEnd]].
	structure := structure asArray.
	(patterns detect: [:ea | structure = ea] ifNone: [nil]) notNil
		ifFalse: [self dom
			addError: (HtmlHeadBodyNestingError new nesting: structure asArray)]
		ifTrue: [
			(dom children size > 1
				and: [(dom children detect: [:ea | ea tag = 'html'] ifNone: [nil]) notNil])
				ifTrue: [
					dom children do: [:ea | 
						(ea isComment or: [ea tag = 'html'])
							ifFalse: [ea addError: HtmlTagImproperlyNestedError new]]]]]

{ #category : #accessing }
HtmlValidator >> content [
	content isNil ifTrue: [content := self document content].
	^content]

{ #category : #accessing }
HtmlValidator >> content: anObject [
	content := anObject]

{ #category : #inquiries }
HtmlValidator >> cssErrors [
	| list |
	list := OrderedCollection new.
	self stylesheets
		do: [:ss | list addAll: (ss allErrorsMatching: [:ea | ea isCssError])].
	^list asArray]

{ #category : #accessing }
HtmlValidator >> document [
	document isNil ifTrue: [
		url notNil ifTrue: [
			document := self loader documentFromUrl: url.
			loader url: document url]].
	^document]

{ #category : #accessing }
HtmlValidator >> document: anObject [
	document := anObject]

{ #category : #accessing }
HtmlValidator >> dom [
	dom isNil ifTrue: [self parse].
	^dom]

{ #category : #accessing }
HtmlValidator >> dom: anObject [
	dom := anObject]

{ #category : #accessing }
HtmlValidator >> errors [
	^errors]

{ #category : #accessing }
HtmlValidator >> errors: anObject [
	errors := anObject]

{ #category : #inquiries }
HtmlValidator >> htmlErrors [
	^self dom allErrorsMatching: [:ea | ea isCssError not]]

{ #category : #accessing }
HtmlValidator >> loader [
	loader isNil ifTrue: [loader := HtmlCache new url: url].
	^loader]

{ #category : #accessing }
HtmlValidator >> loader: anObject [
	loader := anObject]

{ #category : #parsing }
HtmlValidator >> parse [
	dom := HtmlDocument parse: self content]

{ #category : #parsing }
HtmlValidator >> parseStylesheets [
	self dom stylesheets]

{ #category : #inquiries }
HtmlValidator >> stylesheets [
	^self dom stylesheets]

{ #category : #accessing }
HtmlValidator >> url [
	^url]

{ #category : #accessing }
HtmlValidator >> url: anURL [
	url := anURL]

{ #category : #validation }
HtmlValidator >> validate [
	| dtd |
	self parse; checkHtmlHeadBody.
	dtd := HtmlDTD forDocType: self dom docType.
	self dom applyStyles.
	self
		validateAgainstDTD: dtd;
		validateCSSImports;
		validateCSSAgainstDTD: dtd]

{ #category : #validation }
HtmlValidator >> validateAgainstDTD: dtd [
	self dom elementsDo: [:e | 
		(e isComment or: [e isCDATA] or: [e isDocument] or: [e isStyle])
			ifFalse: [
				(dtd tagIsReal: e dtdTag)
					ifFalse: [e addError: HtmlTagUnknownError new]
					ifTrue: [dtd validateChildrenOfNode: e; validateAttributesOfNode: e]]
			ifTrue: [
				e isCDATA ifTrue: [e checkForUnescapedCharacters] ifFalse: [
					e isComment
						ifTrue: [e endTagMissing
							ifTrue: [e addError: HtmlUnclosedCommentError new]]]]]]

{ #category : #validation }
HtmlValidator >> validateCSSAgainstDTD: dtd [
	| rules color backColor |
	rules := dom allStyles.
	rules do: [:rule | 
		rule selector isValid
			ifFalse: [rule addError: CssSelectorNotValidError new]
			ifTrue: [
				rule selector isCSS3
					ifTrue: [rule addError: CssVersion3ConstructFoundError new].
				rule selector typeSelectors do: [:s | 
					s element = s element asLowercase
						ifFalse: [rule
							addError: (CssSelectorElementNotLowercaseError new element: s element)].
					(dtd
						tagIsReal: (dtd isXML
							ifTrue: [s element asLowercase]
							ifFalse: [s element asUppercase]))
						ifFalse: [rule
							addError: (CssSelectorElementNotValidError new element: s element)]].
				(rule matchCount = 0 and: [rule selector isValid])
					ifTrue: [rule addError: CssUnmatchedRuleError new].
				rule properties do: [:p | | lcname |
					lcname := p name asLowercase.
					p name = lcname ifFalse: [
						rule
							addError: (CssPropertyNameNotLowercaseError new propertyName: p name).
						p propertyName: lcname].
					p definition isNil
						ifTrue: [rule
							addError: (CssPropertyUnknownError new propertyName: p name)]
						ifFalse: [
							p valueIsValid
								ifFalse: [rule
									addError: (CssPropertyValueNotValidError new propertyName: p name)]]].
				color := backColor := nil.
				rule properties do: [:p | 
					p name = 'color' ifTrue: [color := p].
					p name = 'background-color' ifTrue: [backColor := p]].
				color = backColor ifFalse: [
					color isNil
						ifTrue: [rule
							addError: (CssColorAndBackgroundColorNotSet new propertyName: 'color')]
						ifFalse: [
							backColor isNil ifTrue: [
								rule
									addError: (CssColorAndBackgroundColorNotSet new
										propertyName: 'background-color')]]]]]]

{ #category : #validation }
HtmlValidator >> validateCSSImports [
	| ss styleFound |
	ss := dom stylesheets.
	ss do: [:ea | 
		styleFound := false.
		ea children do: [:rule | 
			styleFound
				ifFalse: [rule isStyleRule ifTrue: [styleFound := true]]
				ifTrue: [
					rule isAtImportRule
						ifTrue: [rule addError: CssImportAfterStyleRuleError new]]]]]

