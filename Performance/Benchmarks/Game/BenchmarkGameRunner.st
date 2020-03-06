Class {
	#name : #BenchmarkGameRunner,
	#superclass : #Object,
	#instVars : [
		'arguments'
	],
	#category : #Game
}

{ #category : #running }
BenchmarkGameRunner class >> run: arguments [
	^self new arguments: arguments; run
]

{ #category : #actions }
BenchmarkGameRunner >> arguments: anArray [
	arguments := anArray
]

{ #category : #actions }
BenchmarkGameRunner >> readInputFromStdin [
	| handle stdin buffer result |
	handle := KernelLibrary GetStdHandleFor: -10.
	stdin := FileHandle fromInteger: handle.
	buffer := String new: 10000.
	result := ''.
	[| read |
		read := stdin read: 9999 into: buffer.
		read > 0]
		whileTrue: [result := result , buffer trimNullEnd].
	^Array with: result
]

{ #category : #actions }
BenchmarkGameRunner >> run [
	| path index bench selector output input |
	path := arguments first.
	index := path indexOfLastChar: $/.
	bench := (path copyFrom: index + 1) readStream upTo: $..
	selector := self selectorFor: bench.
	input := (#(knucleotide regexdna revcomp) includes: bench asSymbol)
		ifTrue: [self readInputFromStdin]
		ifFalse: [arguments allButFirst collect: [:arg | Integer fromString: arg]].
	output := self perform: selector withArguments: input.
	Smalltalk transcript show: output contents
]

{ #category : #actions }
BenchmarkGameRunner >> runBinaryTrees: input [
	| stream |
	stream := '' writeStream.
	BGBinaryTrees new binarytrees: input to: stream.
	^stream
]

{ #category : #actions }
BenchmarkGameRunner >> runChameleons: input [
	| result |
	result := BGChameleons chameneos: input.
	^result printString readStream
]

{ #category : #actions }
BenchmarkGameRunner >> runChameneosRedux: input [
	| stream |
	self error: 'not implemented yet, needs shared queue'.
	stream := '' writeStream.
	BGChameneosRedux new runBenchMark: input on: stream.
	^stream
]

{ #category : #actions }
BenchmarkGameRunner >> runFannkuchRedux: input [
	| stream |
	stream := '' writeStream.
	BGFannkuchRedux fannkuchRedux: input to: stream.
	^stream
]

{ #category : #actions }
BenchmarkGameRunner >> runFasta: input [
	| stream |
	stream := '' writeStream.
	BGFasta fasta: input to: stream.
	^stream
]

{ #category : #actions }
BenchmarkGameRunner >> runKNucleotide: input [
	| stream bench |
	stream := '' writeStream.
	bench := BGKNucleotide new.
	bench knucleotide5From: input readStream to: stream.
	^stream
]

{ #category : #actions }
BenchmarkGameRunner >> runMandelbrot: input [
	| bench result |
	bench := BGMandelbrot new.
	result := bench mandelbrot2: input.
	^result
]

{ #category : #actions }
BenchmarkGameRunner >> runMeteor: input [
	^BGMeteor meteor: input
]

{ #category : #actions }
BenchmarkGameRunner >> runNBody: input [
	| result stream |
	result := BGNBody nbody: input.
	stream := '' writeStream.
	result do: [:float | 
		float printOn: stream showingDecimalPlaces: 9.
		stream cr].
	^stream
]

{ #category : #actions }
BenchmarkGameRunner >> runPiDigits: input [
	| digits stream characters |
	digits := BGPiDigits piDigits: input.
	stream := '' writeStream.
	characters := #($0 $1 $2 $3 $4 $5 $6 $7 $8 $9).
	1
		to: digits size
		do: [:i | stream nextPut: (characters at: (digits at: i) + 1)].
	stream cr.
	^stream
]

{ #category : #actions }
BenchmarkGameRunner >> runRegexDNA: input [
	| output |
	output := '' writeStream.
	BGRegexDNA new regexDNA: input readStream to: output.
	^output
]

{ #category : #actions }
BenchmarkGameRunner >> runReverseComplement: input [
	^BGReverseComplement new revcomp: input readStream
]

{ #category : #actions }
BenchmarkGameRunner >> runSpectralNorm: input [
	| bench result stream |
	bench := BGSpectralNorm new.
	result := bench spectralnorm: input.
	stream := '' writeStream.
	result printOn: stream showingDecimalPlaces: 9.
	^stream
]

{ #category : #actions }
BenchmarkGameRunner >> runThreadRing: input [
	| result |
	result := BGThreadRing threadring: input.
	^result printString readStream
]

{ #category : #actions }
BenchmarkGameRunner >> selectorFor: name [
	| mappings |
	mappings := OrderedCollection new
		add: #binarytrees -> #runBinaryTrees:;
		add: #chameleons -> #runChameleons:;
		add: #chameneosredux -> #runChameneosRedux:;
		add: #fannkuchredux -> #runFannkuchRedux:;
		add: #fasta -> #runFasta:;
		add: #knucleotide -> #runKNucleotide:;
		add: #mandelbrot -> #runMandelbrot:;
		add: #meteor -> #runMeteor:;
		add: #nbody -> #runNBody:;
		add: #pidigits -> #runPiDigits:;
		add: #regexdna -> #runRegexDNA:;
		add: #revcomp -> #runReverseComplement:;
		add: #spectralnorm -> #runSpectralNorm:;
		add: #threadring -> #runThreadRing:;
		yourself.
	^Dictionary new addAll: mappings; at: name asSymbol
]

