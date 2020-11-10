"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlMathPrinter,
	#superclass : #FmlPrinter,
	#category : #FML
}

{ #category : #private }
FmlMathPrinter >> basicPrint: aString [
	| sub sup i prefix suffix j |
	sub := '*_[*]*' match: aString.
	sup := '*^[*]*' match: aString.
	(sub or: sup) ifFalse: [^self nextPutAll: aString].
	i := aString indexOfLastChar: $[.
	j := aString indexOfLastChar: $].
	i < j ifFalse: [self nextPutAll: aString].
	prefix := aString copyTo: i - 2.
	self nextPutAll: prefix.
	suffix := aString copyFrom: i + 1 to: j - 1.
	sub ifTrue: [self sub: suffix] ifFalse: [self super: suffix].
	j < aString size ifTrue: [self nextPutAll: (aString copyFrom: j + 1)]]

{ #category : #visiting }
FmlMathPrinter >> closeFunction: aString [
	aString = 'abs' ifTrue: [^writer nextPutAll: '|'].
	aString = 'floor' ifTrue: [^writer nextPutAll: '⌋'].
	aString = 'ceiling' ifTrue: [^writer nextPutAll: '⌉'].
	aString = 'squared' ifTrue: [^writer nextPutAll: ')^2'].
	self error: 'invalid function name']

{ #category : #private }
FmlMathPrinter >> delimit: aString [
	(self isDelimited: aString) ifTrue: [^aString].
	^'(' , aString , ')']

{ #category : #private }
FmlMathPrinter >> font [
	^writer GetSelection GetFont]

{ #category : #private }
FmlMathPrinter >> foreColor [
	^self font GetForeColor]

{ #category : #private }
FmlMathPrinter >> isDelimited: aString [
	aString isEmpty ifTrue: [^true].
	(aString conform: [:ch | ch isAlphanumeric]) ifTrue: [^true].
	(aString first = $( and: [aString last = $)]) ifTrue: [^true].
	(aString size > 1 and: [aString first = $'] and: [aString last = $'])
		ifTrue: [^true].
	(aString size > 1 and: [aString first = $"] and: [aString last = $"])
		ifTrue: [^true].
	^false]

{ #category : #visiting }
FmlMathPrinter >> isEnclosingFunction: aString [
	^#('abs' 'floor' 'ceiling' 'squared') includes: aString]

{ #category : #private }
FmlMathPrinter >> nextPut: aCharacter [
	writer nextPut: aCharacter]

{ #category : #private }
FmlMathPrinter >> nextPutAll: aString [
	writer nextPutAll: aString]

{ #category : #private }
FmlMathPrinter >> nextPutFunction: aString [
	aString = 'sqrt' ifTrue: [^writer nextPutAll: '√'].
	aString = 'exp' ifTrue: [^writer nextPutAll: 'e^'].
	aString = 'reciprocal' ifTrue: [^writer nextPutAll: '1/'].
	aString = 'log10' ifTrue: [^writer nextPutAll: 'log_10 '].
	self nextPutString: aString]

{ #category : #private }
FmlMathPrinter >> nextPutString: aString [
	writer nextPutAll: '"' , aString , '"']

{ #category : #visiting }
FmlMathPrinter >> openFunction: aString [
	aString = 'abs' ifTrue: [^writer nextPutAll: '|'].
	aString = 'floor' ifTrue: [^writer nextPutAll: '⌊'].
	aString = 'ceiling' ifTrue: [^writer nextPutAll: '⌈'].
	aString = 'squared' ifTrue: [^writer nextPutAll: '('].
	self error: 'invalid function name']

{ #category : #private }
FmlMathPrinter >> operatorOf: anFmlBinaryExpression [
	| op |
	op := anFmlBinaryExpression operatorString.
	op = #'>=' ifTrue: [^'≥'].
	op = #'<=' ifTrue: [^'≤'].
	^op]

{ #category : #private }
FmlMathPrinter >> pointSize [
	^self font GetSize]

{ #category : #private }
FmlMathPrinter >> position [
	^writer position]

{ #category : #services }
FmlMathPrinter >> print: aString color: aColor from: fmlExpression [
	self
		setCharColor: aColor;
		basicPrint: aString;
		setCharColor: Color black]

{ #category : #services }
FmlMathPrinter >> print: anFmlExpression on: aRichEdit [
	writer := aRichEdit tom2.
	self visit: anFmlExpression]

{ #category : #private }
FmlMathPrinter >> setCharColor: aColor [
	writer selectEnd.
	self font SetForeColor: aColor]

{ #category : #private }
FmlMathPrinter >> space [
	writer space]

{ #category : #private }
FmlMathPrinter >> sub: aString [
	| string |
	aString isEmpty ifTrue: [^self].
	string := self delimit: aString.
	self nextPutAll: '_' , string]

{ #category : #private }
FmlMathPrinter >> super: aString [
	| string |
	string := self delimit: aString.
	self nextPutAll: '^' , string]

{ #category : #private }
FmlMathPrinter >> useColor: aColor fontSize: anInteger while: aBlock [
	| color size |
	color := self foreColor.
	size := self font GetSize.
	[
		self font SetSize: anInteger; SetForeColor: aColor.
		aBlock value]
		ensure: [self font SetSize: size; SetForeColor: color]]

{ #category : #visiting }
FmlMathPrinter >> visitArray: anFmlArray [
	self nextPutAll: '\#('.
	anFmlArray value do: [:each | self visit: each] separatedBy: [self space].
	self nextPut: $)]

{ #category : #visiting }
FmlMathPrinter >> visitBinary: anFmlBinaryExpression [
	| left right op |
	left := anFmlBinaryExpression left.
	right := anFmlBinaryExpression right.
	anFmlBinaryExpression precedence > left precedence
		ifTrue: [
			self
				nextPut: $(;
				visit: left;
				nextPut: $)]
		ifFalse: [self visit: left].
	op := self operatorOf: anFmlBinaryExpression.
	self
		setCharColor: Color darkBlue;
		nextPutAll: op;
		setCharColor: Color black.
	right isNil ifTrue: [^self].
	(anFmlBinaryExpression precedence >= right precedence or: [op = '^'])
		ifTrue: [
			self
				nextPut: $(;
				visit: right;
				setCharColor: Color black;
				nextPut: $)]
		ifFalse: [self visit: right]]

{ #category : #visiting }
FmlMathPrinter >> visitEnclosingFunction: aFmlFunctionCall [
	self
		setCharColor: Color darkBlue;
		openFunction: aFmlFunctionCall name;
		setCharColor: Color black;
		visit: aFmlFunctionCall arguments anyone;
		setCharColor: Color darkBlue;
		closeFunction: aFmlFunctionCall name;
		setCharColor: Color black]

{ #category : #visiting }
FmlMathPrinter >> visitFmlBoolean: anFmlValue [
	self
		print: anFmlValue value asString doubleQuoted
		color: Color brown darker
		from: anFmlValue]

{ #category : #visiting }
FmlMathPrinter >> visitFmlNumber: fmlNumber [
	| number unit u color string |
	number := fmlNumber displayValue.
	unit := fmlNumber basicUnit.
	self setCharColor: Color brown darker.
	string := number floor = number
		ifTrue: [number floor asString]
		ifFalse: [number asString replaceAll: '.' with: self decimalSeparator].
	self nextPutAll: string; setCharColor: Color black.
	(units and: [fmlNumber showsUnitOn: writer])
		ifTrue: [
			self space.
			u := '[' , (unit isString ifTrue: [unit] ifFalse: [fmlNumber unit id])
				, ']'.
			color := (unit isString or: [unit isInvalidUnit])
				ifTrue: [Color red]
				ifFalse: [self foreColor].
			self
				useColor: color
				fontSize: self pointSize - 1
				while: [self nextPutAll: u]]
		ifFalse: [self nextPutAll: u]]

{ #category : #visiting }
FmlMathPrinter >> visitFmlString: anFmlString [
	self
		print: '"' , anFmlString value storeString , '"'
		color: Color blue
		from: anFmlString]

{ #category : #visiting }
FmlMathPrinter >> visitFmlUndefined: anFmlValue [
	self print: 'Undefined' color: Color red muchDarker from: anFmlValue]

{ #category : #visiting }
FmlMathPrinter >> visitFunctionCall: anFmlFunctionCall [
	| first mspace |
	(self isEnclosingFunction: anFmlFunctionCall name)
		ifTrue: [^self visitEnclosingFunction: anFmlFunctionCall].
	first := true.
	self
		setCharColor: Color darkBlue;
		nextPutFunction: anFmlFunctionCall name;
		setCharColor: Color black;
		nextPut: $(.
	mspace := 16r205F asCharacter.
	anFmlFunctionCall arguments do: [:each | 
		first ifTrue: [first := false] ifFalse: [
			self
				setCharColor: Color black;
				nextPutAll: self dataSeparator;
				nextPut: mspace].
		self visit: each].
	anFmlFunctionCall arguments isEmpty ifTrue: [self nextPut: mspace].
	self setCharColor: Color black; nextPut: $)]

{ #category : #visiting }
FmlMathPrinter >> visitValue: anFmlValue [
	self
		print: anFmlValue value asString
		color: anFmlValue color
		from: anFmlValue]

{ #category : #visiting }
FmlMathPrinter >> visitVariableName: anFmlVariableName [
	| name index base sub |
	self nextPutAll: '"\"" "'.
	name := anFmlVariableName fullName.
	index := name indexOfString: '_['.
	(index > 0 and: [name endsWith: ']'])
		ifTrue: [
			base := name copyFrom: 1 to: index - 1.
			sub := name copyFrom: index + 2 to: name size - 1]
		ifFalse: [
			base := name.
			sub := ''].
	self
		print: base color: anFmlVariableName color from: anFmlVariableName;
		nextPutAll: '" "\""';
		sub: sub]

