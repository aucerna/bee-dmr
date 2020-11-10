"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlFunctionCall,
	#superclass : #FmlExpression,
	#instVars : [
		'name',
		'arguments',
		'definition'
	],
	#category : #FML
}

{ #category : #'instance creation' }
FmlFunctionCall class >> name: aString arguments: aCollection [
	^self new 
		name: aString; 
		arguments: aCollection]

{ #category : #'instance creation' }
FmlFunctionCall class >> named: aString [
	^self new name: aString]

{ #category : #comparing }
FmlFunctionCall >> = aFmlFunction [
	(self class == aFmlFunction class
		and: [name = aFmlFunction name]
		and: [arguments size = aFmlFunction arguments size])
		ifFalse: [^false].
	1
		to: arguments size
		do: [:i | (arguments at: i) = (aFmlFunction arguments at: i) ifFalse: [^false]].
	^true]

{ #category : #visiting }
FmlFunctionCall >> acceptVisitor: fmlVisitor [
	fmlVisitor visitFunctionCall: self]

{ #category : #validation }
FmlFunctionCall >> addMagicConstantsTo: aCollection [
	self functionDefinition addMagicConstantsOf: self to: aCollection]

{ #category : #validation }
FmlFunctionCall >> addNumericLiteralsTo: aCollection [
	self functionDefinition addNumericLiteralsOf: self to: aCollection]

{ #category : #accessing }
FmlFunctionCall >> argument [
	^arguments size = 1 ifTrue: [arguments anyone]]

{ #category : #services }
FmlFunctionCall >> argumentAt: index refersToColumn: aString [
	| def arg |
	definition isTableFunction ifFalse: [^false].
	def := definition argumentAt: index.
	def refersToColumn ifFalse: [^false].
	arg := arguments at: index.
	^arg isFmlString and: [arg value = aString]]

{ #category : #accessing }
FmlFunctionCall >> arguments [
	^arguments]

{ #category : #accessing }
FmlFunctionCall >> arguments: aCollection [
	arguments := aCollection asArray.
	self functionDefinition checkArity: self.]

{ #category : #evaluation }
FmlFunctionCall >> argumentsEvaluatedWith: anFmlEvaluator [
	| args |
	args := self messageArguments.
	args := (#('if' 'and' 'or') includes: name)
		ifTrue: [args collect: [:arg | arg lazyEvaluate]]
		ifFalse: [args collect: [:arg | anFmlEvaluator evaluate: arg]].
	(definition hasOpenArity andNot: [definition isAssociative])
		ifTrue: [args := {args}].
	^args]

{ #category : #accessing }
FmlFunctionCall >> arity [
	^self functionDefinition symbol arity + 1]

{ #category : #evaluation }
FmlFunctionCall >> bindContext: aModelObject [
	arguments do: [:fml | fml bindContext: aModelObject]]

{ #category : #testing }
FmlFunctionCall >> canBeInlined [
	"Can I be inlined as an argument in my parent expression?"
	^self functionDefinition resultType ~~ FmlArray]

{ #category : #testing }
FmlFunctionCall >> canBeOptimized [
	^FmlFunctionCall subclasses anySatisfy: [:cls | cls canOptimize: self]]

{ #category : #'file in/out' }
FmlFunctionCall >> clearSurrogate [
	definition := nil]

{ #category : #inquiries }
FmlFunctionCall >> complexityOn: d [
	arguments isEmpty ifTrue: [^0].
	^arguments
		inject: nil
		into: [:result :each | result max: (each complexityOn: d)]]

{ #category : #accessing }
FmlFunctionCall >> definition: anFmlFunctionDefinition [
	definition := anFmlFunctionDefinition]

{ #category : #enumerating }
FmlFunctionCall >> do: aBlock [
	aBlock value: self.
	arguments do: [:exp | exp do: aBlock]]

{ #category : #evaluation }
FmlFunctionCall >> evaluateAt: index [
	| def args receiver function result |
	def := self functionDefinition.
	function := def symbol.
	result := def distributesIndex
		ifTrue: [
			args := self messageArguments
				collect: [:each | each lazyEvaluateAt: index].
			receiver := (self messageReceiver evaluateAt: index) asFmlValue.
			def isAssociative
				ifTrue: [
					args
						inject: receiver
						into: [:answer :arg | answer performFunction: function with: arg]]
				ifFalse: [receiver performFunction: function withArgs: args]]
		ifFalse: [
			args := self messageArguments
				collect: [:each | each lazyEvaluate asFmlValue].
			self messageReceiver lazyEvaluate asFmlValue
				performFunction: function
				withArgs: args
				atColumn: index].
	^result evaluated value]

{ #category : #evaluation }
FmlFunctionCall >> evaluateLiterals [
	| exp receiver arg |
	name = 'if' ifTrue: [
		receiver := arguments first evaluateLiterals.
		receiver hasOnlyConstants ifTrue: [
			arg := receiver value
				ifTrue: [arguments second]
				ifFalse: [arguments third].
			^arg evaluateLiterals]].
	exp := self class
		name: name
		arguments: (arguments collect: #evaluateLiterals).
	exp hasOnlyConstants ifTrue: [^exp value asFmlValue].
	^exp canBeOptimized ifTrue: [exp optimize] ifFalse: [exp]]

{ #category : #evaluation }
FmlFunctionCall >> evaluateWith: anFmlEvaluator [
	| function args receiver |
	function := definition symbol.
	[
		args := self argumentsEvaluatedWith: anFmlEvaluator.
		receiver := self receiverEvaluatedWith: anFmlEvaluator]
		on: FmlMissingVariable
		do: [:e | function == #isDefined ifTrue: [e resume] ifFalse: [e pass]].
	^definition isAssociative
		ifTrue: [
			args inject: receiver into: [:r :a | | result |
				result := r performFunction: function with: a.
				result evaluated]]
		ifFalse: [| result |
			result := receiver performFunction: function withArgs: args.
			result evaluated]]

{ #category : #'file in/out' }
FmlFunctionCall >> fileInActivate [
	super fileInActivate.
	self initializeDefinition]

{ #category : #'file in/out' }
FmlFunctionCall >> fileOutSurrogate [
	^self shallowCopy clearSurrogate]

{ #category : #accessing }
FmlFunctionCall >> functionDefinition [
	^definition]

{ #category : #accessing }
FmlFunctionCall >> functionDescription [
	^definition description]

{ #category : #comparing }
FmlFunctionCall >> hash [
	^name hashWith: arguments]

{ #category : #testing }
FmlFunctionCall >> hasNumericLiterals [
	^arguments anySatisfy: [:arg | arg hasNumericLiterals]]

{ #category : #testing }
FmlFunctionCall >> hasOnlyConstants [
	name = 'objectName' ifTrue: [^false].
	^arguments conform: [:arg | arg hasOnlyConstants]]

{ #category : #accessing }
FmlFunctionCall >> inferredUnit [
	| binary |
	name = 'raisedTo' ifTrue: [
		binary := FmlBinaryExpression
			left: arguments first
			operator: #'^'
			right: arguments last.
		^binary inferredUnit].
	^definition inferredUnitOn: self]

{ #category : #initialization }
FmlFunctionCall >> initialize [
	super initialize.
	arguments := OrderedCollection new]

{ #category : #initialization }
FmlFunctionCall >> initializeDefinition [
	definition := FmlFunctionDefinition named: name.
	definition isNil
		ifTrue: [FmlUnknownFunction unknownFunction: name in: self]]

{ #category : #testing }
FmlFunctionCall >> isArrayValued [
	^self functionDefinition isArrayValued: self]

{ #category : #testing }
FmlFunctionCall >> isConstant [
	^arguments conform: [:arg | arg isConstant]]

{ #category : #testing }
FmlFunctionCall >> isFunctionCall [
	^true]

{ #category : #testing }
FmlFunctionCall >> isIfFunction [
	^name = 'if']

{ #category : #testing }
FmlFunctionCall >> isLike: anFmlFunctionCall [
	self class == anFmlFunctionCall class ifFalse: [^false].
	name = anFmlFunctionCall name ifFalse: [^false].
	arguments size = anFmlFunctionCall arguments size ifFalse: [^false].
	^(1 to: arguments size) conform: [:i | | a b |
		a := arguments at: i.
		b := anFmlFunctionCall arguments at: i.
		a isLike: b]]

{ #category : #testing }
FmlFunctionCall >> isNotFunction [
	^name = 'not']

{ #category : #testing }
FmlFunctionCall >> isSingleValued [
	^self resultType isSingleValued]

{ #category : #testing }
FmlFunctionCall >> isTableValued [
	^self resultType == FmlTable]

{ #category : #accessing }
FmlFunctionCall >> mainFunction [
	^definition]

{ #category : #accessing }
FmlFunctionCall >> messageArguments [
	^(definition argumentsFrom: arguments) allButFirst]

{ #category : #accessing }
FmlFunctionCall >> messageReceiver [
	^arguments isEmpty
		ifTrue: [FmlUndefinedValue new]
		ifFalse: [arguments first]]

{ #category : #accessing }
FmlFunctionCall >> name [
	^name
	]

{ #category : #accessing }
FmlFunctionCall >> name: aString [
	name := aString.
	self initializeDefinition]

{ #category : #testing }
FmlFunctionCall >> negates: anFmlExpression [
	(name = 'not' and: [arguments anyone = anFmlExpression]) ifTrue: [^true].
	anFmlExpression isFunctionCall ifFalse: [^false].
	^anFmlExpression name = 'not'
		and: [anFmlExpression arguments anyone = self]]

{ #category : #accessing }
FmlFunctionCall >> nodes [
	^arguments]

{ #category : #'logical operations' }
FmlFunctionCall >> not [
	^name = 'not'
		ifTrue: [arguments anyone]
		ifFalse: [FmlFunctionCall name: 'not' arguments: {self}]]

{ #category : #services }
FmlFunctionCall >> npvDerivativeFunctionTail: index [
	| array dates |
	array := self arguments second evaluate.
	dates := self arguments third evaluate.
	^array npvDerivativeFunction: dates tail: index]

{ #category : #services }
FmlFunctionCall >> npvFunctionDescription [
	^'Based on the arguments of']

{ #category : #services }
FmlFunctionCall >> npvFunctionTail: index [
	| array dates |
	array := self arguments second evaluate.
	dates := self arguments third evaluate.
	^array npvFunction: dates tail: index]

{ #category : #services }
FmlFunctionCall >> optimize [
	FmlFunctionCall subclasses
		select: [:cls | cls canOptimize: self]
		thenDo: [:cls | ^cls optimize: self]]

{ #category : #copying }
FmlFunctionCall >> postCopy [
	arguments := arguments collect: [:arg | arg copy]]

{ #category : #accessing }
FmlFunctionCall >> receiver [
	^self messageReceiver]

{ #category : #evaluation }
FmlFunctionCall >> receiverEvaluatedWith: anFmlEvaluator [
	definition requiresArrayReceiver
		ifTrue: [^self messageReceiver evaluateAll].
	definition requiresVariableReceiver ifTrue: [^self messageReceiver].
	definition arity = 0 ifTrue: [^ContextRequest signal].
	^anFmlEvaluator evaluate: self messageReceiver]

{ #category : #arithmetic }
FmlFunctionCall >> reciprocal [
	^definition isReciprocalFunction
		ifTrue: [arguments first]
		ifFalse: [super reciprocal]]

{ #category : #services }
FmlFunctionCall >> replaceColumnName: aString of: anFmlVariableName with: anotherString [
	| check |
	check := definition isTableFunction
		and: [self receiver isVariableName]
		and: [self receiver copy inModuleIndependentFormat = anFmlVariableName].
	arguments withIndexDo: [:arg :i | 
		(check and: [self argumentAt: i refersToColumn: aString])
			ifTrue: [arguments at: i put: anotherString asFmlValue]
			ifFalse: [arg
				replaceColumnName: aString
				of: anFmlVariableName
				with: anotherString]]]

{ #category : #renaming }
FmlFunctionCall >> replaceNode: anFmlExpression with: anotherFmlExpression [
	arguments withIndexDo: [:arg :index | 
		arg = anFmlExpression
			ifTrue: [arguments at: index put: anotherFmlExpression]
			ifFalse: [arg replaceNode: anFmlExpression with: anotherFmlExpression]]]

{ #category : #evaluation }
FmlFunctionCall >> resultType [
	^self functionDefinition resultTypeOf: self]

{ #category : #validation }
FmlFunctionCall >> setLiteralUnitsFrom: aUnit [
	self functionDefinition setLiteralUnitsOf: self from: aUnit]

{ #category : #testing }
FmlFunctionCall >> supportsNpvFunction [
	^self functionDefinition name = 'xNPV']

{ #category : #accessing }
FmlFunctionCall >> table [
	^definition isEnumeratingFunction ifFalse: [super table]]

{ #category : #translations }
FmlFunctionCall >> translateExpressionUsing: anFmlTranslator [
	^anFmlTranslator translateFunction: self]

{ #category : #translations }
FmlFunctionCall >> translateUsing: anFmlTranslator [
	"
	In Excel arguments cannot be arrays, they must be ranges. This means that compositions
	have to be stored in a line by themselves, and then referenced as a range.Unlike
	this, numerical functions can be expressed as inlined compositions. Note also
	that the row (for the range) has to be assigned before the translation.
	"
	^self canBeInlined
		ifTrue: [anFmlTranslator translateFunction: self]
		ifFalse: [
			(1 to: anFmlTranslator periodsSize)
				collect: [:index | anFmlTranslator
					variableReference: self
					atColumn: index]]]

{ #category : #translations }
FmlFunctionCall >> translateUsing: aFmlTranslator atColumn: index [
	^self canBeInlined
		ifTrue: [aFmlTranslator translateFunction: self atColumn: index]
		ifFalse: [aFmlTranslator variableReference: self atColumn: index]]

{ #category : #accessing }
FmlFunctionCall >> typeName [
	^'FML Functions']

{ #category : #accessing }
FmlFunctionCall >> unitForConstant: aFmlValue [
	| unit |
	arguments do: [:arg | arg = aFmlValue ifTrue: [^self unit]].
	arguments
		detect: [:arg | (unit := arg unitForConstant: aFmlValue) notNil]
		ifNone: nil.
	^unit]

