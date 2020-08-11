"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RealPolynomial,
	#superclass : #Object,
	#instVars : [
		'coefficients'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
RealPolynomial class >> constant: aFloat [
	^self monomial: 0 coefficient: aFloat]

{ #category : #'instance creation' }
RealPolynomial class >> monomial: i coefficient: ai [
	| coefficients |
	coefficients := FloatArray new: i + 1.
	i > -1 ifTrue: [coefficients at: i + 1 put: ai asFloat].
	^self withCoefficients: coefficients]

{ #category : #references }
RealPolynomial class >> references [
	ShellDLL current
		openWebPage: 'http://en.wikipedia.org/wiki/Sturm''s_theorem']

{ #category : #'instance creation' }
RealPolynomial class >> unity [
	^self new coefficients: #(1.0)]

{ #category : #'instance creation' }
RealPolynomial class >> withCoefficients: aCollection [
	^self new coefficients: aCollection]

{ #category : #'instance creation' }
RealPolynomial class >> x [
	^self monomial: 1 coefficient: 1.0]

{ #category : #'instance creation' }
RealPolynomial class >> xRaisedTo: n [
	n isInteger ifFalse: [self error: 'argument must be integer'].
	n >= 0 ifFalse: [self error: 'argument cannot be negative'].
	^self monomial: n coefficient: 1.0]

{ #category : #'instance creation' }
RealPolynomial class >> zero [
	^self new coefficients: #()]

{ #category : #arithmetic }
RealPolynomial >> - p [
	^self copy -= p]

{ #category : #arithmetic }
RealPolynomial >> -= p [
	^self += p negated]

{ #category : #arithmetic }
RealPolynomial >> * p [
	^self copy *= p]

{ #category : #arithmetic }
RealPolynomial >> *= p [
	| result c |
	p isNumber ifTrue: [
		c := self class constant: p.
		^self *= c].
	p isZero ifTrue: [^self beZero].
	result := FloatArray new: p degree + self degree + 1.
	p
		withIndexDo: [:bj :j | bj ~= 0.0
			ifTrue: [coefficients * bj addTo: result shifted: j negated]].
	coefficients := result]

{ #category : #arithmetic }
RealPolynomial >> + p [
	^self copy += p]

{ #category : #arithmetic }
RealPolynomial >> += p [
	| n m tail c |
	p isNumber ifTrue: [
		c := self class constant: p.
		^self += c].
	n := self degree.
	m := p degree.
	m <= n
		ifTrue: [
			tail := FloatArray new: n - m.
			coefficients += (p coefficients , tail)]
		ifFalse: [
			tail := FloatArray new: m - n.
			coefficients := coefficients , tail.
			coefficients += p coefficients].
	self normalize]

{ #category : #comparing }
RealPolynomial >> = aRealPolynomial [
	self class = aRealPolynomial class ifFalse: [^false].
	^coefficients = aRealPolynomial coefficients]

{ #category : #private }
RealPolynomial >> appendMono: m coefficient: c [
	self isZero
		ifTrue: [
			coefficients := FloatArray new: m + 1.
			m > -1 ifTrue: [coefficients at: m + 1 put: c asFloat]]
		ifFalse: [coefficients at: m + 1 put: c asFloat]]

{ #category : #private }
RealPolynomial >> appendMonomial: mono [
	self isZero
		ifTrue: [coefficients := mono coefficients]
		ifFalse: [coefficients at: mono degree + 1 put: mono leadingCoefficient]]

{ #category : #accessing }
RealPolynomial >> beMonic [
	| lc |
	lc := self leadingCoefficient.
	lc = 1.0 ifTrue: [^self].
	coefficients *= lc reciprocal]

{ #category : #private }
RealPolynomial >> beZero [
	coefficients := FloatArray new]

{ #category : #private }
RealPolynomial >> byMono: aMonomial [
	| result m |
	m := aMonomial degree.
	result := FloatArray new: self degree + m + 1.
	coefficients *= aMonomial leadingCoefficient
		addTo: result
		shifted: m negated.
	coefficients := result]

{ #category : #private }
RealPolynomial >> byMono: m coefficient: c [
	| result |
	result := FloatArray new: self degree + m + 1.
	coefficients *= c addTo: result shifted: m negated.
	coefficients := result]

{ #category : #services }
RealPolynomial >> byMonomial: aMonomial [
	^self copy byMono: aMonomial]

{ #category : #accessing }
RealPolynomial >> coefficient: i [
	^coefficients at: i + 1]

{ #category : #private }
RealPolynomial >> coefficient: i put: ci [
	coefficients at: i + 1 put: ci]

{ #category : #private }
RealPolynomial >> coefficients [
	^coefficients]

{ #category : #accessing }
RealPolynomial >> coefficients: aFloatArray [
	coefficients := aFloatArray asFloatArray.
	self normalize]

{ #category : #accessing }
RealPolynomial >> degree [
	^coefficients size - 1]

{ #category : #services }
RealPolynomial >> derivative [
	| n derivative |
	n := self degree.
	derivative := coefficients copyFrom: 2 to: n + 1.
	derivative *= (1 to: n) asFloatArray.
	^self class withCoefficients: derivative]

{ #category : #evaluation }
RealPolynomial >> evaluateWith: x [
	^self valueAt: x]

{ #category : #services }
RealPolynomial >> gcd: aRealPolynomial [
	^PolynomialEuclideanAlgorithm gcdOf: self and: aRealPolynomial]

{ #category : #comparing }
RealPolynomial >> hash [
	^coefficients hash]

{ #category : #testing }
RealPolynomial >> isConstant [
	^self degree < 1]

{ #category : #testing }
RealPolynomial >> isSquareFree [
	| gcd |
	gcd := self gcd: self derivative.
	^gcd isConstant]

{ #category : #testing }
RealPolynomial >> isZero [
	^coefficients isEmpty]

{ #category : #accessing }
RealPolynomial >> leadingCoefficient [
	^self isZero ifFalse: [coefficients last]]

{ #category : #private }
RealPolynomial >> negate [
	coefficients *= -1.0]

{ #category : #private }
RealPolynomial >> negated [
	^self copy negate]

{ #category : #private }
RealPolynomial >> normalize [
	| m n |
	m := coefficients findLast: [:ai | (ai ~ 0.0) not] ifAbsent: 0.
	n := coefficients size.
	m < n ifTrue: [coefficients := coefficients allButLast: n - m]]

{ #category : #services }
RealPolynomial >> plot [
	self plotBetween: -3 and: 3]

{ #category : #copying }
RealPolynomial >> postCopy [
	super postCopy.
	coefficients := coefficients copy]

{ #category : #printing }
RealPolynomial >> printTextOn: rtf [
	| m am |
	self isZero ifTrue: [
		rtf bold: '0'.
		^self].
	self degree = 0 ifTrue: [
		rtf bold: coefficients anyone printString.
		^self].
	m := coefficients findFirst: [:c | c ~= 0.0].
	(coefficients size - 1 to: m by: -1) do: [:i | | ai si |
		ai := coefficients at: i + 1.
		ai ~= 0.0 ifTrue: [
			si := ai = 1.0
				ifTrue: ['']
				ifFalse: [ai = -1.0 ifTrue: ['-'] ifFalse: [ai printString]].
			rtf nextPutAll: si; bold: 'x'.
			i > 1 ifTrue: [rtf super: i printString].
			rtf nextPutAll: ' + ']].
	am := coefficients at: m.
	rtf nextPutAll: am printString.
	m > 1 ifTrue: [
		rtf bold: 'x'.
		m > 2 ifTrue: [rtf super: (m - 1) printString]]]

{ #category : #arithmetic }
RealPolynomial >> quotient: p [
	^RealPolynomialDivisionAlgorithm quotientOf: self by: p]

{ #category : #arithmetic }
RealPolynomial >> remainder: p [
	^RealPolynomialDivisionAlgorithm remainderOf: self by: p]

{ #category : #private }
RealPolynomial >> removeHead [
	coefficients := coefficients allButLast.
	self normalize]

{ #category : #accessing }
RealPolynomial >> rootFinder [
	^PolynomialRootFinder for: self]

{ #category : #services }
RealPolynomial >> rootsBetween: a and: b [
	| sturm sa sb sigma mu |
	sturm := self sturmChain.
	sa := sturm collect: [:s | s valueAt: a].
	sb := sturm collect: [:s | s valueAt: b].
	sigma := self sigmaOf: sa.
	mu := self sigmaOf: sb.
	^sigma - mu]

{ #category : #private }
RealPolynomial >> sigmaOf: aCollection [
	| sigma copy |
	sigma := 0.
	copy := aCollection reject: [:a | a = 0.0].
	copy withNextDo: [:a :b | a < 0 = (b > 0) ifTrue: [sigma := sigma + 1]].
	^sigma]

{ #category : #services }
RealPolynomial >> squareFree [
	| gcd |
	gcd := self gcd: self derivative.
	gcd isConstant ifTrue: [^self].
	^self quotient: gcd]

{ #category : #services }
RealPolynomial >> sturmChain [
	| p q gcd |
	self isConstant ifTrue: [^{self. self derivative}].
	p := self.
	q := p derivative.
	gcd := p gcd: q.
	gcd isConstant ifFalse: [
		p := p quotient: gcd.
		q := p derivative].
	^Array streamContents: [:strm | | r |
		strm nextPut: p.
		[
			strm nextPut: q.
			r := p remainder: q.
			r isZero]
			whileFalse: [
				p := q.
				q := r negate]]]

{ #category : #accessing }
RealPolynomial >> tail [
	^self copy removeHead]

{ #category : #services }
RealPolynomial >> tails [
	| p |
	p := self copy.
	^(1 to: self degree) collect: [:i | | save |
		save := p.
		p := p tail.
		save]]

{ #category : #evaluation }
RealPolynomial >> valueAt: x [
	| v |
	v := 0.0.
	coefficients reverseDo: [:c | v := v * x + c].
	^v]

{ #category : #enumerating }
RealPolynomial >> withIndexDo: aBlock [
	coefficients withIndexDo: [:c :i | aBlock value: c value: i - 1]]

