"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Object }

{ #category : '*Validations' }
Object class >> validatorClass [
	^DomainValidator]

{ #category : '*Validations' }
Object >> addValidationSelectorsTo: aCollection [
	"
	Do nothing
	"
	]

{ #category : '*Validations' }
Object >> passesValidation [
	^self validatorClass passes: self validation: [:v | | selectors |
		selectors := v class allTestSelectors.
		self addValidationSelectorsTo: selectors.
		selectors do: [:s | v testSelector: s; performTest]]]

{ #category : '*Validations' }
Object >> passesValidation: aBlock [
	^self validatorClass passes: self validation: aBlock]

{ #category : '*Validations' }
Object >> runValidation: selector [
	^self validatorClass validate: self selector: selector]

{ #category : '*Validations' }
Object >> runValidation: aSymbol with: argument [
	^self validatorClass validate: self selector: aSymbol with: argument]

{ #category : '*Validations' }
Object >> runValidation: aSymbol with: argument on: validationResult [
	^self validatorClass
		validate: self
		selector: aSymbol
		with: argument
		on: validationResult]

{ #category : '*Validations' }
Object >> runValidation: aSymbol with: arg1 with: arg2 [
	^self validatorClass validate: self selector: aSymbol with: arg1 with: arg2]

{ #category : '*Validations' }
Object >> runValidation: aSymbol withArguments: array [
	^self validatorClass validate: self selector: aSymbol withArguments: array]

{ #category : '*Validations' }
Object >> runValidations: selectors [
	^self validatorClass validate: self selectors: selectors]

{ #category : '*Validations' }
Object >> validate [
	^self validatorClass validate: self]

{ #category : '*Validations' }
Object >> validationSuite [
	^self validatorClass validationSuiteFor: self]

{ #category : '*Validations' }
Object >> validator [
	^self validatorClass new object: self]

{ #category : '*Validations' }
Object >> validatorClass [
	^self class validatorClass]

