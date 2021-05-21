"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #SmalltalkSystem }

{ #category : '*ProjectChanges' }
SmalltalkSystem >> defineClass: className
superclass: aClass
indexedType: aSymbol
private: aBoolean
instanceVariableNames: instanceVariables
classInstanceVariableNames: classInstanceVariables
imports: dummy
category: projectName [
	| project class |
	self ASSERT: aSymbol == #none.
	self ASSERT: dummy isEmpty.
	project := BeeModule named: projectName.
	self ASSERT: project notNil.
	class := aClass
		subclass: className
		instanceVariableNames: instanceVariables
		classVariableNames: ''
		poolDictionaries: ''.
	class class instanceVariableNames: classInstanceVariables.
	project addClass: class]

{ #category : '*ProjectChanges' }
SmalltalkSystem >> defineSharedVariable: aSymbol
private: aBoolean
constant: isConstant
category: projectName
initializer: aString [
	| project object |
	project := BeeModule named: projectName.
	self ASSERT: project notNil.
	self ASSERT: isConstant.
	Smalltalk at: aSymbol put: nil.
	project addGlobal: aSymbol.
	object := Compiler evaluate: aString.
	Smalltalk at: aSymbol put: object]

