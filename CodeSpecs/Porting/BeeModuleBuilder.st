"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #BeeModuleBuilder, 
	#superclass : #Object, 
	#instVars : [
		'module'
	], 
	#category : #Porting
}

{#category : #services}
BeeModuleBuilder class >> fromClass: aClass [
	^self new name: aClass name; addClass: aClass; module]

{#category : #services}
BeeModuleBuilder class >> fromMethod: aCompiledMethod [
	^self new
		name: aCompiledMethod selector asString;
		addMethod: aCompiledMethod;
		module]

{#category : #services}
BeeModuleBuilder class >> fromProject: aBeeProject [
	^self new
		name: aBeeProject name;
		addProject: aBeeProject;
		calculateDependencies;
		module]

{#category : #'instance creation'}
BeeModuleBuilder class >> ignoredProjects [
	^#('extensions' nil)]

{#category : #'instance creation'}
BeeModuleBuilder class >> new [
	^super new initialize]

{#category : #'adding / removing'}
BeeModuleBuilder >> addAllMethodsFrom: aClass into: aClassSpec [
	self addAllMethodsFrom: aClass project: aClass project into: aClassSpec]

{#category : #'adding / removing'}
BeeModuleBuilder >> addAllMethodsFrom: aClass project: aBeeProject into: aClassSpec [
	| instance meta |
	instance := aBeeProject methodsOf: aClass.
	meta := aBeeProject methodsOf: aClass class.
	self
		addMethods: instance into: aClassSpec;
		addMethods: meta into: aClassSpec metaclass]

{#category : #'adding / removing'}
BeeModuleBuilder >> addClass: aClass [
	| class |
	class := self addClassDefinition: aClass.
	self addAllMethodsFrom: aClass into: class]

{#category : #'adding / removing'}
BeeModuleBuilder >> addClassDefinition: aClass [
	| spec |
	spec := self specFromClass: aClass.
	module addClass: spec.
	self importSharedPoolsOf: aClass.
	^spec]

{#category : #'adding / removing'}
BeeModuleBuilder >> addClasses: aCollection [
	aCollection do: [:c | self addClass: c]]

{#category : #'adding / removing'}
BeeModuleBuilder >> addClassExtension: aClass [
	| spec |
	spec := self specFromClass: aClass.
	module addClassExtension: spec.
	self importSharedPoolsOf: aClass.
	^spec]

{#category : #'adding / removing'}
BeeModuleBuilder >> addMethod: aCompiledMethod [
	| class spec |
	class := self ensureClass: aCompiledMethod classBinding instanceClass.
	aCompiledMethod classBinding isMetaclass ifTrue: [class := class metaclass].
	spec := self specFromMethod: aCompiledMethod species: class.
	class addMethod: spec]

{#category : #'adding / removing'}
BeeModuleBuilder >> addMethods: aCollection [
	(aCollection groupBy: #classBinding) keysAndValuesDo: [:class :methods | | spec |
		spec := self ensureClass: class instanceClass.
		class isMetaclass ifTrue: [spec := spec metaclass].
		self addMethods: methods into: spec]]

{#category : #'adding / removing'}
BeeModuleBuilder >> addMethods: aCollection into: aSpeciesSpec [
	| specs |
	specs := aCollection
		collect: [:m | self specFromMethod: m species: aSpeciesSpec].
	aSpeciesSpec addMethods: specs]

{#category : #'adding / removing'}
BeeModuleBuilder >> addProject: aBeeProject [
	self addClasses: aBeeProject classes; addMethods: aBeeProject extensions]

{#category : #'adding / removing'}
BeeModuleBuilder >> addProjectNamed: aString [
	| project |
	project := BeeProject named: aString.
	self addProject: project]

{#category : #'adding / removing'}
BeeModuleBuilder >> addSelectors: aCollection from: aSpecies [
	| class methods |
	class := self ensureClass: aSpecies instanceClass.
	aSpecies isMetaclass ifTrue: [class := class metaclass].
	methods := aCollection collect: [:selector | aSpecies >> selector].
	self addMethods: methods into: class]

{#category : #'adding / removing'}
BeeModuleBuilder >> addSubclassifiedClasses [
	module allClassesDo: [:c | self addSuperclassesOf: c]]

{#category : #'adding / removing'}
BeeModuleBuilder >> addSuperclassesOf: aClassSpec [
	| next spec |
	next := aClassSpec supername.
	[
		next ifNil: [| c |
			c := Smalltalk at: aClassSpec name asSymbol ifAbsent: [^self].
			next := c superclass ifNotNil: [:s | s name]].
		next ifNil: [^self].
		spec := module resolveClass: next.
		spec isNil or: [self isIncomplete: spec]]
		whileTrue: [| class |
			class := Smalltalk at: next asSymbol.
			spec := self specFromClass: class.
			module addSubclassifiedClass: spec.
			next := spec supername]]

{#category : #services}
BeeModuleBuilder >> calculateDependencies [
	| imports projects map extensions |
	self addSubclassifiedClasses.
	imports := module requiredImports.
	projects := imports associations groupBy: [:a | | global |
		global := Smalltalk at: a key asSymbol ifAbsent: [
			Transcript
				print: 'Global ' , a key printString
					, ' is being referenced but was not found in Smalltalk globals';
				cr.
			nil].
		global isSpecies
			ifTrue: [global project name]
			ifFalse: [global imageSegment ifNotNil: [:p | p name]]].
	self ignoredProjects do: [:d | projects removeKey: d ifAbsent: nil].
	map := projects collect: [:group | Dictionary withAll: group].
	module addImports: imports keys; addDependencies: map.
	extensions := Dictionary new.
	module extendedClasses do: [:spec | 
		Smalltalk at: spec name asSymbol ifPresent: [:class | | deps methods |
			deps := extensions at: class project name ifAbsentPut: [Dictionary new].
			methods := deps at: spec name ifAbsentPut: [OrderedCollection new].
			methods addAll: spec methods]].
	module addDependencies: extensions]

{#category : #'adding / removing'}
BeeModuleBuilder >> ensureClass: aClass [
	| class |
	class := module resolveClass: aClass name.
	^class ifNil: [self addClassExtension: aClass] ifNotNil: [class]]

{#category : #services}
BeeModuleBuilder >> ignoredProjects [
	^self class ignoredProjects]

{#category : #'adding / removing'}
BeeModuleBuilder >> importSharedPoolsOf: aClass [
	aClass sharedPools do: [:symbol | 
		module at: symbol ifAbsent: [| pool |
			pool := Smalltalk at: symbol.
			module addImport: symbol -> pool copy]]]

{#category : #initialization}
BeeModuleBuilder >> initialize [
	module := ModuleSpec new]

{#category : #'adding / removing'}
BeeModuleBuilder >> isIncomplete: aClassSpec [
	"
	a class that has been added inderectly and whose shape is not defined
	"
	^aClassSpec name != 'ProtoObject' and: [aClassSpec superclass = nil]]

{#category : #services}
BeeModuleBuilder >> leaveOnlyProject: aBeeProject [
	| target |
	target := OrderedCollection new.
	module allMethodsDo: [:m | | class |
		class := Smalltalk at: m classBinding name asSymbol.
		(aBeeProject includesClass: class selector: m selector)
			ifFalse: [target add: m]].
	target do: [:m | m classBinding removeSelector: m selector]]

{#category : #'adding / removing'}
BeeModuleBuilder >> loadExtensionFromImage: aClassSpec [
	| class supername |
	class := Smalltalk at: aClassSpec name asSymbol ifAbsent: [^self].
	supername := class superclass ifNotNil: [:s | s name].
	aClassSpec
		name: class name;
		supername: supername;
		ivars: class instVarNames asOrderedCollection;
		cvars: class classVariables;
		sharedPools: class sharedPools.
	aClassSpec metaclass ivars: class class instVarNames asOrderedCollection]

{#category : #'adding / removing'}
BeeModuleBuilder >> loadExtensionsFromImage [
	module extendedClasses copy do: [:spec | self loadExtensionFromImage: spec]]

{#category : #accessing}
BeeModuleBuilder >> module [
	^module]

{#category : #initialization}
BeeModuleBuilder >> module: aModuleSpec [
	module := aModuleSpec]

{#category : #accessing}
BeeModuleBuilder >> name: aString [
	module name: aString]

{#category : #'adding / removing'}
BeeModuleBuilder >> removeClass: aClassSpec [
	module removeClass: aClassSpec]

{#category : #private}
BeeModuleBuilder >> specFromClass: aClass [
	| class metaclass n |
	class := ClassSpec new.
	metaclass := self specFromMetaclass: aClass class: class.
	n := aClass superclass ifNotNil: [:s | s name].
	class
		module: module;
		metaclass: metaclass;
		name: aClass name;
		supername: n;
		ivars: aClass instVarNames asOrderedCollection;
		cvars: aClass classVariables;
		sharedPools: aClass sharedPools.
	aClass instancesAreArrayed ifTrue: [class beArrayed].
	aClass instancesHavePointers ifFalse: [class beBytes].
	^class]

{#category : #private}
BeeModuleBuilder >> specFromMetaclass: aMetaclass class: aClassSpec [
	^MetaclassSpec new
		ivars: aMetaclass instVarNames asOrderedCollection;
		module: module;
		instanceClass: aClassSpec]

{#category : #private}
BeeModuleBuilder >> specFromMethod: aCompiledMethod species: aSpeciesSpec [
	^MethodSpec new
		module: module;
		selector: aCompiledMethod selector;
		classBinding: aSpeciesSpec;
		source: aCompiledMethod sourceCode;
		category: aCompiledMethod category]

