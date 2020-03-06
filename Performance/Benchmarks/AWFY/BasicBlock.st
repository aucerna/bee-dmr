Class {
	#name : #BasicBlock,
	#superclass : #Object,
	#instVars : [
		'inEdges',
		'outEdges',
		'name'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
BasicBlock class >> new: aString [
	^self new init: aString
]

{ #category : #'as yet unclassified' }
BasicBlock >> addInEdge: from [

    inEdges append: from
]

{ #category : #'as yet unclassified' }
BasicBlock >> addOutEdge: to [

    outEdges append: to
]

{ #category : #'as yet unclassified' }
BasicBlock >> customHash [

    ^ name
]

{ #category : #'as yet unclassified' }
BasicBlock >> inEdges [
 ^ inEdges 
]

{ #category : #'as yet unclassified' }
BasicBlock >> init: aName [

    inEdges  := Vector new: 2.
    outEdges := Vector new: 2.
    name     := aName
]

{ #category : #'as yet unclassified' }
BasicBlock >> numPred [
 ^ inEdges size 
]

{ #category : #'as yet unclassified' }
BasicBlock >> outEdges [
 ^ outEdges 
]

