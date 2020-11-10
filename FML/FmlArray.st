"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlArray,
	#superclass : #FmlValue,
	#instVars : [
		'array'
	],
	#category : #FML
}

{ #category : #'result type' }
FmlArray class >> * resultType [
	resultType == FmlTable ifTrue: [^FmlUndefinedValue].
	^self]

{ #category : #testing }
FmlArray class >> isArrayValued [
	^true]

{ #category : #testing }
FmlArray class >> isSingleValued [
	^false]

{ #category : #'instance creation' }
FmlArray class >> new: anInteger [
	"
	FmlArray new: 10
	"
	^self new: anInteger withAll: 0.0]

{ #category : #'instance creation' }
FmlArray class >> new: anInteger withAll: aNumber [
	^self new initialize: anInteger withAll: aNumber]

{ #category : #'instance creation' }
FmlArray class >> on: aCollection [
	"
	#( 1 2 3)  asFmlValue
	"
	^self new initializeArray: aCollection]

{ #category : #'instance creation' }
FmlArray class >> streamContents: aBlock [
	| array |
	array := Array streamContents: aBlock.
	^array asFmlValue]

{ #category : #constants }
FmlArray class >> typeName [
	^'Array']

{ #category : #arithmetic }
FmlArray >> - anFmlValue [
	^self performArrayOperation: #'-' with: anFmlValue]

{ #category : #arithmetic }
FmlArray >> * anFmlValue [
	^self performArrayOperation: #'*' with: anFmlValue]

{ #category : #arithmetic }
FmlArray >> / anFmlValue [
	| answer v numerator |
	answer := Array new: self size.
	1 to: answer size do: [:index | 
		v := [
			numerator := self valueAt: index.
			(numerator isDate ifTrue: [numerator asFmlValue] ifFalse: [numerator])
				/ (anFmlValue valueAt: index)]
			on: ArithmeticError
			do: [FmlUndefinedValue new].
		answer at: index put: v].
	^answer asFmlValue]

{ #category : #arithmetic }
FmlArray >> // anFmlValue [
	^self performArrayOperation: #'//' with: anFmlValue]

{ #category : #arithmetic }
FmlArray >> \\ anFmlValue [
	^self performArrayOperation: #'\\' with: anFmlValue]

{ #category : #arithmetic }
FmlArray >> + anFmlValue [
	^self performArrayOperation: #'+' with: anFmlValue asFmlValue]

{ #category : #comparing }
FmlArray >> < anFmlValue [
	"
	#(1 2 3) asFmlValue < 1 asFmlValue
	#(1 2 3) asFmlValue < #(1 2) asFmlValue
	#(1 2) asFmlValue < #(1 2 3) asFmlValue
	"
	^self performArrayOperation: #'<' with: anFmlValue]

{ #category : #comparing }
FmlArray >> <= anFmlValue [
	"
	#(1 2 3) asFmlValue <= 1 asFmlValue
	#(1 2 3) asFmlValue <= #(1 2) asFmlValue
	#(1 2) asFmlValue <= #(1 2 3) asFmlValue
	"
	anFmlValue isUndefinedValue ifTrue: [^anFmlValue].
	^self performArrayOperation: #'<=' with: anFmlValue]

{ #category : #comparing }
FmlArray >> = anFmlValue [
	"
	#( 1 2 3 ) asFmlValue = #( 1 2 3 ) asFmlValue
	#( 1 2 3 ) asOrderedCollection asFmlValue = #( 1 2 3 ) asFmlValue
	"
	self class == anFmlValue class ifFalse: [^false].
	^self value asArray = anFmlValue value asArray]

{ #category : #comparing }
FmlArray >> > anFmlValue [
	"
	#(1 2 3) asFmlValue > 1 asFmlValue
	#(1 2 3) asFmlValue > #(1 2) asFmlValue
	#(1 2) asFmlValue > #(1 2 3) asFmlValue
	"
	^self performArrayOperation: #'>' with: anFmlValue]

{ #category : #comparing }
FmlArray >> >= anFmlValue [
	"
	#(1 2 3) asFmlValue >= 1 asFmlValue
	#(1 2 3) asFmlValue >= #(1 2) asFmlValue
	#(1 2) asFmlValue >= #(1 2 3) asFmlValue
	"
	anFmlValue isUndefinedValue ifTrue: [^anFmlValue].
	^self performArrayOperation: #'>=' with: anFmlValue]

{ #category : #functions }
FmlArray >> abs [
	^self performArrayOperation: #abs]

{ #category : #visiting }
FmlArray >> acceptVisitor: fmlVisitor [
	fmlVisitor visitArray: self]

{ #category : #arithmetic }
FmlArray >> addTo: aMagnitude [
	^self + aMagnitude]

{ #category : #'logical operations' }
FmlArray >> and: anFmlValue [
	self supportsLogicalOperations
		ifFalse: [^self argumentIn: 'and' shouldBe: FmlBoolean].
	^self asBoolean
		performArrayOperation: #and:
		with: anFmlValue
		into: (Array new: self size)]

{ #category : #converting }
FmlArray >> asArray [
	^self]

{ #category : #converting }
FmlArray >> asBoolean [
	^self isLogical
		ifTrue: [self]
		ifFalse: [FmlArray on: (array collect: [:n | n asFmlValue asBoolean value])]]

{ #category : #converting }
FmlArray >> asPolynomial [
	^RealPolynomial withCoefficients: array]

{ #category : #converting }
FmlArray >> asResult [
	(array isKindOf: FloatArray) ifTrue: [^self].
	(array size > 0 and: [array conform: [:v | v isFloat]])
		ifTrue: [array := array asFloatArray]]

{ #category : #converting }
FmlArray >> asSortedCollection [
	]

{ #category : #accessing }
FmlArray >> at: anInteger [
	^array at: anInteger]

{ #category : #accessing }
FmlArray >> at: anInteger put: aNumber [
	array at: anInteger put: aNumber; markDirty]

{ #category : #tables }
FmlArray >> atColumn: column inTable: table [
	| answer v |
	answer := Array new: self size.
	1 to: self size do: [:i | 
		v := table
			atRow: (self valueAt: i) asInteger
			column: (column valueAt: i) asInteger.
		answer at: i put: v].
	^answer asFmlValue]

{ #category : #tables }
FmlArray >> atRowNumber: fmlNumber inTable: table [
	| answer integer v |
	answer := Array new: self size.
	integer := fmlNumber value asInteger.
	1 to: self size do: [:i | 
		v := table atRow: integer column: (self valueAt: i) asInteger.
		answer at: i put: v].
	^answer asFmlValue]

{ #category : #functions }
FmlArray >> average [
	| invalid sum |
	invalid := array
		findFirst: [:x | x isNumber not andNot: [x isUndefinedValue]]
		ifAbsent: nil.
	invalid isNil ifFalse: [
		^self
			argument: 'value' , invalid printString
			in: 'average'
			shouldBe: FmlNumber].
	sum := array sum: #value.
	^(sum / array size) asFmlValue]

{ #category : #functions }
FmlArray >> average: anArray [
	| args avg |
	args := anArray isArray ifTrue: [anArray] ifFalse: [{anArray}].
	args isEmpty ifTrue: [^self average].
	avg := array withIndexCollect: [:xi :i | | ai |
		ai := args collect: [:a | (a valueAt: i) asFmlValue].
		(xi asFmlValue average: ai) value].
	^avg asFmlValue]

{ #category : #accessing }
FmlArray >> basicValue [
	^array]

{ #category : #arithmetic }
FmlArray >> ceiling [
	^self performArrayOperation: #ceiling]

{ #category : #enumerating }
FmlArray >> collect: evaluable in: aCollection [
	1 to: self size do: [:index | | fx |
		fx := evaluable evaluateWith: (self valueAt: index).
		aCollection add: fx].
	^aCollection]

{ #category : #enumerating }
FmlArray >> collect: aBlock thenSelect: anotherBlock in: aCollection [
	1 to: self size do: [:index | | fx |
		fx := aBlock evaluateWith: (self valueAt: index).
		(anotherBlock evaluateWith: fx) ifTrue: [aCollection add: fx]].
	^aCollection]

{ #category : #accessing }
FmlArray >> columnIndexInTable: anFmlTable [
	| specs indexes |
	self hasStrings ifFalse: [^self].
	specs := anFmlTable columnSpecs.
	indexes := array collect: [:arg | | c |
		c := specs findFirst: [:s | s label = arg] ifAbsent: 0.
		c = 0 ifTrue: [^nil].
		c].
	^indexes asFmlValue]

{ #category : #accessing }
FmlArray >> columnSelectorFor: symbol [
	^(symbol numArgs = 0
		ifTrue: [symbol, 'AtColumn:']
		ifFalse: [symbol, 'atColumn:']) asSymbol]

{ #category : #tables }
FmlArray >> columnValueIn: table row: index [
	| result |
	result := array
		collect: [:r | r asFmlValue columnValueIn: table row: index].
	(result conform: [:x | x isNumber or: [x isUndefinedValue]])
		ifTrue: [result := result asFloatArray].
	^result asFmlValue]

{ #category : #copying }
FmlArray >> copy: start to: stop fill: fill [
	| copy first last limit |
	fill isTableValued
		ifTrue: [^self argument: 'fill' in: 'copy' shouldNotBe: FmlTable].
	first := start value.
	first isUndefinedValue ifTrue: [first := array size + 1].
	first isNumber
		ifFalse: [^self argument: 'fromIndex' in: 'copy' shouldBe: FmlNumber].
	last := stop value.
	last isUndefinedValue ifTrue: [last := array size + 1].
	last isNumber
		ifFalse: [^self argument: 'toIndex' in: 'copy' shouldBe: FmlNumber].
	limit := array size.
	copy := Array new: limit.
	1 to: limit do: [:index | copy at: index put: (fill valueAt: index)].
	first := first asInteger min: limit + 1 max: 1.
	last := last asInteger min: limit max: 0.
	first to: last do: [:index | copy at: index put: (array at: index)].
	^copy asFmlValue]

{ #category : #functions }
FmlArray >> cum [
	"
	#(1 2 3 4) asFmlValue cum
	"
	self isNumeric
		ifFalse: [^self argument: 'array' in: 'cum' shouldBeArrayOf: FmlNumber].
	^(array inject: 0.0 into: [:result :each | result + each]) asFmlValue]

{ #category : #functions }
FmlArray >> cumAtColumn: index [
	"
	#( 1 2 3 4 ) asFmlValue cum
	"
	^array
		inject: 0.0
		into: [:result :each | each isUndefinedValue
			ifTrue: [result]
			ifFalse: [result + each]]]

{ #category : #'date functions' }
FmlArray >> day [
	^self hasDates
		ifTrue: [(array collect: [:each | each dayOfMonth]) asFmlValue]
		ifFalse: [self argumentIn: #day shouldBe: FmlDate]]

{ #category : #'date functions' }
FmlArray >> day: day year: year [
	^self withIndexCollect: [:each :index | 
		(each asFmlValue
			day: (day valueAt: index) asFmlValue
			year: (year valueAt: index) asFmlValue) value]]

{ #category : #'date functions' }
FmlArray >> dayOfYear [
	^self hasDates
		ifTrue: [(array collect: [:each | each dayOfYear]) asFmlValue]
		ifFalse: [self argumentIn: #dayOfYear shouldBe: FmlDate]]

{ #category : #'date functions' }
FmlArray >> daysInYear [
	^self hasDates
		ifTrue: [(array collect: [:each | each daysInYear]) asFmlValue]
		ifFalse: [self argumentIn: #daysInYear shouldBe: FmlDate]]

{ #category : #functions }
FmlArray >> db: life afterlife: aBoolean [
	| after |
	life isNumeric
		ifFalse: [^self argument: 'life' in: 'db' shouldBe: FmlNumber].
	life value > 0.0 ifFalse: [^self nonPositiveArgument: 'life' in: 'db'].
	after := aBoolean value.
	after isBoolean
		ifFalse: [^self argument: 'afterlife' in: 'db' shouldBe: FmlBoolean].
	^self db: life factor: 1.0 afterlife: after]

{ #category : #functions }
FmlArray >> db: period factor: factor [
	^self db: period factor: factor afterlife: false]

{ #category : #functions }
FmlArray >> db: period factor: factor afterlife: aBoolean [
	| answer size rate sum cost n |
	n := self periodsSize.
	answer := self zeroArray.
	size := period asInteger.
	rate := factor / size.
	1 to: n do: [:i | | max |
		sum := 0.0.
		cost := self valueAt: i.
		max := aBoolean ifTrue: [n] ifFalse: [i + size min: n].
		i + 1 to: max do: [:j | | delta |
			delta := cost - sum * rate.
			sum := sum + delta.
			answer at: j sum: delta]].
	^answer asFmlValue]

{ #category : #functions }
FmlArray >> ddb: life afterlife: aBoolean [
	| after |
	life isNumeric
		ifFalse: [^self argument: 'life' in: 'ddb' shouldBe: FmlNumber].
	life value > 0.0 ifFalse: [^self nonPositiveArgument: 'life' in: 'ddb'].
	after := aBoolean value.
	after isBoolean
		ifFalse: [^self argument: 'afterlife' in: 'ddb' shouldBe: FmlBoolean].
	^self db: life factor: 2.0 afterlife: after]

{ #category : #printing }
FmlArray >> displayValueWith: aUnit [
	^array displayValueWith: aUnit]

{ #category : #functions }
FmlArray >> distributionFor: aProbabilityDistribution [
	| values |
	values := array collect: [:xi | aProbabilityDistribution distribution: xi].
	^values asFmlValue]

{ #category : #comparing }
FmlArray >> equals: anFmlValue [
	"
	#( 1 2 3 ) asFmlValue equals: 1 asFmlValue #( 1 2 3 ) asFmlValue equals: #(1
	2 3 ) asFmlValue #( 1 2 3 4 ) asFmlValue equals: #( 1 2 ) asFmlValue #( 1 2
	) asFmlValue equals: #( 1 2 3 4 ) asFmlValue #( 1 2 0 0 ) asFmlValue equals:
	#( 1 2 ) asFmlValue #( 1 2  ) asFmlValue equals: #( 1 2 0 0 ) asFmlValue
	"
	^self performArrayOperation: #'=' with: anFmlValue]

{ #category : #accessing }
FmlArray >> evaluated [
	self value: (array value collect: [:each | each evaluated])]

{ #category : #constants }
FmlArray >> excelErrorBound [
	^0.00001]

{ #category : #'file in/out' }
FmlArray >> fileOutSurrogate [
	^self asResult]

{ #category : #accessing }
FmlArray >> first [
	^array first]

{ #category : #functions }
FmlArray >> firstNegativeIfAbsent: defaultValue [
	^(array
		findFirst: [:each | 
			each isUndefinedValue ifTrue: [^FmlUndefinedValue new].
			each < 0.0]
		ifAbsent: defaultValue) asFmlValue]

{ #category : #functions }
FmlArray >> firstNegativeIfAbsent: defaultValue atColumn: index [
	^self firstNegativeIfAbsent: defaultValue ]

{ #category : #functions }
FmlArray >> firstPositiveIfAbsent: defaultValue [
	^(array
		findFirst: [:each | 
			each isUndefinedValue ifTrue: [^FmlUndefinedValue new].
			each > 0.0]
		ifAbsent: defaultValue) asFmlValue]

{ #category : #functions }
FmlArray >> firstPositiveIfAbsent: defaultValue atColumn: index [
	^self firstPositiveIfAbsent: defaultValue]

{ #category : #functions }
FmlArray >> firstValue [
	^array first asFmlValue]

{ #category : #arithmetic }
FmlArray >> floor [
	^self performArrayOperation: #floor]

{ #category : #functions }
FmlArray >> geometricMean: anArray [
	| args avg |
	args := anArray isArray ifTrue: [anArray] ifFalse: [{anArray}].
	avg := array withIndexCollect: [:xi :i | | ai |
		ai := args collect: [:a | (a valueAt: i) asFmlValue].
		(xi asFmlValue geometricMean: ai) value].
	^avg asFmlValue]

{ #category : #testing }
FmlArray >> hasDates [
	^array conform: [:n | n isUndefinedValue or: [n isDate]]]

{ #category : #comparing }
FmlArray >> hash [
	"
	#(1 2 3 ) asFmlValue hash
	#(1 2 3 ) asOrderedCollection asFmlValue hash
	#(1 2 3 ) asOrderedCollection asFmlValue hash = #(1 2 3 ) asFmlValue hash
	"
	^array hash]

{ #category : #testing }
FmlArray >> hasIndexedSlots [
	^true]

{ #category : #testing }
FmlArray >> hasStrings [
	^array conform: [:v | v isUndefinedValue or: [v isString]]]

{ #category : #testing }
FmlArray >> hasUndefinedValues [
	^array hasUndefinedValues]

{ #category : #functions }
FmlArray >> if: trueArg with: falseArg [
	self supportsLogicalOperations
		ifFalse: [^self argument: 'boolean' in: 'if' shouldBe: FmlBoolean].
	^self withIndexCollect: [:each :index | | value |
		value := (each
			if: [trueArg valueAt: index]
			with: [falseArg valueAt: index])
			value.
		value resultType isTableValued
			ifTrue: [^InvalidArgumentType
				signal: 'An Array cannot contain a Table as an element'].
		value]]

{ #category : #'array compatibility' }
FmlArray >> indexGTValue: value ifAbsent: default [
	| v index |
	v := value value.
	v isSummable
		ifFalse: [^self
			argument: 'value'
			in: 'indexGTValue'
			shouldNotBe: value class].
	index := array
		findFirst: [:e | 
			e isUndefinedValue ifTrue: [^FmlUndefinedValue new].
			v < e]
		ifAbsent: default.
	^index asFmlValue]

{ #category : #'array compatibility' }
FmlArray >> indexLTValue: value ifAbsent: default [
	| v index |
	v := value value.
	v isSummable
		ifFalse: [^self
			argument: 'value'
			in: 'indexLTValue'
			shouldNotBe: value class].
	index := array
		findLast: [:e | 
			e isUndefinedValue ifTrue: [^FmlUndefinedValue new].
			e < v]
		ifAbsent: [default].
	^index asFmlValue]

{ #category : #private }
FmlArray >> initialize: anInteger withAll: anObject [
	| class |
	class := anObject isNumber ifTrue: [FloatArray] ifFalse: [Array].
	array := class new: anInteger withAll: anObject]

{ #category : #private }
FmlArray >> initializeArray: aCollection [
	self value: aCollection]

{ #category : #tables }
FmlArray >> interpolate: value
on: table
returnColumn: return
extrapolate: aBoolean [
	| values |
	values := array withIndexCollect: [:s :i | | v r |
		v := value valueAt: i.
		r := return valueAt: i.
		s asFmlValue
			interpolate: v asFmlValue
			on: table
			returnColumn: r asFmlValue
			extrapolate: aBoolean].
	values hasUndefinedValues ifFalse: [values := values asFloatArray].
	^values asFmlValue]

{ #category : #tables }
FmlArray >> interpolate: value
on: table
searchingAt: columnIndex
extrapolate: aBoolean [
	| values |
	values := array withIndexCollect: [:r :i | | v |
		v := value valueAt: i.
		r asFmlValue
			interpolate: v asFmlValue
			on: table
			searchingAt: columnIndex
			extrapolate: aBoolean].
	values hasUndefinedValues ifFalse: [values := values asFloatArray].
	^values asFmlValue]

{ #category : #tables }
FmlArray >> interpolateUsing: aLinearInterpolatedFunction extrapolate: aBoolean [
	| value |
	value := array collect: [:v | 
		v asFmlValue
			interpolateUsing: aLinearInterpolatedFunction
			extrapolate: aBoolean].
	value hasUndefinedValues ifFalse: [value := value asFloatArray].
	^value asFmlValue]

{ #category : #accessing }
FmlArray >> inverseAt: fmlArray [
	^(array
		collect: [:index | index < 1
			ifTrue: [0]
			ifFalse: [fmlArray valueAt: index asInteger]]) asFmlValue]

{ #category : #functions }
FmlArray >> inverseDistributionFor: aProbabilityDistribution [
	| ok x |
	ok := true.
	x := array collect: [:pi | 
		(pi between: 0.0 and: 1.0)
			ifTrue: [aProbabilityDistribution inverseDistribution: pi]
			ifFalse: [
				ok := false.
				FmlUndefinedValue new]].
	ok ifFalse: [
		self
			argument: 'probability'
			in: 'inverseDistribution'
			notBetween: 0
			and: 1].
	^x asFmlValue]

{ #category : #functions }
FmlArray >> inverseLognormal: mean sd: sd [
	| nan values lognormal |
	nan := Float nan.
	lognormal := LogNormalDistribution new.
	values := array withIndexCollect: [:pi :i | | mi sdi vi |
		mi := mean valueAt: i.
		sdi := sd valueAt: i.
		vi := pi asFmlValue inverseLognormal: lognormal mean: mi sd: sdi.
		vi isNil ifTrue: [nan] ifFalse: [vi]].
	^values asFloatArray asFmlValue]

{ #category : #functions }
FmlArray >> inverseNormal: mean sd: sd [
	| nan values normal |
	nan := Float nan.
	normal := NormalDistribution new.
	values := array withIndexCollect: [:pi :i | | mi sdi vi |
		mi := mean valueAt: i.
		sdi := sd valueAt: i.
		vi := pi asFmlValue inverseNormal: normal mean: mi sd: sdi.
		vi isNil ifTrue: [nan] ifFalse: [vi]].
	^values asFloatArray asFmlValue]

{ #category : #functions }
FmlArray >> inverseTriangular: a mid: c max: b [
	| nan values triangular |
	nan := Float nan.
	triangular := TriangularDistribution new.
	values := array withIndexCollect: [:pi :i | | ai ci bi vi |
		ai := a valueAt: i.
		ci := c valueAt: i.
		bi := b valueAt: i.
		vi := pi asFmlValue
			inverseTriangular: triangular
			left: ai
			mid: ci
			right: bi.
		vi isNil ifTrue: [nan] ifFalse: [vi]].
	^values asFloatArray asFmlValue]

{ #category : #private }
FmlArray >> irr [
	| irr |
	irr := self periodicity isMixed
		ifTrue: [self irr: self periodicity endDates value]
		ifFalse: [self irrTail: array size].
	^irr asFmlValue]

{ #category : #private }
FmlArray >> irr: dates [
	^self irr: dates tail: dates size]

{ #category : #private }
FmlArray >> irr: dates from: start to: stop [
	| interval |
	start to: stop do: [:i | | ai |
		ai := array at: i.
		ai isUndefinedValue ifTrue: [^Float nan]].
	(start + 1 to: stop)
		detect: [:i | | ai bi |
			ai := array at: i.
			bi := array at: i - 1.
			ai negative ~= bi negative]
		ifNone: [^Float nan].
	interval := self irrInterval: dates from: start to: stop.
	interval isNil ifTrue: [^Float nan].
	interval refineBelow: self excelErrorBound.
	^interval first]

{ #category : #private }
FmlArray >> irr: dates startDate: startDate endDate: endDate [
	| i j di dj d |
	i := (dates positionOf: startDate) max: 1.
	j := dates positionOf: endDate.
	di := dates at: i.
	dj := dates at: j.
	d := (di ~= startDate or: [dj ~= endDate])
		ifTrue: [
			dates copy
				at: i put: startDate;
				at: j put: endDate;
				yourself]
		ifFalse: [dates].
	^self irr: d from: i to: j]

{ #category : #private }
FmlArray >> irr: dates tail: index [
	^self irr: dates from: 1 to: index]

{ #category : #private }
FmlArray >> irrInterval: dates from: start to: stop [
	| f a fa b fb inc max count bound interval der |
	f := self npvFunction: dates from: start to: stop.
	a := 0.0.
	fa := f evaluateWith: a.
	fa < 0.0
		ifTrue: [^(self negatedFrom: start to: stop)
			irrInterval: dates
			from: start
			to: stop].
	b := 0.1.
	fb := f evaluateWith: b.
	inc := fb < fa ifTrue: [0.1] ifFalse: [-0.1].
	max := self maxIrrInc.
	count := 0.
	bound := self excelErrorBound.
	[
		count > 200
			ifTrue: [^fb abs < 0.001
				ifTrue: [FunctionRootInterval on: f from: b to: b]].
		fb < 0.0]
		whileFalse: [
			fb < bound ifTrue: [^FunctionRootInterval on: f from: b to: b].
			count := count + 1.
			inc := max min: inc * 2.0.
			a := b.
			b := b + inc.
			fb := f evaluateWith: b].
	interval := FunctionRootInterval on: f from: a to: b.
	der := self npvDerivativeFunction: dates from: start to: stop.
	^interval derivative: der]

{ #category : #private }
FmlArray >> irrIntervalTail: index [
	| f a fa b fb inc max count bound interval der |
	f := self npvFunctionTail: index.
	a := 0.0.
	fa := f evaluateWith: a.
	fa < 0.0 ifTrue: [^(self negatedUpTo: index) irrIntervalTail: index].
	b := 0.1.
	fb := f evaluateWith: b.
	inc := fb < fa ifTrue: [0.1] ifFalse: [-0.1].
	max := self maxIrrInc.
	count := 0.
	bound := self excelErrorBound.
	[
		count > 200
			ifTrue: [^fb abs < 0.001
				ifTrue: [FunctionRootInterval on: f from: b to: b]].
		fb < 0.0]
		whileFalse: [
			fb < bound ifTrue: [^FunctionRootInterval on: f from: b to: b].
			count := count + 1.
			inc := max min: inc * 2.0.
			a := b.
			b := b + inc.
			fb := f evaluateWith: b].
	interval := FunctionRootInterval on: f from: a to: b.
	der := self npvDerivativeFunctionTail: index.
	^interval derivative: der]

{ #category : #private }
FmlArray >> irrTail: index [
	| interval |
	1 to: index do: [:i | | ai |
		ai := array at: i.
		ai isUndefinedValue ifTrue: [^Float nan]].
	(2 to: index)
		detect: [:i | | ai bi |
			ai := array at: i.
			bi := array at: i - 1.
			ai negative ~= bi negative]
		ifNone: [^Float nan].
	interval := self irrIntervalTail: index.
	interval isNil ifTrue: [^Float nan].
	interval refineBelow: self excelErrorBound.
	^interval first]

{ #category : #testing }
FmlArray >> isArrayValued [
	^true]

{ #category : #testing }
FmlArray >> isCloseTo: aFmlArray [
	"
	#( 1.01 1.001 1.0001) asFmlValue isCloseTo: #( 1.01 1.001 1.00075) asFmlValue
	"
	self with: aFmlArray do: [:each :other | (each isCloseTo: other) ifFalse: [^false]].
	^true]

{ #category : #testing }
FmlArray >> isCollection [
	^true]

{ #category : #testing }
FmlArray >> isConstant [
	^false]

{ #category : #testing }
FmlArray >> isDefined [
	^(array collect: [:each | each isUndefinedValue not]) asFmlValue]

{ #category : #testing }
FmlArray >> isDefinedAtColumn: index [
	^(self valueAt: index) isUndefinedValue not]

{ #category : #testing }
FmlArray >> isFmlArray [
	^true]

{ #category : #testing }
FmlArray >> isIncreasing [
	^array isIncreasing]

{ #category : #testing }
FmlArray >> isLogical [
	^array conform: [:n | n isUndefinedValue or: [n isBoolean]]]

{ #category : #testing }
FmlArray >> isNumeric [
	^array conform: [:n | n isUndefinedValue or: [n isNumber]]]

{ #category : #testing }
FmlArray >> isSummable [
	^array conform: [:n | n isSummable]]

{ #category : #testing }
FmlArray >> isZero [
	^array conform: [:v | v isZero]]

{ #category : #functions }
FmlArray >> lastNegativeIfAbsent: defaultValue [
	^(array
		findLast: [:each | 
			each isUndefinedValue ifTrue: [^FmlUndefinedValue new].
			each < 0.0]
		ifAbsent: defaultValue) asFmlValue]

{ #category : #functions }
FmlArray >> lastNegativeIfAbsent: defaultValue atColumn: index [
	^self lastNegativeIfAbsent: defaultValue]

{ #category : #functions }
FmlArray >> lastPositiveIfAbsent: defaultValue [
	^(array
		findLast: [:each | 
			each isUndefinedValue ifTrue: [^FmlUndefinedValue new].
			each > 0.0]
		ifAbsent: defaultValue) asFmlValue]

{ #category : #functions }
FmlArray >> lastPositiveIfAbsent: defaultValue atColumn: index [
	^self lastPositiveIfAbsent: defaultValue]

{ #category : #functions }
FmlArray >> lastValue [
	^array last asFmlValue]

{ #category : #functions }
FmlArray >> lastValueAtColumn: index [
	^self lastValue]

{ #category : #functions }
FmlArray >> log: aFmlValue [
	^self performArrayOperation: #log: with: aFmlValue]

{ #category : #functions }
FmlArray >> lognormal: mean sd: sd cumulative: aBoolean [
	| nan values normal |
	nan := Float nan.
	normal := LogNormalDistribution new.
	values := array withIndexCollect: [:xi :i | | mi sdi bi vi |
		mi := mean valueAt: i.
		sdi := sd valueAt: i.
		bi := aBoolean valueAt: i.
		vi := xi asFmlValue
			lognormal: normal
			mean: mi
			sd: sdi
			cumulative: bi.
		vi isNil ifTrue: [nan] ifFalse: [vi]].
	^values asFloatArray asFmlValue]

{ #category : #functions }
FmlArray >> lognormalBayesianLearningError: error
prevMean: mu0
prevSd: sd0
P90P10: q [
	| numbers |
	numbers := array collect: [:c | 
		c asFmlValue
			lognormalBayesianLearningError: error
			prevMean: mu0
			prevSd: sd0
			P90P10: q].
	^numbers asFmlValue]

{ #category : #functions }
FmlArray >> macrsWith: factors [
	| n answer |
	n := self periodsSize.
	answer := self zeroArray.
	1 to: n do: [:i | | cost |
		cost := self valueAt: i.
		factors withIndexDo: [:factor :j | | pos |
			pos := i + j - 1.
			pos <= n ifTrue: [answer at: pos sum: cost * factor]]].
	^answer asFmlValue]

{ #category : #functions }
FmlArray >> max: anFmlValue [
	"
	#(1 2 3) asFmlValue max: 1 asFmlValue
	#(1 2 3) asFmlValue max: #(1 2) asFmlValue
	#(1 2) asFmlValue max: #(1 2 3) asFmlValue
	"
	^self performArrayOperation: #max: with: anFmlValue]

{ #category : #constants }
FmlArray >> maxIrrInc [
	^10.0]

{ #category : #functions }
FmlArray >> maxValue [
	^array max asFmlValue]

{ #category : #functions }
FmlArray >> maxValueAtColumn: index [
	^self maxValue]

{ #category : #functions }
FmlArray >> min: anFmlValue [
	"
	#(1 2 3) asFmlValue min: 1 asFmlValue
	#(1 2 3) asFmlValue min: #(1 2) asFmlValue
	#(1 2) asFmlValue min: #(1 2 3) asFmlValue
	"
	^self performArrayOperation: #min: with: anFmlValue]

{ #category : #functions }
FmlArray >> min: aMagnitude max: otherMagnitude [
	^(self min: aMagnitude) max: otherMagnitude]

{ #category : #functions }
FmlArray >> minValue [
	^array min asFmlValue]

{ #category : #functions }
FmlArray >> minValueAtColumn: index [
	^self minValue]

{ #category : #'date functions' }
FmlArray >> month [
	^self hasDates
		ifTrue: [(array collect: [:each | each monthIndex]) asFmlValue]
		ifFalse: [self argumentIn: #month shouldBe: FmlDate]]

{ #category : #'date functions' }
FmlArray >> month: month year: year [
	^self
		withIndexCollect: [:each :index | (each asFmlValue
			month: (month valueAt: index)
			year: (year valueAt: index))
			value]]

{ #category : #arithmetic }
FmlArray >> negated [
	^(array collect: [:each | each negated]) asFmlValue]

{ #category : #arithmetic }
FmlArray >> negatedFrom: start to: stop [
	| copy |
	copy := array copy.
	start to: stop do: [:i | | ai |
		ai := array at: i.
		copy at: i put: ai negated].
	^copy asFmlValue]

{ #category : #arithmetic }
FmlArray >> negatedUpTo: index [
	^self negatedFrom: 1 to: index]

{ #category : #functions }
FmlArray >> normal: mean sd: sd cumulative: aBoolean [
	| nan values normal |
	nan := Float nan.
	normal := NormalDistribution new.
	values := array withIndexCollect: [:xi :i | | mi sdi bi vi |
		mi := mean valueAt: i.
		sdi := sd valueAt: i.
		bi := aBoolean valueAt: i.
		vi := xi asFmlValue
			normal: normal
			mean: mi
			sd: sdi
			cumulative: bi.
		vi isNil ifTrue: [nan] ifFalse: [vi]].
	^values asFloatArray asFmlValue]

{ #category : #functions }
FmlArray >> normalBayesianLearningError: error prevSd: sd0 actualSd: sd [
	| numbers |
	numbers := array
		collect: [:c | c asFmlValue
			normalBayesianLearningError: error
			prevSd: sd0
			actualSd: sd].
	^numbers asFmlValue]

{ #category : #'logical operations' }
FmlArray >> not [
	self supportsLogicalOperations
		ifFalse: [^self argumentIn: 'not' shouldBe: FmlBoolean].
	^self asBoolean performArrayOperation: #not]

{ #category : #npv }
FmlArray >> npv: rate [
	| periodicity xnpv d1 d0 discount |
	(rate isNumeric and: [rate isSingleValued])
		ifFalse: [^self argument: 'rate' in: 'npv' shouldBe: FmlNumber].
	rate value = -1.0 ifTrue: [^nil].
	periodicity := [self periodicity] on: MessageNotUnderstood do: [].
	^(periodicity notNil and: [periodicity isMixed])
		ifTrue: [
			xnpv := self xNPVRate: rate dates: periodicity endDates value.
			d1 := periodicity endDates value first.
			d0 := periodicity startDates value first.
			discount := 1.0 + rate value raisedTo: d1 - d0 + 1 / 365.0.
			xnpv / discount]
		ifFalse: [self npv: rate tail: array size]]

{ #category : #private }
FmlArray >> npv: rate
dates: dates
from: start
to: end [
	| rho npv d0 ej |
	rate = -1.0 ifTrue: [^nil].
	rho := 1.0 / (1.0 + rate).
	d0 := dates at: start.
	ej := (dates at: end) subtractDate: d0.
	npv := array at: end.
	end - 1 to: start by: -1 do: [:i | | ai ei |
		ei := (dates at: i) subtractDate: d0.
		ai := array at: i.
		npv := npv * (rho raisedTo: ej - ei / 365.0) + ai.
		ej := ei].
	^npv * (rho raisedTo: ej / 365.0)]

{ #category : #private }
FmlArray >> npv: rate tail: index [
	| rho v |
	rate ~ -1.0 ifTrue: [^Float nan].
	rho := 1.0 / (1.0 + rate).
	v := 0.0.
	index to: 1 by: -1 do: [:i | | ai |
		ai := array at: i.
		v := v * rho + ai].
	^v * rho]

{ #category : #private }
FmlArray >> npvDerivative: rate
dates: dates
from: start
to: end [
	| rho d0 ej fj der ai |
	rate = -1.0 ifTrue: [^nil].
	rho := 1.0 / (1.0 + rate).
	d0 := dates at: start.
	ej := (dates at: end) subtractDate: d0.
	fj := ej - 365.0.
	der := (array at: end) * ej.
	end - 1 to: start by: -1 do: [:i | | bi ei fi |
		ei := (dates at: i) subtractDate: d0.
		fi := ei - 365.0.
		ai := array at: i.
		bi := ei * ai.
		der := der * (rho raisedTo: fj - fi / 365.0) + bi.
		fj := fi].
	^der * (rho raisedTo: fj / 365.0) * rho squared negated / 365.0]

{ #category : #private }
FmlArray >> npvDerivative: rate tail: index [
	| rho der bi |
	rho := 1.0 / (1.0 + rate).
	der := 0.0.
	index to: 1 by: -1 do: [:i | | ai |
		ai := array at: i.
		bi := i * ai.
		der := der * rho + bi].
	^der * rho squared negated]

{ #category : #services }
FmlArray >> npvDerivativeFunction [
	^self npvDerivativeFunctionTail: array size - 1]

{ #category : #services }
FmlArray >> npvDerivativeFunction: dates [
	^self npvDerivativeFunction: dates tail: dates size]

{ #category : #services }
FmlArray >> npvDerivativeFunction: dates from: start to: stop [
	^[:r | 
		self
			npvDerivative: r
			dates: dates
			from: start
			to: stop]]

{ #category : #services }
FmlArray >> npvDerivativeFunction: dates tail: index [
	^self npvDerivativeFunction: dates from: 1 to: index]

{ #category : #services }
FmlArray >> npvDerivativeFunctionTail: index [
	^[:r | self npvDerivative: r tail: index]]

{ #category : #services }
FmlArray >> npvFunction [
	^self npvFunctionTail: array size]

{ #category : #services }
FmlArray >> npvFunction: dates [
	^self npvFunction: dates tail: dates size]

{ #category : #services }
FmlArray >> npvFunction: dates from: start to: stop [
	^[:r | 
		self
			npv: r
			dates: dates
			from: start
			to: stop]]

{ #category : #services }
FmlArray >> npvFunction: dates tail: index [
	^[:r | 
		self
			npv: r
			dates: dates
			from: 1
			to: index]]

{ #category : #services }
FmlArray >> npvFunctionTail: index [
	^[:r | self npv: r tail: index]]

{ #category : #functions }
FmlArray >> npvRate: rate [
	| npv |
	npv := self npv: rate.
	^npv asFmlValue]

{ #category : #'logical operations' }
FmlArray >> or: anFmlValue [
	self supportsLogicalOperations
		ifFalse: [^self argumentIn: 'or' shouldBe: FmlBoolean].
	^self asBoolean
		performArrayOperation: #or:
		with: anFmlValue
		into: (Array new: self size)]

{ #category : #perform }
FmlArray >> performArrayOperation: aSymbol [
	| answer v |
	answer := array class new: self size.
	1 to: answer size do: [:index | 
		v := (self valueAt: index) perform: aSymbol.
		v := (answer class == FloatArray and: [v isUndefinedValue])
			ifTrue: [Float nan]
			ifFalse: [v value].
		answer at: index put: v].
	^answer asFmlValue]

{ #category : #perform }
FmlArray >> performArrayOperation: aSymbol with: anFmlValue [
	| type answer |
	type := (array class ~~ FloatArray
		or: [FmlBinaryExpression logicalOperators includes: aSymbol]
		or: [(anFmlValue isKindOf: FmlValue) and: [anFmlValue hasDates]])
		ifTrue: [Array]
		ifFalse: [array class].
	answer := type new: self size.
	^self performArrayOperation: aSymbol with: anFmlValue into: answer]

{ #category : #perform }
FmlArray >> performArrayOperation: aSymbol with: anFmlValue into: answer [
	| numeric |
	numeric := answer class == FloatArray.
	1 to: answer size do: [:index | | v w quantity |
		v := (self valueAt: index) asFmlValue.
		w := (anFmlValue valueAt: index) asFmlValue.
		quantity := v notNil & w notNil ifTrue: [v perform: aSymbol with: w].
		quantity := (numeric and: [quantity isUndefinedValue])
			ifTrue: [Float nan]
			ifFalse: [quantity value].
		answer at: index put: quantity].
	^answer asFmlValue]

{ #category : #perform }
FmlArray >> performFunction: symbol withArgs: aCollection [
	(self respondsTo: symbol)
		ifTrue: [^self perform: symbol withArguments: aCollection].
	^self withIndexCollect: [:each :index | | args |
		args := aCollection collect: [:arg | arg asFmlValue valueAt: index].
		each perform: symbol withArguments: args]]

{ #category : #perform }
FmlArray >> performFunction: aSymbol withArgs: anArray atColumn: anInteger [
	| selector args value segment |
	selector := self columnSelectorFor: aSymbol.
	^(self respondsTo: selector)
		ifTrue: [
			args := anArray copyWith: anInteger.
			self perform: selector withArguments: args]
		ifFalse: [
			segment := self valueFrom: 1 to: anInteger.
			value := segment asFmlValue performFunction: aSymbol withArgs: anArray.
			value valueAt: anInteger]]

{ #category : #perform }
FmlArray >> performOperation: aSymbol receiverValue: anObject [
	^(array collect: [:each | anObject perform: aSymbol with: each]) asFmlValue]

{ #category : #private }
FmlArray >> periodIrr: dates startDate: startDate endDate: endDate [
	| irr i j end di dj d |
	irr := FloatArray new: self size.
	i := dates positionOf: startDate.
	i >= self size ifTrue: [^Float nan].
	j := dates positionOf: endDate.
	end := j >= self size
		ifTrue: [
			j := self size.
			dates at: j]
		ifFalse: [endDate].
	di := dates at: i.
	dj := dates at: j.
	d := (di ~= startDate or: [dj ~= endDate])
		ifTrue: [
			dates copy
				at: i put: startDate;
				at: j put: end;
				yourself]
		ifFalse: [dates].
	1 to: array size do: [:k | | v |
		v := self irr: d from: i to: j.
		irr at: k put: v].
	^irr]

{ #category : #services }
FmlArray >> periodRates [
	^self]

{ #category : #accessing }
FmlArray >> periodsSize [
	^array size]

{ #category : #functions }
FmlArray >> periodXIRR: dates [
	| fmlDates irr |
	fmlDates := dates asFmlValue.
	(fmlDates isArrayValued and: [fmlDates hasDates])
		ifFalse: [^self
			argument: 'dates'
			in: 'periodXIRR'
			shouldBeArrayOf: FmlDate].
	irr := FloatArray new: self size.
	1 to: self size do: [:i | | tail |
		tail := self irr: fmlDates tail: i.
		irr at: i put: tail].
	^irr asFmlValue]

{ #category : #functions }
FmlArray >> periodXIRR: dates startDate: startDate endDate: endDate [
	| fmlDates irr s e |
	fmlDates := dates asFmlValue.
	(fmlDates isArrayValued and: [fmlDates hasDates])
		ifFalse: [^self argument: 'dates' in: 'xIRRLimit' shouldBeArrayOf: FmlDate].
	(s := startDate value) isDate
		ifFalse: [^self argument: 'startDate' in: 'xIRRLimit' shouldBe: FmlDate].
	(e := endDate value) isDate
		ifFalse: [^self argument: 'endDate' in: 'xIRRLimit' shouldBe: FmlDate].
	irr := self periodIrr: fmlDates value startDate: s endDate: e.
	^irr asFmlValue]

{ #category : #copying }
FmlArray >> postCopy [
	super postCopy.
	array := array copy]

{ #category : #functions }
FmlArray >> previousValue: first [
	^self shiftRight: first]

{ #category : #functions }
FmlArray >> previousValue: first atColumn: col [
	^self shiftRight: first atColumn: col]

{ #category : #functions }
FmlArray >> raisedTo: anFmlValue [
	^self performArrayOperation: #raisedTo: with: anFmlValue]

{ #category : #comparing }
FmlArray >> relativeIncrementFrom: value [
	| increment |
	increment := array
		withIndexCollect: [:a :idx | a relativeIncrementFrom: (value valueAt: idx)].
	^increment asFmlValue]

{ #category : #functions }
FmlArray >> runningCum [
	| writer |
	self isNumeric
		ifFalse: [^self
			argument: 'array'
			in: #runningCum
			shouldBeArrayOf: FmlNumber].
	writer := (Array new: self size) writeStream.
	array inject: 0.0 into: [:result :each | writer nextPut: result + each].
	^writer contents asFmlValue]

{ #category : #functions }
FmlArray >> shiftLeft: last [
	^self shiftLeft: 1 fillWith: last]

{ #category : #functions }
FmlArray >> shiftLeft: last atColumn: index [
	^self shiftLeft: 1 fillWith: last atColumn: index]

{ #category : #functions }
FmlArray >> shiftLeft: positions fillWith: element [
	| shift answer |
	positions isNumber
		ifFalse: [^self
			argument: 'positions'
			in: 'positionsLeft'
			shouldBe: FmlNumber].
	positions value < 0 ifTrue: [^FmlUndefinedValue new].
	shift := positions asInteger min: self size.
	answer := Array streamContents: [:strm | 
		array from: shift + 1 to: self size do: [:e | strm nextPut: e].
		1 to: shift do: [:i | strm nextPut: (element valueAt: i)]].
	^answer asFmlValue]

{ #category : #functions }
FmlArray >> shiftLeft: positions fillWith: element atColumn: index [
	| shift |
	shift := positions asInteger.
	shift < 0 ifTrue: [^FmlUndefinedValue new].
	^index > (array size - shift)
		ifTrue: [element valueAt: index]
		ifFalse: [array at: index + shift]]

{ #category : #functions }
FmlArray >> shiftLeftFillWith: element positions: positions [
	^self shiftLeft: positions fillWith: element]

{ #category : #functions }
FmlArray >> shiftLeftFillWith: element positions: positions atColumn: index [
	^self shiftLeft: positions fillWith: element atColumn: index]

{ #category : #functions }
FmlArray >> shiftRight: first [
	^self shiftRight: 1 fillWith: first]

{ #category : #functions }
FmlArray >> shiftRight: first atColumn: index [
	^self shiftRight: 1 fillWith: first atColumn: index]

{ #category : #functions }
FmlArray >> shiftRight: positions fillWith: element [
	| shift answer |
	positions isNumber
		ifFalse: [^self
			argument: 'positions'
			in: 'positionsRight'
			shouldBe: FmlNumber].
	positions value < 0 ifTrue: [^FmlUndefinedValue new].
	shift := positions asInteger min: self size.
	answer := Array streamContents: [:strm | 
		1 to: shift do: [:i | strm nextPut: (element valueAt: i)].
		array from: 1 to: self size - shift do: [:e | strm nextPut: e]].
	^answer asFmlValue]

{ #category : #functions }
FmlArray >> shiftRight: positions fillWith: element atColumn: index [
	| shift |
	shift := positions asInteger.
	shift < 0 ifTrue: [^FmlUndefinedValue new].
	^index <= shift
		ifTrue: [element valueAt: index]
		ifFalse: [array at: index - shift]]

{ #category : #functions }
FmlArray >> shiftRightFillWith: element positions: positions [
	^self shiftRight: positions fillWith: element]

{ #category : #functions }
FmlArray >> shiftRightFillWith: element positions: positions atColumn: index [
	^self shiftRight: positions fillWith: element atColumn: index]

{ #category : #arithmetic }
FmlArray >> sign [
	^self performArrayOperation: #sign]

{ #category : #accessing }
FmlArray >> size [
	^array size]

{ #category : #functions }
FmlArray >> sl: life [
	| answer size cost n |
	life isNumber
		ifFalse: [^self argument: 'life' in: 'sl' shouldBe: FmlNumber].
	life value > 0.0 ifFalse: [^self nonPositiveArgument: 'life' in: 'sl'].
	n := self periodsSize.
	answer := self zeroArray.
	size := life asInteger.
	1 to: n do: [:i | 
		cost := self valueAt: i.
		1
			to: size
			do: [:j | i + j <= n ifTrue: [answer at: i + j sum: cost / size]]].
	^answer asFmlValue]

{ #category : #arithmetic }
FmlArray >> sqrt [
	^self performArrayOperation: #sqrt]

{ #category : #arithmetic }
FmlArray >> squared [
	^self performArrayOperation: #squared]

{ #category : #arithmetic }
FmlArray >> squaredDifference: anArray [
	^(array with: anArray asArray collect: [:a :b | a squaredDifference: b]) asFmlValue]

{ #category : #testing }
FmlArray >> supportsLogicalOperations [
	^array conform: [:n | n resultType supportsLogicalOperations]]

{ #category : #functions }
FmlArray >> syd: period [
	| answer life cost sumOfYears n |
	period isNumber
		ifFalse: [^self argument: 'life' in: 'syd' shouldBe: FmlNumber].
	period value > 0.0 ifFalse: [^self nonPositiveArgument: 'life' in: 'syd'].
	n := self periodsSize.
	answer := self zeroArray.
	life := period asInteger.
	sumOfYears := life * (life + 1) / 2.
	1 to: n do: [:i | 
		cost := self valueAt: i.
		1 to: life do: [:j | | delta |
			delta := cost * (life - j + 1) / sumOfYears.
			i + j <= n ifTrue: [answer at: i + j sum: delta]]].
	^answer asFmlValue]

{ #category : #tables }
FmlArray >> tableLookupTable: t searchColumn: s returnColumn: r [
	| result |
	result := array asArray withIndexCollect: [:v :i | | si ri |
		si := s valueAt: i.
		ri := r valueAt: i.
		(v asFmlValue tableLookupTable: t searchColumn: si returnColumn: ri) value].
	(result conform: [:x | x isNumber or: [x isUndefinedValue]])
		ifTrue: [result := result asFloatArray].
	^result asFmlValue]

{ #category : #tables }
FmlArray >> tableRollupTable: fmlTable searchColumn: searchColumn factorColumn: factorColumn [
	| s f answer |
	s := searchColumn value asInteger.
	f := factorColumn value asInteger.
	answer := array
		collect: [:value | fmlTable
			basicTableRollup: value
			searchColumn: s
			factorColumn: f].
	^answer asFmlValue]

{ #category : #translation }
FmlArray >> translateUsing: anFmlTranslator [
	^anFmlTranslator translateArray: self value]

{ #category : #arithmetic }
FmlArray >> truncated [
	^self performArrayOperation: #truncated]

{ #category : #accessing }
FmlArray >> value [
	^array]

{ #category : #accessing }
FmlArray >> value: anObject [
	array := anObject]

{ #category : #accessing }
FmlArray >> valueAt: index [
	^array at: index ifAbsent: [FmlUndefinedValue new]]

{ #category : #accessing }
FmlArray >> valueAt: index put: anObject [
	^array at: index put: anObject; markDirty]

{ #category : #accessing }
FmlArray >> valueAtIndex: anFmlValue [
	"
	Double dispatching
	"
	^anFmlValue
		inverseAt: self
"
	'valueAtIndex(#(1 2 3 4), #(4 3 2 1))' asFmlValue translateExpressionUsing: FmlExcelTranslator new
	'valueAtIndex(#(1 2 3 4), 3)' asFmlValue translateExpressionUsing: FmlExcelTranslator new
"]

{ #category : #accessing }
FmlArray >> valueAtIndex: anFmlValue atColumn: index [
	| idx |
	idx := (anFmlValue valueAt: index) asInteger.
	idx < 1 ifTrue: [^0].
	^self valueAt: idx]

{ #category : #copying }
FmlArray >> valueFrom: startIndex to: stopIndex [
	^array copyFrom: startIndex to: stopIndex]

{ #category : #enumerating }
FmlArray >> with: anFmlValue do: aBlock [
	"
	#(1 1 1 ) asFmlValue
		with: 1 asFmlValue
		do: [:receiver :arg | receiver = arg ifFalse: [self halt]]
	"
	| n |
	n := self size max: anFmlValue size.
	1 to: n do: [:i | | xi yi |
		xi := self valueAt: i.
		yi := anFmlValue valueAt: i.
		aBlock value: xi value: yi]]

{ #category : #enumerating }
FmlArray >> withIndexCollect: aBlock [
	| answer size |
	size := array size.
	answer := Array new: size.
	1
		to: size
		do: [:index | answer
			at: index
			put: (aBlock value: (array at: index) value: index)].
	^answer asFmlValue]

{ #category : #functions }
FmlArray >> xIRR [
	^self irr asFmlValue]

{ #category : #functions }
FmlArray >> xIRR: dates [
	| irr |
	dates isFmlArray
		ifFalse: [^self argument: 'dates' in: 'xIRR' shouldBeArrayOf: FmlDate].
	irr := self irr: dates.
	^irr asFmlValue]

{ #category : #functions }
FmlArray >> xIRR: dates startDate: startDate endDate: endDate [
	| fmlDates irr |
	fmlDates := dates asFmlValue.
	(fmlDates isArrayValued and: [fmlDates hasDates])
		ifFalse: [^self argument: 'dates' in: 'xIRRLimit' shouldBeArrayOf: FmlDate].
	startDate isDate
		ifFalse: [^self argument: 'startDate' in: 'xIRRLimit' shouldBe: FmlDate].
	endDate isDate
		ifFalse: [^self argument: 'endDate' in: 'xIRRLimit' shouldBe: FmlDate].
	irr := self
		irr: fmlDates value
		startDate: startDate value
		endDate: endDate value.
	^irr asFmlValue]

{ #category : #functions }
FmlArray >> xNPVRate: rate dates: dateArray [
	^self runningNPV: array rate: rate dates: dateArray]

{ #category : #functions }
FmlArray >> xNPVRate: rate
dates: dateArray
startDate: startDate
endDate: enddate [
	^self
		runningNPV: array
		rate: rate
		dates: dateArray
		startDate: startDate
		endDate: enddate]

{ #category : #'date functions' }
FmlArray >> year [
	^self hasDates
		ifTrue: [(array collect: [:each | each year]) asFmlValue]
		ifFalse: [self argumentIn: #year shouldBe: FmlDate]]

{ #category : #functions }
FmlArray >> yearlyIRR [
	| irr |
	irr := FloatArray new: self size.
	array withIndexDo: [:ai :i | | v |
		(i = 1 orNot: [ai ~ 0.0]) ifTrue: [
			v := self irrTail: i.
			irr at: i put: v]].
	^irr asFmlValue]

{ #category : #functions }
FmlArray >> yearlyIRRAtColumn: index [
	^index = 1 ifTrue: [Float nan] ifFalse: [self irrTail: index]]

{ #category : #services }
FmlArray >> zero [
	| zero |
	zero := array class new: self size withAll: 0.0.
	^zero asFmlValue]

