"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RadixStringSort,
	#superclass : #RadixSort,
	#category : #NumericalMethods
}

{ #category : #computing }
RadixStringSort >> buildOutputFor: index [
	| null |
	null := Character value: min codePoint - 1.
	n to: 1 by: -1 do: [:i | | si j c ch |
		si := input at: i.
		ch := si at: index ifAbsent: null.
		j := ch asLowercase codePoint - min + 2.
		c := count at: j.
		count at: j sum: -1.
		output at: c put: si]]

{ #category : #computing }
RadixStringSort >> computeMax [
	min := max := (input at: 1 ifAbsent: Character null asString) asLowercase min.
	1 to: n do: [:i | | ai mx mn |
		ai := (input at: i) asLowercase.
		mx := ai max.
		mn := ai min.
		max < mx ifTrue: [max := mx] ifFalse: [mn < min ifTrue: [min := mn]]]]

{ #category : #computing }
RadixStringSort >> countFor: index [
	| null |
	null := Character value: min codePoint - 1.
	1 to: n do: [:i | | si ch |
		si := input at: i.
		ch := si at: index ifAbsent: null.
		count at: ch asLowercase codePoint - min + 2 sum: 1]]

{ #category : #accessing }
RadixStringSort >> on: anArray [
	input := anArray.
	n := input size.
	output := Array new: n.
	self computeMax.
	count := Array new: max - min + 2]

{ #category : #sorting }
RadixStringSort >> sort [
	| i |
	n = 0 ifTrue: [^self].
	i := input maxValue: [:s | s size].
	[i > 0] whileTrue: [
		self countSort: i.
		i := i - 1]]

