"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DiscreteDistribution,
	#superclass : #DiscreteProbabilityDistribution,
	#instVars : [
		'values',
		'probabilities',
		'pTable',
		'yTable',
		'size',
		'delta'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
DiscreteDistribution class >> around: aNumber [
	| value delta x |
	value := aNumber asFloat.
	value = 0.0
		ifTrue: [
			delta := 0.25.
			x := -0.5]
		ifFalse: [
			delta := value abs * 0.25.
			x := value - (delta * 2)].
	^self
		values: (Array streamContents: [:stream | 
			5 timesRepeat: [
				stream nextPut: x.
				x := x + delta]])
		probabilities: #(0.2 0.2 0.2 0.2 0.2)
"
	DiscreteDistribution around: -100
"]

{ #category : #'instance creation' }
DiscreteDistribution class >> around: aNumber above: lowerBound [
	| value candidate b |
	value := aNumber max: lowerBound.
	candidate := self around: value.
	^lowerBound <= candidate min ifTrue: [candidate] ifFalse: [
		b := lowerBound = value ifTrue: [lowerBound + 1.0] ifFalse: [value].
		self between: lowerBound and: b]]

{ #category : #'instance creation' }
DiscreteDistribution class >> around: aNumber below: upperBound [
	| value candidate a |
	value := aNumber min: upperBound.
	candidate := self around: value.
	^upperBound >= candidate max ifTrue: [candidate] ifFalse: [
		a := upperBound = value ifTrue: [upperBound - 1.0] ifFalse: [value].
		self between: a and: upperBound]]

{ #category : #'instance creation' }
DiscreteDistribution class >> around: aNumber
between: lowerBound
and: upperBound
steps: n [
	(lowerBound isNil and: [upperBound isNil]) ifTrue: [^self around: aNumber].
	lowerBound isNil ifTrue: [^self around: aNumber below: upperBound].
	upperBound isNil ifTrue: [^self around: aNumber above: lowerBound].
	^self between: lowerBound and: upperBound steps: n]

{ #category : #'instance creation' }
DiscreteDistribution class >> between: n and: m [
	^n = m
		ifTrue: [self values: {n} probabilities: #(1.0)]
		ifFalse: [self between: n and: m steps: 5]]

{ #category : #'instance creation' }
DiscreteDistribution class >> between: n and: m steps: steps [
	"
	DiscreteDistribution between: -30 and: 30 steps: 8
	"
	| probabilities step values validation p |
	validation := self
		runValidation: #validateDiscreteBetween:and:steps:
		withArguments: {n. m. steps}.
	validation hasPassed ifFalse: [^nil].
	step := m - n / steps.
	step isFraction ifTrue: [step := step asFloat].
	values := step = 0 ifTrue: [{n}] ifFalse: [n to: m by: step].
	probabilities := Array new: values size.
	p := step = 0 ifTrue: [1.0] ifFalse: [1.0 / (1.0 + steps)].
	probabilities atAllPut: p.
	^self values: values probabilities: probabilities]

{ #category : #'gs support' }
DiscreteDistribution class >> instVarMap [
	^super instVarMap, #(
	#(pTable nil) #(nil pTable) 
	#(yTable nil) #(nil yTable) 
	#(delta nil) #(nil delta) 
	)]

{ #category : #tests }
DiscreteDistribution class >> knuthTest [
	"
	DiscreteDistribution knuthTest
	"
	| instance |
	instance := self
		values: (0 to: 15) asArray
		probabilities: (#(0 0 1 2 3 4 5 6 5 4 3 2 1 0 0 0)
			collect: [:i | i asFloat / 36.0]).
	^instance knuthTest]

{ #category : #examples }
DiscreteDistribution class >> sampleInstance [
	^self around: 100]

{ #category : #tests }
DiscreteDistribution class >> simpleTest [
	"
	DiscreteDistribution simpleTest
	"
	| instance |
	instance := self values: (1 to: 3) asArray probabilities: #(0.5 0.3 0.2).
	^instance]

{ #category : #'instance creation' }
DiscreteDistribution class >> values: values [
	| n array |
	n := values size.
	array := n = 0 ifTrue: [#()] ifFalse: [Array new: n withAll: 1.0 / n].
	^self values: values probabilities: array]

{ #category : #'instance creation' }
DiscreteDistribution class >> values: values probabilities: probabilities [
	| array validation |
	validation := self
		runValidation: #validateDiscreteValues:probabilities:
		with: values
		with: probabilities.
	validation hasPassed ifFalse: [^nil].
	array := self cleanValues: values probabilities: probabilities.
	^self new values: array first probabilities: array second]

{ #category : #validation }
DiscreteDistribution >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #discreteValidation]

{ #category : #converting }
DiscreteDistribution >> asJson [
	^super asJson
		at: 'Values' put: values;
		at: 'Probabilities' put: probabilities;
		yourself]

{ #category : #operations }
DiscreteDistribution >> beUniform [
	| n array |
	n := values size.
	n = 0 ifTrue: [^self].
	array := Array new: n withAll: 1.0 / n.
	self values: values probabilities: array]

{ #category : #'file in/out' }
DiscreteDistribution >> clearSurrogate [
	pTable := yTable := delta := nil]

{ #category : #services }
DiscreteDistribution >> convertValuesWith: aNumber [
	values := values collect: [:v | v * aNumber].
	self values: values probabilities: probabilities]

{ #category : #'probability functions' }
DiscreteDistribution >> density: x [
	| i |
	i := values indexOf: x.
	i = 0 ifTrue: [^0].
	^probabilities at: i]

{ #category : #'probability functions' }
DiscreteDistribution >> distribution: x [
	"P(X <= x)"
	| answer |
	answer := 0.0.
	values
		withIndexDo: [:v :i | v <= x
			ifTrue: [answer := answer + (probabilities at: i)]].
	^answer]

{ #category : #'probability functions' }
DiscreteDistribution >> distributionLeft: x [
	"
	P(X < x)
	"
	| answer |
	answer := 0.0.
	values
		withIndexDo: [:v :i | v < x
			ifTrue: [answer := answer + (probabilities at: i)]].
	^answer]

{ #category : #initialization }
DiscreteDistribution >> faultSize [
	^size asFloat]

{ #category : #'file in/out' }
DiscreteDistribution >> fileInActivate [
	self initializeTables]

{ #category : #'file in/out' }
DiscreteDistribution >> fileOutSurrogate [
	^self shallowCopy clearSurrogate]

{ #category : #converting }
DiscreteDistribution >> fromJson: aJsonObject [
	self values: aJsonObject Values probabilities: aJsonObject Probabilities]

{ #category : #testing }
DiscreteDistribution >> hasTable [
	^true]

{ #category : #initialization }
DiscreteDistribution >> initializeTables [
	| sorted assoc i1 q1 lastAssoc in qn |
	sorted := (probabilities withIndexCollect: [:p :i | i -> p])
		asSortedCollection: #value.
	pTable := Array new: probabilities size.
	yTable := Array new: probabilities size.
	self faultSize.
	delta := 1.0 / size.
	[sorted isEmpty] whileFalse: [
		assoc := sorted first.
		i1 := assoc key.
		q1 := assoc value.
		pTable at: i1 put: q1.
		lastAssoc := sorted last.
		in := lastAssoc key.
		qn := lastAssoc value.
		yTable at: i1 put: in.
		sorted removeFirst.
		sorted notEmpty
			ifTrue: [sorted removeLast; add: in -> (qn - (delta - q1))]]]

{ #category : #'probability functions' }
DiscreteDistribution >> inverseDistribution: u [
	"
	Walker's method. See Knuth, Vol. 2, p. 115
	"
	| index v |
	u = 1.0 ifTrue: [^self max].
	index := u // delta + 1.
	v := u \\ delta.
	^values
		at: (v < (pTable at: index) ifTrue: [index] ifFalse: [yTable at: index])]

{ #category : #inquiries }
DiscreteDistribution >> isConsistentWithBounds: deterministicValue [
	values isEmptyOrNil ifTrue: [^false].
	(values anyone isKindOf: Magnitude) ifFalse: [^true].
	self min ifNotNil: [:m | m <~ deterministicValue ifFalse: [^false]].
	self max ifNotNil: [:m | ^deterministicValue <~ m].
	^true]

{ #category : #testing }
DiscreteDistribution >> isFinite [
	^true]

{ #category : #testing }
DiscreteDistribution >> isIntegerDistribution [
	^values conform: [:v | v asInteger = v]]

{ #category : #inquiries }
DiscreteDistribution >> isLike: aProbabilityDistribution [
	^(super isLike: aProbabilityDistribution)
		and: [self table = aProbabilityDistribution table]]

{ #category : #tests }
DiscreteDistribution >> knuthTest [
	1 to: probabilities size do: [:k | self knuthTest: k]]

{ #category : #tests }
DiscreteDistribution >> knuthTest: k [
	| yk p |
	yk := (1 to: yTable size) select: [:i | (yTable at: i) = k].
	p := yk inject: (pTable at: k) into: [:r :i | r + (delta - (pTable at: i))].
	self ASSERT: (p isCloseTo: (probabilities at: k))]

{ #category : #estimators }
DiscreteDistribution >> kurtosis [
	| mu mu4 |
	mu := self mean.
	mu4 := 0.0.
	values
		with: probabilities
		do: [:v :p | mu4 := (v - mu raisedToInteger: 4) * p + mu4].
	^mu4 / self variance squared]

{ #category : #estimators }
DiscreteDistribution >> max [
	^values last]

{ #category : #estimators }
DiscreteDistribution >> mean [
	| mu |
	mu := 0.0.
	values with: probabilities do: [:v :p | mu := p * v + mu].
	^mu]

{ #category : #estimators }
DiscreteDistribution >> min [
	^values first]

{ #category : #estimators }
DiscreteDistribution >> mode [
	| index |
	probabilities asSet size = 1 ifTrue: [^values at: values size + 1 // 2].
	index := (1 to: probabilities size) max: [:i | probabilities at: i].
	^(probabilities at: index) > 0 ifTrue: [values at: index]]

{ #category : #printing }
DiscreteDistribution >> parameterArray [
	| n |
	^Array streamContents: [:stream | 
		stream nextPut: (n := values size).
		1 to: n do: [:i | 
			stream
				nextPut: (values at: i);
				nextPut: (probabilities at: i)]]]

{ #category : #printing }
DiscreteDistribution >> parameterArrayForDateDistribution: aDateDistribution [
	^Array streamContents: [:stream | | n |
		n := values size.
		stream nextPut: n.
		1 to: n do: [:i | | vi di pi |
			vi := values at: i.
			di := aDateDistribution dateFrom: vi.
			pi := probabilities at: i.
			stream nextPut: di; nextPut: pi]]]

{ #category : #printing }
DiscreteDistribution >> parameterArrayInUnit: unit [
	^Array streamContents: [:stream | 
		stream nextPut: values size.
		1 to: values size do: [:i | | v |
			v := unit convert: (values at: i).
			stream
				nextPut: v;
				nextPut: (probabilities at: i)]]]

{ #category : #accessing }
DiscreteDistribution >> parameters [
	| answer |
	answer := Dictionary new.
	values with: probabilities withIndexDo: [:v :p :i | 
		answer
			at: 'x' , i asString put: v;
			at: 'p' , i asString put: p].
	^answer]

{ #category : #'probability functions' }
DiscreteDistribution >> percentile: u [
	| sum |
	sum := 0.0.
	values with: probabilities do: [:x :p | 
		sum := sum + p.
		u <~ sum ifTrue: [^x]].
	^self max]

{ #category : #copying }
DiscreteDistribution >> postCopy [
	super postCopy.
	values := values copy.
	probabilities := probabilities copy.
	pTable := pTable copy.
	yTable := yTable copy]

{ #category : #printing }
DiscreteDistribution >> prettyPrint [
	^self displayString]

{ #category : #accessing }
DiscreteDistribution >> probabilities [
	^probabilities]

{ #category : #accessing }
DiscreteDistribution >> probabilityAt: index ifAbsent: aBlock [
	^probabilities at: index ifAbsent: aBlock]

{ #category : #accessing }
DiscreteDistribution >> probabilityAt: index put: aNumber [
	self
		values: values
		probabilities: (probabilities at: index put: aNumber; yourself)]

{ #category : #estimators }
DiscreteDistribution >> skewness [
	| mu mu3 |
	mu := self mean.
	mu3 := 0.0.
	values
		with: probabilities
		do: [:v :p | mu3 := (v - mu raisedToInteger: 3) * p + mu3].
	^mu3 / (self variance raisedTo: 1.5)]

{ #category : #printing }
DiscreteDistribution >> storeString [
	^self class name , ' values: ' , values asArray literalString
		, ' probabilities: '
		, probabilities asArray literalString]

{ #category : #'gui support' }
DiscreteDistribution >> table [
	^Array
		streamContents: [:stream | values
			with: probabilities
			do: [:x :p | stream nextPut: {x. p}]]]

{ #category : #operations }
DiscreteDistribution >> translateBy: amount [
	| translated |
	translated := self values collect: [:v | v + amount].
	self values: translated probabilities: self probabilities]

{ #category : #truncation }
DiscreteDistribution >> truncateFrom: xL to: xR [
	(xL isNil and: [xR isNil]) ifTrue: [^self].
	((xL isNil or: [xL <= self min]) and: [xR isNil or: [self max <= xR]])
		ifTrue: [^self].
	^super truncateFrom: xL to: xR]

{ #category : #validation }
DiscreteDistribution >> validateProbability: aNumber at: index [
	^self
		runValidation: #validateDiscreteProbability:at:
		with: aNumber
		with: index]

{ #category : #validation }
DiscreteDistribution >> validateValue: aNumber at: index [
	^self runValidation: #validateDiscreteValue:at: with: aNumber with: index]

{ #category : #accessing }
DiscreteDistribution >> valueAt: index ifAbsent: aBlock [
	^values at: index ifAbsent: aBlock]

{ #category : #accessing }
DiscreteDistribution >> valueAt: index put: aNumber [
	self
		values: (values at: index put: aNumber; yourself)
		probabilities: probabilities]

{ #category : #accessing }
DiscreteDistribution >> values [
	^values]

{ #category : #private }
DiscreteDistribution >> values: realCollection probabilities: probCollection [
	values := realCollection.
	probabilities := probCollection.
	size := probabilities size asFloat.
	delta := 1.0 / size.
	self initializeTables]

{ #category : #testing }
DiscreteDistribution >> valuesSize [
	^values size]

{ #category : #estimators }
DiscreteDistribution >> variance [
	| mu sigma2 |
	mu := self mean.
	sigma2 := 0.0.
	values
		with: probabilities
		do: [:v :p | sigma2 := (v - mu) squared * p + sigma2].
	^sigma2]

