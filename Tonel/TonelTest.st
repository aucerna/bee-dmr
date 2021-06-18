"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #TonelTest, 
	#superclass : #TestCase, 
	#instVars : OrderedCollection [
		'streams'
	], 
	#classVars : [], 
	#category : #Tonel
}

{
	#category : #private
}
TonelTest >> filenameFor: aClassSpec [
	^(aClassSpec name , '.class.st') asFilename]

{
	#category : #private
}
TonelTest >> readerFor: aClass [
	| filename stream |
	filename := self filenameFor: aClass.
	stream := streams at: filename.
	^TonelReader on: stream readStream]

{
	#category : #'set up'
}
TonelTest >> setUp [
	streams := Dictionary new]

{
	#category : #all
}
TonelTest >> test010writeObjectDefinition [
	| writer definition reader |
	writer := self writerFor: Object.
	writer writeClass: Object category: #Kernel.
	reader := self readerFor: Object.
	definition := reader read; definition.
	self
		assert: (definition at: #name) = #Object;
		assert: (definition at: #superclass) = #ProtoObject;
		assert: (definition at: #category) = #Kernel]

{
	#category : #all
}
TonelTest >> test012writeDefinitionWithInstVars [
	| writer definition reader |
	writer := self writerFor: OrderedCollection.
	writer writeClass: OrderedCollection category: #Kernel.
	reader := self readerFor: OrderedCollection.
	definition := reader read; definition.
	self
		assert: (definition at: #name) = #OrderedCollection;
		assert: (definition at: #superclass) = #SequenceableCollection;
		assert: (definition at: #instVars) = #('start' 'end' 'contents');
		assert: (definition at: #category) = #Kernel]

{
	#category : #all
}
TonelTest >> test014writeDefinitionWithClassVars [
	| writer definition reader |
	writer := self writerFor: SmallInteger.
	writer writeClass: SmallInteger category: #Kernel.
	reader := self readerFor: SmallInteger.
	definition := reader read; definition.
	self
		assert: (definition at: #name) = #SmallInteger;
		assert: (definition at: #superclass) = #Integer;
		assert: (definition at: #classVars) = #('Maximum' 'Minimum');
		assert: (definition at: #category) = #Kernel]

{
	#category : #all
}
TonelTest >> test016writeDefinitionWithInstAndClassVars [
	| writer definition reader |
	writer := self writerFor: CompiledMethod.
	writer writeClass: CompiledMethod category: #Kernel.
	reader := self readerFor: CompiledMethod.
	definition := reader read; definition.
	self
		assert: (definition at: #name) = #CompiledMethod;
		assert: (definition at: #superclass) = CompiledMethod superclass symbol;
		assert: (definition at: #instVars) = CompiledMethod instVarNames;
		assert: (definition at: #classVars) = #('Flags');
		assert: (definition at: #category) = #Kernel]

{
	#category : #all
}
TonelTest >> test020writeOneMethod [
	| writer reader methods cm |
	writer := self writerFor: Object.
	cm := Object >> #species.
	writer writeMethod: cm.
	reader := self readerFor: Object.
	methods := reader readMethods; methods.
	self
		assert: methods size = 1;
		assert: (methods first at: #class) = 'Object';
		assert: (methods first at: #selector) = #species;
		assert: cm source lines size = 2;
		assert: (methods first at: #body) trimBlanks = cm source lines last]

{
	#category : #all
}
TonelTest >> test025writeOneMethodWithArguments [
	| writer reader methods cm |
	writer := self writerFor: Object.
	cm := Object >> #byteAt:put:.
	writer writeMethod: cm.
	reader := self readerFor: Object.
	methods := reader readMethods; methods.
	self
		assert: methods size = 1;
		assert: (methods first at: #class) = 'Object';
		assert: cm source lines size = 2;
		assert: (methods first at: #selector) = cm selector;
		assert: (methods first at: #body) trimBlanks = cm source lines last]

{
	#category : #all
}
TonelTest >> test030writeTwoMethods [
	| cm1 cm2 writer reader methods |
	cm1 := Object >> #species.
	cm2 := Object >> #value.
	writer := self writerFor: Object.
	writer writeMethod: cm1; writeMethod: cm2.
	reader := self readerFor: Object.
	methods := reader readMethods; methods.
	self
		assert: methods size = 2;
		assert: (methods first at: #class) = 'Object';
		assert: (methods first at: #selector) = #species;
		assert: cm1 source lines size = 2;
		assert: (methods first at: #body) trimBlanks = cm1 source lines last;
		assert: (methods second at: #class) = 'Object';
		assert: (methods second at: #selector) = #value;
		assert: cm2 source lines size = 2;
		assert: (methods second at: #body) trimBlanks = cm2 source lines last]

{
	#category : #all
}
TonelTest >> testClassDefinition [
	| tonel writer reader definition |
	tonel := '' writeStream.
	writer := TonelWriter on: tonel.
	writer writeClass: Point.
	reader := TonelReader on: tonel contents readStream.
	reader read.
	definition := reader definition.
	self
		assert: (definition at: #name) = #Point;
		assert: (definition at: #instVars) = #('x' 'y')]

{
	#category : #all
}
TonelTest >> testExtension [
	| tonel writer reader method |
	tonel := '' writeStream.
	writer := TonelWriter on: tonel.
	writer writeMethods: {TonelTest >> #testExtension}.
	reader := TonelReader on: tonel contents readStream.
	reader read.
	self assert: reader methods size = 1.
	method := reader methods anyone.
	self
		assert: (method at: #class) = 'TonelTest';
		assert: (method at: #selector) == #testExtension]

{
	#category : #all
}
TonelTest >> testReadMethodWithLiteralBracket [
	| tonel reader |
	tonel := 'Extension { #name : #TonelTest }

{
	#category : #accessing
}
TestClass >> m [
	$]]'.
	reader := TonelReader on: tonel readStream.
	reader read.
	self
		assert: reader methods size = 1;
		assert: (reader methods anyone at: #body) trimBlanks = '$]']

{
	#category : #private
}
TonelTest >> writerFor: aClass [
	| filename stream |
	filename := self filenameFor: aClass.
	stream := '' writeStream.
	streams at: filename put: stream.
	^TonelWriter on: stream]

