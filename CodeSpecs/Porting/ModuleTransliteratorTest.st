"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ModuleTransliteratorTest, 
	#superclass : #TestCase, 
	#instVars : [
		'module', 
		'transliterator', 
		'builder'
	], 
	#category : #Porting
}

{#category : #private}
ModuleTransliteratorTest >> setUp [
	module := ModuleSpec new name: 'TestModule'.
	transliterator := ModuleTransliterator new module: module.
	builder := BeeModuleBuilder new module: module]

{#category : #private}
ModuleTransliteratorTest >> test001doNothing [
	builder addMethod: ModuleTransliteratorTest >> #test001doNothing.
	transliterator transliterate.
	self
		assert: module name = 'TestModule';
		assert: module classes size = 0;
		assert: module extendedClasses size = 1;
		assert: module extendedClasses first name = 'ModuleTransliteratorTest']

{#category : #private}
ModuleTransliteratorTest >> test002filterMethod [
	| extensions class |
	builder
		addMethod: ModuleTransliteratorTest >> #test001doNothing;
		addMethod: ModuleTransliteratorTest >> #test002filterMethod.
	extensions := module extendedClasses.
	class := extensions first.
	transliterator
		removeMethodsSuchThat: [:m | m selector beginsWith: 'test002'];
		transliterate.
	self
		assert: module name = 'TestModule';
		assert: extensions size = 1;
		assert: class name = 'ModuleTransliteratorTest';
		assert: class methods size = 1;
		assert: class methods first selector == #test001doNothing]

{#category : #private}
ModuleTransliteratorTest >> test010removeClass [
	| extensions test |
	builder
		addMethod: ModuleTransliteratorTest >> #test001doNothing;
		addMethod: ModuleTransliteratorTest >> #test010removeClass;
		addMethod: LargeInteger >> #'&';
		addMethod: LargePositiveInteger >> #abs;
		addClassDefinition: LargeNegativeInteger;
		calculateDependencies.
	transliterator removeClass: 'LargeInteger'; transliterate.
	extensions := module extendedClasses.
	test := extensions first.
	self
		assert: module classes size = 1;
		assert: extensions size = 2;
		assert: test name = 'ModuleTransliteratorTest';
		assert: test methods size = 1;
		assert: test methods first selector == #test001doNothing]

{#category : #private}
ModuleTransliteratorTest >> test020removeInstVar [
	| extensions point |
	builder
		addMethod: Point >> #x;
		addMethod: Point >> #y.
	transliterator removeInstVar: 'x' in: 'Point'; transliterate.
	extensions := module extendedClasses.
	point := extensions first.
	self
		assert: extensions size = 1;
		assert: point name = 'Point';
		assert: point methods size = 1;
		assert: point methods first selector == #y]

{#category : #private}
ModuleTransliteratorTest >> test030renameInstVar [
	| extensions point x source |
	builder
		addMethod: Point >> #x;
		addMethod: Point >> #y.
	transliterator
		renameIdentifier: 'x' to: 'z' class: 'Point';
		transliterate.
	extensions := module extendedClasses.
	point := extensions first.
	x := point methods first.
	source := x ast statements first source.
	self
		assert: extensions size = 1;
		assert: point name = 'Point';
		assert: point instVarNames asArray = #('z' 'y');
		assert: point methods size = 2;
		assert: x selector == #x;
		deny: (source includesString: 'x');
		assert: (source includesString: 'z')]

{#category : #private}
ModuleTransliteratorTest >> test031renameClassVar [
	| extensions source large method |
	builder addMethod: LargeInteger >> #digitAt:put:.
	transliterator
		renameIdentifier: 'Base' to: 'Foo' class: 'LargeInteger';
		transliterate.
	extensions := module extendedClasses.
	large := extensions first.
	method := large methods first.
	source := method ast source.
	self
		assert: large classVarNames asArray sort = #('Bits' 'DigitLength' 'Foo');
		deny: (source includesString: 'Base');
		assert: (source includesString: 'Foo')]

{#category : #private}
ModuleTransliteratorTest >> test032renamePoolVar [
	| extensions character method source |
	builder addMethod: Character class >> #cr.
	transliterator renameIdentifier: 'Cr' to: 'Foo'; transliterate.
	extensions := module extendedClasses.
	character := extensions first.
	method := character metaclass methods first.
	source := method ast source.
	self
		deny: (source includesString: 'Cr');
		assert: (source includesString: 'Foo')]

{#category : #private}
ModuleTransliteratorTest >> test033renameSharedPool [
	builder addClassDefinition: Character.
	transliterator
		renameIdentifier: 'CharacterConstants' to: 'Characters';
		transliterate.
	self
		assert: module classes first sharedPools asArray sort = #(#'Characters')]

