Class {
	#name : #Metaclass,
	#superclass : #Species,
	#instVars : [
		'#class'
	],
	#category : #Kernel
}

{ #category : #accessing }
Metaclass >> beSubclassOf: aClass [
	| md |
	instanceBehavior classBinding: self.
]

{ #category : #accessing }
Metaclass >> classVariables [
	^class classVariables
]

{ #category : #accessing }
Metaclass >> classVarNames [
	^class classVarNames
]

{ #category : #services }
Metaclass >> duplicateHierarchyFrom: aClass with: aClassCopy [
	^(class duplicateHierarchyFrom: aClass with: aClassCopy) class
]

{ #category : #comparing }
Metaclass >> hash [
	^class hash
]

{ #category : #accessing }
Metaclass >> instanceClass [
	^class
]

{ #category : #accessing }
Metaclass >> instanceClass: aClass [
	class := aClass
]

{ #category : #testing }
Metaclass >> isMetaclass [
	^true
]

{ #category : #accessing }
Metaclass >> name [
	^class name , ' class'
]

{ #category : #accessing }
Metaclass >> sharedPools [
	^class sharedPools
]

{ #category : #inquiries }
Metaclass >> shouldBeHidden: aSymbol [
	^class shouldBeHidden: aSymbol
]

{ #category : #accessing }
Metaclass >> subclasses [
	^class subclasses collect: [:cls | cls class]
]

{ #category : #accessing }
Metaclass >> subclasses: aCollection [
	"
]

{ #category : #accessing }
Metaclass >> subclassesDo: aBlock [
	class isNil ifTrue: [^self].
]

{ #category : #accessing }
Metaclass >> subspecies [
	^self subclasses
]

{ #category : #accessing }
Metaclass >> subspeciesDo: aBlock [
	self subclassesDo: aBlock
]

{ #category : #accessing }
Metaclass >> symbol [
	^class symbol
]
