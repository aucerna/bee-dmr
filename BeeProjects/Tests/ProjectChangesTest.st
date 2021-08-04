"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ProjectChangesTest, 
	#superclass : #TestCase, 
	#instVars : [
		'project', 
		'changes'
	], 
	#category : #Tests
}

{#category : #running}
ProjectChangesTest >> setUp [
	project := BeeProject new name: testSelector.
	changes := project changes]

{#category : #running}
ProjectChangesTest >> tearDown [
	changes currentChanges removeAll.
	project notNil ifTrue: [project unload].
	project := changes := nil]

{#category : #logging}
ProjectChangesTest >> testNewPoolDictionary [
	| global browser |
	browser := ProjectBrowserModel on: project.
	global := #AnyPoolDictionary.
	self
		evaluate: [browser selectedProject newPoolDictionary]
		whenOpenModalDialog: [:dialog | dialog result: global; abortOpen].
	self
		assert: (Smalltalk at: global) class == PoolDictionary;
		assert: project changes currentChanges size = 1.
	project removeGlobal: global.
	self deny: (project globals includes: global).
	Smalltalk removeKey: global.
	project changes currentChanges last perform.
	self assert: (project globals includes: global)]

{#category : #tests}
ProjectChangesTest >> testTP37062a [
	changes
		defineClass: 'Object
	subclass: #XYZ
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
		notifying: nil.
	[
		self
			assert: changes currentChanges size = 1;
			assert: (changes wasModifiedClass: (Smalltalk at: #XYZ)).
		changes renameClass: (Smalltalk at: #XYZ) to: 'XYZRenamed'.
		self
			assert: changes currentChanges size = 2;
			assert: (changes wasModifiedClass: (Smalltalk at: #XYZRenamed)).
		changes renameClass: (Smalltalk at: #XYZRenamed) to: 'XYZ'.
		self
			assert: changes currentChanges size = 3;
			assert: (changes wasModifiedClass: (Smalltalk at: #XYZ))]
		ensure: [
			#(#XYZ #XYZRenamed)
				do: [:s | Smalltalk at: s ifPresent: [:c | c removeFromSystem]]]]

{#category : #tests}
ProjectChangesTest >> testTP37062b [
	changes
		defineClass: 'Object
	subclass: #XYZ
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
		notifying: nil.
	changes currentChanges removeAll.
	self
		assert: changes currentChanges size = 0;
		deny: (changes wasModifiedClass: (Smalltalk at: #XYZ)).
	changes renameClass: (Smalltalk at: #XYZ) to: 'XYZRenamed'.
	self
		assert: changes currentChanges size = 1;
		assert: (changes wasModifiedClass: (Smalltalk at: #XYZRenamed)).
	changes renameClass: (Smalltalk at: #XYZRenamed) to: 'XYZ'.
	self
		assert: changes currentChanges size = 2;
		assert: (changes wasModifiedClass: (Smalltalk at: #XYZ))]

{#category : #tests}
ProjectChangesTest >> testTP37062c [
	changes
		defineClass: 'Object
	subclass: #XYZ
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
		notifying: nil.
	[
		changes compile: 'foo ^1' in: (Smalltalk at: #XYZ).
		self
			assert: changes currentChanges size = 2;
			assert: (changes wasModifiedClass: (Smalltalk at: #XYZ));
			assert: (changes
				wasModifiedSelector: 'foo' asSymbol
				in: (Smalltalk at: #XYZ)).
		changes renameSelector: 'foo' asSymbol as: 'bar' asSymbol.
		self
			assert: changes currentChanges size = 3;
			assert: (changes
				wasModifiedSelector: 'bar' asSymbol
				in: (Smalltalk at: #XYZ));
			assert: (changes wasModifiedClass: (Smalltalk at: #XYZ)).
		changes renameSelector: 'bar' asSymbol as: 'foo' asSymbol.
		self
			assert: changes currentChanges size = 4;
			assert: (changes
				wasModifiedSelector: 'foo' asSymbol
				in: (Smalltalk at: #XYZ));
			assert: (changes wasModifiedClass: (Smalltalk at: #XYZ))]
		ensure: [Smalltalk at: #XYZ ifPresent: [:c | c removeFromSystem]]]

{#category : #tests}
ProjectChangesTest >> testTP37062e [
	changes
		defineClass: 'Object
	subclass: #XYZ
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
		notifying: nil.
	[
		changes compile: 'foo ^1' in: (Smalltalk at: #XYZ).
		changes currentChanges removeAll.
		self
			assert: changes currentChanges size = 0;
			deny: (changes wasModifiedClass: (Smalltalk at: #XYZ));
			deny: (changes wasModifiedSelector: 'foo' asSymbol in: (Smalltalk
				at: #XYZ)).
		changes renameSelector: 'foo' asSymbol as: 'bar' asSymbol.
		self
			assert: changes currentChanges size = 1;
			assert: (changes
				wasModifiedSelector: 'bar' asSymbol
				in: (Smalltalk at: #XYZ));
			assert: (changes wasModifiedClass: (Smalltalk at: #XYZ))]
		ensure: [Smalltalk at: #XYZ ifPresent: [:c | c removeFromSystem]]]

{#category : #tests}
ProjectChangesTest >> testTP37062f [
	changes
		defineClass: 'Object
	subclass: #XYZ
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
		notifying: nil;
		compile: 'foo ^self bar' in: (Smalltalk at: #XYZ);
		compile: 'bar ^1' in: (Smalltalk at: #XYZ).
	[
		changes currentChanges removeAll.
		self
			assert: changes currentChanges size = 0;
			deny: (changes wasModifiedClass: (Smalltalk at: #XYZ));
			deny: (changes wasModifiedSelector: 'foo' asSymbol in: (Smalltalk
				at: #XYZ));
			deny: (changes wasModifiedSelector: #bar in: (Smalltalk at: #XYZ)).
		changes renameSelector: 'bar' asSymbol as: #baz.
		self
			assert: changes currentChanges size = 1;
			assert: (changes
				wasModifiedSelector: 'foo' asSymbol
				in: (Smalltalk at: #XYZ));
			deny: (changes wasModifiedSelector: 'bar' asSymbol in: (Smalltalk
				at: #XYZ));
			assert: (changes wasModifiedSelector: #baz in: (Smalltalk at: #XYZ));
			assert: (changes wasModifiedClass: (Smalltalk at: #XYZ))]
		ensure: [Smalltalk at: #XYZ ifPresent: [:c | c removeFromSystem]]]

{#category : #tests}
ProjectChangesTest >> testTP37062g [
	changes
		defineClass: 'Object
	subclass: #XYZ
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
		notifying: nil;
		compile: 'foo ^self bar' in: (Smalltalk at: #XYZ).
	[
		changes currentChanges removeAll.
		changes renameSelector: #bar as: #baz.
		self assert: (changes wasModifiedClass: (Smalltalk at: #XYZ))]
		ensure: [Smalltalk at: #XYZ ifPresent: [:c | c removeFromSystem]]]

{#category : #tests}
ProjectChangesTest >> testTP37062h [
	changes
		defineClass: 'Object
	subclass: #XYZ
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
		notifying: nil;
		defineClass: 'Object
	subclass: #IJK
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
		notifying: nil;
		compile: 'foo ^self bar' in: (Smalltalk at: #XYZ);
		compile: 'bar ^1' in: (Smalltalk at: #IJK).
	changes currentChanges removeAll.
	self
		assert: changes currentChanges size = 0;
		deny: (changes wasModifiedClass: (Smalltalk at: #XYZ));
		deny: (changes wasModifiedClass: (Smalltalk at: #IJK));
		deny: (changes wasModifiedSelector: 'foo' asSymbol in: (Smalltalk at: #XYZ));
		deny: (changes wasModifiedSelector: 'bar' asSymbol in: (Smalltalk at: #IJK)).
	changes renameSelector: 'bar' asSymbol as: #baz.
	self
		assert: changes currentChanges size = 1;
		assert: (changes
			wasModifiedSelector: 'foo' asSymbol
			in: (Smalltalk at: #XYZ));
		deny: (changes wasModifiedSelector: 'bar' asSymbol in: (Smalltalk at: #IJK));
		assert: (changes wasModifiedSelector: #baz in: (Smalltalk at: #XYZ));
		assert: (changes wasModifiedClass: (Smalltalk at: #XYZ));
		assert: (changes wasModifiedClass: (Smalltalk at: #IJK))]

{#category : #tests}
ProjectChangesTest >> testTP37062i [
	| cluster |
	cluster := BeeCluster new.
	cluster add: project.
	changes
		defineClass: 'Object
	subclass: #XYZ
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
		notifying: nil;
		compile: 'foo ^self bar' in: (Smalltalk at: #XYZ).
	[
		changes currentChanges removeAll.
		changes renameSelector: #bar as: #bar.
		changes renameSelector: #bar as: #baz.
		changes renameSelector: #baz as: #qux.
		changes renameSelector: #qux as: #bar.
		self
			assert: (changes wasModifiedSelector: #bar in: (Smalltalk at: #XYZ));
			assert: (cluster wasModifiedSelector: #bar in: (Smalltalk at: #XYZ))]
		ensure: [Smalltalk at: #XYZ ifPresent: [:c | c removeFromSystem]]]

{#category : #tests}
ProjectChangesTest >> testTP37062j [
	#knownIssue.
	changes
		defineClass: 'Object
	subclass: #XYZ
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
		notifying: nil.
	changes currentChanges removeAll.
	changes compile: 'foo ^self bar' in: (Smalltalk at: #XYZ).
	self assert: (changes wasModifiedSelector: #bar in: (Smalltalk at: #XYZ)).
	changes renameClass: (Smalltalk at: #XYZ) to: #IJK.
	self assert: (changes wasModifiedSelector: #bar in: (Smalltalk at: #IJK)).
	changes renameClass: (Smalltalk at: #IJK) to: #LMN.
	self assert: (changes wasModifiedSelector: #bar in: (Smalltalk at: #LMN))]

{#category : #tests}
ProjectChangesTest >> testTP37062k [
	changes
		defineClass: 'Object
	subclass: #XYZ
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
		notifying: nil.
	[
		changes currentChanges removeAll.
		changes compile: 'foo ^self bar' in: (Smalltalk at: #XYZ).
		self
			assert: (changes
				wasModifiedSelector: 'foo' asSymbol
				in: (Smalltalk at: #XYZ)).
		changes renameSelector: 'foo' asSymbol as: 'bar' asSymbol.
		changes renameClass: (Smalltalk at: #XYZ) to: #IJK.
		self
			assert: (changes
				wasModifiedSelector: 'bar' asSymbol
				in: (Smalltalk at: #IJK)).
		changes renameClass: (Smalltalk at: #IJK) to: #LMN.
		changes renameSelector: 'bar' asSymbol as: #baz.
		self assert: (changes wasModifiedSelector: #baz in: (Smalltalk at: #LMN))]
		ensure: [
			#(#YXY #IJK #LMN)
				do: [:s | Smalltalk at: s ifPresent: [:c | c removeFromSystem]]]]

{#category : #tests}
ProjectChangesTest >> testTP45127 [
	changes
		defineClass: 'Object
	subclass: #TP45127
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
		notifying: nil.
	[| d cls |
		cls := Smalltalk at: #TP45127.
		changes currentChanges removeAll.
		changes compile: 'foo ^super foo' in: cls.
		changes renameSelector: 'foo' asSymbol as: 'bar' asSymbol.
		d := MethodDecorator on: cls >> #bar.
		self
			assert: d allVersions size = 1;
			deny: (d project wasOverridden: cls);
			assert: (d isSenderOf: #bar)]
		ensure: [Smalltalk at: #TP45127 ifPresent: [:c | c removeFromSystem]]]

{#category : #tests}
ProjectChangesTest >> testTP52894 [
	| skernel change |
	skernel := Object project.
	change := skernel changes
		methodDefinitionClass: Object
		sourceCode: 'TP52894'.
	[| addition cm |
		cm := change perform.
		self assert: cm project = skernel.
		addition := MethodAddition fromCompiledMethod: cm in: self class project.
		addition perform.
		skernel changes forgetMethod: cm.
		self assert: (skernel excludedMethods includes: cm signature).
		skernel renameSelector: cm selector as: #TP52894_B.
		self class project renameSelector: cm selector as: #TP52894_B.
		self
			assert: (skernel excludedMethods
				includes: (Object >> #TP52894_B) signature)]
		ensure: [
			Object project changes
				removeSelector: #TP52894_B from: Object;
				removeSelector: #TP52894_B from: Object.
			self class project changes
				removeSelector: #TP52894_B from: Object;
				removeSelector: #TP52894_B from: Object]]

