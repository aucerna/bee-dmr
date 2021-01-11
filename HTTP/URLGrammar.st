"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #URLGrammar,
	#superclass : #PPCompositeParser,
	#category : #HTTP
}

{ #category : #productions }
URLGrammar >> anySatisfying: aBlock message: aString [
	| charset |
	charset := PPCharSetPredicate on: [:char | aBlock evaluateWith: char].
	^PPPredicateObjectParser on: charset message: aString]

{ #category : #productions }
URLGrammar >> ascii [
	^(self
		anySatisfying: [:char | 
			(char codePoint < 128 and: [char isLetter])
				or: [char isDigit]
				or: ['-._~!$&''()*+,;=' includes: char]]
		message: 'ascii character expected')
		signature: URLGrammar -> #ascii]

{ #category : #productions }
URLGrammar >> asciiAt [
	^(self
		anySatisfying: [:char | 
			(char codePoint < 128 and: [char isLetter])
				or: [char isDigit]
				or: ['-._~!$&''()*+,;=:@' includes: char]]
		message: 'letter or digit expected')
		signature: URLGrammar -> #asciiAt]

{ #category : #productions }
URLGrammar >> asciiAtQ [
	^(self
		anySatisfying: [:char | 
			(char codePoint < 128 and: [char isLetter])
				or: [char isDigit]
				or: ['-._~:@?/' includes: char]]
		message: 'letter or digit expected')
		signature: URLGrammar -> #asciiAtQ]

{ #category : #productions }
URLGrammar >> asciiEtc [
	^(self
		anySatisfying: [:char | 
			(char codePoint < 128 and: [char isLetter])
				or: [char isDigit]
				or: ['-._~!$&''()*+,;=:@?/' includes: char]]
		message: 'ascii character expected')
		signature: URLGrammar -> #asciiEtc]

{ #category : #productions }
URLGrammar >> authority [
	^self userInfo optional , self host , self port optional
		signature: URLGrammar -> #authority]

{ #category : #productions }
URLGrammar >> decimalByte [
	^(#digit asParser min: 1 max: 3) flatten ==> [:node | 
		node asInteger < 256
			ifTrue: [node]
			ifFalse: [PPFailingParser message: 'invalid ip octect']]
		signature: URLGrammar -> #decimalByte]

{ #category : #productions }
URLGrammar >> fpath [
	^(self asciiAt / $/ asParser / self percent) star flatten
		signature: URLGrammar -> #fpath]

{ #category : #productions }
URLGrammar >> fragment [
	^$# asParser , (self asciiAtQ / self percent) plus flatten
		signature: URLGrammar -> #fragment]

{ #category : #productions }
URLGrammar >> hexWord [
	^(#hex asParser max: 4) flatten signature: URLGrammar -> #hexWord]

{ #category : #productions }
URLGrammar >> host [
	^self ipv4 / ($[ asParser , self ipv6 , $] asParser) flatten
		/ self hostname
		signature: URLGrammar -> #host]

{ #category : #productions }
URLGrammar >> hostname [
	^self ascii plus flatten signature: URLGrammar -> #hostname]

{ #category : #productions }
URLGrammar >> identifier [
	^#identifier asParser plus flatten signature: URLGrammar -> #identifier]

{ #category : #productions }
URLGrammar >> ipv4 [
	| dot byte |
	dot := '.' asParser.
	byte := self decimalByte.
	^((byte , dot times: 3) , byte) flatten signature: URLGrammar -> #ipv4]

{ #category : #productions }
URLGrammar >> ipv6 [
	| colon word |
	colon := ':' asParser.
	word := self hexWord.
	^((word , colon max: 7) , word) flatten signature: URLGrammar -> #ipv6]

{ #category : #productions }
URLGrammar >> option [
	| space |
	space := self space star flatten.
	^space , self optionName , space , $= asParser , self optionValue
		signature: URLGrammar -> #option]

{ #category : #productions }
URLGrammar >> optionName [
	| character |
	character := self
		anySatisfying: [:char | char isAlphanumeric or: ['_$' includes: char]]
		message: 'letter or digit expected'.
	^(character / self percent) plus flatten signature: URLGrammar
		-> #optionName]

{ #category : #productions }
URLGrammar >> optionValue [
	| character |
	character := self
		anySatisfying: [:char | 
			(char codePoint < 128 and: [char isLetter])
				or: [char isDigit]
				or: [char isSpace]
				or: ['-._~:@?/''(),|\{}"*' includes: char]]
		message: 'letter or digit expected'.
	^(character / self percent) star flatten
		signature: URLGrammar -> #optionValue]

{ #category : #productions }
URLGrammar >> password [
	^self string signature: URLGrammar -> #password]

{ #category : #productions }
URLGrammar >> path [
	| segment |
	segment := self segment.
	^(segment , ($/ asParser , segment) star / segment optional) flatten
		signature: URLGrammar -> #path]

{ #category : #productions }
URLGrammar >> percent [
	^$% asParser , (#hex asParser , #hex asParser) flatten
		signature: URLGrammar -> #percent]

{ #category : #productions }
URLGrammar >> port [
	^$: asParser , #digit asParser plus flatten signature: URLGrammar -> #port]

{ #category : #productions }
URLGrammar >> query [
	| option |
	option := self option.
	^$? asParser , option , ($& asParser , option) star
		/ ($? asParser , option , ($; asParser , option) star)
		/ ($? asParser , self stringExt)
		signature: URLGrammar -> #port]

{ #category : #productions }
URLGrammar >> relativeUrl [
	^$/ asParser optional , self fpath , self query optional
		, self fragment optional
		signature: URLGrammar -> #relativeUrl]

{ #category : #productions }
URLGrammar >> scheme [
	| valid |
	valid := self
		anySatisfying: [:ch | 
			(ch codePoint < 128 and: [ch isLetter])
				or: [ch isDigit]
				or: ['+-.' includes: ch]]
		message: 'improper scheme character'.
	^valid star flatten signature: URLGrammar -> #scheme]

{ #category : #productions }
URLGrammar >> segment [
	^(self asciiAt / self percent) plus signature: URLGrammar -> #segment]

{ #category : #productions }
URLGrammar >> space [
	^$  asParser | '%20' asParser signature: URLGrammar -> #space]

{ #category : #productions }
URLGrammar >> start [
	^self url signature: URLGrammar -> #start]

{ #category : #productions }
URLGrammar >> string [
	^(self ascii / self percent) plus flatten signature: URLGrammar -> #string]

{ #category : #productions }
URLGrammar >> stringExt [
	^(self asciiEtc / self percent) plus flatten
		signature: URLGrammar -> #stringExt]

{ #category : #productions }
URLGrammar >> url [
	^self scheme , $: asParser , ('//' asParser , self authority) optional
		, self relativeUrl
		signature: URLGrammar -> #url]

{ #category : #productions }
URLGrammar >> user [
	^self string signature: URLGrammar -> #user]

{ #category : #productions }
URLGrammar >> userInfo [
	^self user , ($: asParser , self password) optional , $@ asParser
		signature: URLGrammar -> #userInfo]

