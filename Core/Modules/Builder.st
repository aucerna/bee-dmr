Class {
	#name : #Builder,
	#superclass : #Object,
	#instVars : [
		'module',
		'closure',
		'wordSize'
	],
	#category : #'Builder'
}

{ #category : #closure }
Builder >> build [
	module prepareForSnapshot: self.
	closure traverse: module.
]

{ #category : #accessing }
Builder >> closure [
	^closure
]

{ #category : #private }
Builder >> configureClass: aClass [
	self
		configureSuperclass: aClass;
		configureSubclasses: aClass;
		configureMethods: aClass.
]

{ #category : #private }
Builder >> configureMethods: aClass [
    | original saved |
    original := aClass methodDictionary.
    saved := Dictionary new. "original collect: [:method | module originalMethodFor: method]."
    saved := saved select: [:method | method notNil].
	saved do: [:method | self configureMethodExecutableCode: method].
    closure map: original to: saved
]

{ #category : #private }
Builder >> configureMethodExecutableCode: method [
	closure map: method executableCode to: nil.
	method hasBlocks ifFalse: [^self].
	method do: [:slot |
		slot class == CompiledBlock
			ifTrue: [closure map: slot blockExecutableCode to: nil]]
]

{ #category : #private }
Builder >> configureSubclasses: aClass [
    | original saved |
    original := aClass subclasses.
    saved := original select: [:s | module classes includes: s].
    closure map: original to: saved
]

{ #category : #private }
Builder >> configureSuperclass: aClass [
    | superclass |
    superclass := aClass superclass.
	superclass ifNil: [^self].
    (module classes includes: superclass) ifFalse: [self import: superclass]
]

{ #category : #initializing }
Builder >> initialize [
	closure := ObjectClosure new.
]

{ #category : #accessing }
Builder >> map: anObject to: anotherObject [
	closure map: anObject to: anotherObject
]

{ #category : #accessing }
Builder >> module: aModule [
	module := aModule.
    module classes do: [:c | self configureClass: c]
]
