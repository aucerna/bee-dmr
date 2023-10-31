"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OCompiler,
	#superclass : #Object,
	#instVars : [
		'environment'
	],
	#category : #IR
}

{ #category : #accessing }
OCompiler >> abi [
	^environment abi
]

{ #category : #accessing }
OCompiler >> environment: aNativizationEnvironment [
	environment := aNativizationEnvironment
]

{ #category : #inquiries }
OCompiler >> initialInlineFactor [
	^environment initialInlineFactor
]

{ #category : #services }
OCompiler >> irFrom: method [
	^method hasSpecialABI
		ifTrue: [self irFromAst: method]
		ifFalse: [self irFromBytecodes: method]
]

{ #category : #services }
OCompiler >> irFromAst: method [
	| omethod |
	omethod := self newOMethodFor: method.
	OptimizingVisitor new translate: omethod.
	omethod metaprocess.
	^omethod
]

{ #category : #services }
OCompiler >> irFromBytecodes: method [
	| omethod |
	omethod := self shouldImplement.
	^omethod
]

{ #category : #accessing }
OCompiler >> messageLinker [
	^environment messageLinker
]

{ #category : #services }
OCompiler >> nativeCodeFor: aCompiledMethod [
	| omethod |
	omethod := self irFrom: aCompiledMethod.
	^omethod
		inlineMessages;
		optimize;
		validate;
		lower;
		optimize;
		assemble
]

{ #category : #services }
OCompiler >> newOMethodFor: aCompiledMethod [
	^OMethod new compiler: self; baseMethod: aCompiledMethod
]

