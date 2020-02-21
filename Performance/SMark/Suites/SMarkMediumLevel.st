Class {
	#name : #SMarkMediumLevel,
	#superclass : #SMarkSuite,
	#instVars : [
		'#bounce',
		'#list',
		'#mandelbrot',
		'#nbody',
		'#permute',
		'#queens',
		'#sieve',
		'#storage',
		'#towers'
	],
	#category : #Suites
}

{ #category : #running }
SMarkMediumLevel >> benchBounce [
	self run: bounce
]

{ #category : #running }
SMarkMediumLevel >> benchList [
	self run: list
]

{ #category : #running }
SMarkMediumLevel >> benchMandelbrot [
	self run: mandelbrot
]

{ #category : #running }
SMarkMediumLevel >> benchNBody [
	self run: nbody
]

{ #category : #running }
SMarkMediumLevel >> benchPermute [
	self run: permute
]

{ #category : #running }
SMarkMediumLevel >> benchQueens [
	self run: queens
]

{ #category : #running }
SMarkMediumLevel >> benchSieve [
	self run: sieve
]

{ #category : #running }
SMarkMediumLevel >> benchStorage [
	self run: storage
]

{ #category : #running }
SMarkMediumLevel >> benchTowers [
	self run: towers
]

{ #category : #defaults }
SMarkMediumLevel >> defaultProblemSize [
	^500
]

{ #category : #benchmarking }
SMarkMediumLevel >> descriptionOf: benchmarkName [
	^benchmarkName , ' (problem: ' , self problemSize printString , ')'
]

{ #category : #benchmarking }
SMarkMediumLevel >> problemSize [
	| ps |
	ps := super problemSize.
	ps ifNil: [^self defaultProblemSize].
	^ps
]

{ #category : #running }
SMarkMediumLevel >> run: bench [
	| size |
	size := self problemSize.
	bench new innerBenchmarkLoop: size
]

{ #category : #running }
SMarkMediumLevel >> setUp [
	bounce := Smalltalk at: #Bounce.
	list := Smalltalk at: #List.
	mandelbrot := Smalltalk at: #Mandelbrot.
	nbody := Smalltalk at: #NBody.
	permute := Smalltalk at: #Permute.
	queens := Smalltalk at: #Queens.
	sieve := Smalltalk at: #Sieve.
	storage := Smalltalk at: #Storage.
	towers := Smalltalk at: #Towers
]

{ #category : #testing }
SMarkMediumLevel >> shouldRunSelector: selector [
	^(super shouldRunSelector: selector)
		andNot: (#(benchBounce) includes: selector)
]

