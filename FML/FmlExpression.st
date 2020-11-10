"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlExpression,
	#superclass : #Object,
	#category : #FML
}

{ #category : #events }
FmlExpression class >> availableEvents [
	^super availableEvents add: #needsPeriodManager; yourself]

{ #category : #accessing }
FmlExpression class >> clipboardFormat [
	^self name]

{ #category : #accessing }
FmlExpression class >> fromClipboard [
	^Clipboard getObjectWithFormatNamed: self clipboardFormat]

{ #category : #'instance creation' }
FmlExpression class >> new [
	^super new initialize]

{ #category : #validation }
FmlExpression class >> validatorClass [
	^FmlExpressionValidator]

{ #category : #comparing }
FmlExpression >> = anFmlExpression [
	self subclassResponsibility]

{ #category : #statistics }
FmlExpression >> addBuiltInFunctionsTo: aCollection [
	self do: [:fml | 
		fml isFunctionCall ifTrue: [aCollection add: fml name].
		fml isBinaryExpression ifTrue: [aCollection add: fml operator]]]

{ #category : #'adding - nonRecursive' }
FmlExpression >> addNeededVariablesTo: aCollection [
	]

{ #category : #validation }
FmlExpression >> addNumericLiteralsTo: aCollection [
	]

{ #category : #accessing }
FmlExpression >> allFunctions [
	| functions |
	functions := self functions.
	self allNeededVariables do: [:v | 
		v hasFmlFunction
			ifTrue: [v fmlExpression
				ifNotNil: [:fml | functions addAll: fml functions]]].
	^functions]

{ #category : #accessing }
FmlExpression >> allNeededVariables [
	| answer |
	answer := OrderedCollection new.
	self allNeededVariablesInto: answer.
	^answer]

{ #category : #accessing }
FmlExpression >> allNeededVariablesInto: aCollection [
	self allNodesDo: [:each | each addNeededVariablesTo: aCollection]]

{ #category : #accessing }
FmlExpression >> allNodesDo: aBlock [
	self depthFirstDo: aBlock gathering: [:exp | exp nodes]]

{ #category : #errors }
FmlExpression >> argument: arg
in: function
notBetween: min
and: max [
	| f |
	f := self displayFunctionName: function.
	^InvalidArgumentType
		signal: 'Argument <' , arg , '> in ' , f , ' should be between '
			, min printString
			, ' and '
			, max printString]

{ #category : #errors }
FmlExpression >> argument: arg in: function shouldBe: class [
	| f |
	f := self displayFunctionName: function.
	^InvalidArgumentType
		signal: 'Argument <' , arg , '> in ' , f , ' should be '
			, class typeName withArticle]

{ #category : #errors }
FmlExpression >> argument: arg in: function shouldNotBe: fmlValueClass [
	| f |
	f := self displayFunctionName: function.
	^InvalidArgumentType
		signal: 'Argument <' , arg , '> in ' , f , ' cannot be a '
			, fmlValueClass typeName]

{ #category : #errors }
FmlExpression >> argument: arg in: function unitShouldBe: class [
	| f |
	f := self displayFunctionName: function.
	^InvalidArgumentType
		signal: 'Argument <' , arg , '> in ' , f , ' should be '
			, class typeName withArticle]

{ #category : #converting }
FmlExpression >> asFmlExpression [
	^self]

{ #category : #converting }
FmlExpression >> asFmlValue [
	^self]

{ #category : #printing }
FmlExpression >> asShortString [
	^String streamContents: [:strm | self printShortOn: strm]]

{ #category : #functions }
FmlExpression >> averageDistribution: number at: domain [
	^self
		argument: 'variable'
		in: 'averageDistribution'
		shouldBe: FmlVariableName]

{ #category : #evaluation }
FmlExpression >> bindContext: aModelObject [
	"
	nothing to do
	"
	]

{ #category : #errors }
FmlExpression >> cannotEvaluate: aString [
	^self cannotOperate: aString on: self]

{ #category : #errors }
FmlExpression >> cannotOperate: aString on: anFmlExpression [
	| parenthesis |
	parenthesis := aString first isLetter ifTrue: ['()'] ifFalse: [''].
	^InvalidArgumentType
		signal: 'Function ' , aString , parenthesis , ' cannot operate on '
			, anFmlExpression typeName asPlural]

{ #category : #testing }
FmlExpression >> canReferToVariable [
	^false]

{ #category : #inquiries }
FmlExpression >> complexityOn: d [
	^0]

{ #category : #testing }
FmlExpression >> couldRequireColumnEvaluation [
	^self allFunctions
		anySatisfy: [:f | f functionDefinition couldRequireColumnEvaluation]]

{ #category : #printing }
FmlExpression >> defaultDataSeparator [
	^Locale current dataSeparator , ' ']

{ #category : #accessing }
FmlExpression >> defaultDecimalSeparator [
	^Locale current decimalSeparator]

{ #category : #enumerating }
FmlExpression >> detect: aBlock ifNone: absentBlock [
	self do: [:n | (aBlock value: n) ifTrue: [^n]].
	^absentBlock value]

{ #category : #services }
FmlExpression >> displayFunctionName: aString [
	^aString first isLetter ifTrue: [aString , '()'] ifFalse: [aString]]

{ #category : #services }
FmlExpression >> displaySquareWith: aUnit [
	| once |
	once := self displayValueWith: aUnit.
	^once displayValueWith: aUnit]

{ #category : #functions }
FmlExpression >> distributionAt: x [
	^self cannotOperate: 'distribution' on: self]

{ #category : #arithmetic }
FmlExpression >> dividedBy: anFmlExpression [
	^FmlBinaryExpression left: self operator: #'/' right: anFmlExpression]

{ #category : #enumerating }
FmlExpression >> do: aBlock [
	aBlock value: self]

{ #category : #evaluation }
FmlExpression >> evaluate [
	^self evaluateWith: FmlEvaluator new]

{ #category : #evaluation }
FmlExpression >> evaluateAll [
	^self evaluateWith: FmlFullEvaluator new]

{ #category : #converting }
FmlExpression >> evaluated [
	^self]

{ #category : #evaluation }
FmlExpression >> evaluateWith: aFmlEvaluator [
	]

{ #category : #grammar }
FmlExpression >> factors [
	^{self}]

{ #category : #printing }
FmlExpression >> format [
	^String streamContents: [:strm | self printTextOn: strm indent: 0]]

{ #category : #accessing }
FmlExpression >> functions [
	| functions |
	functions := Set new.
	self allNodesDo: [:exp | exp isFunctionCall ifTrue: [functions add: exp]].
	^functions]

{ #category : #functions }
FmlExpression >> geometricMeanDistribution: number at: domain [
	^self
		argument: 'variable'
		in: 'geometricMeanDistribution'
		shouldBe: FmlVariableName]

{ #category : #comparing }
FmlExpression >> hash [
	self subclassResponsibility]

{ #category : #testing }
FmlExpression >> hasNumericLiterals [
	^false]

{ #category : #testing }
FmlExpression >> hasOnlyConstants [
	^false]

{ #category : #accessing }
FmlExpression >> inferredUnit [
	^nil]

{ #category : #errors }
FmlExpression >> invalidColumnName: arg in: function [
	| f |
	f := self displayFunctionName: function.
	^InvalidArgumentType
		signal: 'Argument <' , arg , '> in ' , f , ' is not a column name']

{ #category : #functions }
FmlExpression >> inverseDistributionAt: x [
	^self cannotOperate: 'inverseDistribution' on: self]

{ #category : #functions }
FmlExpression >> inverseLognormal: mean sd: sd [
	^self cannotOperate: 'inverseLognormal' on: self]

{ #category : #functions }
FmlExpression >> inverseNormal: mean sd: sd [
	^self cannotOperate: 'inverseNormal' on: self]

{ #category : #testing }
FmlExpression >> isArrayValued [
	^false]

{ #category : #testing }
FmlExpression >> isBinaryExpression [
	^false]

{ #category : #testing }
FmlExpression >> isConstant [
	^false]

{ #category : #testing }
FmlExpression >> isDefined [
	^true asFmlValue]

{ #category : #testing }
FmlExpression >> isFmlString [
	^false]

{ #category : #testing }
FmlExpression >> isFunctionCall [
	^false]

{ #category : #testing }
FmlExpression >> isIfFunction [
	^false]

{ #category : #testing }
FmlExpression >> isIncreasing [
	^false]

{ #category : #testing }
FmlExpression >> isInput [
	^false]

{ #category : #testing }
FmlExpression >> isLeafNode [
	^false]

{ #category : #testing }
FmlExpression >> isLiteral [
	^false]

{ #category : #testing }
FmlExpression >> isLogical [
	^false]

{ #category : #testing }
FmlExpression >> isMagicConstant [
	^false]

{ #category : #testing }
FmlExpression >> isNotFunction [
	^false]

{ #category : #testing }
FmlExpression >> isSingleValued [
	^false]

{ #category : #testing }
FmlExpression >> isTableValued [
	^false]

{ #category : #testing }
FmlExpression >> isVariableName [
	^false]

{ #category : #printing }
FmlExpression >> latex [
	^String streamContents: [:strm | self printLatexOn: strm]]

{ #category : #evaluation }
FmlExpression >> lazyEvaluate [
	^self isArrayValued
		ifTrue: [(FmlExpressionArray
			withAll: ((1 to: self periodsSize)
				collect: [:i | FmlLazyEvaluationArg on: self atIndex: i])) asFmlValue]
		ifFalse: [FmlLazyEvaluationArg on: self]]

{ #category : #evaluation }
FmlExpression >> lazyEvaluateAt: index [
	^FmlLazyEvaluationArg on: self atIndex: index]

{ #category : #printing }
FmlExpression >> literals [
	^#()]

{ #category : #validation }
FmlExpression >> magicConstants [
	| literals |
	self isLiteral ifTrue: [^#()].
	literals := Set new.
	self addMagicConstantsTo: literals.
	^literals]

{ #category : #accessing }
FmlExpression >> mainFunction [
	^nil]

{ #category : #converting }
FmlExpression >> moduleIndependentFormat [
	| answer |
	answer := self copy.
	answer variableNames do: [:v | v inModuleIndependentFormat].
	^answer]

{ #category : #arithmetic }
FmlExpression >> multipliedBy: anFmlExpression [
	^FmlBinaryExpression left: self operator: #'*' right: anFmlExpression]

{ #category : #enumerating }
FmlExpression >> neededVariablesDo: aBlock visited: aCollection [
	]

{ #category : #testing }
FmlExpression >> negates: anFmlExpression [
	^false]

{ #category : #accessing }
FmlExpression >> nodeAtIndex: integer [
	self normalizedString.
	^self
		detect: [:n | n isLeafNode and: [n sourceInterval includes: integer]]
		ifNone: nil]

{ #category : #accessing }
FmlExpression >> nodes [
	^#()]

{ #category : #errors }
FmlExpression >> nonPositiveArgument: arg in: function [
	| f |
	f := self displayFunctionName: function.
	^InvalidArgumentType
		signal: 'Argument <' , arg , '> in ' , f , ' should be positive']

{ #category : #printing }
FmlExpression >> normalizedString [
	^String
		streamContents: [:stream | self
			printOn: stream
			dataSeparator: ', '
			decimalSeparator: '.']]

{ #category : #'logical operations' }
FmlExpression >> not [
	^FmlFunctionCall name: 'not' arguments: {self}]

{ #category : #validation }
FmlExpression >> numericLiterals [
	| literals |
	literals := OrderedCollection new.
	self addNumericLiteralsTo: literals.
	^literals]

{ #category : #translation }
FmlExpression >> parenthesizedTranslateUsing: aFmlTranslator atColumn: index [
	^self translateUsing: aFmlTranslator atColumn: index]

{ #category : #evaluation }
FmlExpression >> periodicity [
	^ContextRequest signal periodicity]

{ #category : #accessing }
FmlExpression >> periodsSize [
	^self periodicity periods]

{ #category : #accessing }
FmlExpression >> precedence [
	^4]

{ #category : #printing }
FmlExpression >> printLatexOn: aStream [
	FmlLatexPrinter new
		dataSeparator: ', ';
		decimalSeparator: '.';
		print: self on: aStream]

{ #category : #printing }
FmlExpression >> printOn: aStream [
	self
		printOn: aStream
		dataSeparator: self defaultDataSeparator
		decimalSeparator: self defaultDecimalSeparator]

{ #category : #printing }
FmlExpression >> printOn: aStream dataSeparator: dataSep decimalSeparator: decimalSep [
	| class |
	class := (aStream isKindOf: Rtf)
		ifTrue: [FmlPrettyPrinter]
		ifFalse: [FmlPlainPrinter].
	class new
		dataSeparator: dataSep;
		decimalSeparator: decimalSep;
		print: self on: aStream]

{ #category : #printing }
FmlExpression >> printOn: aStream indent: anInteger [
	self
		printOn: aStream
		indent: anInteger
		dataSeparator: ', '
		decimalSeparator: '.']

{ #category : #printing }
FmlExpression >> printOn: aStream
indent: anInteger
dataSeparator: dataSep
decimalSeparator: decimalSep [
	| class |
	class := (aStream isKindOf: Rtf)
		ifTrue: [FmlPrettyPrinter]
		ifFalse: [FmlPlainPrinter].
	class new
		indent: anInteger;
		dataSeparator: dataSep;
		decimalSeparator: decimalSep;
		print: self on: aStream]

{ #category : #printing }
FmlExpression >> printShortOn: aStream [
	| long outside inside |
	long := '' writeStream.
	self printOn: long.
	long := long contents readStream.
	[long atEnd] whileFalse: [
		outside := long upTo: $".
		aStream nextPutAll: outside.
		long atEnd ifFalse: [
			inside := long upTo: $".
			inside variableName printShortOn: aStream]]]

{ #category : #printing }
FmlExpression >> printTextOn: aStream indent: anInteger [
	self
		printOn: aStream
		indent: anInteger
		dataSeparator: ', '
		decimalSeparator: '.']

{ #category : #arithmetic }
FmlExpression >> reciprocal [
	^FmlFunctionCall new name: 'reciprocal'; arguments: {self}]

{ #category : #services }
FmlExpression >> removeFactor: anFmlExpression [
	(self isLike: anFmlExpression) ifTrue: [^1 asFmlExpression].
	^self]

{ #category : #enumerating }
FmlExpression >> replaceColumnName: aString of: anFmlVariableName with: anotherString [
	self do: [:fml | 
		fml isFunctionCall
			ifTrue: [fml
				replaceColumnName: aString
				of: anFmlVariableName
				with: anotherString]]]

{ #category : #renaming }
FmlExpression >> replaceNode: anFmlExpression with: anotherFmlExpression [
	"
	default is do nothing
	"
	]

{ #category : #'units support' }
FmlExpression >> replaceReferencedUnitsUsing: aDictionary [
	self
		do: [:fml | fml isNumber
			ifTrue: [fml replaceReferencedUnitsUsing: aDictionary]]]

{ #category : #renaming }
FmlExpression >> replaceReferencesTo: varName1 with: varName2 [
	self variableNames
		select: [:vn | vn = varName1]
		thenDo: [:vn | vn renameTo: varName2]]

{ #category : #renaming }
FmlExpression >> replaceReferencesToPrefix: anFmlVariableName with: aString [
	self variableNames
		do: [:v | v renamePrefix: anFmlVariableName with: aString]]

{ #category : #renaming }
FmlExpression >> replaceReferenceString: string1 with: string2 [
	self variableNamesDo: [:v | v replaceString: string1 with: string2]]

{ #category : #evaluation }
FmlExpression >> resultType [
	^nil resultType]

{ #category : #enumerating }
FmlExpression >> select: aBlock thenDo: anotherBlock [
	self
		do: [:each | (aBlock evaluateWith: each)
			ifTrue: [anotherBlock evaluateWith: each]]]

{ #category : #printing }
FmlExpression >> selectors [
	^#()]

{ #category : #services }
FmlExpression >> simplify [
	^FmlSimplifier simplify: self]

{ #category : #accessing }
FmlExpression >> sourceInterval [
	| a b |
	a := self propertyAt: #startPos.
	b := self propertyAt: #endPos.
	^(a isNil or: [b isNil]) ifTrue: [#()] ifFalse: [a to: b]]

{ #category : #accessing }
FmlExpression >> table [
	self variableNamesDo: [:v | | var |
		v variable isTableValued ifTrue: [
			var := v variable.
			var isVariable ifTrue: [^var tableDefinition]]].
	^nil]

{ #category : #grammar }
FmlExpression >> terms [
	^{FmlSummationTerm with: self}]

{ #category : #translation }
FmlExpression >> translateExpressionUsing: anFmlTranslator [
	^self translateUsing: anFmlTranslator]

{ #category : #translation }
FmlExpression >> translateInOneCellUsing: aFmlTranslator [
	^self resultType isSingleValued
		ifTrue: [self translateUsing: aFmlTranslator]
		ifFalse: [aFmlTranslator variableReference: self]]

{ #category : #constants }
FmlExpression >> typeName [
	^self class typeName]

{ #category : #accessing }
FmlExpression >> unit [
	^self inferredUnit]

{ #category : #accessing }
FmlExpression >> unitForConstant: aFmlValue [
	^self == aFmlValue ifTrue: [self unit].]

{ #category : #'units support' }
FmlExpression >> usedUnitsDo: aBlock [
	self do: [:fml | fml isNumber ifTrue: [fml usedUnitsDo: aBlock]]]

{ #category : #evaluation }
FmlExpression >> value [
	| value |
	value := [self evaluate]
		on: Error
		do: [:error | error isResumable
			ifTrue: [error resume]
			ifFalse: [error pass]].
	^value isUndefinedValue ifTrue: [nil asFmlValue] ifFalse: [value value]]

{ #category : #accessing }
FmlExpression >> variableNames [
	| functions |
	functions := OrderedCollection new.
	self allNodesDo: [:exp | exp isVariableName ifTrue: [functions add: exp]].
	^functions]

{ #category : #accessing }
FmlExpression >> variableNamesDo: aBlock [
	self do: [:exp | exp isVariableName ifTrue: [aBlock value: exp]]]

{ #category : #accessing }
FmlExpression >> variables [
	^self variableNames collect: [:vn | vn variable]]

{ #category : #enumerating }
FmlExpression >> withNeededVariablesDo: aBlock visited: aCollection [
	self ASSERT: false.
	self neededVariablesDo: aBlock visited: aCollection]

