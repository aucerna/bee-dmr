"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JavascriptCompilingTest,
	#superclass : #TestCase,
	#category : #'JavaScript\Tests'
}

{ #category : #compilation }
JavascriptCompilingTest class >> configureCompiler: aCompiler [
	aCompiler optionAt: #compilerClass put: HybridCompiler]

{ #category : #accessing }
JavascriptCompilingTest >> compiler [
	^Compiler forClass: self class]

{ #category : #all }
JavascriptCompilingTest >> testEmptyMethod [
	| cm |
	cm := self compiler compileMethod: 'm <js>'.
	self
		assert: cm notNil;
		assert: (cm executeOn: self) = '']

{ #category : #all }
JavascriptCompilingTest >> testNoDoubleSemicolon [
	| a b one composition |
	a := self compiler compileMethod: 'a
	<js>
	1111'.
	self assert: a notNil.
	b := self compiler compileMethod: 'b: arg
	<js>
	#arg'.
	one := a executeOn: nil.
	composition := b executeOn: nil withArguments: (Array with: one).
	self
		assert: (one includesString: '1111');
		deny: (composition occurrencesOf: $;) = 2]

{ #category : #all }
JavascriptCompilingTest >> testPlaygroundMethod [
	| cm |
	cm := self compiler
		compileMethod: 'ok2
	<js>
	$scope.ok = function() {
		$uibModalInstance.close($scope.selected.item = 17);
	};
'.
	self
		assert: cm notNil;
		assert: (cm executeOn: self)
			= '$scope.ok = function() {
	$uibModalInstance.close($scope.selected.item = 17)
};']

{ #category : #all }
JavascriptCompilingTest >> testSimpleMethod [
	| cm |
	cm := self compiler compileMethod: 'm
	<js>
	$scope.max = 200;'.
	self
		assert: cm notNil;
		assert: (cm executeOn: self) = '$scope.max = 200;']

{ #category : #all }
JavascriptCompilingTest >> testSimpleMethod2 [
	| cm |
	cm := self compiler
		compileMethod: 'validateRole
	<js>
	function validateRole() {
		return $scope.user.Role.Name !== null;
}
;'.
	self
		assert: cm notNil;
		assert: (cm executeOn: self)
			= 'function validateRole() {
	return $scope.user.Role.Name !== null
};']

{ #category : #all }
JavascriptCompilingTest >> testTP49097 [
	| method |
	method := self compiler compileMethod: 'tp49097
	<js>
	"TP49097";'.
	self assert: (method asString endsWith: '>>tp49097')]

{ #category : #all }
JavascriptCompilingTest >> testTP49099 [
	| method |
	Locale current
		answerTo: #decimalSeparator
		with: ','
		while: [method := self compiler compileMethod: 'float
	<js>
	1.0;'].
	self assert: (method executeOn: self) = '1.0;']

{ #category : #all }
JavascriptCompilingTest >> testTP49181 [
	| cm js |
	cm := self compiler compileMethod: 'tp49181: arg
	<js>
	"TP49097" + #arg;'.
	self assert: cm notNil.
	js := cm executeOn: nil withArguments: #('"hola"').
	self assert: js = '"TP49097" + "hola";']

{ #category : #all }
JavascriptCompilingTest >> testTP49181b [
	| cm js |
	cm := self compiler
		compileMethod: 'tp49181: arg arg2: arg2
	<js>
	"TP49097" + #arg + #arg2;'.
	self assert: cm notNil.
	js := cm executeOn: nil withArguments: #('"hola"' '"mundo"').
	self assert: js = '"TP49097" + "hola" + "mundo";']

{ #category : #all }
JavascriptCompilingTest >> testTP49670 [
	| selector |
	selector := self compiler findSelector: 'self k1: one k2: two'.
	self assert: selector == #k1:k2:]

{ #category : #all }
JavascriptCompilingTest >> testTP49673 [
	| a b vars |
	a := self compiler compileMethod: 'a
	<js>
	a = 1;'.
	self assert: a notNil.
	b := self compiler compileMethod: 'b
	<js>
	b = 2;'.
	self assert: b notNil.
	vars := self compiler compileMethod: 'vars: vars
	<js>
	#vars'.
	self assert: vars notNil.
	a := a executeOn: nil.
	b := b executeOn: nil.
	vars := vars executeOn: nil withArguments: (Array with: a , b).
	self assert: vars = 'a = 1;
b = 2;']

{ #category : #all }
JavascriptCompilingTest >> testTP49817 [
	| cm js |
	cm := self compiler compileMethod: 'TP49817: arg
	<js>
	##arg;'.
	self assert: cm notNil.
	js := cm executeOn: nil withArguments: #('hola').
	self assert: js = '#hola;']

{ #category : #all }
JavascriptCompilingTest >> testTP49851 [
	| cm js |
	cm := self compiler
		compileMethod: 'TP49851: arg1 arg2: arg2
	<js>
	arg2= #arg2;
	arg1= #arg1;
	'.
	self assert: cm notNil.
	js := cm executeOn: nil withArguments: #('"a"' '"b"' ).
	self assert: js = 'arg2 = "b";
arg1 = "a";']

{ #category : #all }
JavascriptCompilingTest >> testTP51983 [
	| result |
	result := Compiler
		compile: 'm ^String new , <js>ok()</js>'
		in: UndefinedObject.
	self
		assert: (result method executeOn: nil) = 'ok()';
		assert: (result ast format includesString: 'ok()</js>').
	result := Compiler
		compile: 'm ^String new , <js>ok();</js>'
		in: UndefinedObject.
	self
		assert: (result method executeOn: nil) = 'ok();';
		assert: (result ast format includesString: 'ok();</js>')]

{ #category : #validation }
JavascriptCompilingTest >> validateRole [
	<js>
	function validateRole() {
		return $scope.user.Role.Name !== null;
	};]

