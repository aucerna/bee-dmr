"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JavascriptLexicalTest,
	#superclass : #JavascriptParserTest,
	#category : #'JavaScript\Tests'
}

{ #category : #private }
JavascriptLexicalTest >> parse: aString expectTokens: expecedTokenStrings [
	| tokens tokenStrings |
	tokens := self parser parse: aString.
	self assert: tokens isPetitFailure not description: tokens printString.
	tokens := tokens asArray.
	tokenStrings := tokens collect: [:token | token value].
	self
		assert: tokenStrings = expecedTokenStrings
		description: aString , ': Expected ' , expecedTokenStrings printString
			, ' got: '
			, tokenStrings printString.
	^tokens]

{ #category : #private }
JavascriptLexicalTest >> parse: aString expectTokenValue: tokenValue type: tokenType [
	| tokens |
	tokens := self parser parse: aString.
	self
		parsedString: aString
		tokens: tokens
		expectTokenValue: tokenValue
		type: tokenType.
	^tokens]

{ #category : #private }
JavascriptLexicalTest >> parsedString: aString
tokens: tokens
expectTokenValue: tokenValue
type: tokenType [
	| token |
	self
		assert: tokens isPetitFailure not
		description: aString , ' : ' , tokens printString.
	self
		assert: tokens size = 1
		description: aString , ': Expected one token, got '
			, tokens size printString
			, ': '
			, tokens printString.
	token := tokens first.
	self
		assert: (token isKindOf: JSEToken)
		description: aString , ': Expected token: ' , token printString.
	self
		assert: token literalValue = tokenValue
		description: aString , ': Parsed: ' , token literalValue printString
			, ', expected: '
			, tokenValue printString.
	self
		assert: token type = tokenType
		description: aString , ': Parsed type: ' , token type printString
			, ', expected: '
			, tokenType printString.
	^token]

{ #category : #private }
JavascriptLexicalTest >> parser [
	^self class parserResource lexicalParser]

{ #category : #private }
JavascriptLexicalTest >> parseRegularExpression: aString [

	^ self parseRegularExpression: aString flags: nil]

{ #category : #private }
JavascriptLexicalTest >> parseRegularExpression: aString flags: flags [
	| tokens |
	tokens := self parser parse: 'r = /' , aString , '/' , (flags ifNil: ['']).
	tokens isPetitFailure ifTrue: [^tokens].
	self
		assert: tokens size = 3
		description: aString
			, ' :  three tokens expected, string probably not parsed as regular expression'.
	self
		parsedString: aString
		tokens: (tokens copyFrom: 3 to: 3)
		expectTokenValue: aString
		type: #regex.
	^tokens at: 3]

{ #category : #'testing - private' }
JavascriptLexicalTest >> privateTestEscapeCharacter: character with: escapeCharacter quote: quoteCharacter [

	self 
		parse: ( String with: quoteCharacter with: $\ with: escapeCharacter with: quoteCharacter )
		expectTokenValue: ( String with: character )
		type: #string.]

{ #category : #'testing - private' }
JavascriptLexicalTest >> privateTestStringWithQuote: quoteString [

	self parse: quoteString, 'Test', quoteString expectTokenValue: 'Test' type: #string.
	self parse: quoteString, quoteString expectTokenValue: '' type: #string.

	self assertParseFailure: quoteString, quoteString, quoteString.
	self assertParseFailure: quoteString, 'Missing quote'.
	JSELexicalParser lineTerminatorCodeUnitValues do: [ : codeValue | | string |
		string := 'First', (String with: (Character codePoint: codeValue)), 'Second'.
		self assertParseFailure: quoteString, string, quoteString.
	].]

{ #category : #'7.8.2 Boolean Literals' }
JavascriptLexicalTest >> testBooleanLiteral [

	self parse: 'true' expectTokenValue: true type: #boolean.
	self parse: 'false' expectTokenValue: false type: #boolean.]

{ #category : #'11.1 Primary Expressions' }
JavascriptLexicalTest >> testCallExpression [

	self parse: 'bar()' expectTokens: #('bar' '(' ')').
	self parse: 'bar(arg1)' expectTokens: #('bar' '(' 'arg1' ')').
	self parse: 'foo.bar(arg1)' expectTokens: #('foo' '.' 'bar' '(' 'arg1' ')').]

{ #category : #'7.8.3 Numeric Literals' }
JavascriptLexicalTest >> testDecimalIntegerLiteral [

	0 to: 10 do: [ : i |
		self parse: i printString expectTokenValue: i type: #numeric.
	].
	self parse: '12345' expectTokenValue: 12345 type: #numeric.
	self parse: '1.2' expectTokenValue: (self floatFrom: '1.2') type: #numeric.
	self parse: '.2' expectTokenValue: (self floatFrom: '0.2') type: #numeric.
	self parse: '1e3' expectTokenValue: 1000 type: #numeric.
	self parse: '1e+3' expectTokenValue: 1000 type: #numeric.
	self parse: '1e-2' expectTokenValue: (10 raisedTo: -2) type: #numeric.
	self parse: '1E3' expectTokenValue: 1000 type: #numeric.
	self parse: '12.34E3' expectTokenValue: (self floatFrom: '12.34e3') type: #numeric.
	self parse: '2.3E-2' expectTokenValue: (self floatFrom: '2.3e-2') type: #numeric.
	self parse: '2.3E+2' expectTokenValue: (self floatFrom: '2.3e2') type: #numeric.
	self parse: '1.3E+50' expectTokenValue: (self floatFrom: '1.3e50') type: #numeric.]

{ #category : #'7.8.4 String Literals' }
JavascriptLexicalTest >> testDoubleQuotedString [

	self privateTestStringWithQuote: '"'.]

{ #category : #'7.8.4 String Literals' }
JavascriptLexicalTest >> testEscapeCharacters [

	(Array with: $" with: $') do: [ : quote |
		self privateTestEscapeCharacter: (Character codePoint: 16r08) with: $b quote: quote.
		self privateTestEscapeCharacter: (Character codePoint: 16r09) with: $t quote: quote.
		self privateTestEscapeCharacter: (Character codePoint: 16r0A) with: $n quote: quote.
		self privateTestEscapeCharacter: (Character codePoint: 16r0B) with: $v quote: quote.
		self privateTestEscapeCharacter: (Character codePoint: 16r0C) with: $f quote: quote.
		self privateTestEscapeCharacter: (Character codePoint: 16r0D) with: $r quote: quote.
		self privateTestEscapeCharacter: $" with: $" quote: quote.
		self privateTestEscapeCharacter: $' with: $' quote: quote.
		self privateTestEscapeCharacter: $\ with: $\ quote: quote.
	].]

{ #category : #'11.1 Primary Expressions' }
JavascriptLexicalTest >> testGroupedExpression [

	self parse: '((1+23)+45)' expectTokens: #('(' '(' '1' '+' '23' ')' '+' '45' ')')]

{ #category : #'7.8.4 String Literals' }
JavascriptLexicalTest >> testHexEscapeSequence [
	self
		parse: '"a\xbcdef"'
		expectTokenValue: (WideString with: $a with: (Character codePoint: 16rBC))
			, 'def'
		type: #string]

{ #category : #'7.8.4 String Literals' }
JavascriptLexicalTest >> testHexEscapeSequence2 [
	self
		parse: '"\xbc"'
		expectTokenValue: 16rBC asCharacter asString
		type: #string]

{ #category : #'7.8.3 Numeric Literals' }
JavascriptLexicalTest >> testHexIntegerLiteral [

	self parse: '0x12345' expectTokenValue: 16r12345 type: #numeric.
	self parse: '0Xabcdef' expectTokenValue: 16rabcdef type: #numeric.]

{ #category : #'7.6 Identifier Names and Identifiers' }
JavascriptLexicalTest >> testIdentifier [

	#('foo' 'IF' 'foo42') do: [ : identifier |
		self parse: identifier expectTokenValue: identifier type: #identifier.
	].]

{ #category : #'7.6 Identifier Names and Identifiers' }
JavascriptLexicalTest >> testIdentifierName [
	JSELexicalParser keywords , JSELexicalParser futureReservedWords
		do: [:reservedWord | 
			self
				parse: reservedWord
				expectTokenValue: reservedWord
				type: #identifierName]]

{ #category : #'7.6 Identifier Names and Identifiers' }
JavascriptLexicalTest >> testIdentifierNameNonAscii [
	self parse: '\u0069\u0066' expectTokenValue: 'if' type: #identifierName]

{ #category : #'7.6 Identifier Names and Identifiers' }
JavascriptLexicalTest >> testIdentifierNonAscii [

	" the famous $ variable name "
	self parse: '$' expectTokenValue: '$' type: #identifier.

	" another special character "
	self parse: '_' expectTokenValue: '_' type: #identifier.

	" funny, but valid "
	self parse: '\u002AAsterisk' expectTokenValue: '*Asterisk' type: #identifier.
	self parse: '\u0020Space' expectTokenValue: ' Space' type: #identifier.
	self parse: '\u0000' expectTokenValue: (String with: (Character codePoint: 0)) type: #identifier.]

{ #category : #'7.8.4 String Literals' }
JavascriptLexicalTest >> testLineContiunation [

	| string |
	JSELexicalParser lineTerminatorCodeUnitValues do: 
		[: codeValue | | lineTerminator |
			lineTerminator := Character codePoint: codeValue.
			string := '"First' , ( String with: $\ with: lineTerminator ) , 'Second"'.
			self parse: string expectTokenValue: 'FirstSecond' type: #string
		].
	string := '"First' , ( String with: $\ with: Character cr with: Character lf ) , 'Second"'.
	self parse: string expectTokenValue: 'FirstSecond' type: #string.]

{ #category : #'7.3 Line Terminators' }
JavascriptLexicalTest >> testLineTerminator [
	" line terminators are removed from the token stream. the next token is flagged "

	JSELexicalParser lineTerminatorCodeUnitValues do: [ : codeValue |
		| character tokens |
		character := (Character codePoint: codeValue).
		tokens := self parse: (String with: $1 with: character with: $2 with: Character space with: $3) expectTokens: #('1' '2' '3').
		self assert: (tokens at: 1) hasPreceedingLineTerminator not.
		self assert: (tokens at: 2) hasPreceedingLineTerminator.
		self assert: (tokens at: 1) hasPreceedingLineTerminator not.
	].]

{ #category : #'Bee extensions' }
JavascriptLexicalTest >> testMacro [
	#('#foo' '#IF' '#foo42')
		do: [:identifier | self
			parse: identifier
			expectTokenValue: identifier allButFirst
			type: #macro]]

{ #category : #'11.2 Left-Hand-Side Expressions' }
JavascriptLexicalTest >> testMemberExpression [

	self parse: 'foo[bar]' expectTokens: #('foo' '[' 'bar' ']').
	self parse: 'foo.bar' expectTokens: #('foo' '.' 'bar').]

{ #category : #'7.4 Comments' }
JavascriptLexicalTest >> testMultiLineComment [

	| multilineString |
	self parse: '/*test*/' expectTokens: #().
	self parse: '/**test**/' expectTokens: #().
	self parse: '/* * test * */' expectTokens: #().
	self parse: '123 /*123 is a magic number*/ 456' expectTokens: #('123' '456').
	multilineString := 'real', (String with: Character cr with: Character cr), 'multiline'.
	self parse: '123 /*', multilineString, '*/ 456' expectTokens: (Array with: '123' with: '456').]

{ #category : #'15.10 Regular Expression Objects' }
JavascriptLexicalTest >> testNoRegularExpression [

	" single line comment, not an empty regex "
	self parse: '//' expectTokens: #().
	" line terminator "
	self parse: '/a', (String with:Character cr), 'b/' expectTokens: #('/' 'a' 'b' '/').

	self parse: '(1/2)/3' expectTokens: #('(' '1' '/' '2' ')' '/' '3').
	self parse: 'n/=j/2' expectTokens: #('n' '/=' 'j' '/' '2').]

{ #category : #'7.8.4 String Literals' }
JavascriptLexicalTest >> testNullCharacter [

	self parse: '"a\0b"' expectTokenValue: (String with: $a with: (Character codePoint: 0) with: $b) type: #string.
	self assertParseFailure: '"\01"' .]

{ #category : #'7.8.1 Null Literals' }
JavascriptLexicalTest >> testNullLiteral [

	self parse: 'null' expectTokenValue: nil type: #null.]

{ #category : #'15.10 Regular Expression Objects' }
JavascriptLexicalTest >> testRegularExpression [

	self parseRegularExpression: '(\w.+)'.
	self parseRegularExpression: '(\w.+)'.
	self parseRegularExpression: '[:alnum:]'.
	self parseRegularExpression: '^[:punct:]\s+'.
	self parseRegularExpression: '[az\w]'.]

{ #category : #'15.10 Regular Expression Objects' }
JavascriptLexicalTest >> testRegularExpressionEscape [

	'AZbB<>nrtvfae' do: [ : escapeCharacter |
		self parseRegularExpression: (String with: $\ with: escapeCharacter).
	].]

{ #category : #'15.10 Regular Expression Objects' }
JavascriptLexicalTest >> testRegularExpressionExamples [

	" sizzle.js, (dojo, jQuery) "
	self parseRegularExpression: '((?:\((?:\([^()]+\)|[^()]+)+\)|\[(?:\[[^[\]]*\]|[''"][^''"]*[''"]|[^[\]''"]+)+\]|\\.|[^ >+~,(\[\\]+)+|[>+~])(\s*,\s*)?((?:.|\r|\n)*)'.

	" effects.js (Scriptaculous) "
	self parseRegularExpression: 'opacity:\s*((?:0|1)?(?:\.\d*)?)'.

	" jQuery "
	self parseRegularExpression: 'rgb\(\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*\)'.
	self parseRegularExpression: 'rgb\(\s*([0-9]+(?:\.[0-9]+)?)\%\s*,\s*([0-9]+(?:\.[0-9]+)?)\%\s*,\s*([0-9]+(?:\.[0-9]+)?)\%\s*\)'.
	self parseRegularExpression: '#([a-fA-F0-9]{2})([a-fA-F0-9]{2})([a-fA-F0-9]{2})'.
	self parseRegularExpression: '#([a-fA-F0-9])([a-fA-F0-9])([a-fA-F0-9])'.
	self parseRegularExpression: 'rgba\(0, 0, 0, 0\)'.
	self parseRegularExpression: '#((?:[\w\u00c0-\uFFFF-]|\\.)+)'.
	self parseRegularExpression: '\.((?:[\w\u00c0-\uFFFF-]|\\.)+)'.
	self parseRegularExpression: '\[name=[''"]*((?:[\w\u00c0-\uFFFF-]|\\.)+)[''"]*\]'.
	self parseRegularExpression: '\[\s*((?:[\w\u00c0-\uFFFF-]|\\.)+)\s*(?:(\S?=)\s*([''"]*)(.*?)\3|)\s*\]'.

	self parseRegularExpression: ' jQuery\d+="(?:\d+|null)"'.
	self parseRegularExpression: '^\s+'.
	self parseRegularExpression: '(<([\w:]+)[^>]*?)\/>'.
	self parseRegularExpression: '^(?:area|br|col|embed|hr|img|input|link|meta|param)$'.
	self parseRegularExpression: '<([\w:]+)'.
	self parseRegularExpression: '<tbody'.
	self parseRegularExpression: '<|&#?\w+;'.
	self parseRegularExpression: '<script|<object|<embed|<option|<style'.
	self parseRegularExpression: 'checked\s*(?:[^=]|=\s*.checked.)'.
	self parseRegularExpression: '=([^="''>\s]+\/)>'.

	" jQuery UI "
	self parseRegularExpression: '\Array\(\)']

{ #category : #'15.10 Regular Expression Objects' }
JavascriptLexicalTest >> testRegularExpressionFlags [

	#( '' 'c' 'cF') do: [ : flags |
		| token |
		token := self parseRegularExpression: 'abc' flags: flags.
		self assert: token flags = flags description: token flags printString.
	]]

{ #category : #'15.10 Regular Expression Objects' }
JavascriptLexicalTest >> testRegularExpressionPerl [
	" not supported by the Regex package "

	self parseRegularExpression: '(?=a)'.
	self parseRegularExpression: '(?:0|1)'.
	self parseRegularExpression: '(?:\.\d*)'.]

{ #category : #'7.4 Comments' }
JavascriptLexicalTest >> testSingleLineComment [

	self parse: '123 // 123 is a magic number' expectTokenValue: 123 type: #numeric]

{ #category : #'7.8.4 String Literals' }
JavascriptLexicalTest >> testSingleQuotedString [

	self privateTestStringWithQuote: ''''.]

{ #category : #'Bee extensions' }
JavascriptLexicalTest >> testTP49810 [
	self deny: (JSEParser current parse: 'a.#b') isPetitFailure]

{ #category : #'7.8.4 String Literals' }
JavascriptLexicalTest >> testUnicodeEscapeSequence [

	self parse: '"a\ubcdef"' expectTokenValue: (String with: $a with: (Character codePoint: 16rbcde) with: $f) type: #string.]

{ #category : #'7.2 White Space' }
JavascriptLexicalTest >> testWhiteSpace [

	self parse: ' 1' expectTokens: #('1').
	self parse: '1 ' expectTokens: #('1').
	self parse: ' 1 ' expectTokens: #('1').
	self parse: '  1  ' expectTokens: #('1').

	self parse: '1;23;45' expectTokens: #('1' ';' '23' ';' '45').
	self parse: '1 ; 23 ; 45' expectTokens: #('1' ';' '23' ';' '45').
	self parse: '1;2 3;4 5' expectTokens: #('1' ';' '2' '3' ';' '4' '5').

	self parse: 'abcdef' expectTokens: #('abcdef').
	self parse: 'abc def' expectTokens: #('abc' 'def').
	self parse: 'abc(def)' expectTokens: #('abc' '(' 'def' ')').
	self parse: ' abc ( def ) ' expectTokens: #('abc' '(' 'def' ')').
	
	JSELexicalParser whiteSpaceCodeValues do: [ : codeValue |
		self parse: (String with: (Character codePoint: codeValue)), ' 1' expectTokens: #('1').
	].]

