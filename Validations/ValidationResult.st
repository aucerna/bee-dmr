"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ValidationResult,
	#superclass : #TestResult,
	#instVars : [
		'validationFailures',
		'validationWarnings',
		'validationInfo'
	],
	#category : #Validations
}

{ #category : #'instance creation' }
ValidationResult class >> error: anError [
	| failure result |
	failure := ValidationError new
		description: anError description , '

' , anError stacktrace.
	result := self new.
	result errors add: failure.
	^result]

{ #category : #'instance creation' }
ValidationResult class >> failBecause: aString [
	"
	ValidationResult failBecause: 'Todo mal'
	"
	| failure result |
	failure := ValidationFailure new description: aString.
	result := self new.
	result validationFailures add: failure.
	^result]

{ #category : #'instance creation' }
ValidationResult class >> warnBecause: aString [
	"
	ValidationResult warnBecause: 'Mmm....'
	"
	| failure result |
	failure := ValidationWarning new description: aString.
	result := self new.
	result validationWarnings add: failure.
	^result]

{ #category : #'instance creation' }
ValidationResult class >> withMessages: aCollection [
	^self new addMessages: aCollection]

{ #category : #adding }
ValidationResult >> addAll: aValidationResult [
	super addAll: aValidationResult.
	self validationFailures addAll: aValidationResult validationFailures.
	self validationWarnings addAll: aValidationResult validationWarnings.
	self validationInfo addAll: aValidationResult validationInfo]

{ #category : #adding }
ValidationResult >> addFailure: aValidationFailure [
	self validationFailures add: aValidationFailure]

{ #category : #adding }
ValidationResult >> addFailures: aValidationResult [
	self validationFailures addAll: aValidationResult validationFailures]

{ #category : #adding }
ValidationResult >> addInfo: aValidationInfo [
	self validationInfo add: aValidationInfo]

{ #category : #adding }
ValidationResult >> addMessage: aValidationFailure [
	aValidationFailure isInfo ifTrue: [^self addInfo: aValidationFailure].
	aValidationFailure isWarning ifTrue: [^self addWarning: aValidationFailure].
	^self addFailure: aValidationFailure]

{ #category : #adding }
ValidationResult >> addMessages: aCollection [
	aCollection do: [:m | self addMessage: m]]

{ #category : #adding }
ValidationResult >> addPassed: validation [
	passed notNil ifTrue: [passed add: validation]]

{ #category : #adding }
ValidationResult >> addWarning: aValidationWarning [
	self validationWarnings add: aValidationWarning]

{ #category : #inquiries }
ValidationResult >> allFailureDescriptions [
	^self allValidationFailures collect: [:f | f description]]

{ #category : #inquiries }
ValidationResult >> allValidationFailures [
	^OrderedCollection new
		addAll: (self errors collect: [:each | each]);
		addAll: (self failures collect: [:some | some]);
		addAll: self validationFailures;
		yourself]

{ #category : #inquiries }
ValidationResult >> anyFailure [
	^validationFailures isEmptyOrNil
		ifTrue: [self allValidationFailures anyone]
		ifFalse: [validationFailures anyone]]

{ #category : #inquiries }
ValidationResult >> anyFailureDescription [
	^self anyFailure ifNotNil: [:f | f description]]

{ #category : #accessing }
ValidationResult >> anyone [
	^self anyFailure]

{ #category : #accessing }
ValidationResult >> defaultImageName [
	self isEmpty ifTrue: [^nil].
	self hasValidationFailures ifTrue: [^'Failure'].
	self hasValidationWarnings ifTrue: [^'Exclamation21'].
	self hasValidationInfo ifTrue: [^'Information21'].
	self ASSERT: false.
	^nil]

{ #category : #accessing }
ValidationResult >> defaultLabel [
	self isEmpty ifTrue: [^nil].
	self hasValidationFailures ifTrue: [^'Failure'].
	self hasValidationWarnings ifTrue: [^'Warning'].
	self hasValidationInfo ifTrue: [^'Information'].
	self ASSERT: false.
	^nil]

{ #category : #inquiries }
ValidationResult >> defects [
	^super defects
		addAll: self validationFailures;
		addAll: self validationWarnings;
		yourself]

{ #category : #testing }
ValidationResult >> hasDefects [
	^self hasValidationFailures or: [self hasValidationWarnings]]

{ #category : #testing }
ValidationResult >> hasPassed [
	^super hasPassed and: [self hasValidationFailures not]]

{ #category : #testing }
ValidationResult >> hasValidationFailures [
	^self allValidationFailures notEmpty]

{ #category : #testing }
ValidationResult >> hasValidationInfo [
	^self validationInfo notEmpty]

{ #category : #testing }
ValidationResult >> hasValidationWarnings [
	^self validationWarnings notEmpty]

{ #category : #accessing }
ValidationResult >> ignoreFailures: aBlock [
	validationFailures notNil
		ifTrue: [validationFailures removeAllSuchThat: aBlock]]

{ #category : #accessing }
ValidationResult >> ignoreWarnings: aBlock [
	validationWarnings notNil
		ifTrue: [validationWarnings removeAllSuchThat: aBlock]]

{ #category : #testing }
ValidationResult >> isEmpty [
	^self hasPassed
		and: [self hasValidationWarnings not]
		and: [self hasValidationInfo not]]

{ #category : #testing }
ValidationResult >> isEmptyOrNil [
	^self isEmpty]

{ #category : #testing }
ValidationResult >> isFailure: aTestCase [
	^(super isFailure: aTestCase) or: [self validationFailures includes: aTestCase]]

{ #category : #testing }
ValidationResult >> isInfo: aTestCase [
	^self validationInfo includes: aTestCase]

{ #category : #testing }
ValidationResult >> isPassed: aTestCase [
	^passed isNil
		ifTrue: [(self defects includes: aTestCase) not]
		ifFalse: [super isPassed: aTestCase]]

{ #category : #testing }
ValidationResult >> isWarning: aTestCase [
	^self validationWarnings includes: aTestCase]

{ #category : #testing }
ValidationResult >> notEmpty [
	^self isEmpty not]

{ #category : #printing }
ValidationResult >> printFailuresOn: aStream [
	self validationFailures
		do: [:fail | fail printTextOn: aStream]
		separatedBy: [aStream cr]]

{ #category : #printing }
ValidationResult >> printOn: aStream [
	self allValidationFailures do: [:each | 
		aStream cr.
		each printOn: aStream].
	self validationWarnings do: [:each | 
		aStream cr.
		each printOn: aStream].
	self validationInfo do: [:each | 
		aStream cr.
		each printOn: aStream].]

{ #category : #printing }
ValidationResult >> printTextOn: aStream [
	self validationDescriptions
		do: [:each | each printTextOn: aStream]
		separatedBy: [aStream cr]]

{ #category : #private }
ValidationResult >> releaseValidators [
	validationFailures notNil
		ifTrue: [validationFailures do: [:v | v releaseValidator]].
	validationWarnings notNil
		ifTrue: [validationWarnings do: [:v | v releaseValidator]].
	validationInfo notNil
		ifTrue: [validationInfo do: [:v | v releaseValidator]]]

{ #category : #running }
ValidationResult >> runCase: aTestCase [
	| success |
	success := [
		aTestCase runCase.
		true]
		on: ValidationInfoException
		do: [:ex | | msg |
			msg := ex validationInfo.
			self validationInfo add: msg.
			ex resume: false]
		on: ValidationWarningException
		do: [:ex | | warning |
			warning := ex validationWarning.
			self validationWarnings add: warning.
			ex isResumable
				ifTrue: [ex resume: false]
				ifFalse: [ex sunitExitWith: false]]
		on: ValidationFailureException
		do: [:ex | | fail |
			fail := ex validationFailure.
			self validationFailures add: fail.
			ex sunitExitWith: false]
		on: ValidationBreak
		do: [:ex | ex sunitExitWith: false]
		on: self class failure
		do: [:ex | | fail |
			fail := ValidationFailure fromError: ex whileRunning: aTestCase.
			self failures add: fail.
			ex sunitExitWith: false].
	success ifTrue: [self addPassed: aTestCase]]

{ #category : #adding }
ValidationResult >> takeOut: aValidationResult [
	super takeOut: aValidationResult.
	self validationFailures
		removeAll: aValidationResult validationFailures
		ifAbsent: nil.
	self validationWarnings
		removeAll: aValidationResult validationWarnings
		ifAbsent: nil.
	self validationInfo
		removeAll: aValidationResult validationInfo
		ifAbsent: nil]

{ #category : #inquiries }
ValidationResult >> validationDescriptions [
	^Array streamContents: [:strm | 
		self validationFailures do: [:fail | strm nextPut: fail asText].
		self validationWarnings do: [:warn | strm nextPut: warn asText].
		self validationInfo do: [:msg | strm nextPut: msg asText]]]

{ #category : #accessing }
ValidationResult >> validationFailures [
	validationFailures isNil
		ifTrue: [validationFailures := OrderedCollection new].
	^validationFailures]

{ #category : #accessing }
ValidationResult >> validationFailures: aCollection [
	validationFailures := aCollection]

{ #category : #accessing }
ValidationResult >> validationInfo [
	validationInfo isNil
		ifTrue: [validationInfo := OrderedCollection new].
	^validationInfo]

{ #category : #accessing }
ValidationResult >> validationInfo: aCollection [
	validationInfo := aCollection]

{ #category : #inquiries }
ValidationResult >> validationMessages [
	| messages |
	messages := OrderedCollection new.
	self validationMessagesDo: [:m | messages add: m].
	^messages]

{ #category : #enumerating }
ValidationResult >> validationMessagesDo: aBlock [
	self validationInfo do: aBlock.
	self allValidationFailures do: aBlock.
	self validationWarnings do: aBlock]

{ #category : #accessing }
ValidationResult >> validationWarnings [
	validationWarnings isNil
		ifTrue: [validationWarnings := OrderedCollection new].
	^validationWarnings]

{ #category : #accessing }
ValidationResult >> validationWarnings: aCollection [
	validationWarnings := aCollection]

