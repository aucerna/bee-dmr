"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlUndefinedValue,
	#superclass : #FmlValue,
	#category : #FML
}

{ #category : #'result type' }
FmlUndefinedValue class >> * resultType [
	^resultType]

{ #category : #initialization }
FmlUndefinedValue class >> initializeCurrent [
	current := super new]

{ #category : #'instance creation' }
FmlUndefinedValue class >> new [
	current isNil ifTrue: [self initializeCurrent].
	^current]

{ #category : #testing }
FmlUndefinedValue class >> supportsLogicalOperations [
	^true]

{ #category : #constants }
FmlUndefinedValue class >> typeName [
	^'Undefined']

{ #category : #arithmetic }
FmlUndefinedValue >> - aFmlValue [
	^self]

{ #category : #arithmetic }
FmlUndefinedValue >> * aFmlValue [
	^self]

{ #category : #arithmetic }
FmlUndefinedValue >> / aFmlValue [
	^self]

{ #category : #arithmetic }
FmlUndefinedValue >> // aFmlValue [
	^self]

{ #category : #arithmetic }
FmlUndefinedValue >> \\ aFmlValue [
	^self]

{ #category : #arithmetic }
FmlUndefinedValue >> + aFmlValue [
	^self]

{ #category : #comparing }
FmlUndefinedValue >> < aFmlValue [
	^self]

{ #category : #comparing }
FmlUndefinedValue >> <= aFmlValue [
	^self]

{ #category : #comparing }
FmlUndefinedValue >> = anObject [
	^self equals: anObject]

{ #category : #comparing }
FmlUndefinedValue >> > aFmlValue [
	^self]

{ #category : #comparing }
FmlUndefinedValue >> >= anFmlValue [
	^self]

{ #category : #arithmetic }
FmlUndefinedValue >> abs [
	^self]

{ #category : #visiting }
FmlUndefinedValue >> acceptVisitor: fmlVisitor [
	fmlVisitor visitFmlUndefined: self]

{ #category : #functions }
FmlUndefinedValue >> addDays: n [
	^self]

{ #category : #'logical operations' }
FmlUndefinedValue >> and: anFmlValue [
	^false asFmlValue]

{ #category : #services }
FmlUndefinedValue >> arrayOfUndefined [
	| n answer |
	n := self periodsSize.
	answer := self zeroArray.
	1 to: n do: [:i | answer at: i put: self].
	^answer asFmlValue]

{ #category : #converting }
FmlUndefinedValue >> asDate [
	^self]

{ #category : #converting }
FmlUndefinedValue >> asFloat [
	^Float nan]

{ #category : #converting }
FmlUndefinedValue >> asFmlString [
	^'']

{ #category : #converting }
FmlUndefinedValue >> asInteger [
	^0]

{ #category : #evaluating }
FmlUndefinedValue >> at: dummy [
	^self]

{ #category : #functions }
FmlUndefinedValue >> average: anArray [
	| array i rcvr |
	array := anArray isArray ifTrue: [anArray copy] ifFalse: [{anArray}].
	i := array findFirst: [:x | x isNumber] ifAbsent: [^self].
	rcvr := array at: i.
	array at: i put: self.
	^rcvr average: array]

{ #category : #arithmetic }
FmlUndefinedValue >> between: a and: b [
	^false]

{ #category : #errors }
FmlUndefinedValue >> cannotEvaluate: aSymbol [
	^self]

{ #category : #arithmetic }
FmlUndefinedValue >> ceiling [
	^self]

{ #category : #arithmetic }
FmlUndefinedValue >> ceiling: significance [
	^self]

{ #category : #functions }
FmlUndefinedValue >> cum [
	^self]

{ #category : #'date functions' }
FmlUndefinedValue >> date: dummy day: dummy2 [
	^self]

{ #category : #'date functions' }
FmlUndefinedValue >> dayOfYear [
	^self]

{ #category : #'date functions' }
FmlUndefinedValue >> daysInYear [
	^self]

{ #category : #functions }
FmlUndefinedValue >> daysSince: aDate [
	^self]

{ #category : #functions }
FmlUndefinedValue >> db: life afterlife: aBoolean [
	^self arrayOfUndefined]

{ #category : #functions }
FmlUndefinedValue >> ddb: life afterlife: aBoolean [
	^self arrayOfUndefined]

{ #category : #printing }
FmlUndefinedValue >> displayString [
	^'Undefined']

{ #category : #printing }
FmlUndefinedValue >> displayValue [
	^self]

{ #category : #printing }
FmlUndefinedValue >> displayValueWith: aUnit [
	^self]

{ #category : #printing }
FmlUndefinedValue >> displayValueWithUnit: dummy [
	^self displayString]

{ #category : #converting }
FmlUndefinedValue >> dumpOnVariant: aVARIANT [
	aVARIANT beNull]

{ #category : #comparing }
FmlUndefinedValue >> equals: anFmlValue [
	^self class == anFmlValue class]

{ #category : #arithmetic }
FmlUndefinedValue >> exp [
	^self]

{ #category : #functions }
FmlUndefinedValue >> firstNegativeIfAbsent: defaultValue [
	^self]

{ #category : #functions }
FmlUndefinedValue >> firstPositiveIfAbsent: defaultValue [
	^self]

{ #category : #functions }
FmlUndefinedValue >> firstValue [
	^self]

{ #category : #functions }
FmlUndefinedValue >> floor: dummy [
	^self]

{ #category : #functions }
FmlUndefinedValue >> geometricMean: anArray [
	^self]

{ #category : #comparing }
FmlUndefinedValue >> hash [
	^self class hash]

{ #category : #testing }
FmlUndefinedValue >> hasUndefinedValues [
	^true]

{ #category : #functions }
FmlUndefinedValue >> if: trueExp with: falseExp [
	^self]

{ #category : #functions }
FmlUndefinedValue >> index: row col: col [
	^self]

{ #category : #'array compatibility' }
FmlUndefinedValue >> indexGTValue: value ifAbsent: default [
	^self]

{ #category : #'array compatibility' }
FmlUndefinedValue >> indexLTValue: value ifAbsent: defaultValue [
	^self]

{ #category : #converting }
FmlUndefinedValue >> inUnit: aUnit [
	^self]

{ #category : #functions }
FmlUndefinedValue >> inverseAt: fmlArray [
	^self]

{ #category : #testing }
FmlUndefinedValue >> isCloseTo: aFmlValue [
	^aFmlValue isUndefinedValue]

{ #category : #testing }
FmlUndefinedValue >> isDefined [
	^false asFmlValue]

{ #category : #testing }
FmlUndefinedValue >> isInRange: aRange [
	^false]

{ #category : #testing }
FmlUndefinedValue >> isMagicConstant [
	^false]

{ #category : #testing }
FmlUndefinedValue >> isNumeric [
	^true]

{ #category : #testing }
FmlUndefinedValue >> isSummable [
	^true]

{ #category : #testing }
FmlUndefinedValue >> isUndefinedValue [
	^true]

{ #category : #testing }
FmlUndefinedValue >> isZero [
	^false]

{ #category : #functions }
FmlUndefinedValue >> lastNegativeIfAbsent: defaultValue [
	^self]

{ #category : #functions }
FmlUndefinedValue >> lastPositiveIfAbsent: defaultValue [
	^self]

{ #category : #functions }
FmlUndefinedValue >> ln [
	^self]

{ #category : #functions }
FmlUndefinedValue >> log: anFmlValue [
	^self]

{ #category : #arithmetic }
FmlUndefinedValue >> max: fmlValue [
	^fmlValue]

{ #category : #functions }
FmlUndefinedValue >> min: fmlValue [
	^fmlValue]

{ #category : #functions }
FmlUndefinedValue >> min: fmlValue max: anotherFmlValue [
	^fmlValue max: anotherFmlValue]

{ #category : #'date functions' }
FmlUndefinedValue >> month [
	^self]

{ #category : #functions }
FmlUndefinedValue >> mustBeBoolean [
	^self]

{ #category : #arithmetic }
FmlUndefinedValue >> negated [
	^self]

{ #category : #arithmetic }
FmlUndefinedValue >> negative [
	^false]

{ #category : #'logical operations' }
FmlUndefinedValue >> not [
	^self]

{ #category : #arithmetic }
FmlUndefinedValue >> npvRate: rate [
	^self]

{ #category : #'logical operations' }
FmlUndefinedValue >> or: anFmlBoolean [
	^anFmlBoolean]

{ #category : #perform }
FmlUndefinedValue >> performOperation: aSymbol receiverValue: aNumber [
	aSymbol = #'>' ifTrue: [^(self <= aNumber) asFmlValue].
	aSymbol = #'>=' ifTrue: [^(self < aNumber) asFmlValue].
	aSymbol = #'<' ifTrue: [^(self >= aNumber) asFmlValue].
	aSymbol = #'<=' ifTrue: [^(self > aNumber) asFmlValue].
	aSymbol = #min: ifTrue: [^(self min: aNumber) asFmlValue].
	aSymbol = #max: ifTrue: [^(self max: aNumber) asFmlValue].
	aSymbol = #or: ifTrue: [^(self or: aNumber) asFmlValue].
	^self]

{ #category : #printing }
FmlUndefinedValue >> printWithDecimalPlaces: dummy [
	^'Undefined']

{ #category : #arithmetic }
FmlUndefinedValue >> raisedTo: n [
	^self]

{ #category : #arithmetic }
FmlUndefinedValue >> relativeIncrementFrom: aFmlValue [
	^self]

{ #category : #arithmetic }
FmlUndefinedValue >> roundDigits: anInteger [
	^self]

{ #category : #arithmetic }
FmlUndefinedValue >> rounded [
	^self]

{ #category : #functions }
FmlUndefinedValue >> runningCum [
	^self]

{ #category : #functions }
FmlUndefinedValue >> shiftLeft: element [
	^self]

{ #category : #functions }
FmlUndefinedValue >> shiftLeft: positions fillWith: element [
	^self]

{ #category : #functions }
FmlUndefinedValue >> shiftRight: element [
	^self]

{ #category : #functions }
FmlUndefinedValue >> shiftRight: positions fillWith: element [
	^self]

{ #category : #functions }
FmlUndefinedValue >> sl: life [
	^self arrayOfUndefined]

{ #category : #arithmetic }
FmlUndefinedValue >> sqrt [
	^self]

{ #category : #arithmetic }
FmlUndefinedValue >> squared [
	^self]

{ #category : #arithmetic }
FmlUndefinedValue >> squaredDifference: d [
	^self]

{ #category : #functions }
FmlUndefinedValue >> subtractDate: dummy [
	^self]

{ #category : #functions }
FmlUndefinedValue >> syd: life [
	^self arrayOfUndefined]

{ #category : #functions }
FmlUndefinedValue >> tableLookupTable: fmlTable searchColumn: searchColumn returnColumn: returnColumn [
	^self]

{ #category : #arithmetic }
FmlUndefinedValue >> truncated [
	^self]

{ #category : #converting }
FmlUndefinedValue >> unitsOf: aUnit [
	^self]

{ #category : #evaluating }
FmlUndefinedValue >> value [
	^self]

{ #category : #functions }
FmlUndefinedValue >> vLookup: value returnColumn: index [
	^self]

{ #category : #functions }
FmlUndefinedValue >> xNPVRate: rate dates: dateArray [
	^self]

{ #category : #functions }
FmlUndefinedValue >> xNPVRate: rate
dates: dateArray
startDate: startDate
endDate: enddate [
	^self]

{ #category : #'date functions' }
FmlUndefinedValue >> year [
	^self]

{ #category : #perform }
FmlUndefinedValue >> yesNoString [
	^self printString]

