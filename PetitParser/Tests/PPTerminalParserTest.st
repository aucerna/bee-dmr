Class {
	#name : #PPTerminalParserTest,
	#superclass : #TestCase,
	#instVars : [
		'characters'
	],
	#category : #Tests
}

{ #category : #setup }
PPTerminalParserTest >> setUp [
	super setUp.
	characters := (0 to: 255) collect: [:i | i asCharacter asString]
]

{ #category : #all }
PPTerminalParserTest >> testAnyParser [
	| parser |
	parser := #any asParser.
	characters do: [:ch | self assert: (parser matches: ch)]
]

{ #category : #all }
PPTerminalParserTest >> testCharacterParser [
	| parser ok |
	parser := $a asParser.
	ok := characters select: [:ch | parser matches: ch].
	self assert: ok = #('a')
]

{ #category : #all }
PPTerminalParserTest >> testDigitParser [
	| parser digits |
	parser := #digit asParser.
	digits := characters select: [:ch | parser matches: ch].
	self assert: digits = #('0' '1' '2' '3' '4' '5' '6' '7' '8' '9')
]

{ #category : #all }
PPTerminalParserTest >> testLetterParser [
	| parser letters |
	parser := #letter asParser.
	letters := characters select: [:ch | parser matches: ch].
	self
		assert: letters
			= #('A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'
				'_' 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z')
]

{ #category : #all }
PPTerminalParserTest >> testStringParser [
	| parser |
	parser := 'abc' asParser.
	self
		assert: (parser matches: 'abc');
		deny: (parser matches: 'aabc');
		assert: (parser matchesIn: 'aabc') asArray = #('abc')
]

