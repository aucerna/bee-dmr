"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlDisentangler,
	#superclass : #Object,
	#instVars : [
		'input',
		'expression',
		'nodes',
		'mapping',
		'full'
	],
	#category : #FML
}

{ #category : #'instance creation' }
FmlDisentangler class >> fromFile [
	"
	FmlDisentangler fromFile
	"
	| filename |
	filename := FileDialog new openFile: '*.txt'; file.
	^filename notNil ifTrue: [self fromFile: filename]]

{ #category : #'instance creation' }
FmlDisentangler class >> fromFile: aFilename [
	| file |
	file := aFilename asFilename asFile readStream.
	^[self new fromStream: file] ensure: [file close]]

{ #category : #'instance creation' }
FmlDisentangler class >> new [
	^super new initialize]

{ #category : #validation }
FmlDisentangler class >> validatorClass [
	^FmlDisentanglerValidator]

{ #category : #private }
FmlDisentangler >> allUsersOf: xi [
	| users |
	users := self usersOf: xi.
	(expression variableNames asSet includes: xi)
		ifTrue: [users add: #expression].
	^users]

{ #category : #simplifying }
FmlDisentangler >> apply [
	mapping do: [:assoc | self apply: assoc key]]

{ #category : #simplifying }
FmlDisentangler >> apply: xi [
	| fml |
	fml := self expressionFor: xi.
	expression replaceNode: fml with: xi.
	mapping
		select: [:assoc | assoc key ~= xi]
		thenDo: [:assoc | assoc value replaceNode: fml with: xi]]

{ #category : #accessing }
FmlDisentangler >> auxiliaryVariables [
	^mapping collect: #key]

{ #category : #testing }
FmlDisentangler >> canInline [
	^mapping notEmpty]

{ #category : #entangling }
FmlDisentangler >> checkEntanglement [
	self entangle.
	^expression printString = input asFmlExpression printString]

{ #category : #simplifying }
FmlDisentangler >> cleanUp [
	mapping removeAllSuchThat: [:assoc | (self allUsersOf: assoc key) isEmpty].
	self computeNodes]

{ #category : #outputs }
FmlDisentangler >> compressMapping [
	| block x n bindings map y |
	(self auxiliaryVariables conform: [:xi | | si |
		si := xi fullName.
		si size > 1
			and: [si first = $X]
			and: [si allButFirst conform: [:ch | ch isDigit]]])
		ifFalse: [self error: 'Not implemented yet'].
	block := [:xi :xj | xi fullName allButFirst asInteger
		< xj fullName allButFirst asInteger].
	x := self auxiliaryVariables sortBy: block.
	n := x size.
	bindings := OrderedCollection new: n.
	x withIndexDo: [:xi :i | | yi |
		yi := ('Y' , i printString) variableName.
		bindings add: xi -> yi].
	self remapWith: bindings.
	map := OrderedCollection new: n.
	y := (bindings collect: #value) sortBy: block.
	y withIndexDo: [:yi :i | | xi |
		xi := ('X' , i printString) variableName.
		map add: yi -> xi].
	self remapWith: map]

{ #category : #private }
FmlDisentangler >> computeExpression [
	expression := input asFmlExpression]

{ #category : #private }
FmlDisentangler >> computeNodes [
	| bag |
	bag := Bag new.
	expression
		allNodesDo: [:node | (self isReplaceable: node) ifTrue: [bag add: node]].
	mapping do: [:assoc | 
		assoc value
			allNodesDo: [:node | (self isReplaceable: node) ifTrue: [bag add: node]]].
	nodes := bag frequencies]

{ #category : #simplifying }
FmlDisentangler >> discardVariable [
	| varnames users xi xk |
	varnames := expression variableNames asSet.
	xi := self auxiliaryVariables
		detect: [:xj | 
			users := self usersOf: xj.
			users size = 1 andNot: [varnames includes: xj]]
		ifNone: [^false].
	xk := users anyone.
	self inline: xi in: xk.
	self cleanUp.
	^true]

{ #category : #simplifying }
FmlDisentangler >> discardVariables [
	[self discardVariable] whileTrue]

{ #category : #entangling }
FmlDisentangler >> entangle [
	self auxiliaryVariables do: [:xi | self inline: xi]]

{ #category : #accessing }
FmlDisentangler >> expression [
	^expression]

{ #category : #accessing }
FmlDisentangler >> expressionFor: xi [
	mapping select: [:assoc | assoc key = xi] thenDo: [:assoc | ^assoc value].
	^nil]

{ #category : #accessing }
FmlDisentangler >> fromStream: aStream [
	self input: aStream contents]

{ #category : #accessing }
FmlDisentangler >> full: aBoolean [
	full := aBoolean]

{ #category : #initialization }
FmlDisentangler >> initialize [
	super initialize.
	self input: ''.
	mapping := OrderedCollection new.
	full := false]

{ #category : #simplifying }
FmlDisentangler >> inline: xi [
	| fml users |
	fml := self expressionFor: xi.
	expression replaceNode: xi with: fml.
	users := self usersOf: xi.
	self DENY: (users includes: xi).
	users do: [:xj | self inline: xi in: xj].
	self cleanUp]

{ #category : #simplifying }
FmlDisentangler >> inline: xi in: xj [
	| fml user j binding |
	fml := self expressionFor: xi.
	user := self expressionFor: xj.
	user replaceNode: xi with: fml.
	j := mapping findFirst: [:assoc | assoc key = xj].
	binding := mapping at: j.
	binding value: user]

{ #category : #accessing }
FmlDisentangler >> input [
	^input]

{ #category : #accessing }
FmlDisentangler >> input: aString [
	| string separator |
	string := aString trimBlanks.
	separator := FmlParser defaultDataSeparator.
	input := ((string includes: $;) andNot: [string includes: separator])
		ifTrue: [string replaceAll: ';' with: separator asString]
		ifFalse: [string].
	self computeExpression]

{ #category : #testing }
FmlDisentangler >> isFull [
	^full]

{ #category : #testing }
FmlDisentangler >> isReducible [
	^self nextPattern notNil]

{ #category : #testing }
FmlDisentangler >> isReplaceable: anFmlExpression [
	anFmlExpression isLeafNode ifTrue: [^false].
	anFmlExpression = expression ifTrue: [^false].
	full ifFalse: [
		(anFmlExpression isBinaryExpression
			and: [anFmlExpression left isNumber or: [anFmlExpression right isNumber]])
			ifTrue: [^false]].
	^true]

{ #category : #accessing }
FmlDisentangler >> map: xi to: fml [
	| binding |
	binding := mapping detect: [:assoc | assoc key = xi].
	binding value: fml]

{ #category : #accessing }
FmlDisentangler >> mapping [
	^mapping]

{ #category : #private }
FmlDisentangler >> newVariableFor: aFmlVariableName [
	| n vn |
	n := mapping size + 1.
	[| existed |
		vn := ('X' , n printString) variableName.
		existed := self expressionFor: vn.
		existed notNil]
		whileTrue: [n := n + 1].
	mapping add: vn -> aFmlVariableName copy.
	^vn]

{ #category : #private }
FmlDisentangler >> nextPattern [
	| max candidates patterns |
	self computeNodes.
	nodes isEmpty ifTrue: [^nil].
	max := nodes max.
	max <= 1 ifTrue: [^nil].
	candidates := nodes keys select: [:node | (nodes at: node) = max].
	max := candidates maxValue: [:node | node variableNames size].
	patterns := candidates
		select: [:node | node variableNames size = max]
		in: OrderedCollection new.
	patterns sortBy: [:a :b | a asString < b asString].
	^patterns anyone]

{ #category : #outputs }
FmlDisentangler >> occurrencesOf: xi [
	| count |
	count := expression asString occurrencesOfSubcollection: xi asString.
	mapping select: [:assoc | assoc key ~= xi] thenDo: [:assoc | | occurrences |
		occurrences := assoc value asString
			occurrencesOfSubcollection: xi asString.
		count := count + occurrences].
	^count]

{ #category : #outputs }
FmlDisentangler >> output [
	^expression asString]

{ #category : #simplifying }
FmlDisentangler >> reduce [
	| prev pattern |
	prev := nil.
	[
		pattern := self nextPattern.
		pattern notNil]
		whileTrue: [
			self DENY: prev = pattern.
			self reduceWith: pattern.
			prev := pattern]]

{ #category : #simplifying }
FmlDisentangler >> reduceWith: pattern [
	| xi |
	xi := self newVariableFor: pattern.
	self apply: xi]

{ #category : #private }
FmlDisentangler >> remapWith: bindings [
	| map |
	bindings do: [:assoc | | xi yi |
		xi := assoc key.
		yi := assoc value.
		expression replaceReferencesTo: xi with: yi.
		mapping do: [:pair | | fml |
			fml := pair value.
			fml replaceReferencesTo: xi with: yi]].
	map := OrderedCollection new.
	bindings do: [:assoc | | fml |
		fml := self expressionFor: assoc key.
		map add: assoc value -> fml].
	mapping := map]

{ #category : #services }
FmlDisentangler >> renameVariable: xi to: x [
	| bind bindings |
	(self auxiliaryVariables includes: x) ifTrue: [^self].
	bindings := OrderedCollection streamContents: [:strm | 
		mapping do: [:assoc | | xj |
			xj := assoc key.
			bind := xj = xi ifTrue: [xj -> x] ifFalse: [xj -> xj copy].
			strm nextPut: bind]].
	self remapWith: bindings]

{ #category : #accessing }
FmlDisentangler >> restart [
	self entangle]

{ #category : #outputs }
FmlDisentangler >> singleReverseOf: fml [
	| auxiliary xi v copy |
	auxiliary := self auxiliaryVariables.
	xi := fml variableNames
		detect: [:vn | auxiliary includes: vn]
		ifNone: [^fml].
	v := self expressionFor: xi.
	fml isLeafNode ifTrue: [^v].
	copy := fml copy.
	copy replaceNode: xi with: v.
	^copy]

{ #category : #simplifying }
FmlDisentangler >> step [
	self reduceWith: self nextPattern]

{ #category : #simplifying }
FmlDisentangler >> usersOf: xi [
	^mapping
		select: [:assoc | assoc value variableNames asSet includes: xi]
		thenCollect: [:assoc | assoc key]]

