"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JavascriptSyntaxTest,
	#superclass : #JavascriptParserTest,
	#category : #'JavaScript\Tests'
}

{ #category : #private }
JavascriptSyntaxTest >> assertExpressionFailure: aString [

	self assertParseFailure: aString, ';']

{ #category : #private }
JavascriptSyntaxTest >> parseExpression: expressionString equals: expectedParsedValue [

	self parse: expressionString, ';' equals: (Array with: expectedParsedValue)]

{ #category : #private }
JavascriptSyntaxTest >> parseObjectLiteral: literalString equals: keysAndValues [

	| object |
	object := Dictionary new.
	keysAndValues do: [: pair | object at: pair first put: pair last ].
	self parseExpression: 'o=', literalString equals: (Array with: #o with: #= with: object)]

{ #category : #private }
JavascriptSyntaxTest >> privateTestBinaryOperators: operators [
	operators do: [:operatorString | 
		self
			parseExpression: 'left ' , operatorString , ' right'
			equals: (Array with: #left with: operatorString asSymbol with: #right).
		(operatorString conform: [:char | char isLetter not]) ifTrue: [
			self
				parseExpression: 'left' , operatorString , 'right'
				equals: (Array with: #left with: operatorString asSymbol with: #right)].
		self assertExpressionFailure: 'left ' , operatorString]]

{ #category : #'11 Expressions' }
JavascriptSyntaxTest >> testAdditiveOperators [

	self privateTestBinaryOperators: JSESyntacticParser additiveOperators.
	self parseExpression: '1+2' equals: #( 1 #'+' 2 ).
	self parseExpression: '1.2+3.4' equals: ( Array with: ( self floatFrom: '1.2' ) with: #'+' with: ( self floatFrom: '3.4' )).
	self parseExpression: '.1+.2' equals: ( Array with: ( self floatFrom: '0.1' ) with: #'+' with: ( self floatFrom: '0.2' )).
	self parseExpression: '1e+2+2e+2' equals: #( 100 #'+' 200 ).]

{ #category : #'11.1 Primary Expressions' }
JavascriptSyntaxTest >> testArrayLiteral [

	self parseExpression: '[1, 2, 3]' equals: #(1 2 3).
	self parseExpression: '[1]' equals: #(1).
	self parseExpression: '[]' equals: #().
	self parseExpression: '[1,, 3]' equals: #(1 nil 3).
	self parseExpression: '[1,, , 4]' equals: #(1 nil nil 4).
	self parseExpression: '[,2, 3]' equals: #(nil 2 3).
	self parseExpression: '[,,3, 4]' equals: #(nil nil 3 4).
	self parseExpression: '[1, 2,]' equals: #(1 2 nil).
	self parseExpression: '[1, 2,,]' equals: #(1 2 nil nil).
	self parseExpression: '[, 2,]' equals: #(nil 2 nil).

	self assertExpressionFailure: '[1'.
	self assertExpressionFailure: '1]'.
	self assertExpressionFailure: '[1 2 3]'.
	self assertExpressionFailure: '[1, 2 3]'.]

{ #category : #'11 Expressions' }
JavascriptSyntaxTest >> testAssignment [

	JSESyntacticParser assignmentOperators do: [ : operatorString  |
		self parseExpression: 'v', operatorString, '1' equals: (Array with: #v with: operatorString asSymbol with: 1)
	].]

{ #category : #'7 Lexical Conventions' }
JavascriptSyntaxTest >> testAutomaticSemicolonAtEnd [

	" explicit semicolon "
	self parse: 'a;' equals: #(a).
	" automatic semicolon "
	self parse: 'a' equals: #(a).]

{ #category : #'7 Lexical Conventions' }
JavascriptSyntaxTest >> testAutomaticSemicolonCurlyBrace [

	" explicit semicolon "
	self parse: '{a;}' equals: #((a)).
	" automatic semicolon "
	self parse: '{a}' equals: #((a)).]

{ #category : #'7 Lexical Conventions' }
JavascriptSyntaxTest >> testAutomaticSemicolonExamples [
	" 7.9.2 Examples of Automatic Semicolon Insertion "

	| lineTerminator |
	lineTerminator := String with: Character cr.

	self assertParseFailure: '{ 1 2 } 3'.
	self parse: '{ 1', lineTerminator, '2 } 3' equals: (self parse: '{1;2;}3;').
	self assertParseFailure: 'for (a; b', lineTerminator, ')'.
	self parse: 'return', lineTerminator, 'a + b;' equals:  (self parse: 'return; a + b').
	self parse: 'a = b', lineTerminator, '++c' equals: (self parse: 'a = b; ++c').
	self assertParseFailure: 'if (a > b)', lineTerminator, 'else c = d'.
	self parse: 'a = b + c', lineTerminator, '(d + e).print()' equals: (self parse: 'a = b + c(d + e).print()').]

{ #category : #'7 Lexical Conventions' }
JavascriptSyntaxTest >> testAutomaticSemicolonLineTerminator [

	" explicit semicolon "
	self parse: 'a;b;' equals: #(a b).
	" automatic semicolon "
	self parse: 'a', (String with: Character cr), 'b;' equals: #(a b).]

{ #category : #'11 Expressions' }
JavascriptSyntaxTest >> testBitwiseOperators [

	self privateTestBinaryOperators: #('&' '|' '^')]

{ #category : #'12 Statements' }
JavascriptSyntaxTest >> testBlock [

	self parse: '{}' equals: #(()).
	self parse: '{{}}' equals: #((())).
	self parse: '{{1;}{2;}}' equals: #(((1)(2))).

	self assertParseFailure: '{'.
	self assertParseFailure: '}'.
	self assertParseFailure: '{{}'.]

{ #category : #'11.1 Primary Expressions' }
JavascriptSyntaxTest >> testBracketMemberExpression [

	self parseExpression: 'a[0]' equals: #(a $[ 0 $]).
	self parseExpression: 'a[b]' equals: #(a $[ b $]).
	self parseExpression: 'a[0][b]' equals: #(#(a $[ 0 $]) $[ b $]).

	self assertExpressionFailure: 'a[]'.]

{ #category : #'12 Statements' }
JavascriptSyntaxTest >> testBreak [

	self parse: 'break;' equals: #(break).
	self parse: 'break label;' equals: #((break label)).
	self parse: 'break ', (String with: Character cr), ' noLabel;' equals: #(break noLabel).

	self assertParseFailure: 'break a=b;'.
	self assertParseFailure: 'break {label};'.
	self assertParseFailure: 'break label1 label2;'.]

{ #category : #'11.2 Left-Hand-Side Expressions' }
JavascriptSyntaxTest >> testCallExpression [

	self parseExpression: 'blog()' equals: #(blog ()).
	self parseExpression: 'blog(url)' equals: #(blog (url)).
	self parseExpression: 'my.blog()' equals: #((my $. blog) ()).
	self parseExpression: 'my.blog(url)' equals: #((my $. blog) (url)).
	self parseExpression: 'my.blog(url,title)' equals: #((my $. blog) (url title)).
	self parseExpression: 'my.blog(url,title)[0]' equals: #(((my $. blog) (url title)) $[ 0 $]).
	self parseExpression: 'my.blog(url,title).value' equals: #(((my $. blog) (url title)) $. value).
	self parseExpression: 'my.blog(url)(title)' equals: #(((my $. blog) (url)) (title)).
	self parseExpression: 'blog(get(url))' equals: #(blog ( (get (url)) )).
	self parseExpression: '"a" + name()' equals: #('a' #+ (name ())).
	self parseExpression: 'set("a" + "b")' equals: #(set (('a' #+ 'b'))).

	self assertExpressionFailure: 'blog('.
	self assertExpressionFailure: 'blog(()'.
	self assertExpressionFailure: 'blog(url title)'.]

{ #category : #'11.2 Left-Hand-Side Expressions' }
JavascriptSyntaxTest >> testCallExpressionConcatenation [

	self parseExpression: 'blog().post()' equals: #(((blog ()) $. post) ()).
	self parseExpression: 'my.blog(url).post(stuff)' equals: #((((my $. blog) (url)) $. post) (stuff)).

	self parseExpression: 'new Blog.post()' equals: #(((new #Blog) $. post) ()).
	self parseExpression: 'new Blog().post()' equals: #(((new #Blog ()) $. post) ()).
	self parseExpression: 'new Blog(url).post()' equals: #(((new #Blog (url)) $. post) ()).]

{ #category : #'11 Expressions' }
JavascriptSyntaxTest >> testCommaOperator [

"	JSESyntacticParser assignmentOperators do: [ : operatorString  |
		self parseExpression: 'v', operatorString, '1,w=2' equals: (Array with: (Array with: #v with: operatorString asSymbol with: 1) with: #(w #= 2)).
	]."
	self parseExpression: 'v=1,w=2,x=3,z=4' equals: #((((v #= 1) #(w #= 2)) #(x #= 3)) (z #= 4)).

	self assertExpressionFailure: 'v=1,,w=2'.
	self assertExpressionFailure: ',v=1,w=2'.
	self assertExpressionFailure: 'v=1,w=2,'.]

{ #category : #'11 Expressions' }
JavascriptSyntaxTest >> testConditionalOperator [

	self parseExpression: 'b ? 1 : 2 ' equals: #(b $? 1 $: 2).

	self assertExpressionFailure: 'b ? 1 : '.
	self assertExpressionFailure: 'b ? 1'.]

{ #category : #'12 Statements' }
JavascriptSyntaxTest >> testConstStatement [
	self parse: 'var PI = 3.14;' equals: #((var ((PI #= 3.14)))).
	self parse: 'const PI = 3.14;' equals: #((const ((PI #= 3.14)))).
	self parse: 'let PI = 3.14;' equals: #((let ((PI #= 3.14))))]

{ #category : #'12 Statements' }
JavascriptSyntaxTest >> testContinue [

	self parse: 'continue;' equals: #(continue).
	self parse: 'continue label;' equals: #((continue label)).
	self parse: 'continue ', (String with: Character cr), ' noLabel;' equals: #(continue noLabel).

	self assertParseFailure: 'continue a=b;'.
	self assertParseFailure: 'continue {label};'.
	self assertParseFailure: 'continue label1 label2;'.]

{ #category : #'12 Statements' }
JavascriptSyntaxTest >> testDebugger [

	self parse: 'debugger;' equals: #(debugger).]

{ #category : #'11.1 Primary Expressions' }
JavascriptSyntaxTest >> testDotMemberExpression [

	self parseExpression: 'a.b' equals: #(a $. b).
	self parseExpression: 'a.b.c' equals: #(#(a $. b) $. c).

	self assertExpressionFailure: 'a.'.
	self assertExpressionFailure: '.b'.
	self assertExpressionFailure: 'a..b'.]

{ #category : #'12.6 Iteration Statements' }
JavascriptSyntaxTest >> testDoWhile [

	self parse: 'do {1;} while (a>b)' equals: #((do (1) while (a #> b))).

	self assertExpressionFailure: 'do 1 while (a>b)'.
	self assertExpressionFailure: 'do {1;} while a>b'.]

{ #category : #'12 Statements' }
JavascriptSyntaxTest >> testEmptyStatement [

	self parse: '{;}' equals: #((())).
	self parse: '{;;}' equals: #((()())).]

{ #category : #'12 Statements' }
JavascriptSyntaxTest >> testExpressionStatement [

	self parse: 'a;' equals: #(a).
	self parse: 'a;b;' equals: #(a b).]

{ #category : #'12.6 Iteration Statements' }
JavascriptSyntaxTest >> testFor [

	self parse: 'for (i=1;i<10;i++) {42;}' equals: #((for ((i #= 1) (i #< 10) (i #++)) (42))).

	self parse: 'for (;i<10;i++) {42;}' equals: #((for (nil (i #< 10) (i #++)) (42))).
	self parse: 'for (i=1;;i++) {42;}' equals: #((for ((i #= 1) nil (i #++)) (42))).
	self parse: 'for (i=1;i<10;) {42;}' equals: #((for ((i #= 1) (i #< 10) nil) (42))).
	self parse: 'for (;;) {42;}' equals: #((for (nil nil nil) (42))).

	self assertExpressionFailure: 'for (;) {42;}'.
	self assertExpressionFailure: 'for (;;;) {42;}'.]

{ #category : #'12.6 Iteration Statements' }
JavascriptSyntaxTest >> testForIn [

	self parse: 'for (each in collection) {each;}' equals: #((for (each in collection) (each))).

	self assertParseFailure: 'for (each in) {each;}'.
	self assertParseFailure: 'for (in collection) {each;}'.
	self assertParseFailure: 'for each in collection {each;}'.]

{ #category : #'12.6 Iteration Statements' }
JavascriptSyntaxTest >> testForLet [
	self
		parse: 'for (let i=1;i<10;i++) {42;}'
		equals: #((for (let ((i #= 1)) (i #< 10) (i #++)) (42))).
	self
		parse: 'for (let i=1,j=10;i<j;i++) {42;}'
		equals: #((for (let ((i #= 1)(j #= 10)) (i #< j) (i #++)) (42))).
	self
		parse: 'for (let i=1;;i++) {42;}'
		equals: #((for (let ((i #= 1))nil (i #++)) (42))).
	self
		parse: 'for (let i=1;i<10;) {42;}'
		equals: #((for (let ((i #= 1)) (i #< 10) nil) (42))).
	self
		parse: 'for (let i=1;;) {42;}'
		equals: #((for (let ((i #= 1)) nil nil) (42))).
	"no #in allowed "
	self assertParseFailure: 'for (let b=1 in numbers;;b) {42;}']

{ #category : #'12.6 Iteration Statements' }
JavascriptSyntaxTest >> testForLetIn [
	self
		parse: 'for (let each in collection) {each;}'
		equals: #((for (let each in collection) (each))).
	self
		parse: 'for (let each=1 in collection) {each;}'
		equals: #((for (let (each #= 1) in collection) (each))).
	" variable declaration does not allow #in, so two consecutive #in operators are parsed this way "
	self
		parse: 'for (let each=1 in numbers in collection) {each;}'
		equals: #((for (let (each #= 1) in (numbers in collection)) (each))).
	self assertParseFailure: 'for (let each in) {each;}']

{ #category : #'12.6 Iteration Statements' }
JavascriptSyntaxTest >> testForVariable [
	self
		parse: 'for (var i=1;i<10;i++) {42;}'
		equals: #((for (var ((i #= 1)) (i #< 10) (i #++)) (42))).
	self
		parse: 'for (var i=1,j=10;i<j;i++) {42;}'
		equals: #((for (var ((i #= 1)(j #= 10)) (i #< j) (i #++)) (42))).
	self
		parse: 'for (var i=1;;i++) {42;}'
		equals: #((for (var ((i #= 1))nil (i #++)) (42))).
	self
		parse: 'for (var i=1;i<10;) {42;}'
		equals: #((for (var ((i #= 1)) (i #< 10) nil) (42))).
	self
		parse: 'for (var i=1;;) {42;}'
		equals: #((for (var ((i #= 1)) nil nil) (42))).
	"no #in allowed "
	self assertParseFailure: 'for (var b=1 in numbers;;b) {42;}']

{ #category : #'12.6 Iteration Statements' }
JavascriptSyntaxTest >> testForVariableIn [
	self
		parse: 'for (var each in collection) {each;}'
		equals: #((for (var each in collection) (each))).
	self
		parse: 'for (var each=1 in collection) {each;}'
		equals: #((for (var (each #= 1) in collection) (each))).
	" variable declaration does not allow #in, so two consecutive #in operators are parsed this way "
	self
		parse: 'for (var each=1 in numbers in collection) {each;}'
		equals: #((for (var (each #= 1) in (numbers in collection)) (each))).
	self assertParseFailure: 'for (var each in) {each;}']

{ #category : #'13 Function Definition' }
JavascriptSyntaxTest >> testFunctionDeclaration [

	self parse: 'function blog(){}' equals: #((function blog () nil)).
	self parse: 'function blog(url,title){}' equals: #((function blog (url title) nil)).
	self parse: 'function blog(url,title){42;}' equals: #((function blog (url title) (42))).
	self parse: 'function blog(url,title){function inner(){}}' equals: #((function blog (url title) ((function inner () nil)))).

	self assertParseFailure: 'function blog()'.
	self assertParseFailure: 'function blog{}'.
	self assertParseFailure: 'function function{}'.]

{ #category : #'13 Function Definition' }
JavascriptSyntaxTest >> testFunctionExpression [

	self parse: 'var f=function(){};' equals: #((var ((f #= (function () nil))))).
	self parse: 'var f=function(url,title){};' equals: #((var ((f #= (function (url title) nil))))).
	self parse: 'var f=function(url,title){42;};' equals: #((var ((f #= (function (url title) (42)))))).

	self assertParseFailure: 'function();'.
	self assertParseFailure: 'var f=function blog'.]

{ #category : #'11.1 Primary Expressions' }
JavascriptSyntaxTest >> testGroupedExpression [

	self parseExpression: '((1)+2)' equals: #(((1) #+ 2)).

	self assertExpressionFailure: '(1'.
	self assertExpressionFailure: '1)'.
	self assertExpressionFailure: '((1)'.]

{ #category : #'11.1 Primary Expressions' }
JavascriptSyntaxTest >> testIdentifier [

	#( 'foo' 'foo1' '$' '_') do: [ : identifier |
		self parseExpression: identifier equals: identifier asSymbol
	].]

{ #category : #'12 Statements' }
JavascriptSyntaxTest >> testIfStatement [

	self parse: 'if (a>b) a;' equals: #((if (a #> b) a)).
	self parse: 'if (a>b) a; else b;' equals: #((if (a #> b) a b)).
	self parse: 'if (a>b) {} else {}' equals: #((if (a #> b) #() #())).

	self assertParseFailure: 'if a>b a;'.
	self assertParseFailure: 'if (a>b)'.
	self assertParseFailure: 'if a>b'.]

{ #category : #'12 Statements' }
JavascriptSyntaxTest >> testLabelledStatement [

	self parse: 'blog: 42;' equals: #((blog #':' 42 )).
	self parse: 'blog: {}' equals: #((blog #':' () )).

	self assertParseFailure: 'blog 42;'.]

{ #category : #'12 Statements' }
JavascriptSyntaxTest >> testLetStatement [
	self parse: 'let blog;' equals: #((let (blog))).
	self parse: 'let blog="MyBlog";' equals: #((let ((blog #= 'MyBlog')))).
	self
		parse: 'let blog,microblog,feed;'
		equals: #((let (blog microblog feed))).
	self
		parse: 'let blog="MyBlog",microblog,feed;'
		equals: #((let ((blog #= 'MyBlog') microblog feed))).
	self
		parse: 'let blog="MyBlog",microblog="Whale",feed="News";'
		equals: #((let ((blog #= 'MyBlog') (microblog #= 'Whale') (feed #= 'News')))).
	self
		parse: 'let bool=1 in numbers;'
		equals: #((let ((bool #= (1 in numbers))))).
	self assertParseFailure: 'let blog=;'.
	self assertParseFailure: 'let var=1;'.
	self assertParseFailure: 'let=1;']

{ #category : #'7 Lexical Conventions' }
JavascriptSyntaxTest >> testLineTerminator [

	JSELexicalParser lineTerminatorCodeUnitValues do: [ : codeValue | | character |
		character := (Character codePoint: codeValue).
		self parse: '{a;', (String with:  character), 'b;}' equals: #((a b)).
	].]

{ #category : #'7 Lexical Conventions' }
JavascriptSyntaxTest >> testLiteral [

	self parseExpression: '123' equals: 123.
	self parseExpression: '"test"' equals: 'test'.
	self parseExpression: 'true' equals: true.
	self parseExpression: 'false' equals: false.
	self parseExpression: 'null' equals: nil.

	" make sure that the string token '(' ')' is not handled as parenthesis "
	self parseExpression: '"("' equals: '('.
	self parseExpression: 'call("(" + ")")' equals: #(#call (('(' #+ ')'))).]

{ #category : #'11 Expressions' }
JavascriptSyntaxTest >> testLogicalOperators [

	self privateTestBinaryOperators: #('&&' '||')]

{ #category : #'11.1 Primary Expressions' }
JavascriptSyntaxTest >> testMacro [
	#('#foo' '#foo1')
		do: [:identifier | self
			parseExpression: identifier
			equals: identifier allButFirst asSymbol]]

{ #category : #'11.1 Primary Expressions' }
JavascriptSyntaxTest >> testMacro2 [
	| node1 node2 |
	node1 := JSEParser current parse: '$scope.checkedB = "hola";'.
	node2 := JSEParser new
		factory: JSESyntaxTreeFactory new;
		parse: '$scope.checkedB = "hola";'.
	self
		assert: node1 class = node2 class;
		assert: node2 sourceElements first expression expression literalValue
			= 'hola']

{ #category : #'11 Expressions' }
JavascriptSyntaxTest >> testMultiplicativeOperators [

	self parseExpression: '1 * 2' equals: #(1 #* 2).
	self parseExpression: '1 / 2' equals: #(1 #/ 2).
	self parseExpression: '1 % 2' equals: #(1 #% 2).

	self assertExpressionFailure: '* 1'.
	self assertExpressionFailure: '1 *'.
	self assertExpressionFailure: '1 * / 2'.
	self assertExpressionFailure: '1 % * 2'.]

{ #category : #'11.2 Left-Hand-Side Expressions' }
JavascriptSyntaxTest >> testNewExpression [

	self parseExpression: 'new Blog' equals: #(new Blog).
	self parseExpression: 'new Blog()' equals: #(new Blog ()).
	self parseExpression: 'new Blog(url)' equals: #(new #Blog (url)).
	self parseExpression: 'new Blog(url, title)' equals: #(new Blog (url title)).

	self parseExpression: 'new new Blog' equals: #(new #(new Blog)).
	self parseExpression: 'new new Blog()' equals: #(new #(new Blog ())).
	self parseExpression: 'new new Blog(url, title)' equals: #(new #(new Blog (url title))).
	self parseExpression: 'new new Blog(url)(title)' equals: #(new #(new Blog (url))(title)).

	self assertExpressionFailure: 'new'.
	self assertExpressionFailure: 'new new'.]

{ #category : #'11.1 Primary Expressions' }
JavascriptSyntaxTest >> testObjectLiteral [

	self parseObjectLiteral: '{}' equals: #().
	self parseObjectLiteral: '{key1: 123}' equals: #(( key1 123)).
	self parseObjectLiteral: '{key1: 123, }' equals: #(( key1 123)).
	self parseObjectLiteral: '{key1: 123, key2: 234}' equals: #(( key1 123) ( key2 234)).

	self parseObjectLiteral: '{get property() { {} }}' equals: #(( #(get property) #(()))).
	self parseObjectLiteral: '{set property(arg) { {} }}' equals: #(( (set property arg) #(()))).

	self assertExpressionFailure: 'o={123}'.
	self assertExpressionFailure: 'o={key1:}'.
	self assertExpressionFailure: 'o={key1,key2: 123}'.]

{ #category : #'11 Expressions' }
JavascriptSyntaxTest >> testPostfixOperators [
	self parseExpression: '123++' equals: #(123 #++).
	self parseExpression: '123--' equals: #(123 #'--').
	self parseExpression: '123 ++' equals: #(123 #++).
	self parseExpression: '123 /* postfix */ ++' equals: #(123 #++).
	self assertExpressionFailure: '123' , (String with: Character cr) , '++'.
	self
		assertExpressionFailure: '123 /* ' , (String with: Character cr) , ' */ ++']

{ #category : #'11.1 Primary Expressions' }
JavascriptSyntaxTest >> testRegularExpression [

	self parseExpression: '/\w+\d*/' equals: #(regex '\w+\d*').

	" a greedy lexical parser that does not check the regular expression would return '2)' as regular expression, and the syntactic parser would fail "
	self parseExpression: '(1/2)/3' equals: #(((1 #/ 2)) #/ 3).]

{ #category : #'11 Expressions' }
JavascriptSyntaxTest >> testRelationalOperators [

	self privateTestBinaryOperators: JSESyntacticParser relationalOperators]

{ #category : #'12 Statements' }
JavascriptSyntaxTest >> testReturn [

	self parse: 'return;' equals: #(return).
	self parse: 'return result;' equals: #((return result)).
	self parse: 'return result=42;' equals: #((return (result #= 42))).
	self parse: 'return ', (String with: Character cr), ' noResult;' equals: #(return noResult).

	self assertParseFailure: 'return result1 result2;'.
	self assertParseFailure: 'return {42;};'.]

{ #category : #'11 Expressions' }
JavascriptSyntaxTest >> testShiftOperators [

	self privateTestBinaryOperators: JSESyntacticParser shiftOperators]

{ #category : #'12 Statements' }
JavascriptSyntaxTest >> testSwitch [

	self parse: 'switch (i) {case 1: a;}' equals: #((switch i ((case 1 (a)) ))).
	self parse: 'switch (i) {default: d;}' equals: #((switch i ((default (d)) ))).
	self parse: 'switch (i) {case 1: a; case 2: b;}' equals: #((switch i ((case 1 (a)) (case 2 (b)) ))).
	self parse: 'switch (i) {case 1: a; default: d;}' equals: #((switch i ((case 1 (a)) (default (d)) ))).
	self parse: 'switch (i) {default: d;case 1: a;}' equals: #((switch i ((default (d)) (case 1 (a)) ))).
	self parse: 'switch (i) {}' equals: #((switch i ())).
	self parse: 'switch (i) {case 1: a; case 1: b;}' equals: #((switch i ((case 1 (a)) (case 1 (b)) ))).

	self assertParseFailure: 'switch (i) {default: d; default: d;}'.
	self assertParseFailure: 'switch (i) {case: a;}'.
	self assertParseFailure: 'switch {case 1: a;}'.
	self assertParseFailure: 'switch i {case 1: a;}'.]

{ #category : #'11.1 Primary Expressions' }
JavascriptSyntaxTest >> testThis [

	self parseExpression: 'this' equals: #this]

{ #category : #'12 Statements' }
JavascriptSyntaxTest >> testThrow [

	self parse: 'throw exception;' equals: #((throw exception)).
	self parse: 'return exception=e;' equals: #((return (exception #= e))).

	self assertParseFailure: 'throw ', (String with: Character cr), ' exception;'.
	self assertParseFailure: 'throw;'.
	self assertParseFailure: 'throw {exception;};'.]

{ #category : #'12 Statements' }
JavascriptSyntaxTest >> testTry [

	self parse: 'try {something;} catch (Failure) {fail;}' equals: #((try (something) (catch Failure (fail)))).
	self parse: 'try {something;} finally {cleanup;}' equals: #((try (something) (finally (cleanup)))).
	self parse: 'try {something;} catch (Failure) {fail;} finally {cleanup;}' equals: #((try (something) (catch Failure (fail)) (finally (cleanup)))).

	self assertParseFailure: 'try {something;}'.
	self assertParseFailure: 'try something; finally {cleanup;}'.
	self assertParseFailure: 'try {something;} catch {fail;}'.
	self assertParseFailure: 'try {something;} catch (Failure)'.
	self assertParseFailure: 'try {something;} finally cleanup;'.
	self assertParseFailure: 'try {something;} catch () {fail;}'.
	self assertParseFailure: 'try {something;} finally {cleanup;} catch (Failure) {fail;} '.]

{ #category : #'11 Expressions' }
JavascriptSyntaxTest >> testUnaryOperators [
	JSESyntacticParser unaryOperators do: [:operatorString | 
		self
			parseExpression: operatorString , ' value'
			equals: (Array with: operatorString asSymbol with: #value).
		(operatorString conform: [:ch | ch isLetter not]) ifTrue: [
			self
				parseExpression: operatorString , 'value'
				equals: (Array with: operatorString asSymbol with: #value)]].
	self parseExpression: '++n' equals: #(#++ n).
	self parseExpression: '--n' equals: #(#'--' n).
	self parseExpression: '-- n' equals: #(#'--' n).
	self parseExpression: '- -n' equals: #(#- (#- n))]

{ #category : #'12 Statements' }
JavascriptSyntaxTest >> testVariableStatement [
	self parse: 'var blog;' equals: #((var (blog))).
	self parse: 'var blog="MyBlog";' equals: #((var ((blog #= 'MyBlog')))).
	self
		parse: 'var blog,microblog,feed;'
		equals: #((var (blog microblog feed))).
	self
		parse: 'var blog="MyBlog",microblog,feed;'
		equals: #((var ((blog #= 'MyBlog') microblog feed))).
	self
		parse: 'var blog="MyBlog",microblog="Whale",feed="News";'
		equals: #((var ((blog #= 'MyBlog') (microblog #= 'Whale') (feed #= 'News')))).
	self
		parse: 'var bool=1 in numbers;'
		equals: #((var ((bool #= (1 in numbers))))).
	self assertParseFailure: 'var blog=;'.
	self assertParseFailure: 'var var=1;'.
	self assertParseFailure: 'var=1;']

{ #category : #'12.6 Iteration Statements' }
JavascriptSyntaxTest >> testWhile [

	self parse: 'while (a>b) {1;}' equals: #((while (a #> b) (1) )).

	self assertParseFailure: 'while a<b {1;}'.
	self assertParseFailure: 'while {1;}'.]

{ #category : #'7 Lexical Conventions' }
JavascriptSyntaxTest >> testWhitespace [

	#( '{a;b;}'  '{a; b;}' '{ a; b; }' ' { a; b; } ' ) do: [ : string |
		self parse: string equals: #((a b)).
	].]

{ #category : #'12 Statements' }
JavascriptSyntaxTest >> testWith [

	self parse: 'with (a) b;' equals: #((with a b)).

	self assertParseFailure: 'with () b;'.
	self assertParseFailure: 'with a b;'.
	self assertParseFailure: 'with (;) b;'.]

