"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SimpsonMethod,
	#superclass : #Object,
	#instVars : [
		'f',
		'a',
		'b',
		'n',
		'integral'
	],
	#category : #NumericalMethods
}

{ #category : #input }
SimpsonMethod >> a: aNumber [
	a := aNumber]

{ #category : #input }
SimpsonMethod >> b: aNumber [
	b := aNumber]

{ #category : #computing }
SimpsonMethod >> compute [
	| h s yi |
	h := b - a / n.
	s := (f valueAt: a) + (f valueAt: b).
	1 to: n by: 2 do: [:i | | xi |
		xi := h * i + a.
		yi := f valueAt: xi.
		s := s + (4.0 * yi)].
	2 to: n - 1 by: 2 do: [:i | | xi |
		xi := h * i + a.
		yi := f valueAt: xi.
		s := s + (2.0 * yi)].
	integral := s * h / 3.0]

{ #category : #input }
SimpsonMethod >> f: aFunction [
	f := aFunction]

{ #category : #output }
SimpsonMethod >> integral [
	^integral]

{ #category : #input }
SimpsonMethod >> n: anInteger [
	n := anInteger]

