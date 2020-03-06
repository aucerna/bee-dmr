Class {
	#name : #BGFasta,
	#superclass : #Object,
	#instVars : [
		'lineLength',
		'n',
		'out',
		'r',
		'repeatStreamFact',
		'randomStreamFact',
		'randomNumberFactory',
		'arrayFactory'
	],
	#category : #Game
}

{ #category : #defaults }
BGFasta class >> defaultProblemSize [
	^ 1000
]

{ #category : #benchmarking }
BGFasta class >> fasta [
	"
	self fasta
	"
	| out |
	out := '' writeStream.
	self fasta: self defaultProblemSize to: out.
	^out contents
]

{ #category : #benchmarking }
BGFasta class >> fasta: n to: out [
	^ self new fasta: n to: out
]

{ #category : #'instance creation' }
BGFasta class >> new [
	^self basicNew initialize
]

{ #category : #benchmarking }
BGFasta >> fasta: anInt to: aStream [
	self n:   anInt.
	self out: aStream.
	self oneHomoSapiensAlu.
	
   self r: (randomNumberFactory to: 1). "Shared random sequence"

	self twoIUBAmbiguityCodes.
	self threeHomoSapiensFrequency.
	
	aStream flush.
]

{ #category : #initialization }
BGFasta >> initialize [
	lineLength := 60.
	repeatStreamFact    := BGRepeatStream.
	randomStreamFact    := BGRandomStream.
	randomNumberFactory := BGRandomNumber.
	arrayFactory        := Array.
]

{ #category : #accessing }
BGFasta >> n: anInteger [
	n := anInteger
]

{ #category : #benchmarking }
BGFasta >> oneHomoSapiensAlu [
	 self
      writeFasta: 'ONE Homo sapiens alu'
      from:
         ( repeatStreamFact
            to: n*2
            on:'GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG',
               'GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA',
               'CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT',
               'ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA',
               'GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG',
               'AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC',
               'AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA' ).
]

{ #category : #accessing }
BGFasta >> out: aStream [
	out := aStream 
]

{ #category : #accessing }
BGFasta >> r: aRandomNumberStream [
	r := aRandomNumberStream
]

{ #category : #accessing }
BGFasta >> randomStreamFact: aStreamFact [
	randomStreamFact := aStreamFact
]

{ #category : #accessing }
BGFasta >> repeatStreamFact: aStreamFact [
	repeatStreamFact := aStreamFact
]

{ #category : #benchmarking }
BGFasta >> threeHomoSapiensFrequency [
	self
		writeFasta: 'THREE Homo sapiens frequency'
		from: ((randomStreamFact
			to: n * 5
			on: (arrayFactory
				with: (arrayFactory with: $a with: 0.3029549426680)
				with: (arrayFactory with: $c with: 0.1979883004921)
				with: (arrayFactory with: $g with: 0.1975473066391)
				with: (arrayFactory with: $t with: 0.3015094502008)))
			random: r;
			yourself)
]

{ #category : #benchmarking }
BGFasta >> twoIUBAmbiguityCodes [
	| arr |
	arr := arrayFactory new: 15.
	arr at: 1 put: (arrayFactory with: $a with: 0.27e0).
	arr at: 2 put: (arrayFactory with: $c with: 0.12e0).
	arr at: 3 put: (arrayFactory with: $g with: 0.12e0).
	arr at: 4 put: (arrayFactory with: $t with: 0.27e0).
	arr at: 5 put: (arrayFactory with: $B with: 0.02e0).
	arr at: 6 put: (arrayFactory with: $D with: 0.02e0).
	arr at: 7 put: (arrayFactory with: $H with: 0.02e0).
	arr at: 8 put: (arrayFactory with: $K with: 0.02e0).
	arr at: 9 put: (arrayFactory with: $M with: 0.02e0).
	arr at: 10 put: (arrayFactory with: $N with: 0.02e0).
	arr at: 11 put: (arrayFactory with: $R with: 0.02e0).
	arr at: 12 put: (arrayFactory with: $S with: 0.02e0).
	arr at: 13 put: (arrayFactory with: $V with: 0.02e0).
	arr at: 14 put: (arrayFactory with: $W with: 0.02e0).
	arr at: 15 put: (arrayFactory with: $Y with: 0.02e0).
	self
		writeFasta: 'TWO IUB ambiguity codes'
		from: ((randomStreamFact to: n * 3 on: arr)
			random: r;
			yourself)
]

{ #category : #benchmarking }
BGFasta >> writeFasta: aString from: inStream [
   | i |
   out nextPut: $>; nextPutAll: aString; cr.
   i := 0.
   [inStream atEnd] whileFalse:
      [i == lineLength ifTrue: [out cr. i := 0].
      out nextPut: inStream next.
      i := i + 1].
   out cr
]

