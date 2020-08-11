"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RadixSortTest,
	#superclass : #TestCase,
	#category : #'NumericalMethods\Tests'
}

{ #category : #'sorting integers' }
RadixSortTest >> testEmpty [
	| array |
	array := #() copy.
	RadixSort sort: array.
	self assert: array isEmpty]

{ #category : #'sorting strings' }
RadixSortTest >> testEmptyS [
	| array |
	array := #() copy.
	RadixStringSort sort: array.
	self assert: array isEmpty]

{ #category : #'sorting integers' }
RadixSortTest >> testNegative [
	| array |
	array := #(170 45 75 90 802 24 -2 -6) copy.
	RadixSort sort: array.
	self assert: array isIncreasing]

{ #category : #'sorting integers' }
RadixSortTest >> testSingle [
	| array |
	array := #(127) copy.
	RadixSort sort: array.
	self assert: array = #(127)]

{ #category : #'sorting strings' }
RadixSortTest >> testSingleS [
	| array |
	array := #('Hello') copy.
	RadixStringSort sort: array.
	self assert: array = #('Hello')]

{ #category : #'sorting integers' }
RadixSortTest >> testSort [
	| array |
	array := #(170 45 75 90 802 24 2 6) copy.
	RadixSort sort: array.
	self assert: array isIncreasing]

{ #category : #'sorting strings' }
RadixSortTest >> testSortS [
	| array |
	array := 'Finding the substring pattern P of length m in the string S of length n takes'
		substrings.
	RadixStringSort sort: array.
	self assert: array isNonDecreasing]

