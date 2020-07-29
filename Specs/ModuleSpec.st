"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ModuleSpec,
	#superclass : #Object,
	#instVars : [
		'name',
		'description',
		'classes',
		'extendedClasses',
		'requiredClasses',
		'dependencies'
	],
	#category : #Specs
}

{ #category : #'instance creation' }
ModuleSpec class >> new [
	^super new initialize]

{ #category : #'adding / removing' }
ModuleSpec >> addClass: aClassSpec [
	classes add: aClassSpec]

{ #category : #'adding / removing' }
ModuleSpec >> addClasses: aCollection [
	aCollection do: [:c | self addClass: c]]

{ #category : #'adding / removing' }
ModuleSpec >> addClassExtension: aClassSpec [
	extendedClasses add: aClassSpec]

{ #category : #'adding / removing' }
ModuleSpec >> addDependencies: aCollection [
	dependencies addAll: aCollection]

{ #category : #'adding / removing' }
ModuleSpec >> addDependency: dependency [
	dependencies add: dependency]

{ #category : #'adding / removing' }
ModuleSpec >> addRequiredClass: aClassSpec [
	requiredClasses add: aClassSpec]

{ #category : #inquiries }
ModuleSpec >> allClasses [
	^classes , extendedClasses]

{ #category : #enumerating }
ModuleSpec >> allMethodsDo: aBlock [
	self allClasses do: [:c | c methods do: aBlock]]

{ #category : #accessing }
ModuleSpec >> classes [
	^classes]

{ #category : #accessing }
ModuleSpec >> dependencies [
	^dependencies]

{ #category : #accessing }
ModuleSpec >> dependencies: aCollection [
	dependencies := aCollection]

{ #category : #accessing }
ModuleSpec >> description [
	^description]

{ #category : #accessing }
ModuleSpec >> description: aString [
	description := aString]

{ #category : #accessing }
ModuleSpec >> extendedClasses [
	^extendedClasses]

{ #category : #testing }
ModuleSpec >> includesClass: aClassSpec [
	^(self resolveClass: aClassSpec) notNil]

{ #category : #initialization }
ModuleSpec >> initialize [
	classes := OrderedCollection new.
	extendedClasses := OrderedCollection new.
	requiredClasses := OrderedCollection new.
	dependencies := OrderedCollection new]

{ #category : #accessing }
ModuleSpec >> name [
	^name]

{ #category : #accessing }
ModuleSpec >> name: aString [
	name := aString]

{ #category : #'adding / removing' }
ModuleSpec >> removeSelectors: aCollection [
	self allClasses do: [:c | 
		c removeSelectors: aCollection.
		c metaclass removeSelectors: aCollection]]

{ #category : #'adding / removing' }
ModuleSpec >> removeSelectors: aCollection inClass: aClassSpec [
	| class |
	class := self resolveClass: aClassSpec.
	class removeSelectors: aCollection]

{ #category : #'adding / removing' }
ModuleSpec >> removeSelectors: aCollection inScope: aClassSpec [
	| class all |
	class := self resolveClass: aClassSpec.
	all := self withAllSubclasses: class.
	all do: [:c | c removeSelectors: aCollection]]

{ #category : #resolving }
ModuleSpec >> resolveClass: class [
	| moniker |
	moniker := class isString ifTrue: [class] ifFalse: [class name].
	classes detect: [:c | c name = moniker] ifFound: [:c | ^c].
	^extendedClasses detect: [:c | c name = moniker] ifNone: nil]

{ #category : #resolving }
ModuleSpec >> resolveSpecies: aString [
	| classname |
	^(aString endsWith: ' class')
		ifTrue: [
			classname := aString trimTail: ' class'.
			(self resolveClass: classname) ifNotNil: [:c | c metaclass]]
		ifFalse: [self resolveClass: aString]]

{ #category : #private }
ModuleSpec >> sortedClasses [
	| remaining sorted |
	remaining := classes copy.
	sorted := OrderedCollection new.
	[remaining isEmpty] whileFalse: [| c |
		c := remaining first.
		(remaining includes: c superclass)
			ifTrue: [remaining removeFirst; add: c]
			ifFalse: [
				remaining remove: c.
				sorted add: c]].
	^sorted]

{ #category : #services }
ModuleSpec >> withAllSubclasses: aClassSpec [
	^self allClasses select: [:c | c withAllSuperclasses includes: aClassSpec]]

