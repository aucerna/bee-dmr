"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlSimplifier,
	#superclass : #Object,
	#instVars : [
		'expression'
	],
	#category : #FML
}

{ #category : #services }
FmlSimplifier class >> simplify: anFmlExpression [
	^self new simplify: anFmlExpression]

{ #category : #private }
FmlSimplifier >> boolean10For: binary [
	| left right if constant yes |
	left := binary left.
	right := binary right.
	left isFunctionCall
		ifTrue: [
			if := left.
			constant := right]
		ifFalse: [
			if := right.
			constant := left].
	yes := if messageArguments first.
	^yes = constant ifTrue: [if receiver] ifFalse: [if receiver not]]

{ #category : #private }
FmlSimplifier >> booleanFor: if [
	| rcvr |
	rcvr := if receiver.
	^if messageArguments first = true asFmlValue
		ifTrue: [rcvr]
		ifFalse: [rcvr not]]

{ #category : #testing }
FmlSimplifier >> canDoTheMath: node [
	node isBinaryExpression ifFalse: [^false].
	^node hasOnlyConstants
		and: [node left isLeafNode]
		and: [node left isNumeric]
		and: [node right isLeafNode]
		and: [node right isNumeric andNot: [node isUndefinedValue]]]

{ #category : #testing }
FmlSimplifier >> canJoinConstants: node [
	node isBinaryExpression ifFalse: [^false].
	node operator == #'*' ifFalse: [^false].
	node right isLiteral ifFalse: [^false].
	node right isNumeric ifFalse: [^false].
	node left isBinaryExpression ifFalse: [^false].
	node left operator == #'*' ifFalse: [^false].
	node left right isLiteral ifFalse: [^false].
	^node left right isNumeric]

{ #category : #testing }
FmlSimplifier >> canPopupNegativeConstants: node [
	node isBinaryExpression ifFalse: [^false].
	(#(#* #/) includes: node operator) ifFalse: [^false].
	^node arguments anySatisfy: [:a | self hasNegativeFactor: a]]

{ #category : #testing }
FmlSimplifier >> canRemoveBooleanArguments: node [
	| boolean |
	node isFunctionCall ifFalse: [^false].
	(#('or' 'and') includes: node name) ifFalse: [^false].
	boolean := (node name = 'and') asFmlExpression.
	^node arguments anySatisfy: [:arg | arg = boolean]]

{ #category : #testing }
FmlSimplifier >> canRemoveContradiction: node [
	| negated |
	node isFunctionCall ifFalse: [^false].
	node name = 'and' ifFalse: [^false].
	negated := node arguments
		select: [:arg | arg isNotFunction]
		thenCollect: [:arg | arg arguments anyone].
	negated isEmpty ifTrue: [^false].
	^node arguments intersects: negated]

{ #category : #testing }
FmlSimplifier >> canRemoveDoubleDenominator: node [
	| arg |
	node isBinaryExpression ifFalse: [^false].
	node operator == #'/' ifFalse: [^false].
	arg := node right.
	arg isBinaryExpression ifFalse: [^false].
	^arg operator == #'/']

{ #category : #testing }
FmlSimplifier >> canRemoveDoubleNegation: node [
	| arg |
	node isFunctionCall ifFalse: [^false].
	node name = 'negated' ifFalse: [^false].
	arg := node arguments anyone.
	^arg isFunctionCall and: [arg name = node name]]

{ #category : #testing }
FmlSimplifier >> canRemoveTautology: node [
	| negated |
	node isFunctionCall ifFalse: [^false].
	node name = 'or' ifFalse: [^false].
	negated := node arguments
		select: [:arg | arg isNotFunction]
		thenCollect: [:arg | arg arguments anyone].
	negated isEmpty ifTrue: [^false].
	^node arguments intersects: negated]

{ #category : #testing }
FmlSimplifier >> canRemoveUnities: node [
	node isBinaryExpression ifFalse: [^false].
	node operator == #'*' ifTrue: [
		(node left isLike: 1 asFmlValue) ifTrue: [^true].
		(node right isLike: 1 asFmlValue) ifTrue: [^true]].
	node operator == #'/'
		ifTrue: [(node right isLike: 1 asFmlValue) ifTrue: [^true]].
	node operator == #'+' ifTrue: [
		(node left isLike: 0 asFmlValue) ifTrue: [^true].
		(node right isLike: 0 asFmlValue) ifTrue: [^true]].
	node operator == #'-'
		ifTrue: [(node right isLike: 0 asFmlValue) ifTrue: [^true]].
	^false]

{ #category : #testing }
FmlSimplifier >> canReplaceIfWithAnd: node [
	| third |
	node isIfFunction ifFalse: [^false].
	third := node arguments third.
	^third = false asFmlValue or: [third = node arguments first]]

{ #category : #testing }
FmlSimplifier >> canReplaceIfWithOr: node [
	| second |
	node isIfFunction ifFalse: [^false].
	second := node arguments second.
	^second = true asFmlValue or: [node arguments first = second]]

{ #category : #testing }
FmlSimplifier >> canResolveToBoolean: node [
	| boolean |
	node isFunctionCall ifFalse: [^false].
	(#('or' 'and') includes: node name) ifFalse: [^false].
	boolean := (node name = 'or') asFmlExpression.
	^node arguments anySatisfy: [:arg | arg = boolean]]

{ #category : #testing }
FmlSimplifier >> canSolveComparison: node [
	node isBinaryExpression ifFalse: [^false].
	node isBooleanExpression ifFalse: [^false].
	node isComparison ifFalse: [^false].
	^(node left isLike: node right)
		or: [node left isLiteral and: [node right isLiteral]]]

{ #category : #testing }
FmlSimplifier >> canSubtractNegativeTerms: node [
	node isBinaryExpression ifFalse: [^false].
	(#(#+ #-) includes: node operator) ifFalse: [^false].
	node right isBinaryExpression ifFalse: [^false].
	(#(#* #/) includes: node right operator) ifFalse: [^false].
	^node right arguments anySatisfy: [:a | a = -1 asFmlValue]]

{ #category : #testing }
FmlSimplifier >> canUseAndOrFactorization: node [
	| subargs common op |
	node isFunctionCall ifFalse: [^false].
	(#('and' 'or') includes: node name) ifFalse: [^false].
	op := node name = 'and' ifTrue: ['or'] ifFalse: ['and'].
	(node arguments conform: [:arg | arg isFunctionCall and: [arg name = op]])
		ifFalse: [^false].
	subargs := node arguments collect: [:arg | arg arguments].
	common := nil.
	subargs do: [:args | 
		common := common isNil ifTrue: [args] ifFalse: [common intersection: args].
		common isEmpty ifTrue: [^false]].
	^true]

{ #category : #testing }
FmlSimplifier >> canUseBooleanAbsorption: node [
	| op |
	node isFunctionCall ifFalse: [^false].
	(#('and' 'or') includes: node name) ifFalse: [^false].
	op := node name = 'and' ifTrue: ['or'] ifFalse: ['and'].
	^node arguments anySatisfy: [:arg | 
		arg isFunctionCall
			and: [arg name = op]
			and: [arg arguments anySatisfy: [:a | node arguments includes: a]]]]

{ #category : #testing }
FmlSimplifier >> canUseDeMorganIn: node [
	| inner |
	node isNotFunction ifFalse: [^false].
	inner := node arguments anyone.
	inner isFunctionCall ifFalse: [^false].
	(#('or' 'and') includes: inner name) ifFalse: [^false].
	^inner arguments conform: #isNotFunction]

{ #category : #testing }
FmlSimplifier >> canUseNegatedBooleanAbsorption: node [
	| op |
	node isFunctionCall ifFalse: [^false].
	(#('and' 'or') includes: node name) ifFalse: [^false].
	op := node name = 'and' ifTrue: ['or'] ifFalse: ['and'].
	^node arguments anySatisfy: [:arg | 
		arg isFunctionCall and: [arg name = op] and: [
			arg arguments
				anySatisfy: [:a | node arguments anySatisfy: [:b | a negates: b]]]]]

{ #category : #testing }
FmlSimplifier >> comparesWithBoolean: node [
	node isBinaryExpression ifFalse: [^false].
	node operator = #equals: ifFalse: [^false].
	^node right isBoolean or: [node left isBoolean]]

{ #category : #simplifying }
FmlSimplifier >> doTheMath [
	self
		replaceNodesSatisfying: [:node | self canDoTheMath: node]
		evaluating: [:node | | unit value |
			unit := node inferredUnit.
			value := node value.
			(unit notNil and: [unit isNumeric])
				ifTrue: [
					value := value inUnit: unit.
					value asFmlValue unit: unit]
				ifFalse: [value asFmlValue]]]

{ #category : #simplifying }
FmlSimplifier >> factorOut [
	self
		replaceNodesSatisfying: [:node | self hasCommonFactors: node]
		evaluating: [:node | | algorithm |
			algorithm := FmlFactorizationAlgorithm on: node.
			algorithm compute; output]]

{ #category : #testing }
FmlSimplifier >> hasCommonFactors: node [
	^node isBinaryExpression and: [| algorithm |
		algorithm := FmlFactorizationAlgorithm on: node.
		algorithm updateRanking canSimplify]]

{ #category : #testing }
FmlSimplifier >> hasIdempotentRedundance: node [
	| args inner |
	node isFunctionCall ifFalse: [^false].
	node functionDefinition isIdempotent ifFalse: [^false].
	args := node arguments.
	inner := args first.
	inner isFunctionCall ifFalse: [^false].
	inner functionDefinition = node functionDefinition ifFalse: [^false].
	^args size = 1 or: [
		args size = inner arguments size
			and: [args allButFirst = inner arguments allButFirst]]]

{ #category : #testing }
FmlSimplifier >> hasNegativeFactor: node [
	^node isBinaryExpression and: [#(#* #/) includes: node operator] and: [
		node arguments
			anySatisfy: [:arg | arg isLiteral
				and: [arg value isNumber]
				and: [arg value < 0]]]]

{ #category : #testing }
FmlSimplifier >> includesNotNot: node [
	| arg |
	node isFunctionCall ifFalse: [^false].
	node name = 'not' ifFalse: [^false].
	arg := node arguments anyone.
	arg isFunctionCall ifFalse: [^false].
	^arg name = 'not']

{ #category : #private }
FmlSimplifier >> isIf10: node [
	| one zero args yes no |
	node isFunctionCall ifFalse: [^false].
	node isIfFunction ifFalse: [^false].
	one := 1 asFmlValue.
	zero := 0 asFmlValue.
	args := node messageArguments.
	yes := args first.
	no := args second.
	^(yes = one and: [no = zero]) or: [yes = zero and: [no = one]]]

{ #category : #simplifying }
FmlSimplifier >> joinConstants [
	self
		replaceNodesSatisfying: [:node | self canJoinConstants: node]
		evaluating: [:node | | b c m |
			b := node right value.
			c := node left right value.
			m := b * c.
			m = 1
				ifTrue: [node left left]
				ifFalse: [FmlBinaryExpression
					left: m
					operator: #'*'
					right: node left left]]]

{ #category : #private }
FmlSimplifier >> maxFor: if [
	| args |
	args := if receiver arguments.
	if receiver operator first = $< ifTrue: [args reversed].
	^if class new name: 'max'; arguments: args]

{ #category : #private }
FmlSimplifier >> minFor: if [
	| args |
	args := if receiver arguments.
	if receiver operator first = $> ifTrue: [args reversed].
	^if class new name: 'min'; arguments: args]

{ #category : #simplifying }
FmlSimplifier >> popupNegativeConstants [
	self
		replaceNodesSatisfying: [:node | self canPopupNegativeConstants: node]
		evaluating: [:node | | neg |
			neg := false.
			node arguments select: [:a | self hasNegativeFactor: a] thenDo: [:a | 
				a arguments do: [:b | | value |
					(b isLiteral
						and: [
							value := b value.
							value isNumber]
						and: [value < 0])
						ifTrue: [
							neg := neg not.
							b value: value negated]]].
			neg
				ifTrue: [FmlBinaryExpression left: -1 operator: #'*' right: node]
				ifFalse: [node]]]

{ #category : #simplifying }
FmlSimplifier >> removeAndOrRepeatedArguments [
	self
		replaceNodesSatisfying: [:node | self canUseAndOrFactorization: node]
		evaluating: [:f | | subargs common arg2 op1 op2 |
			f name = 'and'
				ifTrue: [
					op1 := 'or'.
					op2 := 'and']
				ifFalse: [
					op1 := 'and'.
					op2 := 'or'].
			subargs := f arguments collect: [:arg | arg arguments].
			common := nil.
			subargs
				do: [:args | common := common isNil
					ifTrue: [args]
					ifFalse: [common intersection: args]].
			common := common anyone.
			f arguments
				do: [:arg | arg arguments: (arg arguments copyWithout: common)].
			arg2 := f arguments
				collect: [:arg | arg arguments size = 1
					ifTrue: [arg arguments anyone]
					ifFalse: [arg]].
			arg2 := FmlFunctionCall name: op2 arguments: arg2.
			f name: op1; arguments: {common. arg2}]]

{ #category : #simplifying }
FmlSimplifier >> removeBooleanComparisons [
	self
		replaceNodesSatisfying: [:node | self comparesWithBoolean: node]
		evaluating: [:comparison | | boolean condition |
			comparison left isBoolean
				ifTrue: [
					boolean := comparison left.
					condition := comparison right]
				ifFalse: [
					boolean := comparison right.
					condition := comparison left].
			boolean value = false ifTrue: [condition not] ifFalse: [condition]]]

{ #category : #simplifying }
FmlSimplifier >> removeConstantBooleanArguments [
	self
		replaceNodesSatisfying: [:node | self canRemoveBooleanArguments: node]
		evaluating: [:f | | boolean args |
			boolean := (f name = 'and') asFmlExpression.
			args := f arguments reject: [:arg | arg = boolean].
			args size = 1 ifTrue: [args anyone] ifFalse: [f arguments: args]]]

{ #category : #simplifying }
FmlSimplifier >> removeContradictions [
	self
		replaceNodesSatisfying: [:node | self canRemoveContradiction: node]
		evaluating: [:or | false asFmlValue]]

{ #category : #simplifying }
FmlSimplifier >> removeDoubleDenominators [
	self
		replaceNodesSatisfying: [:node | self canRemoveDoubleDenominator: node]
		evaluating: [:quotient | | a b c ac |
			a := quotient left.
			b := quotient right left.
			c := quotient right right.
			ac := a multipliedBy: c.
			ac dividedBy: b]]

{ #category : #simplifying }
FmlSimplifier >> removeDoubleNegations [
	self
		replaceNodesSatisfying: [:node | self canRemoveDoubleNegation: node]
		evaluating: [:node | node arguments anyone arguments anyone]]

{ #category : #simplifying }
FmlSimplifier >> removeIdepotentArguments [
	self
		replaceNodesSatisfying: [:node | self usesIdenpotentBooleanArguments: node]
		evaluating: [:f | | args |
			args := f arguments withoutDuplicates.
			args size > 1 ifTrue: [f arguments: args] ifFalse: [args anyone]]]

{ #category : #simplifying }
FmlSimplifier >> removeIfs [
	self
		replaceNodesSatisfying: [:node | self usesConstantIf: node]
		evaluating: [:if | 
			(if receiver value = 1 or: [if receiver value == true])
				ifTrue: [if arguments second]
				ifFalse: [if arguments third]]]

{ #category : #simplifying }
FmlSimplifier >> removeNewArray [
	self
		replaceNodesSatisfying: [:node | self usesNewArray: node]
		evaluating: [:f | f arguments anyone]]

{ #category : #simplifying }
FmlSimplifier >> removeNotNots [
	self
		replaceNodesSatisfying: [:node | self includesNotNot: node]
		evaluating: [:f | f arguments anyone arguments anyone]]

{ #category : #simplifying }
FmlSimplifier >> removeSimpleNots [
	self
		replaceNodesSatisfying: [:node | self shouldRemoveSimpleNot: node]
		evaluating: [:f | f arguments anyone value not asFmlValue]]

{ #category : #simplifying }
FmlSimplifier >> removeSuperfluousNots [
	self
		replaceNodesSatisfying: [:node | self shouldRemoveIfNot: node]
		evaluating: [:if | 
			if arguments
				at: 1 put: if receiver receiver;
				swap: 2 with: 3.
			if]]

{ #category : #simplifying }
FmlSimplifier >> removeTautologies [
	self
		replaceNodesSatisfying: [:node | self canRemoveTautology: node]
		evaluating: [:or | true asFmlValue]]

{ #category : #simplifying }
FmlSimplifier >> removeUnities [
	self
		replaceNodesSatisfying: [:node | self canRemoveUnities: node]
		evaluating: [:node | | n |
			n := node.
			node operator == #'*' ifTrue: [
				(node left isLike: 1 asFmlValue) ifTrue: [n := node right].
				(node right isLike: 1 asFmlValue) ifTrue: [n := node left]].
			node operator == #'/' ifTrue: [n := node left].
			node operator == #'+' ifTrue: [
				(node left isLike: 0 asFmlValue) ifTrue: [n := node right].
				(node right isLike: 0 asFmlValue) ifTrue: [n := node left]].
			node operator == #'-'
				ifTrue: [(node right isLike: 0 asFmlValue) ifTrue: [n := node left]].
			n]]

{ #category : #simplifying }
FmlSimplifier >> replaceIfWithAnd [
	self
		replaceNodesSatisfying: [:node | self canReplaceIfWithAnd: node]
		evaluating: [:f | FmlFunctionCall
			name: 'and'
			arguments: f arguments allButLast]]

{ #category : #simplifying }
FmlSimplifier >> replaceIfWithOr [
	self
		replaceNodesSatisfying: [:node | self canReplaceIfWithOr: node]
		evaluating: [:f | | args |
			args := f arguments asOrderedCollection removeIndex: 2.
			FmlFunctionCall name: 'or' arguments: args asArray]]

{ #category : #private }
FmlSimplifier >> replaceNodesSatisfying: condition evaluating: evaluable [
	(condition evaluateWith: expression)
		ifTrue: [expression := evaluable evaluateWith: expression].
	expression
		select: [:node | node !== expression and: [condition evaluateWith: node]]
		thenDo: [:node | | substitute |
			substitute := evaluable evaluateWith: node.
			expression replaceNode: node with: substitute]]

{ #category : #simplifying }
FmlSimplifier >> replaceNotEqualFalse [
	self
		replaceNodesSatisfying: [:node | self usesNotEqualFalse: node]
		evaluating: [:b | | i |
			i := b arguments indexOf: false asFmlValue.
			b arguments at: 2 - i + 1]]

{ #category : #simplifying }
FmlSimplifier >> replaceNotEqualTrue [
	self
		replaceNodesSatisfying: [:node | self usesNotEqualTrue: node]
		evaluating: [:b | | i |
			i := b arguments indexOf: true asFmlValue.
			FmlFunctionCall name: 'not' arguments: {b arguments at: 2 - i + 1}]]

{ #category : #simplifying }
FmlSimplifier >> resolveToBoolean [
	self
		replaceNodesSatisfying: [:node | self canResolveToBoolean: node]
		evaluating: [:f | (f name = 'or') asFmlExpression]]

{ #category : #testing }
FmlSimplifier >> shouldBeBoolean: node [
	| args yes no t f |
	node isFunctionCall ifFalse: [^false].
	node isIfFunction ifFalse: [^false].
	args := node messageArguments.
	args size = 2 ifFalse: [^false].
	yes := args first.
	no := args second.
	t := true asFmlValue.
	f := false asFmlValue.
	^(yes = t and: [no = f]) or: [yes = f and: [no = t]]]

{ #category : #testing }
FmlSimplifier >> shouldBeBoolean10: node [
	| left right one zero |
	node isBinaryExpression ifFalse: [^false].
	(node operator = #'=' or: [node operator = #equals:]) ifFalse: [^false].
	left := node left.
	right := node right.
	one := 1 asFmlValue.
	zero := 0 asFmlValue.
	^((self isIf10: left) and: [right = one or: [right = zero]])
		or: [(self isIf10: right) and: [left = one or: [left = zero]]]]

{ #category : #testing }
FmlSimplifier >> shouldBeMax: node [
	| rcvr args yes no op |
	node isIfFunction ifFalse: [^false].
	rcvr := node receiver.
	rcvr isBinaryExpression ifFalse: [^false].
	op := rcvr operator.
	(#(#< #<= #> #>=) includesIdentical: op) ifFalse: [^false].
	args := node messageArguments.
	yes := args first.
	no := args second.
	^(op first = $> and: [rcvr left isLike: yes] and: [rcvr right isLike: no])
		or: [op first = $<
			and: [rcvr left isLike: no]
			and: [rcvr right isLike: yes]]]

{ #category : #testing }
FmlSimplifier >> shouldBeMin: node [
	| rcvr args yes no op |
	node isIfFunction ifFalse: [^false].
	rcvr := node receiver.
	rcvr isBinaryExpression ifFalse: [^false].
	op := rcvr operator.
	(#(#< #<= #> #>=) includesIdentical: op) ifFalse: [^false].
	args := node messageArguments.
	yes := args first.
	no := args second.
	^(op first = $< and: [rcvr left isLike: yes] and: [rcvr right isLike: no])
		or: [op first = $>
			and: [rcvr left isLike: no]
			and: [rcvr right isLike: yes]]]

{ #category : #simplifying }
FmlSimplifier >> shouldRemoveIfNot: node [
	^node isIfFunction and: [node receiver isNotFunction]]

{ #category : #testing }
FmlSimplifier >> shouldRemoveSimpleNot: node [
	| arg t f |
	node isNotFunction ifFalse: [^false].
	arg := node receiver.
	t := true asFmlValue.
	f := false asFmlValue.
	^arg = t or: [arg = f]]

{ #category : #testing }
FmlSimplifier >> shouldUseColumnNames: node [
	| def i c receiver |
	node isFunctionCall ifFalse: [^false].
	def := node functionDefinition.
	def isTableFunction ifFalse: [^false].
	receiver := node receiver.
	(receiver isVariableName
		and: [receiver variable notNil]
		and: [receiver variable calculator isTableInput])
		ifFalse: [^false].
	i := def arguments
		findFirst: [:arg | arg refersToColumn]
		ifAbsent: [^false].
	c := node arguments at: i ifAbsent: [^false].
	(c isSingleValued and: [c isInput] and: [c isNumeric]) ifFalse: [^false].
	node table isNil ifTrue: [^false].
	^c value asInteger between: 1 and: node table numColumns]

{ #category : #simplifying }
FmlSimplifier >> simplify: anFmlExpression [
	| prev |
	expression := anFmlExpression.
	prev := expression asString.
	[
		self simplifyOnce.
		expression asString = prev]
		whileFalse: [prev := expression asString].
	^expression]

{ #category : #simplifying }
FmlSimplifier >> simplifyOnce [
	self
		doTheMath;
		factorOut;
		removeDoubleDenominators;
		popupNegativeConstants;
		subtractNegativeTerms;
		joinConstants;
		removeUnities;
		removeBooleanComparisons;
		useMax;
		useMin;
		useBooleans;
		useBoolean10;
		removeSuperfluousNots;
		removeIfs;
		removeNewArray;
		removeIdepotentArguments;
		removeAndOrRepeatedArguments;
		useBooleanAbsorption;
		useNegatedBooleanAbsorption;
		removeConstantBooleanArguments;
		resolveToBoolean;
		removeNotNots;
		useDeMorgan;
		removeTautologies;
		removeContradictions;
		solveComparisons;
		replaceNotEqualTrue;
		replaceNotEqualFalse;
		useColumnNames;
		simplifyRedundantIdempotency;
		removeSimpleNots;
		replaceIfWithAnd;
		replaceIfWithOr;
		removeDoubleNegations]

{ #category : #simplifying }
FmlSimplifier >> simplifyRedundantIdempotency [
	self
		replaceNodesSatisfying: [:node | self hasIdempotentRedundance: node]
		evaluating: [:f | f arguments first]]

{ #category : #simplifying }
FmlSimplifier >> solveComparisons [
	self
		replaceNodesSatisfying: [:node | self canSolveComparison: node]
		evaluating: [:bin | | v |
			v := (bin left isLiteral and: [bin right isLiteral])
				ifTrue: [bin value]
				ifFalse: [(bin class strictOperators includes: bin operator) not].
			v asFmlValue]]

{ #category : #simplifying }
FmlSimplifier >> subtractNegativeTerms [
	self
		replaceNodesSatisfying: [:node | self canSubtractNegativeTerms: node]
		evaluating: [:node | | right term sign |
			right := node right.
			right operator == #'*'
				ifTrue: [term := right left = -1 asFmlValue
					ifTrue: [right right]
					ifFalse: [right left]].
			right operator == #'/' ifTrue: [
				term := right left = -1 asFmlValue
					ifTrue: [right left: 1 asFmlValue]
					ifFalse: [right left]].
			sign := node operator == #'+' ifTrue: [#'-'] ifFalse: [#'+'].
			node operator: sign; right: term]]

{ #category : #simplifying }
FmlSimplifier >> useBoolean10 [
	self
		replaceNodesSatisfying: [:node | self shouldBeBoolean10: node]
		evaluating: [:node | self boolean10For: node]]

{ #category : #simplifying }
FmlSimplifier >> useBooleanAbsorption [
	self
		replaceNodesSatisfying: [:node | self canUseBooleanAbsorption: node]
		evaluating: [:f | | op args |
			op := f name = 'and' ifTrue: ['or'] ifFalse: ['and'].
			args := f arguments reject: [:arg | 
				arg isFunctionCall
					and: [arg name = op]
					and: [arg arguments anySatisfy: [:a | f arguments includes: a]]].
			args size = 1 ifTrue: [args anyone] ifFalse: [f arguments: args]]]

{ #category : #simplifying }
FmlSimplifier >> useBooleans [
	self
		replaceNodesSatisfying: [:node | self shouldBeBoolean: node]
		evaluating: [:node | self booleanFor: node]]

{ #category : #simplifying }
FmlSimplifier >> useColumnNames [
	self
		replaceNodesSatisfying: [:node | self shouldUseColumnNames: node]
		evaluating: [:f | | arguments args specs |
			arguments := f arguments.
			args := f functionDefinition arguments.
			specs := f table columnSpecs.
			(1 to: args size)
				select: [:i | (args at: i) refersToColumn]
				thenDo: [:i | | j spec |
					j := arguments at: i.
					spec := specs at: j value asInteger.
					arguments at: i put: spec label asFmlValue].
			f]]

{ #category : #simplifying }
FmlSimplifier >> useDeMorgan [
	self
		replaceNodesSatisfying: [:node | self canUseDeMorganIn: node]
		evaluating: [:node | | arg op |
			arg := node arguments anyone.
			op := arg name = 'or' ifTrue: ['and'] ifFalse: ['or'].
			arg name: op.
			arg arguments
				withIndexDo: [:not :i | arg arguments at: i put: not arguments anyone].
			arg]]

{ #category : #private }
FmlSimplifier >> useMax [
	self
		replaceNodesSatisfying: [:node | self shouldBeMax: node]
		evaluating: [:node | self maxFor: node]]

{ #category : #simplifying }
FmlSimplifier >> useMin [
	self
		replaceNodesSatisfying: [:node | self shouldBeMin: node]
		evaluating: [:node | self minFor: node]]

{ #category : #simplifying }
FmlSimplifier >> useNegatedBooleanAbsorption [
	self
		replaceNodesSatisfying: [:node | self canUseNegatedBooleanAbsorption: node]
		evaluating: [:f | | op args t |
			op := f name = 'and' ifTrue: ['or'] ifFalse: ['and'].
			args := f arguments collect: [:arg | | subargs |
				(arg isFunctionCall
					and: [arg name = op]
					and: [arg arguments
						anySatisfy: [:a | f arguments anySatisfy: [:b | a negates: b]]])
					ifTrue: [
						subargs := arg arguments
							reject: [:a | f arguments anySatisfy: [:b | a negates: b]].
						subargs size = 1
							ifTrue: [subargs anyone]
							ifFalse: [arg arguments: subargs]]
					ifFalse: [arg]].
			f arguments: args]]

{ #category : #testing }
FmlSimplifier >> usesConstantIf: node [
	^node isIfFunction and: [
		node receiver isBoolean
			or: [node receiver = 1 asFmlValue]
			or: [node receiver = 0 asFmlValue]]]

{ #category : #testing }
FmlSimplifier >> usesIdenpotentBooleanArguments: node [
	node isFunctionCall ifFalse: [^false].
	(#('or' 'and') includes: node name) ifFalse: [^false].
	^node arguments hasDuplicates]

{ #category : #testing }
FmlSimplifier >> usesMagicConstant: node [
	^(node isKindOf: FmlNumber) and: [node value != 0] and: [node value != 1]]

{ #category : #testing }
FmlSimplifier >> usesNewArray: node [
	node isFunctionCall ifFalse: [^false].
	^node name = 'newArray']

{ #category : #testing }
FmlSimplifier >> usesNotEqualFalse: node [
	node isBinaryExpression ifFalse: [^false].
	node operator == #'<>' ifFalse: [^false].
	^node arguments includes: false asFmlValue]

{ #category : #testing }
FmlSimplifier >> usesNotEqualTrue: node [
	node isBinaryExpression ifFalse: [^false].
	node operator == #'<>' ifFalse: [^false].
	^node arguments includes: true asFmlValue]

