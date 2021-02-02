"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ValidationSuite,
	#superclass : #TestSuite,
	#category : #Validations
}

{ #category : #accessors }
ValidationSuite >> object [
	^self tests anyone object]

{ #category : #accessors }
ValidationSuite >> object: anObject [
	self object: anObject originalObject: nil]

{ #category : #accessors }
ValidationSuite >> object: anObject originalObject: anotherObject [
	self tests
		do: [:each | each object: anObject originalObject: anotherObject]]

{ #category : #accessors }
ValidationSuite >> originalObject: anObject [
	self tests do: [:each | each originalObject: anObject]]

{ #category : #printing }
ValidationSuite >> printOn: aStream [
	name isNil
		ifTrue: [super printOn: aStream]
		ifFalse: [name printOn: aStream]]

{ #category : #running }
ValidationSuite >> run [
	| result |
	result := ValidationResult new.
	self run: result.
	^result]

{ #category : #running }
ValidationSuite >> run: aValidationResult [
	super run: aValidationResult.
	tests notEmpty ifTrue: [tests last object triggerEvent: #justValidated]]

{ #category : #running }
ValidationSuite >> runForAll: aCollection [
	| result |
	result := ValidationResult new.
	self resources do: [:resource | resource beAvailableFor: self].
	aCollection do: [:item | 
		[
			tests do: [:test | 
				test object: item.
				stop == true ifTrue: [^result].
				test run: result]]
			sunitEnsure: [self resources do: [:resource | resource reset]]].
	^result]

{ #category : #testing }
ValidationSuite >> stopped [
	^stop == true]

{ #category : #accessors }
ValidationSuite >> suite [
	^self]

