"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSESyntacticParser,
	#superclass : #JSEAbstractParser,
	#instVars : [
		'factory',
		'expression',
		'elision',
		'elementList',
		'assignmentExpression',
		'propertyNameAndValueList',
		'propertyAssignment',
		'propertyName',
		'functionBody',
		'primaryExpression',
		'functionExpression',
		'arguments',
		'argumentList',
		'leftHandSideExpression',
		'postfixExpression',
		'unaryExpression',
		'multiplicativeExpression',
		'additiveExpression',
		'shiftExpression',
		'relationalExpression',
		'relationalExpressionNoIn',
		'equalityExpression',
		'equalityExpressionNoIn',
		'bitwiseANDExpression',
		'bitwiseANDExpressionNoIn',
		'bitwiseXORExpression',
		'bitwiseXORExpressionNoIn',
		'bitwiseORExpressionNoIn',
		'bitwiseORExpression',
		'logicalANDExpression',
		'logicalANDExpressionNoIn',
		'logicalORExpression',
		'logicalORExpressionNoIn',
		'assignmentExpressionNoIn',
		'assignmentOperator',
		'conditionalExpression',
		'conditionalExpressionNoIn',
		'expressionNoIn',
		'block',
		'variableStatement',
		'constStatement',
		'letStatement',
		'emptyStatement',
		'expressionStatement',
		'ifStatement',
		'iterationStatement',
		'continueStatement',
		'breakStatement',
		'returnStatement',
		'withStatement',
		'labelledStatement',
		'switchStatement',
		'throwStatement',
		'tryStatement',
		'debuggerStatement',
		'statementList',
		'statement',
		'variableDeclarationList',
		'variableDeclaration',
		'variableDeclarationListNoIn',
		'variableDeclarationNoIn',
		'initialiser',
		'initialiserNoIn',
		'caseBlock',
		'defaultClause',
		'caseClause',
		'catch',
		'finally',
		'formalParameterList',
		'sourceElements',
		'sourceElement',
		'functionDeclaration',
		'program',
		'memberExpressionStar',
		'arrayLiteral',
		'objectLiteral',
		'lineTerminator',
		'identifier',
		'identifierName',
		'stringLiteral',
		'numericLiteral',
		'literal',
		'automaticSemicolon',
		'newMemberExpression',
		'memberExpressionNoCallStar',
		'newExpression',
		'forStatementLoop',
		'defaultClauseAndClauses',
		'macro'
	],
	#category : #JavaScript
}

{ #category : #constants }
JSESyntacticParser class >> additiveOperators [
	^#( '+' '-' )]

{ #category : #constants }
JSESyntacticParser class >> assignmentOperators [
	^#(
		'='
		'*='
		'/='
		'%='
		'+='
		'-='
		'<<='
		'>>='
		'>>>='
		'&='
		'^='
		'|='
	)]

{ #category : #constants }
JSESyntacticParser class >> equalityOperators [
	^#('===' '!==' '==' '!=')]

{ #category : #accessing }
JSESyntacticParser class >> ignoredNames [
	^super ignoredNames , #(factory)]

{ #category : #constants }
JSESyntacticParser class >> literalTokenTypes [
	^#(#string #numeric #boolean #null #literal #regex)]

{ #category : #constants }
JSESyntacticParser class >> multiplicativeOperators [
	^#( '*' '/' '%' )]

{ #category : #constants }
JSESyntacticParser class >> relationalOperators [
	^#('<=' '>=' '<' '>' 'instanceof' 'in')]

{ #category : #constants }
JSESyntacticParser class >> shiftOperators [
	^#( '<<' '>>>' '>>' )]

{ #category : #constants }
JSESyntacticParser class >> unaryOperators [
	^#('delete' 'void' 'typeof' '++' '--' '+' '-' '~' '!')]

{ #category : #'11 Expressions' }
JSESyntacticParser >> additiveExpression [
	^multiplicativeExpression
		, ((self anyOf: self class additiveOperators) , multiplicativeExpression) star
		==> [:elements | 
			self
				combineBinaryExpressions: elements
				with: [:e1 :e2 :op | self factory
					createAdditiveExpression: e1
					with: e2
					operator: op]]]

{ #category : #utilities }
JSESyntacticParser >> anyOf: anArray [

	^ PPPredicateObjectParser 
		on: [: token | anArray includes: token literalValue ]
		message: 'any of ', anArray printString , ' expected'
		negated: [: token | (anArray includes: token literalValue) not ]
		message: 'none of ', anArray printString , ' not expected']

{ #category : #'11.2 Left-Hand-Side Expressions' }
JSESyntacticParser >> argumentList [

	^ assignmentExpression listSeparatedBy: $, jseTokenParser]

{ #category : #'11.2 Left-Hand-Side Expressions' }
JSESyntacticParser >> arguments [
	^$( jseTokenParser , argumentList optional , $) jseTokenParser
		==> [:elements | self factory
			createArguments: ((elements at: 2) ifNil: [#()])]]

{ #category : #'11.1 Primary Expressions' }
JSESyntacticParser >> arrayLiteral [
	^$[ jseTokenParser , elision optional , elementList optional
		, elision optional
		, $] jseTokenParser
		map: [:b1 :elision1 :arrayElements :elision2 :b2 | 
			self factory
				createArray: (arrayElements ifNil: #())
				padBefore: elision1
				after: elision2]]

{ #category : #'11.13 Assignment Operators' }
JSESyntacticParser >> assignmentExpression [
	^conditionalExpression
		/ (leftHandSideExpression , assignmentOperator , assignmentExpression
			==> [:elements | 
				self factory
					createAssignmentExpression: (elements at: 1)
					to: (elements at: 3)
					operator: (elements at: 2) literalValue])]

{ #category : #'11.13 Assignment Operators' }
JSESyntacticParser >> assignmentExpressionNoIn [
	^leftHandSideExpression , assignmentOperator , assignmentExpressionNoIn
		==> [:elements | 
			self factory
				createAssignmentExpression: (elements at: 1)
				to: (elements at: 3)
				operator: (elements at: 2) literalValue] / conditionalExpressionNoIn]

{ #category : #'11.13 Assignment Operators' }
JSESyntacticParser >> assignmentOperator [

	^ self anyOf: self class assignmentOperators]

{ #category : #'7.9 Automatic Semicolon Insertion' }
JSESyntacticParser >> automaticSemicolon [
	^$; jseTokenParser / (lineTerminator ==> [:e | #lineTerminator])
		/ ((JSELookaheadParser on: $} jseTokenParser) ==> [:e | #closedCurlyBrace])
		/ (PPPluggableParser on: [:stream | 
			stream atEnd
				ifTrue: [#endOfInput]
				ifFalse: [PPFailure message: 'end of input expected' from: stream]])]

{ #category : #'11.10 Binary Bitwise Operators' }
JSESyntacticParser >> bitwiseANDExpression [

	^ equalityExpression, ($& jseTokenParser, equalityExpression) star
		==> [ : elements | 
			self 
				combineBinaryExpressions: elements 
				with: [ : e1 : e2 : op | self factory createBitwiseExpression: e1 with: e2 operator: op  ]]]

{ #category : #'11.10 Binary Bitwise Operators' }
JSESyntacticParser >> bitwiseANDExpressionNoIn [

	^ equalityExpressionNoIn, ($& jseTokenParser, equalityExpressionNoIn) star
		==> [ : elements | 
			self 
				combineBinaryExpressions: elements 
				with: [ : e1 : e2 : op | self factory createBitwiseExpression: e1 with: e2 operator: op  ]]]

{ #category : #'11.10 Binary Bitwise Operators' }
JSESyntacticParser >> bitwiseORExpression [

	^ bitwiseXORExpression , ($| jseTokenParser, bitwiseXORExpression) star
		==> [ : elements | 
			self 
				combineBinaryExpressions: elements 
				with: [ : e1 : e2 : op | self factory createBitwiseExpression: e1 with: e2 operator: op  ]]]

{ #category : #'11.10 Binary Bitwise Operators' }
JSESyntacticParser >> bitwiseORExpressionNoIn [

	^ bitwiseXORExpressionNoIn, ($| jseTokenParser, bitwiseXORExpressionNoIn) star
		==> [ : elements | 
			self 
				combineBinaryExpressions: elements 
				with: [ : e1 : e2 : op | self factory createBitwiseExpression: e1 with: e2 operator: op  ]]]

{ #category : #'11.10 Binary Bitwise Operators' }
JSESyntacticParser >> bitwiseXORExpression [

	^ bitwiseANDExpression, ($^ jseTokenParser, bitwiseANDExpression) star
		==> [ : elements | 
			self 
				combineBinaryExpressions: elements 
				with: [ : e1 : e2 : op | self factory createBitwiseExpression: e1 with: e2 operator: op  ]]]

{ #category : #'11.10 Binary Bitwise Operators' }
JSESyntacticParser >> bitwiseXORExpressionNoIn [

	^ bitwiseANDExpressionNoIn, ($^ jseTokenParser, bitwiseANDExpressionNoIn) star
		==> [ : elements | 
			self 
				combineBinaryExpressions: elements 
				with: [ : e1 : e2 : op | self factory createBitwiseExpression: e1 with: e2 operator: op  ]]]

{ #category : #'12 Statements' }
JSESyntacticParser >> block [

	^ ${ jseTokenParser, statementList , $} jseTokenParser
		==> [ : elements | self factory createBlock: (elements at: 2)  ]]

{ #category : #'12 Statements' }
JSESyntacticParser >> breakStatement [
	^'break' jseTokenParser
		, (lineTerminator not , identifier , automaticSemicolon
			==> [:elements | elements at: 2]
			/ (automaticSemicolon ==> [:elements | nil]))
		==> [:elements | self factory createBreak: (elements at: 2)]]

{ #category : #'12.11 The switch Statement' }
JSESyntacticParser >> caseBlock [

	^ (${ jseTokenParser, caseClause star , defaultClauseAndClauses, $} jseTokenParser
		==> [ : elements |
				(elements at: 3) notNil 
					ifTrue: [ (elements at: 2), (elements at: 3) ]
					ifFalse: [ elements at: 2 ]
		])]

{ #category : #'12.11 The switch Statement' }
JSESyntacticParser >> caseClause [
	^'case' jseTokenParser , expression , $: jseTokenParser , statementList
		==> [:elements | self factory
			createSwitchClause: (elements at: 2)
			statements: (elements at: 4)]]

{ #category : #'12.14 The try Statement' }
JSESyntacticParser >> catch [

	^ 'catch' jseTokenParser, $( jseTokenParser, identifier, $) jseTokenParser,  block
		==> [ : elements | self factory createCatch: (elements at: 3) block: (elements at: 5) ]]

{ #category : #'factory - private' }
JSESyntacticParser >> combine: aParsedElement withElements: otherParsedElements with: combinatorBlock [

	| e |
	e := aParsedElement.
	otherParsedElements do: [: anotherParsedElement | e := combinatorBlock value: e value: anotherParsedElement ].
	^ e]

{ #category : #'factory - private' }
JSESyntacticParser >> combineBinaryExpressions: elements with: combinatorBlock [

	| e |
	e := elements at: 1.
	( elements at: 2 ) ifNotNil: 
		[: operatorAndRightSideExpressions |
			operatorAndRightSideExpressions do: 
				[: operatorAndRightSideExpression |
					e := combinatorBlock value: e value: ( operatorAndRightSideExpression at: 2 ) value: ( operatorAndRightSideExpression at: 1 ) literalValue
				]
		].
	^ e]

{ #category : #'factory - private' }
JSESyntacticParser >> combineExpression: aMemberExpression callArguments: aArgumentsList memberExpressionBlocks: expressionBlocks [

	| e |
	e := self factory createCall: aMemberExpression arguments: aArgumentsList.
	^ self combineExpression: e expressionBlocks: expressionBlocks]

{ #category : #'factory - private' }
JSESyntacticParser >> combineExpression: anExpression conditionalExpression: trueAndFalseExpressions [
	^trueAndFalseExpressions isEmptyOrNil not
		ifTrue: [
			self factory
				createConditionalExpression: anExpression
				trueExpression: (trueAndFalseExpressions at: 2)
				falseExpression: (trueAndFalseExpressions at: 4)]
		ifFalse: [anExpression]]

{ #category : #'factory - private' }
JSESyntacticParser >> combineExpression: baseExpression expressionBlocks: expressionBlocks [

	| e |
	e := baseExpression.
	expressionBlocks notNil
		ifTrue: [
			expressionBlocks do: [ : aBlock |
				e := aBlock value: e.
			]
	].
	^ e]

{ #category : #'11.12 Conditional Operator' }
JSESyntacticParser >> conditionalExpression [
	^logicalORExpression , assignmentOperator not
		, ($? jseTokenParser , assignmentExpression , $: jseTokenParser
			, assignmentExpression)
			optional
		==> [:elements | self
			combineExpression: (elements at: 1)
			conditionalExpression: (elements at: 3)]]

{ #category : #'11.12 Conditional Operator' }
JSESyntacticParser >> conditionalExpressionNoIn [
	^logicalORExpressionNoIn
		, ($? jseTokenParser , assignmentExpressionNoIn , $: jseTokenParser
			, assignmentExpressionNoIn)
			optional
		==> [:elements | self
			combineExpression: (elements at: 1)
			conditionalExpression: (elements at: 2)]]

{ #category : #'12.2 Variable Statement' }
JSESyntacticParser >> constStatement [
	^'const' jseTokenParser , variableDeclarationList , automaticSemicolon
		==> [:elements | self factory createConstStatement: (elements at: 2)]]

{ #category : #'12 Statements' }
JSESyntacticParser >> continueStatement [
	^'continue' jseTokenParser
		, (lineTerminator not , identifier , automaticSemicolon
			==> [:elements | elements at: 2]
			/ (automaticSemicolon ==> [:elements | nil]))
		==> [:elements | self factory createContinue: (elements at: 2)]]

{ #category : #'factory - private' }
JSESyntacticParser >> createLiteralForToken: token [
	token type = #regex ifTrue: [^self factory createRegularExpression: token].
	token type = #string ifTrue: [^self factory createLiteralString: token].
	token type = #numeric ifTrue: [^self factory createLiteralNumeric: token].
	token type = #boolean ifTrue: [^self factory createLiteralBoolean: token].
	token type = #null ifTrue: [^self factory createLiteralNull: token].
	self error: 'Unknown literal type: ' , token type]

{ #category : #'factory - private' }
JSESyntacticParser >> createPaddedElementList: elementsAndPaddings [

	| i size elements |
	elementsAndPaddings isEmpty 
		ifTrue: [ ^ #( )].
	size := 1.
	2 to: elementsAndPaddings size by: 2 do: [: elisionIndex | size := size + ( elementsAndPaddings at: elisionIndex )].
	elements := Array new: size.
	i := 1.
	1 to: elementsAndPaddings size
		by: 2
		do: 
		[: elementIndex |
			elements at: i put: ( elementsAndPaddings at: elementIndex ).
			elementIndex < elementsAndPaddings size 
				ifTrue: [ i := i + ( elementsAndPaddings at: elementIndex + 1 )]
		].
	^ elements]

{ #category : #'12 Statements' }
JSESyntacticParser >> debuggerStatement [

	^ 'debugger' jseTokenParser, automaticSemicolon
		==> [ : elements | self factory createDebugger ]]

{ #category : #'12.11 The switch Statement' }
JSESyntacticParser >> defaultClause [

	^ 'default' jseTokenParser, $: jseTokenParser, statementList 
		==> [ : elements | self factory createSwitchDefaultClause: (elements at: 3) ]]

{ #category : #'12.11 The switch Statement' }
JSESyntacticParser >> defaultClauseAndClauses [

	^ ( defaultClause , caseClause star) optional
		 ==> [: elements |
			elements notNil 
				ifTrue: [ self arrayFromStartAndStarElements: elements ]
				ifFalse: [ nil ]
		]]

{ #category : #'11.1 Primary Expressions' }
JSESyntacticParser >> elementList [

	^ ( assignmentExpression separatedBy: elision)
		==> [: paddingsAndElements | self createPaddedElementList: paddingsAndElements ]]

{ #category : #'11.1 Primary Expressions' }
JSESyntacticParser >> elision [

	^ ($, jseTokenParser plus) ==> [ : elison | elison size ]]

{ #category : #'12 Statements' }
JSESyntacticParser >> emptyStatement [

	^ $;  jseTokenParser
		==> [ : elements | self factory createEmptyStatement ]]

{ #category : #'11.9 Equality Operators' }
JSESyntacticParser >> equalityExpression [
	^relationalExpression
		, ((self anyOf: self class equalityOperators) , shiftExpression) star
		==> [:elements | 
			self
				combineBinaryExpressions: elements
				with: [:e1 :e2 :op | self factory
					createEqualityExpression: e1
					with: e2
					operator: op]]]

{ #category : #'11.9 Equality Operators' }
JSESyntacticParser >> equalityExpressionNoIn [
	^relationalExpressionNoIn
		, ((self anyOf: self class equalityOperators) , shiftExpression) star
		==> [:elements | 
			self
				combineBinaryExpressions: elements
				with: [:e1 :e2 :op | self factory
					createEqualityExpression: e1
					with: e2
					operator: op]]]

{ #category : #'11.14 Comma Operator' }
JSESyntacticParser >> expression [

	^ ( assignmentExpression , (( $, jseTokenParser , assignmentExpression ) ==> [: s | s at: 2 ]) star ) ==> 
		[: elements |
			self combine: ( elements at: 1 ) withElements: ( elements at: 2 ) with: [: e1 : e2 | self factory createCommaSeparatedExpression: e1 with: e2 ]
		]]

{ #category : #'11.14 Comma Operator' }
JSESyntacticParser >> expressionNoIn [

	^ ( assignmentExpression , (( $, jseTokenParser , assignmentExpressionNoIn ) ==> [: s | s at: 2 ]) star ) ==> 
		[: elements |
			self combine: ( elements at: 1 ) withElements: ( elements at: 2 ) with: [: e1 : e2 | self factory createCommaSeparatedExpression: e1 with: e2 ]
		]]

{ #category : #'12 Statements' }
JSESyntacticParser >> expressionStatement [

	^ ((expression, automaticSemicolon ) butNot: ${ jseTokenParser / 'function' jseTokenParser)
		==> [ : elements | self factory createExpressionStatement: (elements at: 1) ]]

{ #category : #accessing }
JSESyntacticParser >> factory [

	factory isNil ifTrue: [ factory := JSEParsedNodesFactory new ].
	^ factory]

{ #category : #accessing }
JSESyntacticParser >> factory: aFactory [

	factory := aFactory.]

{ #category : #'12.14 The try Statement' }
JSESyntacticParser >> finally [

	^ 'finally' jseTokenParser, block
		==> [ : elements | self factory createFinally: (elements at: 2) ]]

{ #category : #'13 Function Definition' }
JSESyntacticParser >> formalParameterList [
	^identifier / macro listSeparatedBy: $, jseTokenParser]

{ #category : #'12.6 Iteration Statements' }
JSESyntacticParser >> forStatementLoop [
	^'var' jseTokenParser / 'let' jseTokenParser , variableDeclarationListNoIn
		, $; jseTokenParser
		, expression optional
		, $; jseTokenParser
		, expression optional
		==> [:elements | 
			elements first value = 'var'
				ifTrue: [
					[:s | 
						self factory
							createForVariables: (elements at: 2)
							condition: (elements at: 4)
							update: (elements at: 6)
							do: s]]
				ifFalse: [
					[:s | 
						self factory
							createForLetList: (elements at: 2)
							condition: (elements at: 4)
							update: (elements at: 6)
							do: s]]]
		/ ('var' jseTokenParser / 'let' jseTokenParser , variableDeclarationNoIn
			, 'in' jseTokenParser
			, expression
			==> [:elements | 
				elements first value = 'var'
					ifTrue: [[:s | self factory
						createForVariable: (elements at: 2)
						in: (elements at: 4)
						do: s]]
					ifFalse: [[:s | self factory
						createForLet: (elements at: 2)
						in: (elements at: 4)
						do: s]]])
		/ (expressionNoIn optional , $; jseTokenParser , expression optional
			, $; jseTokenParser
			, expression optional
			==> [:elements | 
				[:s | 
					self factory
						createFor: (elements at: 1)
						condition: (elements at: 3)
						update: (elements at: 5)
						do: s]])
		/ (leftHandSideExpression , 'in' jseTokenParser , expression
			==> [:elements | [:s | self factory
				createFor: (elements at: 1)
				in: (elements at: 3)
				do: s]])]

{ #category : #'13 Function Definition' }
JSESyntacticParser >> functionBody [

	^ sourceElements optional
		==> [ : elements | self factory createFunctionBody: elements ]]

{ #category : #'13 Function Definition' }
JSESyntacticParser >> functionDeclaration [
	^'function' jseTokenParser , (identifier / macro) , $( jseTokenParser
		, formalParameterList optional
		, $) jseTokenParser
		, ${ jseTokenParser
		, functionBody
		, $} jseTokenParser
		==> [:elements | 
			self factory
				createFunctionDeclaration: (elements at: 2)
				parameters: ((elements at: 4) ifNil: [#()])
				body: (elements at: 7)]]

{ #category : #'13 Function Definition' }
JSESyntacticParser >> functionExpression [
	^'function' jseTokenParser , (identifier / macro) optional
		, $( jseTokenParser
		, formalParameterList optional
		, $) jseTokenParser
		, ${ jseTokenParser
		, functionBody
		, $} jseTokenParser
		==> [:elements | 
			self factory
				createFunctionExpression: (elements at: 2)
				parameters: ((elements at: 4) ifNil: [#()])
				body: (elements at: 7)]]

{ #category : #'lexical tokens' }
JSESyntacticParser >> identifier [
	^(self tokenParserOfType: #identifier)
		==> [:token | self factory createIdentifier: token]]

{ #category : #'lexical tokens' }
JSESyntacticParser >> identifierName [
	^(self tokenParserOfTypes: #(identifier #identifierName))
		==> [:token | self factory createIdentifierName: token]]

{ #category : #'12 Statements' }
JSESyntacticParser >> ifStatement [

	^ 
	( 'if' jseTokenParser, $( jseTokenParser, expression, $) jseTokenParser, statement, ('else' jseTokenParser, statement ==> [ : elements | elements at: 2 ]) optional
		==> [ : elements | self factory createIf: (elements at: 3)  trueExpression: (elements at: 5)  falseExpression: (elements at: 6) ])]

{ #category : #'12.2 Variable Statement' }
JSESyntacticParser >> initialiser [

	^ $= jseTokenParser, assignmentExpression
		==> [ : elements | elements at: 2 ]]

{ #category : #'12.2 Variable Statement' }
JSESyntacticParser >> initialiserNoIn [

	^ $= jseTokenParser, assignmentExpressionNoIn 
		==> [ : elements | elements at: 2 ]]

{ #category : #'12.6 Iteration Statements' }
JSESyntacticParser >> iterationStatement [

	^ 
	('do' jseTokenParser, statement,  'while' jseTokenParser,  $( jseTokenParser,  expression, $) jseTokenParser
		==> [ : elements |  self factory createDo: (elements at: 2) whileExpression: (elements at: 5)  ])
	/ ('while' jseTokenParser,  $( jseTokenParser,  expression,  $) jseTokenParser, statement
		==> [ : elements |  self factory createWhile: (elements at: 3) statement: (elements at: 5)  ])
	/ ('for' jseTokenParser, $( jseTokenParser, forStatementLoop, $) jseTokenParser, statement
		==> [ : elements |  
			" forStatementLoop returns a factory block " 
			(elements at: 3) value: (elements at: 5) ])]

{ #category : #'12 Statements' }
JSESyntacticParser >> labelledStatement [

	^ identifier,  $: jseTokenParser, statement
		==> [ : elements | self factory createLabel: (elements at: 1) statement: (elements at: 3) ]]

{ #category : #'11.2 Left-Hand-Side Expressions' }
JSESyntacticParser >> leftHandSideExpression [
	" tweaked for better performance "

	^ newMemberExpression, memberExpressionStar star
		==> [: elements | self combineExpression: ( elements at: 1 ) expressionBlocks: ( elements at: 2 )]]

{ #category : #'12.2 Variable Statement' }
JSESyntacticParser >> letStatement [
	^'let' jseTokenParser , variableDeclarationList , automaticSemicolon
		==> [:elements | self factory createLetStatement: (elements at: 2)]]

{ #category : #'lexical tokens' }
JSESyntacticParser >> lineTerminator [

	^ JSELookaheadParser on: (PPPredicateObjectParser 
		on: [: token | token hasPreceedingLineTerminator ]
		message: 'line terminator expected')]

{ #category : #'lexical tokens' }
JSESyntacticParser >> literal [
	^(self tokenParserOfTypes: self class literalTokenTypes)
		==> [:token | self createLiteralForToken: token]]

{ #category : #'11.11 Binary Logical Operators' }
JSESyntacticParser >> logicalANDExpression [

	^ bitwiseORExpression,  ('&&' jseTokenParser, bitwiseORExpression) star
		==> [ : elements | 
			self 
				combineBinaryExpressions: elements 
				with: [ : e1 : e2 : op | self factory createLogicalExpression: e1 with: e2 operator: op  ]]]

{ #category : #'11.11 Binary Logical Operators' }
JSESyntacticParser >> logicalANDExpressionNoIn [

	^ bitwiseORExpressionNoIn,  ('&&' jseTokenParser, bitwiseORExpressionNoIn) star
		==> [ : elements | 
			self 
				combineBinaryExpressions: elements 
				with: [ : e1 : e2 : op | self factory createLogicalExpression: e1 with: e2 operator: op  ]]]

{ #category : #'11.11 Binary Logical Operators' }
JSESyntacticParser >> logicalORExpression [

	^ logicalANDExpression, ('||' jseTokenParser, logicalANDExpression) star
		==> [ : elements | 
			self 
				combineBinaryExpressions: elements 
				with: [ : e1 : e2 : op | self factory createLogicalExpression: e1 with: e2 operator: op  ]]]

{ #category : #'11.11 Binary Logical Operators' }
JSESyntacticParser >> logicalORExpressionNoIn [

	^ logicalANDExpressionNoIn, ('||' jseTokenParser, logicalANDExpressionNoIn) star
		==> [ : elements | 
			self 
				combineBinaryExpressions: elements 
				with: [ : e1 : e2 : op | self factory createLogicalExpression: e1 with: e2 operator: op  ]]]

{ #category : #'lexical tokens' }
JSESyntacticParser >> macro [
	^(self tokenParserOfType: #macro)
		==> [:token | self factory createMacro: token]]

{ #category : #'11.2 Left-Hand-Side Expressions' }
JSESyntacticParser >> memberExpressionNoCallStar [
	^$[ jseTokenParser , expression , $] jseTokenParser
		==> [:elements | [:call | self factory
			createMemberOf: call
			bracket: (elements at: 2)]]
		/ ($. jseTokenParser , (identifierName / macro)
			==> [:elements | [:call | self factory
				createMemberOf: call
				dot: (elements at: 2)]])]

{ #category : #'11.2 Left-Hand-Side Expressions' }
JSESyntacticParser >> memberExpressionStar [
	" returns a block that receives a base expression "

	^ 
	(arguments 
		==> [ : elements |
			[ : aCallExpression | self factory createCall: aCallExpression arguments: elements ]
		])
	/ memberExpressionNoCallStar]

{ #category : #'11 Expressions' }
JSESyntacticParser >> multiplicativeExpression [

	^ ( unaryExpression , (( self anyOf: self class multiplicativeOperators) , unaryExpression ) star ) 
		==> [: elements |
			self 
				combineBinaryExpressions: elements 
				with: [: e1 : e2 : op | self factory createMultiplicativeExpression: e1 with: e2 operator: op ]
		]]

{ #category : #'11.2 Left-Hand-Side Expressions' }
JSESyntacticParser >> newExpression [
	" tweaked for better performance "

	^ 
	 (( 'new' jseTokenParser , newMemberExpression , arguments optional ) 
			==> [: elements | self factory createNew: ( elements at: 2 ) arguments: ( elements at: 3 )])]

{ #category : #'11.2 Left-Hand-Side Expressions' }
JSESyntacticParser >> newMemberExpression [
	" tweaked for better performance "

	^ 
	newExpression 
	/ primaryExpression 
	/ functionExpression]

{ #category : #'lexical tokens' }
JSESyntacticParser >> numericLiteral [
	^(self tokenParserOfType: #numeric)
		==> [:token | self factory createLiteralNumeric: token]]

{ #category : #'11.1 Primary Expressions' }
JSESyntacticParser >> objectLiteral [
	^${ jseTokenParser , $} jseTokenParser
		==> [:elements | self factory createObject: #()]
		/ (${ jseTokenParser , propertyNameAndValueList
			, $, jseTokenParser optional
			, $} jseTokenParser
			==> [:elements | self factory createObject: (elements at: 2)])]

{ #category : #'11 Expressions' }
JSESyntacticParser >> postfixExpression [

	^ ( leftHandSideExpression , (( self anyOf: #( '++' '--' )) butNot: lineTerminator ) optional )
		==> [: elements | | postfix |
			postfix := elements at: 2.
			postfix notNil 
				ifTrue: [ self factory createPostfixExpression: ( elements at: 1 ) operator: postfix literalValue ]
				ifFalse: [ elements at: 1 ]
		]]

{ #category : #'11.1 Primary Expressions' }
JSESyntacticParser >> primaryExpression [
	^'this' jseTokenParser ==> [:token | self factory createThisExpression]
		/ ($( jseTokenParser , expression , $) jseTokenParser
			==> [:elements | self factory createGroupedExpression: (elements at: 2)])
		/ identifier
		/ literal
		/ arrayLiteral
		/ objectLiteral
		/ macro]

{ #category : #'14 Program' }
JSESyntacticParser >> program [

	^ sourceElements optional 
		==> [ : e | self factory createProgram: e ]]

{ #category : #'11.1 Primary Expressions' }
JSESyntacticParser >> propertyAssignment [

	^ 
	(propertyName, $: jseTokenParser, assignmentExpression 
		==> [ : elements | self factory createPropertyAssignment: (elements at: 1)  expression: (elements at: 3) ])
	/ ('get' jseTokenParser, propertyName, $( jseTokenParser, $) jseTokenParser, ${ jseTokenParser, functionBody,  $} jseTokenParser
		==> [ : elements | self factory createPropertyGetAssignment: (elements at: 2)  functionBody: (elements at: 6) ])
	/ ('set' jseTokenParser, propertyName, $( jseTokenParser, identifier, $) jseTokenParser, ${ jseTokenParser, functionBody,  $} jseTokenParser
		==> [ : elements | self factory createPropertySetAssignment: (elements at: 2)  parameter: (elements at: 4) functionBody: (elements at: 7) ])]

{ #category : #'11.1 Primary Expressions' }
JSESyntacticParser >> propertyName [

	^ 
	identifierName 
	/ stringLiteral 
	/ numericLiteral]

{ #category : #'11.1 Primary Expressions' }
JSESyntacticParser >> propertyNameAndValueList [

	^ propertyAssignment listSeparatedBy: $, jseTokenParser]

{ #category : #'11.1 Primary Expressions' }
JSESyntacticParser >> propertySetParameterList [

	^ identifier]

{ #category : #'11.8 Relational Operators' }
JSESyntacticParser >> relationalExpression [

	^ shiftExpression, ((self anyOf: self class relationalOperators), shiftExpression) star
		==> [ : elements | 
			self 
				combineBinaryExpressions: elements 
				with: [ : e1 : e2 : op | self factory createRelationalExpression: e1 with: e2 operator: op  ]]]

{ #category : #'11.8 Relational Operators' }
JSESyntacticParser >> relationalExpressionNoIn [

	^ shiftExpression, ((self anyOf: (self class relationalOperators copyWithout: 'in')), shiftExpression) star
	==> [ : elements | 
			self 
				combineBinaryExpressions: elements 
				with: [ : e1 : e2 : op | self factory createRelationalExpression: e1 with: e2 operator: op  ]]]

{ #category : #'12 Statements' }
JSESyntacticParser >> returnStatement [
	^'return' jseTokenParser
		, (lineTerminator not , expression , automaticSemicolon
			==> [:elements | elements at: 2]
			/ (automaticSemicolon ==> [:elements | nil]))
		==> [:elements | self factory createReturn: (elements at: 2)]]

{ #category : #'11 Expressions' }
JSESyntacticParser >> shiftExpression [

	^ ( additiveExpression , (( self anyOf: #( '<<' '>>>' '>>' )) , additiveExpression ) star ) 
		==> [: elements |
			self 
				combineBinaryExpressions: elements 
				with: [: e1 : e2 : op | self factory createShiftExpression: e1 with: e2 operator: op ]
		]]

{ #category : #'14 Program' }
JSESyntacticParser >> sourceElement [

	^ statement 
	/ functionDeclaration]

{ #category : #'14 Program' }
JSESyntacticParser >> sourceElements [

	^ sourceElement plus]

{ #category : #accessing }
JSESyntacticParser >> start [

	^  program end]

{ #category : #'12 Statements' }
JSESyntacticParser >> statement [
	^block / variableStatement / constStatement / letStatement / emptyStatement
		/ expressionStatement
		/ ifStatement
		/ iterationStatement
		/ continueStatement
		/ breakStatement
		/ returnStatement
		/ withStatement
		/ labelledStatement
		/ switchStatement
		/ throwStatement
		/ tryStatement
		/ debuggerStatement]

{ #category : #'12 Statements' }
JSESyntacticParser >> statementList [

	^ statement star]

{ #category : #'lexical tokens' }
JSESyntacticParser >> stringLiteral [
	^(self tokenParserOfType: #string)
		==> [:token | self factory createLiteralString: token]]

{ #category : #'12.11 The switch Statement' }
JSESyntacticParser >> switchStatement [

	^ 'switch' jseTokenParser, $( jseTokenParser,  expression, $) jseTokenParser, caseBlock
		==>[ : elements | self factory createSwitch: (elements at: 3) clauses: (elements at: 5) ]]

{ #category : #'12 Statements' }
JSESyntacticParser >> throwStatement [

	^ 'throw' jseTokenParser, lineTerminator not, expression, $; jseTokenParser
		==> [ : elements | self factory createThrow: (elements at: 3) ]]

{ #category : #private }
JSESyntacticParser >> tokenParserOfType: tokenType [

	^ PPPredicateObjectParser on: [: token | token type = tokenType ] message: tokenType , ' expected']

{ #category : #private }
JSESyntacticParser >> tokenParserOfTypes: tokenTypes [

	^ PPPredicateObjectParser on: [ : token | tokenTypes includes: token type ] message: 'any of ', tokenTypes printString, ' expected']

{ #category : #'12.14 The try Statement' }
JSESyntacticParser >> tryStatement [

	^ 
	('try' jseTokenParser, block, catch, finally optional
		==> [ : elements | self factory createTry: (elements at: 2) catch: (elements at: 3) finally: (elements at: 4) ])
	/ ('try' jseTokenParser, block, finally 
		==> [ : elements | self factory createTry: (elements at: 2) catch: nil finally: (elements at: 3) ])]

{ #category : #'11 Expressions' }
JSESyntacticParser >> unaryExpression [

	^ 
	 ((self anyOf: self class unaryOperators) , unaryExpression 
		==> [ : elements | self factory createUnaryExpression: (elements at: 2) operator: (elements at: 1) literalValue ])
	/ postfixExpression]

{ #category : #'12.2 Variable Statement' }
JSESyntacticParser >> variableDeclaration [
	^identifier , initialiser optional ==> [:elements | 
		self factory
			createVariableDeclaration: (elements at: 1)
			initializer: (elements at: 2)]]

{ #category : #'12.2 Variable Statement' }
JSESyntacticParser >> variableDeclarationList [

	^ self variableDeclaration listSeparatedBy: $, jseTokenParser]

{ #category : #'12.2 Variable Statement' }
JSESyntacticParser >> variableDeclarationListNoIn [

	^ variableDeclarationNoIn listSeparatedBy: $, jseTokenParser]

{ #category : #'12.2 Variable Statement' }
JSESyntacticParser >> variableDeclarationNoIn [

	^ identifier, initialiserNoIn optional
		==> [ : elements | self factory createVariableDeclaration: (elements at: 1) initializer: (elements at: 2)  ].]

{ #category : #'12.2 Variable Statement' }
JSESyntacticParser >> variableStatement [
	^'var' jseTokenParser , variableDeclarationList , automaticSemicolon
		==> [:elements | self factory createVariableStatement: (elements at: 2)]]

{ #category : #'12 Statements' }
JSESyntacticParser >> withStatement [

	^ 'with' jseTokenParser, $( jseTokenParser, expression, $) jseTokenParser, statement
		==> [ : elements | self factory createWith: (elements at: 3)  statement: (elements at: 5)  ]]

