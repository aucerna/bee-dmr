"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ClassRenameTest,
	#superclass : #TestCase,
	#category : #ProjectChanges
}

{ #category : #running }
ClassRenameTest >> runCase [
	(self class >> testSelector includes: #ignoreChanges)
		ifTrue: [(self class >> testSelector) project
			ignoreChangesWhile: [super runCase]]
		ifFalse: [super runCase]]

{ #category : #all }
ClassRenameTest >> testClassRename [
	| project cls source source2 method change |
	#ignoreChanges.
	project := (self class >> #testClassRename) project.
	[
		cls := self class subclass: 'RCT' asSymbol.
		project changes addClass: cls.
		source := 'm
	Array with: #RCT with: RCT.
	#(#RCT)'.
		source2 := 'm
	Array with: #RCT2 with: RCT2.
	#(#RCT2)'.
		method := self class class compile: source.
		method sourceCode: source.
		change := MethodDefinition fromCompiledMethod: method.
		change addToProject: project.
		project changes
			renameClass: (Smalltalk at: 'RCT' asSymbol)
			to: 'RCT2' asSymbol
			renameReferences: true.
		self
			assert: method currentVersion source trimBlanks
				= (source2 copyWithout: Character lf).
		project changes
			renameClass: (Smalltalk at: 'RCT2' asSymbol)
			to: 'RCT' asSymbol
			renameReferences: true.
		self
			assert: method currentVersion source trimBlanks zapLfs = source zapLfs]
		ensure: [
			method isCompiledMethod ifTrue: [
				project changes
					removeSelector: method selector
					from: method classBinding;
					removeClass: cls]]]

{ #category : #all }
ClassRenameTest >> testClassRename2 [
	| project cls source source2 method change info |
	#ignoreChanges.
	project := (self class >> #testClassRename2) project.
	[
		cls := self class subclass: 'RCT' asSymbol.
		project changes addClass: cls.
		source := 'm
	Array with: #RCT with: RCT.
	#(#RCT
#RCT_
#_RCT   RCT #(RCT))'.
		source2 := 'm
	Array with: #RCT2 with: RCT2.
	#(#RCT2
#RCT_
#_RCT   RCT2 #(RCT2))'.
		method := self class class compile: source.
		method sourceCode: source.
		change := MethodDefinition fromCompiledMethod: method.
		change addToProject: project.
		project changes
			renameClass: (Smalltalk at: 'RCT' asSymbol)
			to: 'RCT2' asSymbol
			renameReferences: true.
		self
			assert: method currentVersion source trimBlanks
				= (source2 copyWithout: Character lf).
		project changes
			renameClass: (Smalltalk at: 'RCT2' asSymbol)
			to: 'RCT' asSymbol
			renameReferences: true.
		self
			assert: method currentVersion source trimBlanks zapLfs = source zapLfs]
		ensure: [
			method isCompiledMethod ifTrue: [
				project changes
					removeSelector: method selector
					from: method classBinding;
					removeClass: cls]]]

{ #category : #all }
ClassRenameTest >> testLiteralNodeVisit [
	| a a2 literal visitor |
	a := #(RCT #(RCT #(RCT))).
	a2 := #(RCT #(RCT #(RCT))).
	literal := LiteralNode new.
	literal answerTo: #source with: nil.
	literal value: a.
	visitor := GlobalRenameVisitor forReplacing: #(#RCT) with: #(#RCT).
	literal acceptVisitor: visitor.
	self assert: literal value = a2]

{ #category : #all }
ClassRenameTest >> testTP56167 [
	| source class changes saved |
	#ignoreChanges.
	source := 'm
	^{TP56167}'.
	class := Class new name: 'TP56167'.
	changes := self class project changes.
	saved := changes currentChanges.
	changes instVarNamed: 'changes' put: OrderedCollection new.
	[
		Smalltalk globals at: class symbol put: class.
		self class compile: source.
		self
			shouldnt: [class renameWithReferencesTo: 'TP56167B']
			raise: UndeclaredIdentifierError.
		self
			assert: self m = (Array with: class);
			assert: ((self class >> #m) sourceCode includesString: 'TP56167B')]
		ensure: [
			self class removeSelector: #m.
			Smalltalk globals
				removeKey: #TP56167B ifAbsent: nil;
				removeKey: #TP56167B ifAbsent: nil.
			changes instVarNamed: 'changes' put: saved]]

