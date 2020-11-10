"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlSynopsis,
	#superclass : #Object,
	#instVars : [
		'input',
		'expression',
		'mapping',
		'output',
		'units'
	],
	#category : #FML
}

{ #category : #'instance creation' }
FmlSynopsis class >> new [
	^super new initialize]

{ #category : #'instance creation' }
FmlSynopsis class >> on: aString [
	^self on: aString withUnits: false]

{ #category : #'instance creation' }
FmlSynopsis class >> on: aString withUnits: aBoolean [
	^self new input: aString; showUnits: aBoolean; synopsis]

{ #category : #computing }
FmlSynopsis >> applyMutations [
	| mutator copy |
	mutator := FmlFunctionMutator new.
	mutator mutate: 'raisedTo' to: #'^'.
	copy := mutator visit: expression copy; expression.
	mutator mutate: #'//' to: #'"//"'.
	output := mutator visit: copy copy; expression]

{ #category : #private }
FmlSynopsis >> characterClosing: aCharacter [
	aCharacter = $( ifTrue: [^$)].
	aCharacter = $[ ifTrue: [^$]].
	aCharacter = ${ ifTrue: [^$}].
	^aCharacter]

{ #category : #computing }
FmlSynopsis >> compute [
	| groups |
	self reset; applyMutations.
	output variableNames withoutDuplicates do: [:vn | self mapVariable: vn].
	groups := output variableNames groupBy: #yourself.
	groups keysAndValuesDo: [:vn :group | | xi |
		xi := mapping at: vn.
		group do: [:v | | var |
			var := v variable.
			v
				renameTo: xi variableName;
				instVarNamed: 'variable' put: var]]]

{ #category : #accessing }
FmlSynopsis >> defaultNameFor: aFmlVariableName [
	| name |
	name := aFmlVariableName lastName.
	('([{' noneSatisfy: [:ch | name includes: ch])
		ifTrue: [^self initialsFor: name].
	^String streamContents: [:strm | | reader |
		reader := name readStream.
		[reader atEnd] whileFalse: [| piece initials opening closing |
			piece := reader untilAnySatisfying: [:ch | '([{' includes: ch].
			initials := self initialsFor: piece.
			strm nextPutAll: initials.
			reader atEnd ifFalse: [
				opening := reader next.
				strm nextPut: opening.
				closing := self characterClosing: opening.
				piece := reader upToClosing: opening with: closing.
				piece := self defaultNameFor: piece variableName.
				strm nextPutAll: piece; nextPut: closing]]]]

{ #category : #initialize }
FmlSynopsis >> initialize [
	super initialize.
	mapping := Dictionary new.
	units := false]

{ #category : #accessing }
FmlSynopsis >> initialsFor: aString [
	^String streamContents: [:strm | 
		aString substrings do: [:s | 
			strm nextPut: s first asLowercase.
			(s conform: #isUppercase) ifFalse: [
				2 to: s size do: [:i | | ci |
					ci := s at: i.
					ci isUppercase ifTrue: [strm nextPut: ci asLowercase]]]]]]

{ #category : #input }
FmlSynopsis >> input: anFmlExpression [
	(anFmlExpression isKindOf: FmlExpression)
		ifTrue: [
			expression := anFmlExpression.
			input := expression asString]
		ifFalse: [self inputString: anFmlExpression].
	self reset]

{ #category : #private }
FmlSynopsis >> inputString: aString [
	| string separator |
	string := aString trimBlanks.
	separator := FmlParser defaultDataSeparator.
	input := ((string includes: $;) andNot: [string includes: separator])
		ifTrue: [string replaceAll: ';' with: separator asString]
		ifFalse: [string].
	expression := input asFmlExpression]

{ #category : #computing }
FmlSynopsis >> mapVariable: anFmlVariableName [
	| x max letters vn xj |
	x := self defaultNameFor: anFmlVariableName.
	letters := x size.
	max := -1.
	mapping select: [:xi | (xi upTo: $_) = x] thenDo: [:xi | | n |
		n := xi allButFirst: letters.
		(n beginsWith: '_[') ifTrue: [n := n allButFirst: '_[' size].
		max := max max: n asInteger].
	xj := max = -1 ifTrue: [x] ifFalse: [
		max = 0
			ifTrue: [
				vn := mapping keyAtValue: x.
				mapping at: vn put: x , '_[1]'.
				x , '_[2]']
			ifFalse: [x , '_[' , (max + 1) printString , ']']].
	mapping at: anFmlVariableName copy put: xj.
	xj propertyAt: #varname put: anFmlVariableName asString]

{ #category : #accessing }
FmlSynopsis >> output [
	output isNil ifTrue: [self compute].
	^output]

{ #category : #computing }
FmlSynopsis >> reset [
	mapping removeAll.
	output := nil]

{ #category : #testing }
FmlSynopsis >> showsUnits [
	^units]

{ #category : #input }
FmlSynopsis >> showUnits: aBoolean [
	units := aBoolean.
	self reset]

{ #category : #output }
FmlSynopsis >> synopsis [
	| rtf |
	rtf := Rtf new setFont: GDIFont defaultTextFont.
	self synopsisOn: rtf.
	^rtf]

{ #category : #output }
FmlSynopsis >> synopsisOn: aStream [
	| class |
	class := aStream isWindow
		ifTrue: [FmlMathPrinter]
		ifFalse: [FmlPrettyPrinter].
	class new
		printUnits: units;
		print: self output on: aStream]

{ #category : #accessing }
FmlSynopsis >> variableFor: aString [
	| string reader n |
	reader := aString readStream.
	n := reader upTo: $"; upTo: $".
	string := reader atEnd ifTrue: [n] ifFalse: [
		self ASSERT: (reader peekFor: $ ).
		n , '_[' , reader upToEnd , ']'].
	^mapping keyAtValue: string]

