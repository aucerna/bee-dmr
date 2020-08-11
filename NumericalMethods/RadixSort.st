"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RadixSort,
	#superclass : #Object,
	#instVars : [
		'input',
		'output',
		'count',
		'n',
		'max',
		'min'
	],
	#category : #NumericalMethods
}

{ #category : #sorting }
RadixSort class >> sort: anArray [
	| cls |
	anArray isEmpty ifTrue: [^self].
	cls := anArray first isInteger
		ifTrue: [RadixSort]
		ifFalse: [RadixStringSort].
	cls new on: anArray; sort]

{ #category : #computing }
RadixSort >> buildOutputFor: exp [
	n to: 1 by: -1 do: [:i | | ai j c |
		ai := input at: i.
		j := ai // exp \\ 10 + 1.
		c := count at: j.
		count at: j sum: -1.
		output at: c put: ai]]

{ #category : #computing }
RadixSort >> computeMax [
	| offset |
	min := max := input at: 1 ifAbsent: 0.
	2 to: n do: [:i | | ai |
		ai := input at: i.
		max < ai ifTrue: [max := ai] ifFalse: [ai < min ifTrue: [min := ai]]].
	min < 0 ifTrue: [
		offset := min negated.
		1 to: n do: [:i | input at: i sum: offset]]]

{ #category : #computing }
RadixSort >> computePositions [
	2 to: count size do: [:i | count at: i sum: (count at: i - 1)]]

{ #category : #computing }
RadixSort >> countFor: exp [
	1 to: n do: [:i | | ai |
		ai := input at: i.
		count at: ai // exp \\ 10 + 1 sum: 1]]

{ #category : #computing }
RadixSort >> countSort: exp [
	self
		reset;
		countFor: exp;
		computePositions;
		buildOutputFor: exp;
		readOutput]

{ #category : #accessing }
RadixSort >> on: anArray [
	input := anArray.
	n := input size.
	output := Array new: n.
	count := Array new: 10]

{ #category : #computing }
RadixSort >> readOutput [
	1 to: n do: [:i | input at: i put: (output at: i)]]

{ #category : #accessing }
RadixSort >> reset [
	count atAllPut: 0]

{ #category : #sorting }
RadixSort >> sort [
	| exp |
	self computeMax.
	exp := 1.
	[max // exp > 0] whileTrue: [
		self countSort: exp.
		exp := exp * 10].
	min < 0 ifTrue: [1 to: n do: [:i | input at: i sum: min]]]

