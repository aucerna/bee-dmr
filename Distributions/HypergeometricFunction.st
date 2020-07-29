"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HypergeometricFunction,
	#superclass : #Object,
	#instVars : [
		'a',
		'b',
		'c'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
HypergeometricFunction class >> a: a b: b c: c [
	^self new
		a: a;
		b: b;
		c: c]

{ #category : #bibliography }
HypergeometricFunction class >> references [
	ShellDLL current
		openWebPage: 'http://www.efunda.com/math/hypergeometric/hypergeometric.cfm']

{ #category : #accessing }
HypergeometricFunction >> a: aNumber [
	a := aNumber asFloat]

{ #category : #accessing }
HypergeometricFunction >> b: aNumber [
	b := aNumber asFloat]

{ #category : #accessing }
HypergeometricFunction >> c: aNumber [
	c := aNumber asFloat]

{ #category : #evaluating }
HypergeometricFunction >> evaluateWith: z [
	^self valueAt: z]

{ #category : #accessing }
HypergeometricFunction >> minValue [
	^0.00001]

{ #category : #printing }
HypergeometricFunction >> printOn: aStream [
	aStream
		nextPutAll: '2F1(';
		nextPutAll: a printString;
		nextPutAll: ', ';
		nextPutAll: b printString;
		nextPutAll: ', ';
		nextPutAll: c printString;
		nextPutAll: '; z)']

{ #category : #printing }
HypergeometricFunction >> printTextOn: rtf [
	rtf
		sub: '2';
		nextPutAll: 'F';
		sub: '1';
		nextPut: $(;
		nextPutAll: a printString;
		nextPutAll: ', ';
		nextPutAll: b printString;
		nextPutAll: ', ';
		nextPutAll: c printString;
		nextPutAll: '; z)']

{ #category : #evaluating }
HypergeometricFunction >> valueAt: z [
	| term s n k |
	term := a / c * b * z.
	s := 1.0 + term.
	n := 1.0.
	k := 1.
	[| p |
		p := a + n / (c + n) * (b + n * z / (1.0 + n)).
		term := term * p.
		s := s + term.
		n := n + 1.0.
		k = 5000 or: [term abs < (s abs * 0.1e-20)]]
		whileFalse: [k := k + 1].
	^s]

