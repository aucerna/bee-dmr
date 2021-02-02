"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Validator,
	#superclass : #TestCase,
	#instVars : [
		'object',
		'originalObject',
		'prettyPrint',
		'reportFailureFor',
		'aspect'
	],
	#category : #Validations
}

{ #category : #private }
Validator class >> addSelectorsSpecializedFor: anObject to: aCollection [
	anObject addValidationSelectorsTo: aCollection]

{ #category : #'suite building' }
Validator class >> allTestSelectors [
	^(self
		selectorsUpTo: self rootClass
		satisfying: [:sel | sel last ~= $: and: [sel beginsWith: 'validate']]) asOrderedCollection]

{ #category : #private }
Validator class >> isAbstract [
	^self == Validator]

{ #category : #'suite building' }
Validator class >> on: modelObject [
	^self new object: modelObject]

{ #category : #validation }
Validator class >> passes: anObject validation: aBlock [
	| text valid |
	text := NullText new.
	valid := true.
	[| validator |
		validator := self new object: anObject.
		validator prettyPrint: text.
		aBlock value: validator]
		on: ValidationFailureException , ValidationBreak
		do: [:f | 
			f tryResume.
			valid := false].
	^valid]

{ #category : #private }
Validator class >> rootClass [
	^Validator]

{ #category : #private }
Validator class >> selectorPattern [
	^'validate']

{ #category : #private }
Validator class >> selectorPatterns [
	^{self selectorPattern}]

{ #category : #running }
Validator class >> shouldBuildForSubclasses [
	^false]

{ #category : #testing }
Validator class >> shouldInheritSelectors [
	^true]

{ #category : #'runtime packager' }
Validator class >> subHierarchyValidationSelectors [
	^(self withAllSubclasses
		inject: Set new
		into: [:selectors :eachValidatorClass | selectors
			addAll: eachValidatorClass testSelectors;
			yourself]) asArray]

{ #category : #private }
Validator class >> suiteClass [
	^ValidationSuite]

{ #category : #validation }
Validator class >> validate: anObject [
	^self validate: anObject originalObject: nil]

{ #category : #validation }
Validator class >> validate: anObject originalObject: anotherObject [
	| suite |
	suite := self validationSuiteFor: anObject originalObject: anotherObject.
	^suite run]

{ #category : #validation }
Validator class >> validate: anObject selector: selector [
	^self validate: anObject selectors: {selector}]

{ #category : #validation }
Validator class >> validate: anObject selector: selector on: validationResult [
	^self validate: anObject selectors: {selector} on: validationResult]

{ #category : #validation }
Validator class >> validate: anObject selector: selector with: argument [
	^self
		validate: anObject
		selector: (Message selector: selector arguments: {argument})]

{ #category : #validation }
Validator class >> validate: anObject
selector: selector
with: argument
on: validationResult [
	^self
		validate: anObject
		selector: (Message selector: selector arguments: {argument})
		on: validationResult]

{ #category : #validation }
Validator class >> validate: anObject
selector: selector
with: arg1
with: arg2 [
	| msg |
	msg := Message selector: selector arguments: {arg1. arg2}.
	^self validate: anObject selector: msg]

{ #category : #validation }
Validator class >> validate: anObject
selector: selector
with: arg1
with: arg2
with: arg3 [
	^self
		validate: anObject
		selector: (Message selector: selector arguments: {arg1. arg2. arg3})]

{ #category : #validation }
Validator class >> validate: anObject
selector: selector
withArguments: array [
	^self
		validate: anObject
		selector: (Message
			selector: selector
			arguments: array)]

{ #category : #validation }
Validator class >> validate: anObject selectors: selectors [
	^self validate: anObject selectors: selectors on: ValidationResult new]

{ #category : #validation }
Validator class >> validate: anObject selectors: selectors on: validationResult [
	| suite |
	suite := self validationSuiteFor: anObject selectors: selectors.
	suite run: validationResult.
	^validationResult]

{ #category : #validation }
Validator class >> validationSuiteFor: anObject [
	^self validationSuiteFor: anObject originalObject: nil]

{ #category : #validation }
Validator class >> validationSuiteFor: anObject originalObject: anotherObject [
	| suite specific |
	suite := self buildSuiteFromSelectors.
	specific := OrderedCollection new.
	self addSelectorsSpecializedFor: anObject to: specific.
	specific do: [:selector | | test |
		test := self selector: selector.
		suite addTest: test].
	suite object: anObject originalObject: anotherObject.
	^suite]

{ #category : #'suite building' }
Validator class >> validationSuiteFor: anObject selectors: selectors [
	| suite |
	suite := self suiteClass new.
	selectors
		do: [:sel | suite addTest: (self new testSelector: sel; object: anObject)].
	^suite]

{ #category : #'validation helpers' }
Validator >> are: aCollection inRange: aRange [
	(aRange notNil andNot: [aCollection isInRange: aRange]) ifTrue: [
		self
			failValidationBecause: self prettyPrint , ' must have all entries '
				, aRange conditionString]]

{ #category : #'validation helpers' }
Validator >> are: aCollection inRange: aRange unit: unit [
	| range1 range2 |
	(aRange isNil or: [aCollection areInRange: aRange]) ifTrue: [^self].
	(aRange hasUpperBound and: [aRange hasLowerBound]) ifTrue: [
		range1 := aRange inUnit: unit.
		self
			failBecause: self prettyPrint , ' must have all entries '
				, range1 conditionString].
	range1 := aRange copy upperBound: nil.
	(aCollection areInRange: range1) ifFalse: [
		range2 := (unit notNil andNot: [unit isBaseUnit])
			ifTrue: [range1 inUnit: unit]
			ifFalse: [range1].
		range2 upperBound: nil.
		self
			failBecause: self prettyPrint , ' must have all entries '
				, range2 conditionString].
	range1 := aRange copy lowerBound: nil.
	(aCollection areInRange: range1) ifFalse: [
		range2 := (unit notNil andNot: [unit isBaseUnit])
			ifTrue: [range1 inUnit: unit]
			ifFalse: [range1].
		range2 lowerBound: nil.
		self
			failBecause: self prettyPrint , ' must have all entries '
				, range2 conditionString].
	(unit isNil or: [unit isBaseUnit]) ifTrue: [^self].
	range1 := aRange inUnit: unit.
	(aCollection conform: [:value | (unit convert: value) isInRange: range1])
		ifFalse: [
			self
				failBecause: self prettyPrint , ' must have all entries '
					, range1 conditionString]]

{ #category : #'validation helpers' }
Validator >> are: aCollection kindOf: aClass [
	aCollection do: [:v | self is: v kindOf: aClass]]

{ #category : #'validation helpers' }
Validator >> areDefined: aCollection [
	(aCollection isNil
		or: [aCollection anySatisfy: [:v | v isNil or: [v isFloat and: [v isNaN]]]])
		ifTrue: [self failValidationBecause: self areRequired]]

{ #category : #'validation helpers' }
Validator >> areDifferent: aCollection [
	((aCollection isKindOf: Collection)
		and: [aCollection asSet size = aCollection size])
		ifFalse: [self failBecause: self cannotHaveDuplicates]]

{ #category : #'validation helpers' }
Validator >> areIncreasing: aCollection [
	| prev index |
	aCollection isIncreasing ifTrue: [^self].
	prev := aCollection at: 1.
	index := (2 to: aCollection size) detect: [:i | | xi test |
		xi := aCollection at: i.
		test := xi <= prev.
		prev := xi.
		test].
	self failValidationBecause: (self mustBeIncreasingAt: index)]

{ #category : #'validation helpers' }
Validator >> areNonNegative: aCollection [
	self areDefined: aCollection.
	aCollection
		do: [:v | v < 0 ifTrue: [self failBecause: self mustBeAllNonNegative]]]

{ #category : #'validation helpers' }
Validator >> arePositive: aCollection [
	self areDefined: aCollection.
	aCollection
		do: [:v | v > 0 ifFalse: [self failBecause: self mustBeAllPositive]]]

{ #category : #'message patterns' }
Validator >> areRequired [
	^self prettyPrint , ' are required']

{ #category : #accessors }
Validator >> aspect [
	^aspect]

{ #category : #accessors }
Validator >> aspect: aSymbol [
	Smalltalk isRuntime ifFalse: [self count: aSymbol].
	aspect := aSymbol]

{ #category : #accessors }
Validator >> aspect: aSymbol prettyPrint: aString [
	false ifTrue: [self aspect: aSymbol].
	self count: aSymbol.
	aspect := aSymbol.
	prettyPrint := aString]

{ #category : #private }
Validator >> aspectForReporting [
	^reportFailureFor ifNil: [self aspect]]

{ #category : #object }
Validator >> broker [
	^self object broker]

{ #category : #'message patterns' }
Validator >> cannotBeInTheFuture [
	^self prettyPrint , ' cannot be in the future']

{ #category : #'message patterns' }
Validator >> cannotBeOldDate [
	^self prettyPrint , ' cannot be prior to ' , self minimumDate printString]

{ #category : #'message patterns' }
Validator >> cannotHaveDuplicates [
	^self prettyPrint, ' cannot have duplicates']

{ #category : #accessors }
Validator >> counter [
	^counter]

{ #category : #'message patterns' }
Validator >> dateIsRequired [
	^self prettyPrint, ' Must be a date']

{ #category : #debugging }
Validator >> debug [
	self resources do: [:resource | resource beAvailableFor: self].
	[
		(self class selector: testSelector)
			object: object;
			originalObject: originalObject;
			prettyPrint: prettyPrint;
			runCase]
		sunitEnsure: [self resources do: [:resource | resource reset]]]

{ #category : #debugging }
Validator >> debugAsFailure [
	| semaphore |
	semaphore := Semaphore new.
	[semaphore wait] fork.
	self runCaseAsFailure: semaphore]

{ #category : #'message patterns' }
Validator >> differentFrom: anObject [
	^self prettyPrint , ' is not ' , anObject printString]

{ #category : #'validation helpers' }
Validator >> doesntBelongIn: aCollection [
	| msg |
	self ASSERT: aCollection notEmpty.
	aCollection size = 1 ifTrue: [^self differentFrom: aCollection anyone].
	aCollection size = 2
		ifTrue: [msg := ' should be ' , aCollection first printString , ' or '
			, aCollection last printString].
	aCollection size = 3
		ifTrue: [msg := ' should be ' , aCollection first printString , ', '
			, aCollection second printString
			, ' or '
			, aCollection last printString].
	aCollection size > 3 ifTrue: [
		msg := ' should be any of: ' , (String streamContents: [:strm | 
			aCollection
				do: [:each | strm nextPutAll: each printString storeString]
				separatedBy: [strm nextPutAll: ', ']])].
	^self prettyPrint , msg]

{ #category : #exceptions }
Validator >> fail: anObject because: aString [
	| failure |
	failure := self newFailureFor: anObject description: aString.
	failure signalException]

{ #category : #exceptions }
Validator >> failBecause: aString [
	self failValidationBecause: aString]

{ #category : #queries }
Validator >> failures [
	| answer |
	answer := OrderedCollection new.
	[self debugAsFailure] sunitOn: ValidationFailureException do: [:ex | 
		answer add: ex validationFailure.
		ex sunitExitWith: false].
	^answer]

{ #category : #exceptions }
Validator >> failValidationBecause: aString [
	self fail: self object because: aString]

{ #category : #'message patterns' }
Validator >> hasCollidingName: aString [
	^self prettyPrint append: ' has (at least) a colliding name '; italic: aString]

{ #category : #'validation helpers' }
Validator >> includeFailuresOf: validationResult withPrefix: text [
	| break |
	break := false.
	validationResult allValidationFailures do: [:v | | description |
		v isResumable ifFalse: [break := true].
		description := text copy.
		description space; append: v text.
		v description: description; resignal].
	break ifTrue: [ValidationBreak signal]]

{ #category : #'validation helpers' }
Validator >> includeValidation: selector of: value [
	self includeValidationOf: value for: {selector}]

{ #category : #'validation helpers' }
Validator >> includeValidation: selector of: value with: argument [
	| v |
	v := Message selector: selector argument: argument.
	self includeValidation: v of: value]

{ #category : #'validation helpers' }
Validator >> includeValidation: selector
of: value
with: arg1
with: arg2 [
	| msg |
	msg := Message selector: selector arguments: {arg1. arg2}.
	self includeValidation: msg of: value]

{ #category : #'validation helpers' }
Validator >> includeValidationOf: value [
	| validationSuite |
	self isDefined: value.
	value triggerEvent: #aboutToValidate: with: value.
	validationSuite := value validatorClass
		validationSuiteFor: value
		originalObject: object.
	self includeValidationOfSuite: validationSuite]

{ #category : #'validation helpers' }
Validator >> includeValidationOf: value for: selectors [
	| suite |
	self isDefined: value.
	suite := value validatorClass
		validationSuiteFor: value
		selectors: selectors.
	self includeValidationOfSuite: suite]

{ #category : #'validation helpers' }
Validator >> includeValidationOf: value for: selectors withPrefix: text [
	| suite |
	self isDefined: value.
	suite := value validatorClass
		validationSuiteFor: value
		selectors: selectors.
	self includeValidationOfSuite: suite withPrefix: text]

{ #category : #'validation helpers' }
Validator >> includeValidationOf: value withPrefix: evaluableText [
	| validationSuite text |
	self isDefined: value.
	value triggerEvent: #aboutToValidate: with: value.
	validationSuite := value validatorClass
		validationSuiteFor: value
		originalObject: object.
	text := evaluableText evaluate.
	self includeValidationOfSuite: validationSuite withPrefix: text]

{ #category : #'validation helpers' }
Validator >> includeValidationOfAll: aCollection [
	self includeValidationOfAll: aCollection withPrefix: nil]

{ #category : #'validation helpers' }
Validator >> includeValidationOfAll: aCollection for: selector [
	| suite message |
	self isDefined: aCollection.
	message := Message selector: selector.
	aCollection do: [:item | 
		self isDefined: item.
		item triggerEvent: #aboutToValidate: with: item.
		suite := item validatorClass validationSuiteFor: item selectors: {message}.
		[self includeValidationOfSuite: suite]
			on: ValidationFailureException
			do: [:e | e outer; exit]
			on: ValidationBreak
			do: [:e | e return]]]

{ #category : #'validation helpers' }
Validator >> includeValidationOfAll: aCollection for: selector with: argument [
	| suite message |
	self isDefined: aCollection.
	message := Message selector: selector arguments: {argument}.
	aCollection do: [:item | 
		self isDefined: item.
		item triggerEvent: #aboutToValidate: with: item.
		suite := item validatorClass validationSuiteFor: item selectors: {message}.
		[self includeValidationOfSuite: suite]
			on: ValidationFailureException
			do: [:e | e outer; exit]
			on: ValidationBreak
			do: [:e | e return]]]

{ #category : #'validation helpers' }
Validator >> includeValidationOfAll: aCollection for: selector withPrefix: evaluableText [
	| suite |
	self isDefined: aCollection.
	aCollection do: [:item | | text |
		self isDefined: item.
		item triggerEvent: #aboutToValidate: with: item.
		suite := item validatorClass
			validationSuiteFor: item
			selectors: {selector}.
		text := evaluableText evaluateWith: item.
		[self includeValidationOfSuite: suite withPrefix: text]
			on: ValidationFailureException
			do: [:e | e outer; exit]
			on: ValidationBreak
			do: [:e | e return]]]

{ #category : #'validation helpers' }
Validator >> includeValidationOfAll: aCollection withPrefix: evaluableText [
	self isDefined: aCollection.
	aCollection do: [:item | | text |
		self isDefined: item.
		item triggerEvent: #aboutToValidate: with: item.
		text := evaluableText evaluateWith: item.
		[self includeValidationOfSuite: item validationSuite withPrefix: text]
			on: ValidationFailureException
			do: [:e | e outer; exit]
			on: ValidationBreak
			do: [:e | e return]]]

{ #category : #'validation helpers' }
Validator >> includeValidationOfAllHomogeneous: aCollection [
	| anyone suite result |
	self isDefined: aCollection.
	aCollection isEmpty ifTrue: [^self].
	aCollection do: [:item | self isDefined: item].
	anyone := aCollection anyone.
	suite := anyone validatorClass validationSuiteFor: anyone.
	result := suite runForAll: aCollection.
	[self includeValidationResult: result]
		on: ValidationFailureException
		do: [:e | e outer; exit]
		on: ValidationBreak
		do: [:e | e return].
	suite tests do: [:v | v addCountTo: counter]]

{ #category : #'validation helpers' }
Validator >> includeValidationOfSuite: validationSuite [
	self includeValidationOfSuite: validationSuite withPrefix: nil]

{ #category : #'validation helpers' }
Validator >> includeValidationOfSuite: validationSuite withPrefix: text [
	| result |
	result := validationSuite run.
	validationSuite tests do: [:test | test addCountTo: counter].
	self includeValidationResult: result withPrefix: text]

{ #category : #'validation helpers' }
Validator >> includeValidationResult: result [
	self includeValidationResult: result withPrefix: nil]

{ #category : #'validation helpers' }
Validator >> includeValidationResult: result withPrefix: text [
	| break |
	break := false.
	result validationMessagesDo: [:v | 
		v isResumable ifFalse: [break := true].
		text notNil ifTrue: [v description: (text copy space; append: v text)].
		v resignal].
	break ifTrue: [ValidationBreak signal]]

{ #category : #exceptions }
Validator >> inform: aString [
	self inform: self object about: aString]

{ #category : #exceptions }
Validator >> inform: anObject about: aString [
	| info |
	info := self newInfoFor: anObject description: aString.
	info signalException]

{ #category : #'validation helpers' }
Validator >> is: aValue above: lowerLimit andBelow: upperLimit [
	(lowerLimit < aValue and: [aValue < upperLimit]) ifFalse: [
		self
			failValidationBecause: self prettyPrint , ' must be above '
				, lowerLimit printString
				, ' and below '
				, upperLimit printString]]

{ #category : #'validation helpers' }
Validator >> is: aMagnitude between: minValue and: maxValue [
	(aMagnitude <~ maxValue and: [minValue <~ aMagnitude]) ifFalse: [
		self
			failValidationBecause: self prettyPrint , ' must be between '
				, minValue printString
				, ' and '
				, maxValue printString]]

{ #category : #'validation helpers' }
Validator >> is: anObject closeTo: otherObject [
	anObject ~ otherObject
		ifFalse: [self failValidationBecause: (self differentFrom: otherObject)]]

{ #category : #'validation helpers' }
Validator >> is: anObject equalTo: otherObject [
	anObject = otherObject
		ifFalse: [self failValidationBecause: (self differentFrom: otherObject)]]

{ #category : #'validation helpers' }
Validator >> is: aValue inRange: aRange [
	aRange isNil ifTrue: [^self].
	(aValue notNil and: [aValue isInRange: aRange])
		ifFalse: [
			self
				failValidationBecause: self prettyPrint , ' must be '
					, aRange conditionString]]

{ #category : #'validation helpers' }
Validator >> is: aValue inRange: aRange unit: aUnit [
	| value range |
	aRange isNil ifTrue: [^self].
	value := aValue notNil ifTrue: [aUnit convert: aValue].
	range := aRange inUnit: aUnit.
	self is: value inRange: range]

{ #category : #'validation helpers' }
Validator >> is: value kindOf: aClass [
	(value isKindOf: aClass)
		ifFalse: [self failBecause: (self mustBeOfClass: aClass)]]

{ #category : #'validation helpers' }
Validator >> is: aTimestamp newerThanTimestamp: otherTimestamp [
	aTimestamp > otherTimestamp
		ifFalse: [self
			failBecause: (self shouldBeNewerThanTimestamp: otherTimestamp)]]

{ #category : #'validation helpers' }
Validator >> is: aValue notInRange: aRange [
	aRange isNil ifTrue: [^self].
	(aValue notNil andNot: [aValue isInRange: aRange]) ifFalse: [
		self
			failValidationBecause: self prettyPrint , ' should not be '
				, aRange conditionString]]

{ #category : #'validation helpers' }
Validator >> isArray: value [
	value isArray ifFalse: [self failBecause: self shouldBeArray]]

{ #category : #'validation helpers' }
Validator >> isBoolean: value [
	(value == true or: [value == false])
		ifFalse: [self failBecause: self shouldBeBoolean]]

{ #category : #'validation helpers' }
Validator >> isDate: value [
	(value isKindOf: Date)
		ifFalse: [self failValidationBecause: self dateIsRequired]]

{ #category : #'validation helpers' }
Validator >> isDefined: aValue [
	aValue isUndefinedValue ifTrue: [self failBecause: self isRequired]]

{ #category : #'validation helpers' }
Validator >> isFilename: value [
	value isFilename ifFalse: [self failBecause: self mustBeFilename]]

{ #category : #'validation helpers' }
Validator >> isInteger: value [
	value isInteger ifFalse: [self failBecause: self shouldBeInteger]]

{ #category : #'message patterns' }
Validator >> isInvalid [
	^self prettyPrint , ' is invalid']

{ #category : #private }
Validator >> isKnownIssue [
	^false]

{ #category : #'message patterns' }
Validator >> isMissing [
	^self prettyPrint isEmpty
		ifTrue: [^'No selection has been made']
		ifFalse: [^'No ' , self prettyPrint , ' selection has been made']]

{ #category : #'validation helpers' }
Validator >> isNonEmptyString: aValue [
	((aValue isText or: [aValue isString]) and: [aValue notEmpty])
		ifFalse: [self failValidationBecause: self isRequired]]

{ #category : #'validation helpers' }
Validator >> isNonFutureDate: aValue [
	((aValue isKindOf: Date) and: [aValue <= Date today])
		ifFalse: [self failValidationBecause: self cannotBeInTheFuture]]

{ #category : #'validation helpers' }
Validator >> isNonFutureTimestamp: aValue [
	((aValue isKindOf: Timestamp) and: [aValue <= Timestamp now])
		ifFalse: [self failValidationBecause: self cannotBeInTheFuture]]

{ #category : #'validation helpers' }
Validator >> isNonNegative: aNumber [
	(aNumber isNumber and: [aNumber isUndefinedValue not] and: [aNumber >= 0.0])
		ifFalse: [self failValidationBecause: self mustBeNonNegative]]

{ #category : #'validation helpers' }
Validator >> isNonNegativeInteger: aValue [
	(aValue isInteger and: [aValue >= 0])
		ifFalse: [self failValidationBecause: self mustBeNonNegativeInteger]]

{ #category : #'validation helpers' }
Validator >> isNonOldDate: aValue [
	((aValue isKindOf: Date) and: [aValue >= self broker minimumDate])
		ifFalse: [self failValidationBecause: self cannotBeOldDate]]

{ #category : #'validation helpers' }
Validator >> isNonOldTimestamp: aValue [
	((aValue isKindOf: Timestamp) and: [aValue asDate
		>= self broker minimumDate])
		ifFalse: [self failValidationBecause: self cannotBeOldDate]]

{ #category : #'validation helpers' }
Validator >> isNonPositive: aValue [
	(aValue isNumber and: [aValue isUndefinedValue not] and: [aValue <= 0.0])
		ifFalse: [self failValidationBecause: self mustBeNonPositive]]

{ #category : #'validation helpers' }
Validator >> isNotArray: value [
	value isArray ifFalse: [self failBecause: self shouldNotBeArray]]

{ #category : #'validation helpers' }
Validator >> isNotEmpty: aCollection [
	((aCollection isKindOf: Collection) and: [aCollection notEmpty])
		ifFalse: [self failValidationBecause: self mustBeNotEmpty]]

{ #category : #'validation helpers' }
Validator >> isNotZero: aValue [
	aValue = 0 ifTrue: [self failValidationBecause: self isZero]]

{ #category : #'validation helpers' }
Validator >> isNumber: aValue [
	aValue isNumber
		ifFalse: [self failValidationBecause: self numberIsRequired]]

{ #category : #'validation helpers' }
Validator >> isPositive: aValue [
	(aValue isNumber and: [aValue isUndefinedValue not] and: [aValue > 0.0])
		ifFalse: [self failValidationBecause: self mustBePositive]]

{ #category : #'validation helpers' }
Validator >> isPositiveInteger: aValue [
	(aValue isInteger and: [aValue > 0])
		ifFalse: [self failValidationBecause: self mustBePositiveInteger]]

{ #category : #'message patterns' }
Validator >> isRequired [
	^self prettyPrint , ' is required']

{ #category : #'validation helpers' }
Validator >> isString: value [
	value isString ifFalse: [self failBecause: self mustBeString]]

{ #category : #'validation helpers' }
Validator >> isTimestamp: aValue [
	(aValue isKindOf: Timestamp)
		ifFalse: [self failValidationBecause: self isRequired]]

{ #category : #'validation helpers' }
Validator >> isUndefined: aValue [
	aValue notNil
		ifTrue: [self failValidationBecause: self shouldNotBeSpecified]]

{ #category : #'validation helpers' }
Validator >> isValidDirectory: aFilename [
	self isDefined: aFilename.
	aFilename asFilename directoryExists
		ifFalse: [self
			failBecause: self prettyPrint , ' must point to an existing directory']]

{ #category : #'message patterns' }
Validator >> isZero [
	^self prettyPrint , ' must not be zero']

{ #category : #'validation helpers' }
Validator >> isZero: value [
	(value isNumber and: [value = 0.0])
		ifFalse: [self failBecause: self mustBeZero]]

{ #category : #object }
Validator >> minimumDate [
	^self broker minimumDate]

{ #category : #'message patterns' }
Validator >> mustBeAbove: aNumber [
	^self prettyPrint , ' must be greater than ' , aNumber printString]

{ #category : #'message patterns' }
Validator >> mustBeAlignedTo: alignment [
	^self prettyPrint , ' must be aligned to ' , alignment printString]

{ #category : #'message patterns' }
Validator >> mustBeAllNonNegative [
	^self prettyPrint , ' cannot have negative values']

{ #category : #'message patterns' }
Validator >> mustBeAllPositive [
	^self prettyPrint , ' must have positive values']

{ #category : #'message patterns' }
Validator >> mustBeBelow: aNumber [
	^self prettyPrint , ' must be less than ' , aNumber printString]

{ #category : #'message patterns' }
Validator >> mustBeFilename [
	^self prettyPrint , ' must be a filename']

{ #category : #'message patterns' }
Validator >> mustBeIncreasingAt: index [
	^self prettyPrint , ' does not increase at index ' , index printString]

{ #category : #'message patterns' }
Validator >> mustBeNonNegative [
	^self prettyPrint , ' must be greater than or equal to zero']

{ #category : #'message patterns' }
Validator >> mustBeNonNegativeInteger [
	^self prettyPrint , ' must be an integer greater or equal than zero']

{ #category : #'message patterns' }
Validator >> mustBeNonPositive [
	^self prettyPrint , ' must be less than or equal to zero']

{ #category : #'message patterns' }
Validator >> mustBeNotEmpty [
	^self prettyPrint , ' should have at least one element']

{ #category : #'message patterns' }
Validator >> mustBeOfClass: aClass [
	^self prettyPrint , ' must be kind of ' , aClass name]

{ #category : #'message patterns' }
Validator >> mustBePositive [
	^self prettyPrint , ' must be greater than zero']

{ #category : #'message patterns' }
Validator >> mustBePositiveInteger [
	^self prettyPrint , ' must be an integer greater than zero']

{ #category : #'message patterns' }
Validator >> mustBeString [
	^self prettyPrint, ' must be a String']

{ #category : #'message patterns' }
Validator >> mustBeZero [
	^self prettyPrint , ' must be zero']

{ #category : #'message patterns' }
Validator >> mustNotBeAbove: aNumber [
	^self prettyPrint , ' must not be greater than ' , aNumber printString]

{ #category : #'message patterns' }
Validator >> mustNotBeBelow: aNumber [
	^self prettyPrint , ' must not be less than ' , aNumber printString]

{ #category : #'validation helpers' }
Validator >> namesDoNotCollideIn: aCollection [
	| used key |
	used := Set new: aCollection size.
	aCollection do: [:each | 
		key := each name.
		(used includes: key)
			ifTrue: [self failBecause: (self hasCollidingName: each name)].
		used add: key]]

{ #category : #exceptions }
Validator >> newFailure: class for: anObject description: aString [
	^class new
		object: anObject;
		validator: self;
		aspect: self aspectForReporting;
		description: aString]

{ #category : #exceptions }
Validator >> newFailureFor: anObject description: aString [
	^self newFailure: ValidationFailure for: anObject description: aString]

{ #category : #exceptions }
Validator >> newInfoFor: anObject description: aString [
	^self newFailure: ValidationInfo for: anObject description: aString]

{ #category : #exceptions }
Validator >> newWarningFor: anObject description: aString [
	^self newFailure: ValidationWarning for: anObject description: aString]

{ #category : #'message patterns' }
Validator >> numberIsRequired [
	^self prettyPrint , ' must be a number']

{ #category : #setup }
Validator >> object [
	^object]

{ #category : #setup }
Validator >> object: anObject [
	object := anObject]

{ #category : #setup }
Validator >> object: anObject originalObject: anotherObject [
	self object: anObject; originalObject: anotherObject]

{ #category : #setup }
Validator >> originalObject [
	^originalObject]

{ #category : #setup }
Validator >> originalObject: anObject [
	originalObject isNil ifTrue: [originalObject := anObject]]

{ #category : #private }
Validator >> originalValue [
	^self originalObject perform: self aspect]

{ #category : #running }
Validator >> performTest [
	object triggerEvent: #aboutToValidate:with: with: object with: self.
	testSelector performOn: self]

{ #category : #accessors }
Validator >> prettyPrint [
	^prettyPrint ifNil: [self prettyPrintFor: aspect]]

{ #category : #accessors }
Validator >> prettyPrint: anObject [
	prettyPrint := anObject notNil ifTrue: [anObject asText]]

{ #category : #private }
Validator >> prettyPrintFor: aString [
	aString isNil ifTrue: [^''].
	^String streamContents: [:strm | 
		aString subwords
			do: [:w | strm nextPutAll: (w at: 1 put: w first asUppercase; yourself)]
			separatedBy: [strm space]]]

{ #category : #accessors }
Validator >> reportFailuresFor: aSymbol [
	reportFailureFor := aSymbol]

{ #category : #debugging }
Validator >> resignal [
	self debug]

{ #category : #'set up' }
Validator >> setUp [
	"
	Do nothing
	"
	]

{ #category : #'message patterns' }
Validator >> shouldBeArray [
	^self prettyPrint, ' must be an Array']

{ #category : #'message patterns' }
Validator >> shouldBeBoolean [
	^self prettyPrint, ' must be a Boolean']

{ #category : #'message patterns' }
Validator >> shouldBeDefined [
	^self prettyPrint, ' should be defined']

{ #category : #'message patterns' }
Validator >> shouldBeInteger [
	^self prettyPrint , ' must be an Integer']

{ #category : #'message patterns' }
Validator >> shouldBeNewerThanTimestamp: aTimestamp [
	^self prettyPrint , ' should be after ' , aTimestamp printString]

{ #category : #'message patterns' }
Validator >> shouldNotBeArray [
	^self prettyPrint, ' should not be an array']

{ #category : #'message patterns' }
Validator >> shouldNotBeSpecified [
	^self prettyPrint , ' should not be specified']

{ #category : #'message patterns' }
Validator >> shouldNotBeTable [
	^self prettyPrint, ' should not be a table']

{ #category : #'validation helpers' }
Validator >> sumIs1: value [
	^self sumIs1: value withTolerance: 0.0000000001]

{ #category : #'validation helpers' }
Validator >> sumIs1: value withTolerance: aNumber [
	(value sum - 1.0) abs < aNumber
		ifFalse: [self failBecause: self prettyPrint , ' must sum 1.0']]

{ #category : #'validation helpers' }
Validator >> sumIs100Percent: value [
	value sum ~ 1.0
		ifFalse: [self failBecause: self prettyPrint , ' must sum 100%']]

{ #category : #private }
Validator >> value [
	^[object perform: (aspect ifNil: #yourself)]
		on: MessageNotUnderstood
		do: [:ex | 
			ex message selector = aspect
				ifTrue: [object instVarNamed: aspect asString]
				ifFalse: [ex outer]]]

{ #category : #'validation helpers' }
Validator >> value: value belongsIn: aCollection [
	(aCollection includes: value)
		ifFalse: [self failBecause: (self doesntBelongIn: aCollection)]]

{ #category : #'validation helpers - values' }
Validator >> valueBelongsIn: aCollection [
	self value: self value belongsIn: aCollection]

{ #category : #'validation helpers - values' }
Validator >> valueIs: anObject [
	self is: self value equalTo: anObject]

{ #category : #'validation helpers - values' }
Validator >> valueIsAbove: bound [
	self value > bound ifFalse: [self failBecause: (self mustBeAbove: bound)]]

{ #category : #'validation helpers - values' }
Validator >> valueIsAbove: lowerLimit andBelow: upperLimit [
	self is: self value above: lowerLimit andBelow: upperLimit]

{ #category : #'validation helpers - values' }
Validator >> valueIsAlignedTo: alignment [
	| aligned |
	aligned := self value alignedTo: alignment.
	aligned = self value ifFalse: [self failBecause: (self mustBeAlignedTo: alignment)]]

{ #category : #'validation helpers - values' }
Validator >> valueIsArray [
	self isArray: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsBelow: bound [
	self value < bound ifFalse: [self failBecause: (self mustBeBelow: bound)]]

{ #category : #'validation helpers - values' }
Validator >> valueIsBetween: minValue and: maxValue [
	self is: self value between: minValue and: maxValue]

{ #category : #'validation helpers - values' }
Validator >> valueIsBoolean [
	self isBoolean: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsCloseTo: anObject [
	self is: self value closeTo: anObject]

{ #category : #'validation helpers - values' }
Validator >> valueIsDate [
	self isDate: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsDefined [
	self isDefined: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsFilename [
	self isFilename: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsInRange: aRange [
	self is: self value inRange: aRange]

{ #category : #'validation helpers - values' }
Validator >> valueIsInRange: aRange unit: aUnit [
	self is: self value inRange: aRange unit: aUnit]

{ #category : #'validation helpers - values' }
Validator >> valueIsInteger [
	self isInteger: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsKindOf: aClass [
	^self is: self value kindOf: aClass]

{ #category : #'validation helpers - values' }
Validator >> valueIsNewerThanTimestamp: aTimestamp [
	self is: self value newerThanTimestamp: aTimestamp]

{ #category : #'validation helpers - values' }
Validator >> valueIsNonEmptyString [
	self isNonEmptyString: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsNonFutureDate [
	self isNonFutureDate: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsNonFutureTimestamp [
	self isNonFutureTimestamp: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsNonNegative [
	self isNonNegative: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsNonNegativeInteger [
	self isNonNegativeInteger: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsNonOldDate [
	self isNonOldDate: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsNonOldTimestamp [
	self isNonOldTimestamp: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsNonPositive [
	self isNonPositive: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsNotAbove: bound [
	self value > bound ifTrue: [self failBecause: (self mustNotBeAbove: bound)]]

{ #category : #'validation helpers - values' }
Validator >> valueIsNotBelow: bound [
	self value < bound ifTrue: [self failBecause: (self mustNotBeBelow: bound)]]

{ #category : #'validation helpers - values' }
Validator >> valueIsNotEmpty [
	self isNotEmpty: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsNotZero [
	self isNotZero: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsNumber [
	self isNumber: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsPositive [
	self isPositive: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsPositiveInteger [
	self isPositiveInteger: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsString [
	self isString: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsTimestamp [
	self isTimestamp: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsUndefined [
	self isUndefined: self value]

{ #category : #'validation helpers - values' }
Validator >> valueIsZero [
	self isZero: self value]

{ #category : #'validation helpers - values' }
Validator >> valueNamesDoNotCollide [
	self namesDoNotCollideIn: self value]

{ #category : #'validation helpers - values' }
Validator >> valueNotEmpty [
	self isNotEmpty: self value]

{ #category : #'validation helpers - values' }
Validator >> valuesAreDefined [
	self areDefined: self value]

{ #category : #'validation helpers - values' }
Validator >> valuesAreDifferent [
	self areDifferent: self value]

{ #category : #'validation helpers - values' }
Validator >> valuesAreInRange: aRange [
	self are: self value inRange: aRange]

{ #category : #'validation helpers - values' }
Validator >> valuesAreKindOf: aClass [
	^self are: self value kindOf: aClass]

{ #category : #'validation helpers - values' }
Validator >> valuesAreNonNegative [
	self areNonNegative: self value]

{ #category : #'validation helpers - values' }
Validator >> valuesArePositive [
	self arePositive: self value]

{ #category : #'validation helpers - values' }
Validator >> valuesSumIs1 [
	self sumIs1: self value]

{ #category : #'validation helpers - values' }
Validator >> valuesSumIs100Percent [
	self sumIs100Percent: self value]

{ #category : #'validation helpers - values' }
Validator >> valuesSumIs1WithTolerance: aNumber [
	self sumIs1: self value withTolerance: aNumber]

{ #category : #'validation helpers - values' }
Validator >> valueValidate [
	self includeValidationOf: self value]

{ #category : #'validation helpers' }
Validator >> valueValidate: selectors [
	self includeValidationOf: self value for: selectors]

{ #category : #exceptions }
Validator >> warn: anObject because: aString [
	self warn: anObject because: aString resumable: true]

{ #category : #exceptions }
Validator >> warn: anObject because: aString resumable: aBoolean [
	| warning |
	warning := self newWarningFor: anObject description: aString.
	warning resumable: aBoolean; signalException]

{ #category : #exceptions }
Validator >> warnBecause: aString [
	self warn: self object because: aString]

{ #category : #queries }
Validator >> warnings [
	| answer |
	answer := OrderedCollection new.
	[self debugAsFailure] sunitOn: ValidationWarningException do: [:ex | 
		answer add: ex validationWarning.
		ex sunitExitWith: false].
	^answer]

