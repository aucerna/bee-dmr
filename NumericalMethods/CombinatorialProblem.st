"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CombinatorialProblem,
	#superclass : #Object,
	#instVars : [
		'goal'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
CombinatorialProblem class >> new [
	^super new initialize]

{ #category : #examples }
CombinatorialProblem class >> sampleInstance [
	^self new]

{ #category : #'gui support' }
CombinatorialProblem >> canExportToExcel [
	^false]

{ #category : #inquiries }
CombinatorialProblem >> costAt: point [
	self subclassResponsibility

	]

{ #category : #inquiries }
CombinatorialProblem >> costIncrementFor: delta on: point [
	self subclassResponsibility]

{ #category : #inquiries }
CombinatorialProblem >> costScale [
	^1.0]

{ #category : #inquiries }
CombinatorialProblem >> distanceToGoal [
	^(goal - self initialCost) abs]

{ #category : #accessing }
CombinatorialProblem >> goal [
	^goal]

{ #category : #accessing }
CombinatorialProblem >> goal: value [
	goal := value]

{ #category : #inquiries }
CombinatorialProblem >> initialCost [
	^self costAt: self initialSolution]

{ #category : #initialization }
CombinatorialProblem >> initialize [
	super initialize.
	goal := 0.0]

{ #category : #inquiries }
CombinatorialProblem >> initialSolution [
	self subclassResponsibility]

{ #category : #services }
CombinatorialProblem >> modify: point with: delta [
	self subclassResponsibility]

{ #category : #services }
CombinatorialProblem >> solver [
	^self solverClass forProblem: self]

{ #category : #accessing }
CombinatorialProblem >> solverClass [
	^self subclassResponsibility]

