"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlBinaryExpression,
	#superclass : #FmlExpression,
	#instVars : [
		'left',
		'operator',
		'right'
	],
	#category : #FML
}

{ #category : #'instance creation' }
FmlBinaryExpression class >> left: leftExpression operator: symbol right: rightExpression [
	^self new
		left: leftExpression asFmlExpression;
		operator: symbol;
		right: rightExpression asFmlExpression]

{ #category : #accessing }
FmlBinaryExpression class >> logicalOperators [
	^self strictOperators , #(#'=' #'<=' #'>=' #equals: #& #| #~)]

{ #category : #accessing }
FmlBinaryExpression class >> strictOperators [
	^#(#'<' #'>' #'<>')]

{ #category : #comparing }
FmlBinaryExpression >> = aFmlBinaryExpression [
	^self class == aFmlBinaryExpression class
		and: [operator = aFmlBinaryExpression operator]
		and: [left = aFmlBinaryExpression left]
		and: [right = aFmlBinaryExpression right]]

{ #category : #visiting }
FmlBinaryExpression >> acceptVisitor: fmlVisitor [
	fmlVisitor visitBinary: self]

{ #category : #validation }
FmlBinaryExpression >> addMagicConstantsTo: aCollection [
	(operator = #'*' and: [left isLiteral] and: [left canBeConsideredPercent])
		ifFalse: [left addMagicConstantsTo: aCollection].
	(operator = #'*' and: [right isLiteral] and: [right canBeConsideredPercent])
		ifFalse: [right addMagicConstantsTo: aCollection]]

{ #category : #validation }
FmlBinaryExpression >> addNumericLiteralsTo: aCollection [
	(operator = #'*' and: [left isLiteral] and: [left canBeConsideredPercent])
		ifFalse: [left addNumericLiteralsTo: aCollection].
	(operator = #'*' and: [right isLiteral] and: [right canBeConsideredPercent])
		ifFalse: [right addNumericLiteralsTo: aCollection]]

{ #category : #private }
FmlBinaryExpression >> applyOperatorToLeftUnit: lu right: ru [
	| s |
	s := operator.
	(s == #raisedTo: and: [right hasOnlyConstants]) ifTrue: [
		right value = 1 ifTrue: [s := #yourself].
		right value = 2 ifTrue: [s := #squared].
		right value = 3 ifTrue: [s := #cubic]].
	^(lu respondsTo: s)
		ifTrue: [s arity = 1
			ifTrue: [lu perform: s with: ru]
			ifFalse: [lu perform: s]]]

{ #category : #accessing }
FmlBinaryExpression >> arguments [
	^{left. right}]

{ #category : #evaluation }
FmlBinaryExpression >> bindContext: aModelObject [
	left bindContext: aModelObject.
	right bindContext: aModelObject]

{ #category : #testing }
FmlBinaryExpression >> canBeConsideredPercent: fmlChildNode [
	^operator = #'*'
		and: [fmlChildNode isLiteral]
		and: [fmlChildNode canBeConsideredPercent]]

{ #category : #inquiries }
FmlBinaryExpression >> complexityOn: d [
	^(left complexityOn: d) max: (right complexityOn: d)]

{ #category : #accessing }
FmlBinaryExpression >> do: aBlock [
	aBlock value: self.
	left do: aBlock.
	right do: aBlock]

{ #category : #evaluation }
FmlBinaryExpression >> evaluateAt: index [
	^((left evaluateAt: index) asFmlValue
		perform: operator
		with: (right evaluateAt: index) asFmlValue) value]

{ #category : #evaluation }
FmlBinaryExpression >> evaluateLiterals [
	| exp |
	exp := self class
		left: left evaluateLiterals
		operator: operator
		right: right evaluateLiterals.
	^exp hasOnlyConstants ifTrue: [exp value asFmlValue] ifFalse: [exp]]

{ #category : #evaluation }
FmlBinaryExpression >> evaluateWith: aFmlEvaluator [
	| first |
	first := aFmlEvaluator evaluate: left.
	first isUndefinedValue ifTrue: [^first].
	^first perform: operator with: (aFmlEvaluator evaluate: right)]

{ #category : #grammar }
FmlBinaryExpression >> factors [
	^(#(#*) includes: operator)
		ifTrue: [left factors , right factors]
		ifFalse: [super factors]]

{ #category : #comparing }
FmlBinaryExpression >> hash [
	^left hashWith: right with: operator]

{ #category : #testing }
FmlBinaryExpression >> hasNumericLiterals [
	^left hasNumericLiterals or: [right hasNumericLiterals]]

{ #category : #testing }
FmlBinaryExpression >> hasOnlyConstants [
	^left hasOnlyConstants and: [right hasOnlyConstants]]

{ #category : #accessing }
FmlBinaryExpression >> inferredUnit [
	| lu ru |
	self isBooleanExpression ifTrue: [^BooleanUnit defaultInstance].
	lu := left inferredUnit.
	ru := right inferredUnit.
	(lu isNil or: [ru isNil]) ifTrue: [
		(#(#+ #-) includes: operator) ifTrue: [^lu ifNil: [ru]].
		(lu isNil and: [ru notNil] and: [left hasOnlyConstants])
			ifTrue: [lu := NumberUnit baseUnit].
		(ru isNil and: [lu notNil] and: [right hasOnlyConstants])
			ifTrue: [ru := NumberUnit baseUnit]].
	(lu isNil or: [ru isNil]) ifTrue: [^nil].
	^self applyOperatorToLeftUnit: lu right: ru]

{ #category : #private }
FmlBinaryExpression >> inferredUnitFor: exp from: aUnit and: otherUnit [
	| date u |
	u := self isBooleanExpression ifTrue: [^otherUnit].
	#'\\' == operator
		ifTrue: [^exp == left
			ifTrue: [aUnit]
			ifFalse: [NumberUnit defaultInstance]].
	date := aUnit notNil
		and: [aUnit isDateUnit]
		and: [otherUnit notNil]
		and: [otherUnit isDateUnit].
	date ifTrue: [^TimeUnit day].
	u := (#(#+ #-) includes: operator) ifTrue: [otherUnit ifNil: [aUnit]].
	u notNil ifTrue: [^u].
	u := aUnit notNil & otherUnit notNil ifTrue: [
		(exp == left or: [self isCommutative])
			ifTrue: [self inverseOperator
				ifNotNil: [:op | aUnit perform: op with: otherUnit]]
			ifFalse: [otherUnit perform: operator with: aUnit]].
	(u isNil and: [self canBeConsideredPercent: exp])
		ifTrue: [u := PercentUnit defaultInstance].
	^u]

{ #category : #accessing }
FmlBinaryExpression >> inverseOperator [
	operator == #'+' ifTrue: [^#'-'].
	operator == #'-' ifTrue: [^#'+'].
	operator == #'*' ifTrue: [^#'/'].
	operator == #'/' ifTrue: [^#'*'].
	operator == #'//' ifTrue: [^#'*'].
	operator == #raisedTo: ifTrue: [^nil].
	operator == #'\\' ifTrue: [^nil].
	self ASSERT: false.
	^nil]

{ #category : #testing }
FmlBinaryExpression >> isArrayValued [
	^left isArrayValued or: [right isArrayValued]]

{ #category : #testing }
FmlBinaryExpression >> isBinaryExpression [
	^true]

{ #category : #testing }
FmlBinaryExpression >> isBooleanExpression [
	^self class logicalOperators includes: operator]

{ #category : #testing }
FmlBinaryExpression >> isCommutative [
	^#(#+ #* #=) includes: operator]

{ #category : #testing }
FmlBinaryExpression >> isComparison [
	^#(#= #> #< #<= #>= #equals: #<>) includes: operator]

{ #category : #testing }
FmlBinaryExpression >> isConstant [
	^left isConstant and: [right isConstant]]

{ #category : #testing }
FmlBinaryExpression >> isIncreasing [
	self isComparison ifTrue: [^false].
	left isIncreasing ifTrue: [
		operator == #'+' ifTrue: [^right isConstant or: [right isIncreasing]].
		operator == #'*' ifTrue: [
			^right isNumeric
				and: [right isConstant or: [right isIncreasing]]
				and: [right value > 0]]].
	(left isConstant andNot: [left evaluate isUndefinedValue]) ifFalse: [^false].
	operator == #'+' ifTrue: [^right isIncreasing].
	operator == #'*' ifFalse: [^false].
	left isNumeric ifFalse: [^false].
	(left value > 0 and: [right isIncreasing]) ifTrue: [^true].
	(left value < 0 and: [right isDecreasing]) ifTrue: [^true].
	^false]

{ #category : #testing }
FmlBinaryExpression >> isLike: anFmlExpression [
	self class == anFmlExpression class ifFalse: [^false].
	self = anFmlExpression ifTrue: [^true].
	operator = anFmlExpression operator ifFalse: [^false].
	((left isLike: anFmlExpression left)
		and: [right isLike: anFmlExpression right])
		ifTrue: [^true].
	self isCommutative ifFalse: [^false].
	(left isLike: anFmlExpression right) ifFalse: [^false].
	^right isLike: anFmlExpression left]

{ #category : #testing }
FmlBinaryExpression >> isReachCondition [
	(#(#> #< #<= #>=) includes: operator) ifFalse: [^false].
	(left isIncreasing and: [right isConstant]) ifTrue: [^true].
	(left isConstant and: [right isIncreasing]) ifTrue: [^true].
	^false]

{ #category : #accessing }
FmlBinaryExpression >> left [
	^left]

{ #category : #accessing }
FmlBinaryExpression >> left: aFmlExpression [
	left := aFmlExpression]

{ #category : #accessing }
FmlBinaryExpression >> mainFunction [
	^operator]

{ #category : #evaluation }
FmlBinaryExpression >> neededVariablesDo: aBlock visited: aCollection [
	left neededVariablesDo: aBlock visited: aCollection.
	right neededVariablesDo: aBlock visited: aCollection]

{ #category : #accessing }
FmlBinaryExpression >> nodes [
	^{left. right}]

{ #category : #'logical operations' }
FmlBinaryExpression >> not [
	| index op |
	self isBooleanExpression ifFalse: [^self cannotEvaluate: 'not'].
	index := #(#'<' #'=' #'>' #'<=' #'>=' #'<>' #equals:) indexOf: operator.
	op := #(#'>=' #'<>' #'<=' #'>' #'<' #'=' #'<>') at: index.
	^self class new
		operator: op;
		left: left;
		right: right]

{ #category : #accessing }
FmlBinaryExpression >> operator [
	^operator]

{ #category : #accessing }
FmlBinaryExpression >> operator: aSymbol [
	operator := aSymbol reduced.
	operator == #'=' ifTrue: [operator := #equals:].
	operator == #'^' ifTrue: [operator := #raisedTo:]]

{ #category : #accessing }
FmlBinaryExpression >> operatorString [
	operator == #equals: ifTrue: [^'='].
	operator == #raisedTo: ifTrue: [^'^' ].
	^operator]

{ #category : #translations }
FmlBinaryExpression >> parenthesizedTranslateUsing: aFmlTranslator atColumn: index [
	^'(' , (self translateUsing: aFmlTranslator atColumn: index) , ')']

{ #category : #copying }
FmlBinaryExpression >> postCopy [
	left := left copy.
	right := right copy]

{ #category : #evaluation }
FmlBinaryExpression >> precedence [
	operator = #raisedTo: ifTrue: [^3].
	(#(#* #/ #//) includes: operator) ifTrue: [^2].
	(#(#> #>= #= #< #<=) includes: operator) ifTrue: [^0].
	^1]

{ #category : #accessing }
FmlBinaryExpression >> receiver [
	^left]

{ #category : #services }
FmlBinaryExpression >> removeFactor: anFmlExpression [
	| e1 e2 e |
	(#(#+ #-) includes: operator) ifTrue: [
		e1 := left removeFactor: anFmlExpression.
		e2 := right removeFactor: anFmlExpression.
		^self class left: e1 operator: operator right: e2].
	operator == #'*' ifFalse: [^super removeFactor: anFmlExpression].
	(left isLike: anFmlExpression) ifTrue: [^right].
	(right isLike: anFmlExpression) ifTrue: [^left].
	e := left removeFactor: anFmlExpression.
	(left isLike: e) ifFalse: [
		^(e isLike: 1 asFmlValue)
			ifTrue: [right]
			ifFalse: [self class left: e operator: operator right: right]].
	e := right removeFactor: anFmlExpression.
	(right isLike: e) ifFalse: [
		^(e isLike: 1 asFmlValue)
			ifTrue: [left]
			ifFalse: [self class left: left operator: operator right: e]].
	^self]

{ #category : #renaming }
FmlBinaryExpression >> replaceNode: anFmlExpression with: anotherFmlExpression [
	left = anFmlExpression
		ifTrue: [left := anotherFmlExpression]
		ifFalse: [left replaceNode: anFmlExpression with: anotherFmlExpression].
	right = anFmlExpression
		ifTrue: [right := anotherFmlExpression]
		ifFalse: [right replaceNode: anFmlExpression with: anotherFmlExpression]]

{ #category : #evaluation }
FmlBinaryExpression >> resultType [
	^left resultType * right resultType]

{ #category : #accessing }
FmlBinaryExpression >> right [
	^right]

{ #category : #accessing }
FmlBinaryExpression >> right: aFmlExpression [
	right := aFmlExpression]

{ #category : #validation }
FmlBinaryExpression >> setLiteralUnitsFrom: aUnit [
	| unit |
	unit := aUnit ifNil: [self inferredUnit].
	left hasNumericLiterals
		ifTrue: [self setLiteralUnitsTo: left from: unit and: right unit].
	right hasNumericLiterals
		ifTrue: [self setLiteralUnitsTo: right from: unit and: left unit]]

{ #category : #validation }
FmlBinaryExpression >> setLiteralUnitsTo: exp from: aUnit and: otherUnit [
	| u |
	u := self inferredUnitFor: exp from: aUnit and: otherUnit.
	exp setLiteralUnitsFrom: u]

{ #category : #grammar }
FmlBinaryExpression >> terms [
	^(#(#+ #-) includes: operator)
		ifTrue: [
			operator = #'+'
				ifTrue: [left terms , right terms]
				ifFalse: [left terms , (right terms collect: #negated)]]
		ifFalse: [super terms]]

{ #category : #translations }
FmlBinaryExpression >> translateUsing: aFmlTranslator [
	^aFmlTranslator translateBinaryExpression: self
	]

{ #category : #translations }
FmlBinaryExpression >> translateUsing: anFmlExcelTranslator atColumn: index [
	| op rcvr arg |
	op := anFmlExcelTranslator translateOperator: operator.
	rcvr := left
		parenthesizedTranslateUsing: anFmlExcelTranslator
		atColumn: index.
	arg := right
		parenthesizedTranslateUsing: anFmlExcelTranslator
		atColumn: index.
	^(anFmlExcelTranslator hasInfixOperatorFor: op)
		ifTrue: [rcvr , ' ' , op , ' ' , arg]
		ifFalse: [op , '(' , rcvr , ', ' , arg , ')']]

{ #category : #accessing }
FmlBinaryExpression >> unit [
	| candidate lu ru |
	self isBooleanExpression ifTrue: [^BooleanUnit defaultInstance].
	lu := left unit.
	ru := right unit.
	(lu isNil or: [ru isNil])
		ifTrue: [^(#(#+ #-) includes: operator) ifTrue: [lu ifNil: [ru]]].
	^(lu respondsTo: operator) ifTrue: [
		candidate := [lu perform: operator with: ru]
			on: MessageNotUnderstood
			do: [:err | err halt].
		(candidate isKindOf: Unit) ifTrue: [candidate]]]

{ #category : #accessing }
FmlBinaryExpression >> unitForConstant: aFmlValue [
	left = aFmlValue ifTrue: [^right unit].
	right = aFmlValue ifTrue: [^left unit].
	^(left unitForConstant: aFmlValue) ifNil: [right unitForConstant: aFmlValue]]

{ #category : #testing }
FmlBinaryExpression >> wasConditionReached [
	(operator == #'<' or: [operator == #'<='])
		ifTrue: [self evaluate value ifFalse: [^true]].
	(operator == #'>' or: [operator == #'>='])
		ifTrue: [self evaluate value ifTrue: [^true]].
	^false]

