"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #PPParser }

{ #category : '*JavaScript' }
PPParser >> allParsersDo: aBlock [
	self allParsersDo: aBlock visited: IdentitySet new]

{ #category : '*JavaScript' }
PPParser >> allParsersDo: aBlock visited: aCollection [
	(aCollection includes: self) ifTrue: [^self].
	aCollection add: self.
	aBlock evaluateWith: self.
	self children do: [:p | p allParsersDo: aBlock visited: aCollection]]

{ #category : '*JavaScript' }
PPParser >> butNot: notParser [
	" a parser that does not match if the given parser matches.
	returns the result of this parser "

	^ (notParser asParser not, self) ==> [ : elements | elements at: 2 ]]

{ #category : '*JavaScript' }
PPParser >> jseParseAndCountProductions: aString [
	" count how often a production was applied "

	^ self jseCountProductionsWhile: [ : countingParser | countingParser  parse: aString ] do: [ : result : counters | counters ]]

{ #category : '*JavaScript' }
PPParser >> jseToken: tokenType [
	^(JSETokenParser on: self) type: tokenType; yourself]

{ #category : '*JavaScript' }
PPParser >> jseToken: tokenType valueBlock: valueBlock [
	"
	returns a parser that creates JSE tokens of the given type. the literal value is computed by the valueBlock
	"
	^(self jseToken: tokenType) ==> [:token | 
		token parsedValue: (valueBlock cull: token).
		token]]

{ #category : '*JavaScript' }
PPParser >> jseWithLoggingTo: aStream [
	| printBlock |
	printBlock := [:string | 
		string do: [:ch | 
			ch = $&
				ifTrue: [aStream nextPutAll: '&amp;']
				ifFalse: [ch = $<
					ifTrue: [aStream nextPutAll: '&lt;']
					ifFalse: [aStream nextPut: ch]]]].
	^self transform: [:p | 
		p name notNil
			ifTrue: [
				PPWrappingParser on: p block: [:stream :parseBlock | | result |
					aStream
						nextPutAll: '<parse position="';
						print: stream position;
						nextPutAll: '" parser="'.
					printBlock value: p name.
					aStream
						nextPutAll: '">';
						cr;
						nextPutAll: '<dive>';
						cr.
					result := parseBlock value.
					aStream cr; nextPutAll: '</dive>'; cr.
					aStream nextPutAll: '<result>'.
					printBlock value: result literalString.
					aStream nextPutAll: '</result>'; cr.
					aStream nextPutAll: '</parse>'; cr.
					result]]
			ifFalse: [p]]]

{ #category : '*JavaScript' }
PPParser >> listSeparatedBy: aParser [
	"Answer a new parser that parses the receiver one or more times, separated by aParser.
	Returns the elements parsed by the receiver. The separating elements are discarded "

	^ ( PPSequenceParser with: self with: (( PPSequenceParser with: aParser with: self ) ==> [ : nodes | nodes at: 2 ]) star ) 
		==> [: nodes | | array firstElement otherElements |
			firstElement := nodes at: 1.
			otherElements := nodes at: 2.
			array := Array new: otherElements size + 1.
			array at: 1 put: firstElement.
			otherElements notEmpty 
				ifTrue: [ array replaceFrom: 2 to: array size with: otherElements ].
			array
		]]

