"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlPlainPrinter,
	#superclass : #FmlPrettyPrinter,
	#category : #FML
}

{ #category : #initialization }
FmlPlainPrinter >> initialize [
	super initialize.
	separators := Array with: ', ' with: '.']

{ #category : #services }
FmlPlainPrinter >> print: aString color: aColor from: fmlExpression [
	fmlExpression propertyAt: #startPos put: writer position.
	writer nextPutAll: aString.
	fmlExpression propertyAt: #endPos put: writer position]

{ #category : #visiting }
FmlPlainPrinter >> visitBinary: anFmlBinaryExpression [
	| left right |
	left := anFmlBinaryExpression left.
	right := anFmlBinaryExpression right.
	anFmlBinaryExpression precedence > left precedence
		ifTrue: [
			writer nextPut: $(.
			self visit: left.
			writer nextPut: $)]
		ifFalse: [self visit: left].
	writer space; nextPutAll: anFmlBinaryExpression operatorString; space.
	right isNil ifTrue: [^self].
	anFmlBinaryExpression precedence >= right precedence
		ifTrue: [
			writer nextPut: $(.
			self visit: right.
			writer nextPut: $)]
		ifFalse: [self visit: right]]

{ #category : #visiting }
FmlPlainPrinter >> visitFmlNumber: anFmlNumber [
	| number unit u |
	anFmlNumber propertyAt: #startPos put: writer position.
	number := anFmlNumber displayValue.
	unit := anFmlNumber basicUnit.
	number floor = number
		ifTrue: [number floor printOn: writer]
		ifFalse: [number printOn: writer separatedBy: self decimalSeparator].
	(units and: [anFmlNumber showsUnitOn: writer]) ifTrue: [
		writer space.
		u := '[' , (unit isString ifTrue: [unit] ifFalse: [anFmlNumber unit id])
			, ']'.
		writer nextPutAll: u].
	anFmlNumber propertyAt: #endPos put: writer position]

{ #category : #visiting }
FmlPlainPrinter >> visitFunctionCall: aFmlFunctionCall [
	| first |
	first := true.
	writer nextPutAll: aFmlFunctionCall name.
	writer nextPut: $(.
	aFmlFunctionCall arguments do: [:each | 
		first
			ifTrue: [first := false]
			ifFalse: [writer nextPutAll: self dataSeparator].
		self visit: each].
	writer nextPut: $)]

