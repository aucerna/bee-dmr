"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlVariableName,
	#superclass : #FmlExpression,
	#instVars : [
		'levels',
		'variable'
	],
	#classVars : [
		'Separator'
	],
	#category : #FML
}

{ #category : #services }
FmlVariableName class >> commonPrefixOf: aCollection [
	| names levels index |
	aCollection isEmptyOrNil ifTrue: [^''].
	aCollection size = 1
		ifTrue: [^aCollection anyone variableName allButLast fullName].
	names := aCollection collect: [:each | each variableName].
	levels := names maxValue: #levelsSize.
	index := 1.
	[| level |
		level := names anyone levelAt: index.
		index < levels and: [
			names conform: [:n | | s |
				s := n levelAt: index.
				s isNil or: [s = level]]]]
		whileTrue: [index := index + 1].
	^names anyone stringFromLevel: 1 to: index - 1]

{ #category : #services }
FmlVariableName class >> disambiguatedNames: aCollection [
	| names short |
	names := aCollection collect: [:each | each variableName lastName].
	names asSet size = names size ifTrue: [^names].
	names := aCollection.
	[
		(names conform: [:sc | (sc occurrencesOf: $:) > 0]) and: [
			short := names
				collect: [:string | string variableName stringFromLevel: 2].
			short asSet size = short size]]
		whileTrue: [names := short].
	^names]

{ #category : #'instance creation' }
FmlVariableName class >> forVariable: variable [
	^self new forVariable: variable]

{ #category : #'instance creation' }
FmlVariableName class >> fromString: aString [
	^self new fromString: aString]

{ #category : #'instance creation' }
FmlVariableName class >> fromStringCollection: stringCollection [
	^self new fromStringCollection: stringCollection]

{ #category : #initialization }
FmlVariableName class >> initialize [
	"
	FmlVariableName initialize
	"
	super initialize.
	Separator := $:]

{ #category : #constants }
FmlVariableName class >> separator [
	^Separator]

{ #category : #constants }
FmlVariableName class >> typeName [
	^'Variable']

{ #category : #accessing }
FmlVariableName >> , anFmlVariableName [
	^self class new levels: levels , anFmlVariableName levels]

{ #category : #comparing }
FmlVariableName >> < anFmlVariableName [
	^self <= anFmlVariableName andNot: [self = anFmlVariableName]]

{ #category : #comparing }
FmlVariableName >> <= anFmlVariableName [
	| min |
	self = anFmlVariableName ifTrue: [^true].
	min := levels size min: anFmlVariableName levelsSize.
	1 to: min do: [:i | | si ti |
		si := self stringAndIndexAt: i.
		ti := anFmlVariableName stringAndIndexAt: i.
		si first < ti first ifTrue: [^true].
		ti first < si first ifTrue: [^false].
		si second < ti second ifTrue: [^true].
		ti second < si second ifTrue: [^false]].
	^levels size <= anFmlVariableName levelsSize]

{ #category : #comparing }
FmlVariableName >> = anFmlVariableName [
	^self class == anFmlVariableName class
		and: [levels = anFmlVariableName levels]]

{ #category : #visiting }
FmlVariableName >> acceptVisitor: fmlVisitor [
	fmlVisitor visitVariableName: self]

{ #category : #'adding - nonRecursive' }
FmlVariableName >> addLevel: aString [
	levels := levels copyWith: aString]

{ #category : #validation }
FmlVariableName >> addMagicConstantsTo: aCollection [
	"
	do nothing
	"
	]

{ #category : #'adding - nonRecursive' }
FmlVariableName >> addNeededVariablesTo: aCollection [
	variable isVariable ifTrue: [
		(aCollection includes: variable) ifFalse: [
			aCollection add: variable.
			variable addNeededVariablesTo: aCollection]]]

{ #category : #services }
FmlVariableName >> allButFirst [
	^self allButFirst: 1]

{ #category : #services }
FmlVariableName >> allButFirst: n [
	^self copy removeLevelsFrom: 1 to: n]

{ #category : #services }
FmlVariableName >> allButLast [
	^self allButLast: 1]

{ #category : #services }
FmlVariableName >> allButLast: n [
	^self copy removeLevelsFrom: levels size - n + 1 to: levels size]

{ #category : #inquiries }
FmlVariableName >> allReferencesIn: model [
	| name variables unresolved |
	name := self fullName.
	variables := model allVariables.
	unresolved := model hasUnresolvedReferencesModule
		ifTrue: [model unresolvedReferencesModule allVariables]
		ifFalse: [#()].
	^variables & unresolved
		select: [:v | v referencedVariableNames
			anySatisfy: [:vn | vn includesString: name]]]

{ #category : #copying }
FmlVariableName >> asResolved [
	^self allButFirst]

{ #category : #functions }
FmlVariableName >> averageDistribution: n at: x [
	| normal arithmetic |
	(n isNumeric and: [n isSingleValued])
		ifFalse: [^self
			argument: 'order'
			in: 'averageDistribution'
			shouldBe: FmlNumber].
	n value asInteger > 0
		ifFalse: [^self nonPositiveArgument: 'order' in: 'averageDistribution'].
	x isNumeric
		ifFalse: [^self
			argument: 'value'
			in: 'averageDistribution'
			shouldBe: FmlNumber].
	variable isVariable ifFalse: [^FmlUndefinedValue new].
	normal := variable activeDistribution.
	normal isNil ifTrue: [^FmlUndefinedValue new].
	normal isNormal ifFalse: [^FmlUndefinedValue new].
	arithmetic := normal arithmeticMean: n value asInteger.
	arithmetic isNil ifTrue: [^FmlUndefinedValue new].
	^x distributionFor: arithmetic]

{ #category : #testing }
FmlVariableName >> beginsWith: aString [
	| varname |
	varname := aString variableName.
	levels size < varname levelsSize ifTrue: [^false].
	1
		to: varname levelsSize
		do: [:i | (self levelAt: i) = (varname levelAt: i) ifFalse: [^false]].
	^true]

{ #category : #testing }
FmlVariableName >> beginsWithPrefix: aString [
	| varname n |
	varname := aString variableName.
	n := varname levelsSize.
	levels size < n ifTrue: [^false].
	1
		to: n - 1
		do: [:i | (self levelAt: i) = (varname levelAt: i) ifFalse: [^false]].
	^(self levelAt: n) beginsWith: (varname levelAt: n)]

{ #category : #accessing }
FmlVariableName >> bindContext [
	self bindContext: ContextRequest signal]

{ #category : #evaluation }
FmlVariableName >> bindContext: aModelObject [
	self resolveVariableIn: aModelObject]

{ #category : #accessing }
FmlVariableName >> binding [
	^variable]

{ #category : #accessing }
FmlVariableName >> binding: anObject [
	variable := anObject]

{ #category : #testing }
FmlVariableName >> canReferToVariable [
	^true]

{ #category : #'file in/out' }
FmlVariableName >> clearSurrogate [
	variable := nil.
	levels := self fullName]

{ #category : #inquiries }
FmlVariableName >> complexityOn: d [
	variable isNil ifTrue: [^1].
	^(variable hasFunction
		ifTrue: [
			(d includes: variable calcFunction) ifTrue: [1] ifFalse: [
				d add: variable calcFunction.
				variable complexityOn: d]]
		ifFalse: [0]) + 1]

{ #category : #functions }
FmlVariableName >> deviation [
	| distribution |
	variable isVariable ifFalse: [^FmlUndefinedValue new].
	distribution := variable activeDistribution.
	distribution isNil ifTrue: [^FmlUndefinedValue new].
	^distribution sd asFmlValue]

{ #category : #functions }
FmlVariableName >> distributionAt: x [
	| distribution u class |
	variable isVariable ifFalse: [^FmlUndefinedValue new].
	u := variable unit.
	(u isNumeric or: [u isDateUnit])
		ifFalse: [^self cannotOperate: 'distribution' on: u type].
	class := variable unit isNumeric ifTrue: [FmlNumber] ifFalse: [FmlDate].
	x isNumeric = u isNumeric
		ifFalse: [^self argument: 'value' in: 'distribution' shouldBe: class].
	distribution := variable activeDistribution.
	distribution isNil ifTrue: [^FmlUndefinedValue new].
	^x distributionFor: distribution]

{ #category : #services }
FmlVariableName >> editDistanceTo: aString cache: aDictionary [
	^aString variableName levels
		sum: [:s | self simpleEditDistanceTo: s asLowercase cache: aDictionary]]

{ #category : #testing }
FmlVariableName >> endsWith: aString [
	| varname n m |
	varname := aString variableName.
	n := levels size.
	m := varname levelsSize.
	n < m ifTrue: [^false].
	m to: 1 by: -1 do: [:i | 
		(self levelAt: n) = (varname levelAt: i) ifFalse: [^false].
		n := n - 1].
	^true]

{ #category : #comparing }
FmlVariableName >> equals: anFmlVariableName upToLevel: anInteger [
	| i |
	(anInteger <= levels size and: [anInteger <= anFmlVariableName levelsSize])
		ifFalse: [^false].
	i := 0.
	anFmlVariableName levelsDo: [:s | 
		i := i + 1.
		i > anInteger ifTrue: [^true].
		(self levelAt: i) = s ifFalse: [^false]].
	^true]

{ #category : #comparing }
FmlVariableName >> equalsCaseInsensitive: anFmlVariableName [
	| i |
	levels size = anFmlVariableName levelsSize ifFalse: [^false].
	i := 0.
	anFmlVariableName levelsDo: [:level | 
		i := i + 1.
		((self levelAt: i) equalsCaseInsensitive: level) ifFalse: [^false]].
	^true]

{ #category : #evaluation }
FmlVariableName >> evaluateAt: index [
	variable isNil ifTrue: [^nil].
	variable isUndefinedValue ifTrue: [self signalInactiveVariable].
	^self isTableValued
		ifTrue: [variable value]
		ifFalse: [variable valueAt: index]]

{ #category : #evaluation }
FmlVariableName >> evaluateLiterals [
	^(variable notNil andNot: [variable isVariable])
		ifTrue: [variable asFmlValue]
		ifFalse: [self]]

{ #category : #evaluation }
FmlVariableName >> evaluateWith: anFmlEvaluator [
	| value |
	value := variable isVariable
		ifTrue: [anFmlEvaluator evaluateVariable: variable]
		ifFalse: [
			(variable notNil and: [variable isUndefinedValue])
				ifTrue: [self signalInactiveVariable].
			variable].
	^value asFmlValue]

{ #category : #inquiries }
FmlVariableName >> exactReferencesIn: module [
	^module functionsUsingVariableName: self]

{ #category : #'file in/out' }
FmlVariableName >> fileInActivate [
	levels isString ifTrue: [self fromString: levels]]

{ #category : #inquiries }
FmlVariableName >> firstName [
	^levels notEmpty ifTrue: [levels first]]

{ #category : #accessing }
FmlVariableName >> forVariable: aVariable [
	aVariable isVariable ifTrue: [self fromString: aVariable modelName].
	variable := aVariable]

{ #category : #initialization }
FmlVariableName >> fromStream: aStream [
	| quote level |
	levels := Array streamContents: [:strm | 
		quote := aStream peekFor: $".
		[aStream atEnd] whileFalse: [
			aStream skipSeparators.
			level := aStream upTo: Separator.
			level notEmpty ifTrue: [
				(quote and: [aStream atEnd]) ifTrue: [level := level allButLast].
				strm nextPut: level]]]]

{ #category : #accessing }
FmlVariableName >> fromString: aString [
	| s |
	s := aString.
	(s notEmpty and: [s first = $"]) ifTrue: [s := s copyFrom: 2 to: s size - 1].
	levels := (Separator split: s)
		collect: [:level | level trimBlanks]
		thenSelect: [:level | level notEmpty]]

{ #category : #private }
FmlVariableName >> fromStringCollection: aCollection [
	levels := aCollection asArray collect: #trimBlanks]

{ #category : #inquiries }
FmlVariableName >> fullName [
	^levels isEmpty ifTrue: [''] ifFalse: [self stringFromLevel: 1]]

{ #category : #printing }
FmlVariableName >> fullNameLines [
	^String streamContents: [:strm | 
		levels
			do: [:level | strm nextPutAll: level]
			separatedBy: [strm nextPut: Separator; cr]]]

{ #category : #functions }
FmlVariableName >> geometricMeanDistribution: n at: x [
	| ln geometric |
	(n isNumeric and: [n isSingleValued])
		ifFalse: [^self
			argument: 'order'
			in: 'geometricMeanDistribution'
			shouldBe: FmlNumber].
	n value asInteger > 0
		ifFalse: [^self
			nonPositiveArgument: 'order'
			in: 'geometricMeanDistribution'].
	x isNumeric
		ifFalse: [^self
			argument: 'value'
			in: 'geometricMeanDistribution'
			shouldBe: FmlNumber].
	variable isVariable ifFalse: [^FmlUndefinedValue new].
	ln := variable activeDistribution.
	ln isNil ifTrue: [^FmlUndefinedValue new].
	ln isLogNormal ifFalse: [^FmlUndefinedValue new].
	geometric := ln geometricMean: n value asInteger.
	geometric isNil ifTrue: [^FmlUndefinedValue new].
	^x distributionFor: geometric]

{ #category : #comparing }
FmlVariableName >> hash [
	| hash |
	hash := levels size.
	1
		to: hash
		do: [:i | hash := (hash hashMultiply: 16r19660D) bitXor: (levels at: i) hash].
	^hash]

{ #category : #testing }
FmlVariableName >> hasReferencesIn: model [
	^model referencesVariableNamed: self]

{ #category : #testing }
FmlVariableName >> includesLevel: aString [
	^levels includes: aString]

{ #category : #testing }
FmlVariableName >> includesLevelsOf: anFmlVariableName [
	| i |
	i := 1.
	anFmlVariableName variableName levels do: [:level | 
		i := levels indexOf: level startingAt: i ifAbsent: [^false].
		i := i + 1].
	^true]

{ #category : #testing }
FmlVariableName >> includesString: aString [
	^self fullName includesString: aString]

{ #category : #inquiries }
FmlVariableName >> indexOf: anFmlVariableName [
	| index i |
	index := self indexOfLevel: anFmlVariableName firstName.
	index = 0 ifTrue: [^0].
	i := index + 1.
	2 to: anFmlVariableName levelsSize do: [:j | 
		(self levelAt: i) = (anFmlVariableName levelAt: j)
			ifTrue: [i := i + 1]
			ifFalse: [^0]].
	^index]

{ #category : #inquiries }
FmlVariableName >> indexOfLevel: aString [
	^levels findFirst: [:level | level = aString] ifAbsent: 0]

{ #category : #inquiries }
FmlVariableName >> inferredUnit [
	^variable isVariable ifTrue: [variable unit]]

{ #category : #initialization }
FmlVariableName >> initialize [
	levels := #()]

{ #category : #converting }
FmlVariableName >> inModuleDependentFormat: module [
	levels size = 1 ifTrue: [^self].
	((self beginsWith: module modelName)
		or: [self moduleName = module name and: [levels size = 2]])
		ifTrue: [module convertToLocalName: self]]

{ #category : #converting }
FmlVariableName >> inModuleIndependentFormat: aModule [
	aModule convertToFullName: self]

{ #category : #transforming }
FmlVariableName >> insert: aString at: index [
	levels := levels asOrderedCollection.
	levels add: aString beforeIndex: index.
	levels := levels asArray]

{ #category : #functions }
FmlVariableName >> inverseDistributionAt: p [
	| distribution u |
	variable isVariable ifFalse: [^FmlUndefinedValue new].
	(p isNumeric not or: [p isTableValued])
		ifTrue: [^self
			argument: 'probability'
			in: 'inverseDistribution'
			shouldBe: FmlNumber].
	u := p inferredUnit.
	(u notNil and: [u type ~= NumberUnit]) ifTrue: [
		self
			argument: 'probability'
			in: 'inverseDistribution'
			unitShouldBe: NumberUnit].
	distribution := variable activeDistribution.
	distribution isNil ifTrue: [^FmlUndefinedValue new].
	^p inverseDistributionFor: distribution]

{ #category : #testing }
FmlVariableName >> isArrayValued [
	^variable isArrayValued]

{ #category : #testing }
FmlVariableName >> isConstant [
	^variable isVariable not or: [variable isConstant]]

{ #category : #testing }
FmlVariableName >> isIncreasing [
	^variable notNil and: [variable isIncreasing]]

{ #category : #testing }
FmlVariableName >> isLeafNode [
	^true]

{ #category : #testing }
FmlVariableName >> isTableValued [
	^variable isTableValued]

{ #category : #testing }
FmlVariableName >> isVariableName [
	^true]

{ #category : #inquiries }
FmlVariableName >> lastName [
	^levels notEmpty ifTrue: [levels last]]

{ #category : #accessing }
FmlVariableName >> lastName: aString [
	self levelAt: levels size put: aString trimBlanks]

{ #category : #evaluation }
FmlVariableName >> lazyEvaluate [
	| value |
	^(variable isVariable not or: [variable wasCalculated])
		ifTrue: [
			value := variable isArrayValued
				ifTrue: [variable fullValue]
				ifFalse: [variable value].
			value asFmlValue]
		ifFalse: [super lazyEvaluate]]

{ #category : #accessing }
FmlVariableName >> levelAt: index [
	^levels at: index ifAbsent: nil]

{ #category : #accessing }
FmlVariableName >> levelAt: index ifAbsent: aBlock [
	^levels at: index ifAbsent: aBlock]

{ #category : #accessing }
FmlVariableName >> levelAt: index put: aString [
	levels at: index put: aString; markDirty]

{ #category : #accessing }
FmlVariableName >> levels [
	^levels]

{ #category : #accessing }
FmlVariableName >> levels: aCollection [
	levels := aCollection]

{ #category : #enumerating }
FmlVariableName >> levelsDo: aBlock [
	levels do: aBlock]

{ #category : #accessing }
FmlVariableName >> levelsSize [
	^levels size]

{ #category : #functions }
FmlVariableName >> mean [
	| distribution |
	variable isVariable ifFalse: [^FmlUndefinedValue new].
	distribution := variable activeDistribution.
	distribution isNil ifTrue: [^FmlUndefinedValue new].
	^distribution mean asFmlValue]

{ #category : #accessing }
FmlVariableName >> modelName [
	^self fullName]

{ #category : #converting }
FmlVariableName >> moduleIndependentFormat [
	^self copy inModuleIndependentFormat]

{ #category : #accessing }
FmlVariableName >> moduleName [
	^levels size > 1 ifTrue: [levels first]]

{ #category : #inquiries }
FmlVariableName >> namesakesIn: model [
	| variables name |
	variables := model allReachableVariables.
	model hasUnresolvedReferencesModule
		ifTrue: [variables addAll: model unresolvedReferencesModule allVariables].
	name := self lastName.
	^(variables select: [:v | v name = name]) asOrderedCollection
		sortBy: #modelName]

{ #category : #inquiries }
FmlVariableName >> neededVariablesDo: aBlock visited: aCollection [
	(variable isVariable andNot: [variable isRemoved])
		ifTrue: [variable withNeededVariablesDo: aBlock visited: aCollection]]

{ #category : #copying }
FmlVariableName >> postCopy [
	levels := levels copy]

{ #category : #printing }
FmlVariableName >> printShortOn: aStream [
	| short |
	short := self lastName.
	short notNil
		ifTrue: [
			aStream
				nextPut: $";
				nextPutAll: short;
				nextPut: $"]
		ifFalse: [self printOn: aStream]]

{ #category : #inquiries }
FmlVariableName >> referencesIn: model [
	^(model functionsUsingVarNamed: self) asOrderedCollection sortBy: #modelName]

{ #category : #services }
FmlVariableName >> reject: substrings [
	| strings |
	strings := OrderedCollection new.
	self levelsDo: [:level | 
		substrings
			detect: [:s | level equalsCaseInsensitive: s]
			ifNone: [strings add: level]].
	strings isEmpty ifFalse: [strings at: 1 put: strings first].
	^self class fromStringCollection: strings]

{ #category : #accessing }
FmlVariableName >> removeLevel: anInteger [
	self removeLevelsFrom: anInteger to: anInteger]

{ #category : #accessing }
FmlVariableName >> removeLevelsFrom: anInteger to: anotherInteger [
	| head tail |
	head := levels copyFrom: 1 to: anInteger - 1.
	tail := levels copyFrom: anotherInteger + 1 to: levels size.
	levels := head , tail]

{ #category : #renaming }
FmlVariableName >> renameAfterModel: aModelSpec with: aString [
	| varname index last postfix |
	varname := aModelSpec modelName variableName.
	index := levels indexOfSubcollection: varname allButLast levels.
	index > 0 ifFalse: [^self].
	index := index + varname levelsSize - 1.
	last := self levelAt: index.
	postfix := last allButFirst: varname lastName size.
	self levelAt: index put: aString , postfix]

{ #category : #renaming }
FmlVariableName >> renameLevel: index from: aString to: anotherString [
	self ASSERT: (self levelAt: index) = aString.
	self levelAt: index put: anotherString]

{ #category : #renaming }
FmlVariableName >> renameLevel: aString to: anotherString [
	| index |
	index := self indexOfLevel: aString.
	index > 0 ifTrue: [self levelAt: index put: anotherString]]

{ #category : #renaming }
FmlVariableName >> renamePrefix: anFmlVariableName with: aString [
	| index |
	index := self indexOf: anFmlVariableName.
	index = 0 ifTrue: [^self].
	self levelAt: index + anFmlVariableName levelsSize - 1 put: aString]

{ #category : #renaming }
FmlVariableName >> renameTo: anFmlVariableName [
	levels := anFmlVariableName levels.
	variable := anFmlVariableName variable]

{ #category : #renaming }
FmlVariableName >> renameVariableName: aFmlVariableName with: aString [
	| index |
	index := levels indexOfSubcollection: aFmlVariableName levels.
	index > 0 ifFalse: [^self].
	index := index + aFmlVariableName levelsSize - 1.
	self levelAt: index put: aString]

{ #category : #renaming }
FmlVariableName >> replace: aString with: anotherString [
	| old index head tail |
	old := aString variableName.
	index := levels indexOfSubcollection: old levels.
	index = 0 ifTrue: [^self].
	head := levels copyFrom: 1 to: index - 1.
	tail := levels copyFrom: index + old levelsSize to: levels size.
	levels := head , anotherString variableName levels , tail.
	self unbindContext]

{ #category : #renaming }
FmlVariableName >> replacePrefix: anFmlVariableName with: anotherFmlVariableName [
	self ASSERT: [self beginsWith: anFmlVariableName].
	levels := anotherFmlVariableName levels copy
		, (levels copyFrom: anFmlVariableName levelsSize + 1)]

{ #category : #renaming }
FmlVariableName >> replaceString: string1 with: string2 [
	| string |
	string := self fullName replaceAll: string1 with: string2.
	levels := string variableName levels.
	self unbindContext]

{ #category : #inquiries }
FmlVariableName >> resolveModelObjectIn: aCollection [
	| string |
	string := self fullName.
	aCollection do: [:spec | | v |
		v := spec modelName.
		(string beginsWith: v) ifTrue: [
			v := v variableName.
			(self beginsWith: v)
				ifTrue: [(spec resolveModelObject: self level: v levelsSize + 1)
					ifNotNil: [:o | ^o]]]].
	^nil]

{ #category : #evaluation }
FmlVariableName >> resolveVariableIn: context [
	variable := context findVariableName: self.
	variable isNil ifTrue: [
		FmlMissingVariable signalOn: self fullName function: self.
		^self].
	(variable isVariable andNot: [variable isActive]) ifTrue: [
		variable := nil asFmlValue.
		FmlInactiveVariable informOn: self fullName function: self]]

{ #category : #evaluation }
FmlVariableName >> resultType [
	^variable resultType]

{ #category : #validation }
FmlVariableName >> setLiteralUnitsFrom: aUnit [
	"
	do nothing
	"
	]

{ #category : #evaluation }
FmlVariableName >> signalInactiveVariable [
	FmlInactiveVariable signalOn: self fullName]

{ #category : #services }
FmlVariableName >> simpleEditDistanceTo: aString cache: aDictionary [
	| max distances cache |
	max := aString size + 1.
	distances := levels collect: [:level | | s |
		s := level trimBlanks.
		s copyFrom: 1 to: (s size min: max).
		s := s asLowercase.
		cache := aDictionary at: aString ifAbsentPut: [Dictionary new].
		cache at: s ifAbsentPut: [s editDistanceTo: aString]].
	^distances min]

{ #category : #private }
FmlVariableName >> stringAndIndexAt: anInteger [
	"
	'hola [2]' variableName stringAndIndexAt: 1.
	"
	| level i tail j string index |
	level := self levelAt: anInteger.
	i := level findLast: [:c | c isDigit] ifAbsent: [^{level. 0}].
	tail := level allButFirst: i.
	(tail noneSatisfy: [:c | c isLetter]) ifFalse: [^{level. 0}].
	j := i.
	[j > 0 and: [(level at: j) isDigit]] whileTrue: [j := j - 1].
	index := level allButFirst: j.
	[j < 1 or: [(level at: j) isAlphanumeric]] whileFalse: [j := j - 1].
	string := level copyTo: j.
	^{string asLowercase. index asInteger}]

{ #category : #inquiries }
FmlVariableName >> stringFromLevel: index [
	^self stringFromLevel: index to: levels size]

{ #category : #inquiries }
FmlVariableName >> stringFromLevel: start to: stop [
	start > levels size ifTrue: [^nil].
	^String streamContents: [:strm | 
		levels
			from: start
			to: (stop min: levels size)
			do: [:level | strm nextPutAll: level]
			andBetweenDo: [strm nextPut: Separator; space]]]

{ #category : #inquiries }
FmlVariableName >> stringUpToLevel: index [
	^self stringFromLevel: 1 to: index]

{ #category : #transforming }
FmlVariableName >> swapLevel: i with: j [
	levels swap: i with: j]

{ #category : #'translation to Excel' }
FmlVariableName >> translateExpressionUsing: anFmlTranslator [
	| type |
	type := self resultType.
	type == FmlUndefinedValue ifTrue: [^'NA()'].
	type = FmlTable ifTrue: [^anFmlTranslator translateVariable: self].
	type = FmlString ifTrue: [^anFmlTranslator translateVariable: self].
	(variable isBindingVariable
		or: [variable mainOwner ~= anFmlTranslator model])
		ifTrue: [^type == FmlArray
			ifTrue: [variable value]
			ifFalse: [{variable value}]].
	^type == FmlArray
		ifTrue: [
			(1 to: anFmlTranslator periodsSize)
				collect: [:index | anFmlTranslator
					translateVariable: self
					atColumn: index]]
		ifFalse: [anFmlTranslator translateVariable: self atColumn: 1]]

{ #category : #'translation to Excel' }
FmlVariableName >> translateUsing: aFmlTranslator [
	^aFmlTranslator translateVariable: self]

{ #category : #'translation to Excel' }
FmlVariableName >> translateUsing: aFmlTranslator atColumn: index [
	^aFmlTranslator translateVariable: self atColumn: index]

{ #category : #evaluation }
FmlVariableName >> unbindContext [
	variable := nil]

{ #category : #accessing }
FmlVariableName >> unit [
	^(variable isVariable and: [variable unitHasBeenEdited])
		ifTrue: [variable unit]]

{ #category : #accessing }
FmlVariableName >> variable [
	^variable]

{ #category : #accessing }
FmlVariableName >> variableName [
	^self]

