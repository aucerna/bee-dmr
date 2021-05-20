"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TreeItem,
	#superclass : #GUIControlItem,
	#instVars : [
		'id',
		'leaf',
		'children',
		'expanded',
		'parent',
		'depth'
	],
	#classVars : [
		'Stub'
	],
	#category : #GUIbase
}

{ #category : #initialization }
TreeItem class >> initialize [
	super initialize.
	Stub := self new expanded: false]

{ #category : #accessing }
TreeItem class >> stubItem [
	^Stub]

{ #category : #comparing }
TreeItem >> = aListItem [
	super = aListItem ifFalse: [^false].
	id = aListItem id ifFalse: [^false].
	^true]

{ #category : #queries }
TreeItem >> allChildren [
	| collection |
	collection := OrderedCollection with: self.
	self hasChildItems
		ifTrue: [children do: [:spec | collection addAll: spec allChildren]].
	^collection]

{ #category : #'collection protocol' }
TreeItem >> allItemsDo: aBlock [
	aBlock value: self.
	self children ifNil: [^self].
	children do: [:c | c allItemsDo: aBlock]]

{ #category : #'collection protocol' }
TreeItem >> anySatisfy: aBlock [
	self do: [:item | (aBlock value: item) ifTrue: [^true]].
	^false]

{ #category : #converting }
TreeItem >> asParameter [
	^id]

{ #category : #accessing }
TreeItem >> children [
	(leaf isNil or: [children isNil]) ifTrue: [self updateChildren].
	^children]

{ #category : #accessing }
TreeItem >> children: aCollection [
	| class |
	aCollection isNil ifTrue: [
		children := nil.
		^self].
	leaf := aCollection isEmptyOrNil.
	class := self class.
	children := aCollection asArray collect: [:element | 
		element class == class
			ifTrue: [element]
			ifFalse: [class new object: element]].
	children do: [:item | item owner: owner; parent: self]]

{ #category : #accessing }
TreeItem >> clear [
	leaf := label := bitmaps := nil]

{ #category : #accessing }
TreeItem >> color [
	self isStubItem ifTrue: [^nil].
	^owner triggerEvent: #needsColorFor: with: object defaultHandler: nil]

{ #category : #'collection protocol' }
TreeItem >> depth [
	^depth
		ifNil: [depth := parent notNil ifTrue: [parent depth + 1] ifFalse: [0]]]

{ #category : #'collection protocol' }
TreeItem >> do: aBlock [
	aBlock value: self.
	children notNil ifTrue: [children do: [:c | c do: aBlock]]]

{ #category : #accessing }
TreeItem >> expanded: aBoolean [
	expanded := aBoolean]

{ #category : #services }
TreeItem >> expandToFind: anObject [
	object = anObject ifTrue: [^true].
	self == anObject ifTrue: [^true].
	self hasChildItems ifFalse: [^false].
	self children do: [:item | 
		(item expandToFind: anObject) ifTrue: [
			expanded := true.
			^true]].
	^false]

{ #category : #testing }
TreeItem >> hasChildItems [
	self isStubItem ifTrue: [^false].
	leaf isNil ifTrue: [self updateLeaf].
	^leaf == false]

{ #category : #testing }
TreeItem >> hash [
	^id hashWith: super hash]

{ #category : #accessing }
TreeItem >> id [
	^id]

{ #category : #accessing }
TreeItem >> id: aNumber [
	id := aNumber]

{ #category : #accessing }
TreeItem >> image [
	^(self bitmapAt: #default) ifNil: [| bmp |
		self isStubItem ifTrue: [^nil].
		bmp := owner
			triggerEvent: #needsImageFor:
			with: object
			defaultHandler: [^nil].
		self image: bmp]]

{ #category : #accessing }
TreeItem >> invalidate [
	label := bitmaps := depth := nil]

{ #category : #accessing }
TreeItem >> invalidateAll [
	self invalidate.
	children := leaf := nil]

{ #category : #testing }
TreeItem >> isCollapsed [
	^self isExpanded not]

{ #category : #testing }
TreeItem >> isExpanded [
	expanded isNil
		ifTrue: [expanded := owner notNil and: [owner isExpanded: object]].
	^expanded]

{ #category : #accessing }
TreeItem >> isStubItem [
	^self == Stub]

{ #category : #testing }
TreeItem >> isTreeItem [
	^true]

{ #category : #services }
TreeItem >> itemFor: anObject [
	object = anObject ifTrue: [^self].
	^self clear itemSatisfying: [:tvi | tvi object = anObject]]

{ #category : #services }
TreeItem >> itemSatisfying: aBlock [
	self hasChildItems ifTrue: [
		self children do: [:item | 
			(aBlock evaluateWith: item) ifTrue: [^item].
			(item itemSatisfying: aBlock) ifNotNil: [:tvi | ^tvi]]].
	^nil]

{ #category : #accessing }
TreeItem >> label [
	^label ifNil: [
		self isStubItem ifTrue: [^nil].
		label := owner
			triggerEvent: #needsStringFor:
			with: object
			defaultHandler: [object asString]]]

{ #category : #queries }
TreeItem >> lastChild [
	| item |
	item := self children last.
	^item hasChildItems ifTrue: [item lastChild] ifFalse: [item]]

{ #category : #accessing }
TreeItem >> owner [
	^owner ifNil: [owner := parent notNil ifTrue: [parent owner]]]

{ #category : #accessing }
TreeItem >> parent [
	^parent]

{ #category : #accessing }
TreeItem >> parent: aTreeItem [
	parent := aTreeItem]

{ #category : #inquiries }
TreeItem >> previousOf: aTreeItem [
	| i |
	i := children indexOf: aTreeItem.
	^i = 1 ifTrue: [self] ifFalse: [(children at: i - 1) lastChild]]

{ #category : #printing }
TreeItem >> printOn: aStream [
	children notNil ifTrue: [aStream nextPutAll: '▷ '].
	aStream nextPutAll: self text]

{ #category : #printing }
TreeItem >> printTextOn: rtf indent: anInteger [
	rtf tab: anInteger; append: self text.
	children notNil
		ifTrue: [children
			do: [:child | child printTextOn: rtf indent: anInteger + 1]]]

{ #category : #accessing }
TreeItem >> resetChildren [
	leaf := false.
	children := nil]

{ #category : #updating }
TreeItem >> update [
	self clear children]

{ #category : #accessing }
TreeItem >> updateChildren [
	| nodes |
	nodes := self owner childrenFor: object.
	nodes notNil ifTrue: [self updateChildren: nodes]]

{ #category : #updating }
TreeItem >> updateChildren: aCollection [
	| registry nodes |
	children == aCollection ifTrue: [^self].
	children isNil ifTrue: [^self children: aCollection].
	registry := Dictionary new.
	children do: [:child | registry at: child object put: child].
	nodes := aCollection collect: [:c | | item |
		c isTreeItem
			ifTrue: [
				item := registry at: c object ifAbsent: c.
				item updateFrom: c]
			ifFalse: [registry
				at: c
				ifAbsent: [c]
				ifPresent: [:tvi | tvi clear object: c]]].
	self children: nodes]

{ #category : #updating }
TreeItem >> updateFrom: aTreeItem [
	self == aTreeItem ifTrue: [^self].
	label := aTreeItem label.
	bitmaps := nil.
	children notNil
		ifTrue: [self updateChildren]
		ifFalse: [leaf notNil ifTrue: [self updateLeaf]]]

{ #category : #private }
TreeItem >> updateLeaf [
	| hasChildren |
	hasChildren := owner
		triggerEvent: #needsHasChildrenFor:
		with: object
		defaultHandler: [self children isEmptyOrNil not].
	leaf := hasChildren not]

{ #category : #'collection protocol' }
TreeItem >> visibleItemsDo: aBlock [
	aBlock value: self.
	self isExpanded ifFalse: [^self].
	self children ifNil: [^self].
	children do: [:c | c visibleItemsDo: aBlock]]

