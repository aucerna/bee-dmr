Class {
	#name : #ZeroDivide,
	#superclass : #ArithmeticError,
	#instVars : [
		'#dividend'
	],
	#category : #Kernel
}

{ #category : #accessing }
ZeroDivide >> dividend [
	^dividend
]

{ #category : #accessing }
ZeroDivide >> dividend: aNumber [
	dividend := aNumber
]

{ #category : #initialization }
ZeroDivide >> initialize [
	super initialize.
]

{ #category : #testing }
ZeroDivide >> isResumable [
	^true
]

{ #category : #accessing }
ZeroDivide >> operation: aSymbol [
	super operation: aSymbol.
]
