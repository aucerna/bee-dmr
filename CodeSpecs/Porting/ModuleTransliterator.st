"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ModuleTransliterator, 
	#superclass : #Object, 
	#instVars : [
		'module', 
		'rules'
	], 
	#category : #Porting
}

{#category : #'instance creation'}
ModuleTransliterator class >> new [
	^super new initialize]

{#category : #'adding / removing'}
ModuleTransliterator >> addRule: aTransliterationRule [
	rules add: aTransliterationRule]

{#category : #'adding / removing'}
ModuleTransliterator >> addRules: aCollection [
	rules addAll: aCollection]

{#category : #'adding / removing'}
ModuleTransliterator >> initialize [
	rules := OrderedCollection new]

{#category : #'adding / removing'}
ModuleTransliterator >> module [
	^module]

{#category : #accessing}
ModuleTransliterator >> module: aModuleSpec [
	module := aModuleSpec]

{#category : #services}
ModuleTransliterator >> removeClass: aString [
	| rule |
	rule := ClassRemoveRule name: aString.
	self addRule: rule]

{#category : #services}
ModuleTransliterator >> removeInstVar: ivar in: classname [
	| rule |
	rule := RemoveInstVarRule named: ivar in: classname.
	self addRule: rule]

{#category : #services}
ModuleTransliterator >> removeMethodsSuchThat: aBlock [
	self removeMethodsSuchThat: aBlock class: nil module: nil]

{#category : #services}
ModuleTransliterator >> removeMethodsSuchThat: aBlock class: classname module: modulename [
	| rule |
	rule := (MethodFilterRule on: aBlock)
		module: modulename;
		class: classname.
	self addRule: rule]

{#category : #services}
ModuleTransliterator >> removePackage: aString [
	| rule |
	rule := PackageRemoveRule name: aString.
	self addRule: rule]

{#category : #services}
ModuleTransliterator >> removeSelectors: selectors [
	self removeSelectors: selectors class: nil module: nil]

{#category : #services}
ModuleTransliterator >> removeSelectors: selectors class: classname [
	^self removeSelectors: selectors class: classname module: nil]

{#category : #services}
ModuleTransliterator >> removeSelectors: selectors class: classname module: modulename [
	| rule |
	rule := (MethodFilterRule on: [:m | selectors includes: m selector])
		module: modulename;
		class: classname.
	self addRule: rule]

{#category : #services}
ModuleTransliterator >> removeSelectors: selectors module: modulename [
	^self removeSelectors: selectors class: nil module: modulename]

{#category : #services}
ModuleTransliterator >> renameIdentifier: from to: to [
	self renameIdentifier: from to: to class: nil module: nil]

{#category : #services}
ModuleTransliterator >> renameIdentifier: from to: to class: classname [
	self renameIdentifier: from to: to class: classname module: nil]

{#category : #services}
ModuleTransliterator >> renameIdentifier: from
to: to
class: classname
module: modulename [
	| rule |
	rule := IdentifierRenameRule from: from to: to.
	rule class: classname; module: modulename.
	self addRule: rule]

{#category : #services}
ModuleTransliterator >> renamePackage: aString to: anotherString [
	| rule |
	rule := PackageRenameRule from: aString to: anotherString.
	self addRule: rule]

{#category : #services}
ModuleTransliterator >> renameSelector: aString to: anotherString [
	| rule |
	rule := SelectorRenameRule from: aString to: anotherString.
	self addRule: rule]

{#category : #actions}
ModuleTransliterator >> transliterate [
	rules do: [:rule | rule applyTo: module].
	module cleanDependencies; removeEmptyExtensions]

{#category : #actions}
ModuleTransliterator >> transliterate: aModuleSpec [
	module := aModuleSpec.
	self transliterate]

