Class {
	#name : #ClassOrganizer,
	#superclass : #Object,
	#instVars : [
		'#comment',
		'#categories',
		'#selectors',
		'#author',
		'#timestamp',
		'#prev'
	],
	#category : #Kernel
}

{ #category : #constants }
ClassOrganizer class >> default [
	^#unclassified
]

{ #category : #updating }
ClassOrganizer >> addCategory: aString [
	| s |
]

{ #category : #accessing }
ClassOrganizer >> allSelectors [
	selectors isNil ifTrue: [^#()].
]

{ #category : #accessing }
ClassOrganizer >> author [
	^author
]

{ #category : #accessing }
ClassOrganizer >> author: aString [
	author := aString
]

{ #category : #accessing }
ClassOrganizer >> categories [
	categories isNil ifTrue: [
]

{ #category : #private }
ClassOrganizer >> categoriesOn: aClass [
	categories isNil ifTrue: [
]

{ #category : #queries }
ClassOrganizer >> categoryFor: element [
	| index |
]

{ #category : #private }
ClassOrganizer >> checkDefaultCategoryOn: aClass [
	| index unclassified all |
]

{ #category : #updating }
ClassOrganizer >> classify: element [
	element == #doit ifTrue: [^self].
]

{ #category : #updating }
ClassOrganizer >> classify: element under: category [
	| protocol |
]

{ #category : #updating }
ClassOrganizer >> classifyAll: elements under: category [
	| protocol |
]

{ #category : #accessing }
ClassOrganizer >> comment [
	^comment ifNil: ['']
]

{ #category : #updating }
ClassOrganizer >> comment: aString [
	comment := aString
]

{ #category : #updating }
ClassOrganizer >> down: category [
	| index |
]

{ #category : #updating }
ClassOrganizer >> getSelectorsFor: heading [
	| h |
]

{ #category : #private }
ClassOrganizer >> hasValidSelectorsIn: aClass [
	| valid |
]

{ #category : #updating }
ClassOrganizer >> move: element to: category [
	self
]

{ #category : #updating }
ClassOrganizer >> moveCategory: category to: integer [
	| index s |
]

{ #category : #accessing }
ClassOrganizer >> position [
	^prev
]

{ #category : #accessing }
ClassOrganizer >> position: anInteger [
	prev := anInteger
]

{ #category : #copying }
ClassOrganizer >> postCopy [
	categories := categories copy.
]

{ #category : #accessing }
ClassOrganizer >> prev [
	^prev
]

{ #category : #accessing }
ClassOrganizer >> prev: ref [
	self ASSERT: false.
]

{ #category : #queries }
ClassOrganizer >> rebuild [
	| n prevCat |
]

{ #category : #removing }
ClassOrganizer >> remove: element [
	selectors isNil ifTrue: [^self].
]

{ #category : #updating }
ClassOrganizer >> removeCategory: aString [
	| index |
]

{ #category : #updating }
ClassOrganizer >> renameCategory: aSymbol toBe: anotherSymbol [
	| index existing protocol |
]

{ #category : #updating }
ClassOrganizer >> reorganizeWith: categoryCollection [
	categoryCollection withIndexDo: [:c :i | self moveCategory: c to: i]
]

{ #category : #private }
ClassOrganizer >> selectors [
	^selectors
]

{ #category : #queries }
ClassOrganizer >> selectorsFor: aString [
	| index |
]

{ #category : #accessing }
ClassOrganizer >> timestamp [
	^timestamp
]

{ #category : #accessing }
ClassOrganizer >> timestamp: aTimestamp [
	timestamp := aTimestamp
]

{ #category : #updating }
ClassOrganizer >> up: heading [
	| index |
]

{ #category : #private }
ClassOrganizer >> updateOn: aClass [
	| valid |
]
