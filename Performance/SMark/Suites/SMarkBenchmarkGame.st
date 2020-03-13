"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #SMarkBenchmarkGame,
	#superclass : #SMarkSuite,
	#instVars : [
		'bgBinaryTrees',
		'bgChameleons',
		'bgChameneosRedux',
		'bgFannkuchRedux',
		'bgFasta',
		'bgKNucleotide',
		'bgFastaCache',
		'bgMandelbrot',
		'bgMeteor',
		'bgNBody',
		'bgPiDigits',
		'bgRegexDNA',
		'bgReverseComplement',
		'bgSpectralNorm',
		'bgThreadRing'
	],
	#category : #Suites
}

{ #category : #benchmarking }
SMarkBenchmarkGame >> benchBinaryTrees [
	| problemSize |
	problemSize := self problemSize
		ifNotNil: [:ps | ps]
		ifNil: [bgBinaryTrees defaultProblemSize].
	^10
		timesRepeat: [bgBinaryTrees new
			binarytrees: problemSize
			to: '' writeStream]
]

{ #category : #benchmarking }
SMarkBenchmarkGame >> benchChameleons [
	| result problemSize |
	problemSize := self problemSize
		ifNotNil: [:ps | ps]
		ifNil: [bgChameleons defaultProblemSize].
	10 timesRepeat: [result := bgChameleons chameneos: problemSize].
	"Result should be 2*numberOfProcesses (as far as I understand the benchmark)"
	self flag: 'TODO adapt once verification is supported'.
	result = (2 * problemSize) ifFalse: [
		Error
			signal: bgChameleons name , ' benchmark failed. Input: '
				, problemSize asString
				, ' Output: '
				, result asString]
]

{ #category : #benchmarking }
SMarkBenchmarkGame >> benchChameneosRedux [
	| result report problemSize |
	problemSize := self problemSize ifNotNil: [:ps | ps] ifNil: [
		bgChameneosRedux defaultProblemSize.
		report := '' writeStream.
		result := bgChameneosRedux new runBenchMark: problemSize on: report.
		"Result should be 2*problemSize"
	self flag: 'TODO: adapt once verification is supported'.
		result = (2 * problemSize) ifFalse: [
			Error
				signal: self class name , ' benchmark failed. Input: '
					, runner processes asString
					, ' Output: '
					, result asString]]
]

{ #category : #benchmarking }
SMarkBenchmarkGame >> benchFannkuchRedux [
	| f problemSize |
	problemSize := self problemSize
		ifNotNil: [:ps | ps]
		ifNil: [bgFannkuchRedux defaultProblemSize].
	10
		timesRepeat: [f := bgFannkuchRedux
			fannkuchRedux: problemSize
			to: '' writeStream].
	" the output should only be done by some reporter"
	"ScriptConsole print: 'Pfannkuchen(', problemSize asString , ') = ', f asString."
   ^f
]

{ #category : #benchmarking }
SMarkBenchmarkGame >> benchFasta [
	| out problemSize |
	out := '' writeStream.
	problemSize := self problemSize
		ifNotNil: [:ps | ps]
		ifNil: [bgFasta defaultProblemSize].
	100 timesRepeat: [bgFasta fasta: problemSize to: out]
]

{ #category : #benchmarking }
SMarkBenchmarkGame >> benchKNucleotide [
	| bench input result problemSize output |
	problemSize := self problemSize
		ifNotNil: [:ps | ps]
		ifNil: [bgKNucleotide defaultProblemSize].
	bench := bgKNucleotide new.
	input := (bgFastaCache forFasta: problemSize) readStream.
	result := '' writeStream.
	output := bench knucleotide5From: input to: result.
	^output
]

{ #category : #benchmarking }
SMarkBenchmarkGame >> benchMandelbrot [
	| result bench problemSize |
	bench := bgMandelbrot new.
	problemSize := self problemSize
		ifNotNil: [:ps | ps]
		ifNil: [bgMandelbrot defaultProblemSize].
	result := bench mandelbrot2: problemSize.
	result reset.
	^result contents
]

{ #category : #benchmarking }
SMarkBenchmarkGame >> benchMeteor [
	| problemSize |
	problemSize := self problemSize
		ifNotNil: [:ps | ps]
		ifNil: [bgMeteor defaultProblemSize].
	^bgMeteor meteor: problemSize
]

{ #category : #benchmarking }
SMarkBenchmarkGame >> benchNBody [
	| problemSize |
	problemSize := self problemSize
		ifNotNil: [:ps | ps]
		ifNil: [bgNBody defaultProblemSize].
	bgNBody nbody: problemSize
]

{ #category : #benchmarking }
SMarkBenchmarkGame >> benchPiDigits [
	| problemSize |
	problemSize := self problemSize
		ifNotNil: [:ps | ps]
		ifNil: [bgPiDigits defaultProblemSize].
	^100 timesRepeat: [bgPiDigits piDigits: problemSize]
]

{ #category : #benchmarking }
SMarkBenchmarkGame >> benchRegexDNA [
	| problemSize |
	problemSize := self problemSize
		ifNotNil: [:ps | ps]
		ifNil: [bgRegexDNA defaultProblemSize].
	bgRegexDNA regexdna: problemSize
]

{ #category : #benchmarking }
SMarkBenchmarkGame >> benchReverseComplement [
	| problemSize |
	problemSize := self problemSize
		ifNotNil: [:ps | ps]
		ifNil: [bgReverseComplement defaultProblemSize].
	5 timesRepeat: [bgReverseComplement revcomp: problemSize]
]

{ #category : #benchmarking }
SMarkBenchmarkGame >> benchSpectralNorm [
	| bench problemSize |
	bench := bgSpectralNorm new.
	problemSize := self problemSize
		ifNotNil: [:ps | ps]
		ifNil: [bgSpectralNorm defaultProblemSize].
	^bench spectralnorm: problemSize
]

{ #category : #benchmarking }
SMarkBenchmarkGame >> benchThreadRing [
	| problemSize |
	problemSize := self problemSize
		ifNotNil: [:ps | ps]
		ifNil: [bgThreadRing defaultProblemSize].
	^bgThreadRing threadring: problemSize
]

{ #category : #benchmarking }
SMarkBenchmarkGame >> flag: aString [
	aString show
]

{ #category : #license }
SMarkBenchmarkGame >> license [
	^
'Revised BSD license

This is a specific instance of the Open Source Initiative (OSI) BSD license
template http://www.opensource.org/licenses/bsd-license.php


Copyright 2008-2010 Isaac Gouy
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

   Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

   Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

   Neither the name of "The Computer Language Benchmarks Game" nor the name of
   "The Computer Language Shootout Benchmarks" nor the name "nanobench" nor
   the name "bencher" nor the names of its contributors may be used to endorse
   or promote products derived from this software without specific prior
   written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.'
]

{ #category : #benchmarking }
SMarkBenchmarkGame >> setUp [
	#(bgBinaryTrees bgChameleons bgChameneosRedux bgFannkuchRedux bgFasta bgKNucleotide bgFastaCache bgMandelbrot bgMeteor bgNBody bgPiDigits bgRegexDNA bgReverseComplement bgSpectralNorm bgThreadRing)
		do: [:name | | classname |
			classname := 'BG' , (name copyFrom: 3).
			self instVarNamed: name put: (Smalltalk at: classname asSymbol)]
]

{ #category : #benchmarking }
SMarkBenchmarkGame >> setUpBenchKNucleotide [
	"
	initialize input, taken from fasta cache
	"
	| problemSize |
	problemSize := self problemSize
		ifNotNil: [:ps | ps]
		ifNil: [bgKNucleotide defaultProblemSize].
	bgFastaCache primeForFasta: problemSize
]

{ #category : #benchmarking }
SMarkBenchmarkGame >> setUpBenchRegexDNA [
	"
	initialize input, taken from fasta cache
	"
	| problemSize |
	problemSize := self problemSize
		ifNotNil: [:ps | ps]
		ifNil: [bgRegexDNA defaultProblemSize].
	bgFastaCache primeForFasta: problemSize
]

{ #category : #benchmarking }
SMarkBenchmarkGame >> shouldRunSelector: selector [
	^(super shouldRunSelector: selector)
		andNot: (#(benchChameleons benchChameneosRedux benchMandelbrot benchNBody benchRegexDNA benchThreadRing )
			includes: selector)
]

