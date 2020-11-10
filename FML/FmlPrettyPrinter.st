"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlPrettyPrinter,
	#superclass : #FmlPrinter,
	#instVars : [
		'indent',
		'separators'
	],
	#category : #FML
}

{ #category : #private }
FmlPrettyPrinter >> basicPrint: aString [
	| sub sup i prefix suffix j |
	sub := '*_[*]*' match: aString.
	sup := '*^[*]*' match: aString.
	(sub or: sup) ifFalse: [^writer nextPutAll: aString].
	i := aString indexOfLastChar: $[.
	j := aString indexOfLastChar: $].
	i < j ifFalse: [writer nextPutAll: aString].
	prefix := aString copyTo: i - 2.
	writer nextPutAll: prefix.
	suffix := aString copyFrom: i + 1 to: j - 1.
	sub ifTrue: [writer sub: suffix] ifFalse: [writer super: suffix].
	j < aString size ifTrue: [writer nextPutAll: (aString copyFrom: j + 1)]]

{ #category : #private }
FmlPrettyPrinter >> dataSeparator [
	^separators first]

{ #category : #private }
FmlPrettyPrinter >> dataSeparator: aString [
	| string |
	string := (aString endsWith: ' ') ifTrue: [aString] ifFalse: [aString , ' '].
	separators at: 1 put: string]

{ #category : #accessing }
FmlPrettyPrinter >> decimalSeparator [
	^separators second]

{ #category : #private }
FmlPrettyPrinter >> decimalSeparator: aString [
	separators at: 2 put: aString]

{ #category : #accessing }
FmlPrettyPrinter >> indent: anInteger [
	indent := anInteger]

{ #category : #initialization }
FmlPrettyPrinter >> initialize [
	super initialize.
	separators := {Locale current dataSeparator , ' '.
		Locale current decimalSeparator}]

{ #category : #accessing }
FmlPrettyPrinter >> prettyPrint [
	^writer contents]

{ #category : #private }
FmlPrettyPrinter >> print: aString color: aColor from: fmlExpression [
	fmlExpression propertyAt: #startPos put: writer position.
	writer setCharColor: aColor.
	self basicPrint: aString.
	fmlExpression propertyAt: #endPos put: writer position.
	writer setCharColor: Color black]

{ #category : #visiting }
FmlPrettyPrinter >> visitArray: anFmlArray [
	writer nextPutAll: '#('.
	anFmlArray value
		do: [:each | self visitArrayElement: each]
		separatedBy: [writer space].
	writer nextPut: $)]

{ #category : #visiting }
FmlPrettyPrinter >> visitArrayElement: anObject [
	| string |
	string := String streamContents: [:strm | 
		anObject
			printOn: strm
			dataSeparator: self dataSeparator
			decimalSeparator: self decimalSeparator].
	writer nextPutAll: string]

{ #category : #visiting }
FmlPrettyPrinter >> visitBinary: anFmlBinaryExpression [
	| left right rtf |
	left := anFmlBinaryExpression left.
	right := anFmlBinaryExpression right.
	anFmlBinaryExpression precedence > left precedence
		ifTrue: [
			writer nextPut: $(.
			self visit: left.
			writer nextPut: $)]
		ifFalse: [self visit: left].
	rtf := writer isKindOf: Rtf.
	rtf ifTrue: [writer setCharColor: Color darkBlue].
	writer space; nextPutAll: anFmlBinaryExpression operatorString; space.
	rtf ifTrue: [writer setCharColor: Color black].
	right isNil ifTrue: [^self].
	anFmlBinaryExpression precedence >= right precedence
		ifTrue: [
			writer nextPut: $(.
			self visit: right.
			writer nextPut: $)]
		ifFalse: [self visit: right]]

{ #category : #visiting }
FmlPrettyPrinter >> visitFmlNumber: anFmlNumber [
	| number unit u color |
	anFmlNumber propertyAt: #startPos put: writer position.
	number := anFmlNumber displayValue.
	unit := anFmlNumber basicUnit.
	writer setCharColor: Color brown darker.
	number floor = number
		ifTrue: [number floor printOn: writer]
		ifFalse: [number printOn: writer separatedBy: self decimalSeparator].
	writer setCharColor: Color black.
	(units and: [anFmlNumber showsUnitOn: writer]) ifTrue: [
		u := '[' , (unit isString ifTrue: [unit] ifFalse: [anFmlNumber unit id])
			, ']'.
		color := (unit isString or: [unit isInvalidUnit])
			ifTrue: [Color red]
			ifFalse: [writer color].
		writer
			space;
			useColor: color
			fontSize: writer font pointSize - 1
			while: [writer nextPutAll: u]].
	anFmlNumber propertyAt: #endPos put: writer position]

{ #category : #visiting }
FmlPrettyPrinter >> visitFmlString: anFmlString [
	self
		print: anFmlString value storeString
		color: Color blue
		from: anFmlString]

{ #category : #visiting }
FmlPrettyPrinter >> visitFmlUndefined: anFmlValue [
	self print: 'Undefined' color: Color red muchDarker from: anFmlValue]

{ #category : #visiting }
FmlPrettyPrinter >> visitFunctionCall: anFmlFunctionCall [
	| first |
	first := true.
	writer
		setCharColor: Color darkBlue;
		nextPutAll: anFmlFunctionCall name;
		setCharColor: Color black;
		nextPut: $(.
	anFmlFunctionCall arguments do: [:each | 
		first
			ifTrue: [first := false]
			ifFalse: [writer nextPutAll: self dataSeparator].
		self visit: each].
	writer nextPut: $)]

{ #category : #visiting }
FmlPrettyPrinter >> visitValue: anFmlValue [
	self
		print: anFmlValue value asString
		color: anFmlValue color
		from: anFmlValue]

{ #category : #visiting }
FmlPrettyPrinter >> visitVariableName: anFmlVariableName [
	self
		print: anFmlVariableName fullName doubleQuoted
		color: anFmlVariableName color
		from: anFmlVariableName]

