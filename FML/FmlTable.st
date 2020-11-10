"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlTable,
	#superclass : #FmlValue,
	#instVars : [
		'table'
	],
	#category : #FML
}

{ #category : #'result type' }
FmlTable class >> * aResultType [
	"Tables does not decide the distribution of the
	index (see FunctionRecord >> #distributesIndex),
	that's why this result type acts as a FmlNumber."

	^FmlUndefinedValue]

{ #category : #testing }
FmlTable class >> isSingleValued [
	^false]

{ #category : #testing }
FmlTable class >> isTableValued [
	^true]

{ #category : #constants }
FmlTable class >> typeName [
	^'Table']

{ #category : #'string functions' }
FmlTable >> asLowercase [
	^self cannotEvaluate: #asLowercase]

{ #category : #'string functions' }
FmlTable >> asUppercase [
	^self cannotEvaluate: #asUppercase]

{ #category : #accessing }
FmlTable >> at: aPoint [
	^(table at: aPoint ifAbsent: nil) asFmlValue]

{ #category : #functions }
FmlTable >> atRow: row column: column [
	^(table atRow: row column: column) asFmlValue]

{ #category : #functions }
FmlTable >> basicInterpolate: value
searchColumn: searchIndex
returnColumn: returnIndex
extrapolate: aBoolean [
	| f dic |
	dic := table propertyAt: #interpolators ifAbsentPut: [Dictionary new].
	f := dic
		at: searchIndex @ returnIndex
		ifAbsentPut: [self buildInterpolator: searchIndex @ returnIndex].
	f class = LinearInterpolatedFunction ifFalse: [^f].
	^value interpolateUsing: f extrapolate: aBoolean]

{ #category : #functions }
FmlTable >> basicTableRollup: value searchColumn: s factorColumn: f [
	| element answer prev factor |
	element := table atRow: 1 column: s.
	answer := 0.0.
	value <= element ifTrue: [^answer].
	2 to: table numRows do: [:row | 
		element := table atRow: row column: s.
		prev := table atRow: row - 1 column: s.
		factor := table atRow: row - 1 column: f.
		value < element ifTrue: [^answer + (value - prev * factor)].
		answer := answer + (element - prev * factor)].
	^answer + (value - element * (table atRow: table numRows column: f))]

{ #category : #functions }
FmlTable >> buildInterpolator: aPoint [
	| s increasing r |
	s := table column: aPoint x.
	(s conform: #isMagnitude) ifFalse: [^FmlUndefinedValue new].
	increasing := s isIncreasing.
	(increasing or: [s isDecreasing]) ifFalse: [
		^FmlEvaluationError
			signal: 'Elements in <searchColumn> should be in increasing or decreasing order'].
	r := table column: aPoint y.
	(r conform: #isMagnitude) ifFalse: [^FmlUndefinedValue new].
	increasing ifFalse: [
		s := s reversed.
		r := r reversed].
	^LinearInterpolatedFunction abscissas: s ordinates: r]

{ #category : #testing }
FmlTable >> canBeSorted [
	^self isNumeric or: [self isDate] or: [self isString]]

{ #category : #'string functions' }
FmlTable >> capitalized [
	^self cannotEvaluate: #capitalized]

{ #category : #accessing }
FmlTable >> columnFrom: fml arg: arg function: f [
	| c |
	c := fml asFmlValue columnIndexInTable: self.
	^c ifNil: [self invalidColumnName: arg in: f]]

{ #category : #accessing }
FmlTable >> columnSpecs [
	^table propertyAt: #columns]

{ #category : #functions }
FmlTable >> cum [
	^self cannotEvaluate: 'cum']

{ #category : #'string functions' }
FmlTable >> includesString: aString [
	^self cannotEvaluate: #includesString]

{ #category : #functions }
FmlTable >> index: row col: column [
	| c |
	row isTableValued
		ifTrue: [^self argument: 'row' in: 'index' shouldNotBe: FmlTable].
	c := self columnFrom: column arg: 'column' function: 'index'.
	^row value asFmlValue atColumn: c asFmlValue inTable: self]

{ #category : #functions }
FmlTable >> interpolate: value searchColumn: search returnColumn: return [
	^self
		interpolate: value
		searchColumn: search
		returnColumn: return
		extrapolate: false]

{ #category : #functions }
FmlTable >> interpolate: value
searchColumn: search
returnColumn: return
extrapolate: aBoolean [
	| e |
	value isSummable
		ifFalse: [^self
			argument: 'value'
			in: 'interpolate'
			shouldNotBe: value class].
	(e := aBoolean value) isBoolean
		ifFalse: [^self
			argument: 'extrapolate'
			in: 'interpolate'
			shouldBe: FmlBoolean].
	^search value asFmlValue
		interpolate: value
		on: self
		returnColumn: return
		extrapolate: e]

{ #category : #functions }
FmlTable >> interpolate2D: x Y: y [
	| abscissas ordinates matrix lookup a b interpolator max |
	table isNumeric ifFalse: [^self table: 'table' shouldBe: FmlNumber].
	table numRows > 2
		ifFalse: [^FmlEvaluationError
			signal: 'Argument ''table'' should have at least 3 rows'].
	(x isNumber or: [x isArrayValued and: [x isNumeric]])
		ifFalse: [^self argument: 'x' in: 'interpolate2D' shouldBe: FmlNumber].
	(y isNumber or: [y isArrayValued and: [y isNumeric]])
		ifFalse: [^self argument: 'y' in: 'interpolate2D' shouldBe: FmlNumber].
	abscissas := (table row: 1) allButFirst collect: [:v | v asFloat].
	abscissas isIncreasing ifFalse: [
		^FmlEvaluationError
			signal: 'The first row of argument "table" should be increasing'].
	ordinates := (table column: 1) allButFirst collect: [:v | v asFloat].
	ordinates isIncreasing ifFalse: [
		^FmlEvaluationError
			signal: 'The first column of argument "table" should be increasing'].
	matrix := FloatMatrix
		fromBlock: [:i :j | table atRow: i + 1 column: j + 1]
		numRows: table numRows - 1
		columns: table numColumns - 1.
	a := x value.
	b := y value.
	interpolator := BidimensionalLookup new
		abscissas: abscissas;
		ordinates: ordinates;
		values: matrix.
	max := abscissas first @ ordinates first.
	lookup := (a isNumber and: [b isNumber])
		ifTrue: [interpolator valueAt: (a @ b max: max)]
		ifFalse: [
			a isNumber
				ifTrue: [
					b withIndexCollect: [:yi :i | | xi |
						xi := x valueAt: i.
						interpolator valueAt: (xi value @ yi value max: max)]]
				ifFalse: [
					a withIndexCollect: [:xi :i | | yi |
						yi := y valueAt: i.
						interpolator valueAt: (xi value @ yi value max: max)]]].
	^lookup asFmlValue]

{ #category : #functions }
FmlTable >> interpolatorAt: aPoint [
	| dic |
	dic := table propertyAt: #interpolators ifAbsentPut: [Dictionary new].
	^dic at: aPoint ifAbsentPut: [self buildInterpolator: aPoint]]

{ #category : #testing }
FmlTable >> isDate [
	^table conform: [:v | v isUndefinedValue or: [v isDate]]]

{ #category : #testing }
FmlTable >> isNumeric [
	^table conform: [:v | v isUndefinedValue or: [v isNumber]]]

{ #category : #testing }
FmlTable >> isString [
	^table conform: [:v | v isUndefinedValue or: [v isString]]]

{ #category : #comparing }
FmlTable >> max: anFmlValue [
	^self invalidOperation: #max]

{ #category : #'array compatibility' }
FmlTable >> maxValue [
	self canBeSorted
		ifFalse: [^FmlEvaluationError
			signal: 'Table values have not a defined maximum'].
	^table max]

{ #category : #comparing }
FmlTable >> min: anFmlValue [
	^self invalidOperation: #min]

{ #category : #'array compatibility' }
FmlTable >> minValue [
	self canBeSorted
		ifFalse: [^FmlEvaluationError
			signal: 'Table values have not a defined minimum'].
	^table min]

{ #category : #functions }
FmlTable >> newArray [
	^self cannotEvaluate: 'newArray']

{ #category : #accessing }
FmlTable >> numColumns [
	^table numColumns]

{ #category : #perform }
FmlTable >> performOperation: aSymbol receiverValue: anObject [
	^self cannotEvaluate: aSymbol]

{ #category : #accessing }
FmlTable >> table [
	^table]

{ #category : #functions }
FmlTable >> tableLookup: variable searchColumn: searchColumn returnColumn: returnColumn [
	| s r |
	searchColumn isUndefinedValue ifTrue: [^FmlUndefinedValue new].
	s := self
		columnFrom: searchColumn
		arg: 'searchColumn'
		function: 'tableLookup'.
	s isNumber
		ifFalse: [^self argument: 'searchColumn' in: 'vLookup' shouldBe: FmlNumber].
	(s between: 1 and: table numColumns) ifFalse: [
		self
			argument: 'searchColumn'
			in: 'tableLookup'
			notBetween: 1
			and: table numColumns.
		^FmlUndefinedValue new].
	returnColumn isUndefinedValue ifTrue: [^FmlUndefinedValue new].
	r := self
		columnFrom: returnColumn
		arg: 'returnColumn'
		function: 'tableLookup'.
	r isNumber
		ifFalse: [^self argument: 'returnColumn' in: 'vLookup' shouldBe: FmlNumber].
	(r between: 1 and: table numColumns) ifFalse: [
		self
			argument: 'returnColumn'
			in: 'tableLookup'
			notBetween: 1
			and: table numColumns.
		^FmlUndefinedValue new].
	^variable tableLookupTable: self searchColumn: s returnColumn: r]

{ #category : #functions }
FmlTable >> tableRollup: value searchColumn: searchColumn factorColumn: factorColumn [
	| s f |
	s := self
		columnFrom: searchColumn
		arg: 'searchColumn'
		function: 'tableRollup'.
	s isNumber
		ifFalse: [^self
			argument: 'searchColumn'
			in: 'tableRollup'
			shouldBe: FmlNumber].
	(s between: 1 and: table numColumns) ifFalse: [
		self
			argument: 'searchColumn'
			in: 'tableRollup'
			notBetween: 1
			and: table numColumns.
		^FmlUndefinedValue new].
	f := self
		columnFrom: factorColumn
		arg: 'factorColumn'
		function: 'tableRollup'.
	f isNumber
		ifFalse: [^self
			argument: 'factorColumn'
			in: 'tableRollup'
			shouldBe: FmlNumber].
	(f between: 1 and: table numColumns) ifFalse: [
		self
			argument: 'factorColumn'
			in: 'tableRollup'
			notBetween: 1
			and: table numColumns.
		^FmlUndefinedValue new].
	value isNumeric
		ifFalse: [^self argument: 'value' in: 'tableRollup' shouldBe: FmlNumber].
	s := s asInteger.
	f := f asInteger.
	(table isNumericColumn: s)
		ifFalse: [^InvalidArgumentType
			signal: 'Elements in searchColumn should be Numbers'].
	(table column: s) isIncreasing ifFalse: [
		^FmlEvaluationError
			signal: 'Elements in searchColumn should be in increasing order'].
	(table isNumericColumn: f)
		ifFalse: [^InvalidArgumentType
			signal: 'Elements in factorColumn should be Numbers'].
	^value tableRollupTable: self searchColumn: s factorColumn: f]

{ #category : #accessing }
FmlTable >> value [
	^table]

{ #category : #accessing }
FmlTable >> value: aFlatMatrix [
	aFlatMatrix removeProperty: #interpolators ifAbsent: [].
	table := aFlatMatrix]

{ #category : #'array compatibility' }
FmlTable >> valueAtIndex: aFmlValue [
	^self cannotEvaluate: 'valueAtIndex']

{ #category : #functions }
FmlTable >> vLookup: value returnColumn: index [
	| r |
	index isUndefinedValue ifTrue: [^FmlUndefinedValue new].
	r := self columnFrom: index arg: 'returnColumn' function: 'vLookup'.
	r isNumeric
		ifFalse: [^self argument: 'returnColumn' in: 'vLookup' shouldBe: FmlNumber].
	^value vLookupTable: self returnColumn: r]

