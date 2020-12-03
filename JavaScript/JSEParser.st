"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEParser,
	#superclass : #PPParser,
	#instVars : [
		'lexicalParser',
		'syntacticParser'
	],
	#category : #JavaScript
}

{ #category : #accessing }
JSEParser class >> aboutToSaveLibraryOn: aCodeSegmentBuilder [
	aCodeSegmentBuilder map: current to: nil.
	super aboutToSaveLibraryOn: aCodeSegmentBuilder]

{ #category : #accessing }
JSEParser class >> current [
	current isNil ifTrue: [self initializeCurrent].
	^current]

{ #category : #initialization }
JSEParser class >> initializeCurrent [
	current := JSEParser new factory: JSESyntaxTreeFactory new]

{ #category : #services }
JSEParser class >> parse: aString [
	^self current parse: aString]

{ #category : #accessing }
JSEParser class >> pragma [
	^#js]

{ #category : #accessing }
JSEParser >> children [
	^{lexicalParser. syntacticParser}]

{ #category : #accessing }
JSEParser >> factory: aFactory [

	syntacticParser factory: aFactory]

{ #category : #initialization }
JSEParser >> initialize [
	lexicalParser := JSELexicalParser new.
	syntacticParser := JSESyntacticParser new]

{ #category : #'*JavascriptEngine-Development' }
JSEParser >> jseCountProductionsWhile: aBlock do: aResultBlock [

	| counters copy |
	counters := Dictionary new.
	copy := self copy.
	lexicalParser 
		jseCountProductionsWhile: 
		[: countingLexicalParser |
			copy lexicalParser: countingLexicalParser.
			syntacticParser 
				jseCountProductionsWhile: 
				[: countingSyntacticParser |
					copy syntacticParser: countingSyntacticParser.
					aBlock value: copy
				]
				do: [: syntacticResult : syntacticCounters | counters at: #syntactic put: syntacticCounters ]
		]
		do: [: lexicalResult : lexicalCounters | counters at: #lexical put: lexicalCounters ].
	^ counters]

{ #category : #'*JavascriptEngine-Development' }
JSEParser >> jseParseAndCountTotalSyntaxProductions: aString [
	" count how often any syntax production was applied "

	| counters |
	counters := self jseParseAndCountProductions: aString.
	^ (counters at: #syntactic) inject: 0 into: [ : total : counter | total + counter ]]

{ #category : #'*JavascriptEngine-Development' }
JSEParser >> jseWithLoggingTo: aStream [

	| copy |
	copy := self copy.
	copy syntacticParser: ( self syntacticParser jseWithLoggingTo: aStream ).
	^ copy]

{ #category : #private }
JSEParser >> lexicalParser [
	^lexicalParser]

{ #category : #private }
JSEParser >> lexicalParser: aLexicalParser [
	lexicalParser := aLexicalParser]

{ #category : #parsing }
JSEParser >> parseOn: aStream [
	| start tokens source result |
	start := aStream position.
	tokens := lexicalParser parseOn: aStream.
	tokens isPetitFailure ifTrue: [^tokens].
	source := aStream copyFrom: start + 1 to: aStream position.
	result := syntacticParser parse: tokens.
	result isPetitFailure ifTrue: [
		^result position > 0
			ifTrue: [
				aStream position: (tokens at: result position) start.
				PPFailure message: result message from: aStream]
			ifFalse: [result]].
	^(result isKindOf: JSEParseNode)
		ifTrue: [result source: source]
		ifFalse: [result]]

{ #category : #accessing }
JSEParser >> pragma [
	^self class pragma]

{ #category : #'*JavascriptEngine-Development' }
JSEParser >> replace: aParser with: anotherParser [
	super replace: aParser with: anotherParser.
	syntacticParser == aParser ifTrue: [ syntacticParser := anotherParser ].
	lexicalParser == aParser ifTrue: [ lexicalParser := anotherParser ].]

{ #category : #private }
JSEParser >> syntacticParser [

	^ syntacticParser]

{ #category : #private }
JSEParser >> syntacticParser: aSyntacticParser [

	syntacticParser := aSyntacticParser.]

