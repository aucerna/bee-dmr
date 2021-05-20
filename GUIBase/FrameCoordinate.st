"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FrameCoordinate,
	#superclass : #Object,
	#instVars : [
		'ratio',
		'inset',
		'pane',
		'skipHidden',
		'pixels',
		'owner'
	],
	#category : #GUIbase
}

{ #category : #'instance creation' }
FrameCoordinate class >> for: aFramingLayout [
	^self new owner: aFramingLayout]

{ #category : #'instance creation' }
FrameCoordinate class >> new [
	^super new initialize]

{ #category : #testing }
FrameCoordinate >> canTieToOpposite [
	^false]

{ #category : #utility }
FrameCoordinate >> clone [
	^self copy]

{ #category : #private }
FrameCoordinate >> defaultRatio [
	^0]

{ #category : #accessing }
FrameCoordinate >> displayUnit [
	^self subclassResponsibility]

{ #category : #comparing }
FrameCoordinate >> equals: aFrameCoordinate [
	^inset = aFrameCoordinate insetDU
		and: [ratio = aFrameCoordinate ratio]
		and: [pane = aFrameCoordinate pane]
		and: [skipHidden = aFrameCoordinate skipsHidden]
		and: [inset notNil or: [pixels = aFrameCoordinate pixels]]]

{ #category : #testing }
FrameCoordinate >> hasLinkedPanes [
	^pane notNil ]

{ #category : #initialization }
FrameCoordinate >> initialize [
	ratio := self defaultRatio.
	inset := 0.
	skipHidden := false]

{ #category : #accessing }
FrameCoordinate >> inset [
	^pixels notNil ifTrue: [pixels] ifFalse: [self insetInPixels]]

{ #category : #accessing }
FrameCoordinate >> inset: anInteger [
	pixels := anInteger.
	inset := nil]

{ #category : #accessing }
FrameCoordinate >> insetDU [
	^inset]

{ #category : #accessing }
FrameCoordinate >> insetDU: anInteger [
	inset := anInteger.
	pixels := nil]

{ #category : #accessing }
FrameCoordinate >> insetInPixels [
	pixels notNil ifTrue: [^pixels].
	^pixels := (inset * self displayUnit) rounded]

{ #category : #testing }
FrameCoordinate >> isHorizontal [
	^false]

{ #category : #testing }
FrameCoordinate >> isLinkedTo: aWindow [
	^pane == aWindow]

{ #category : #testing }
FrameCoordinate >> isProportional [
	^ratio != 0 and: [ratio != 1]]

{ #category : #displaying }
FrameCoordinate >> label [
	^self name asString]

{ #category : #'gui support' }
FrameCoordinate >> link: aSymbol in: aRectangle [
	| proportion |
	aSymbol == #proportional ifTrue: [^self keepProportionWith: aRectangle].
	proportion := self ratioFor: aSymbol.
	self keepProportion: proportion in: aRectangle]

{ #category : #utility }
FrameCoordinate >> linkBottomTo: aChildWindow [
	ratio := 1.
	pane := aChildWindow]

{ #category : #utility }
FrameCoordinate >> linkLeftTo: aChildWindow [
	ratio := 0.
	pane := aChildWindow]

{ #category : #utility }
FrameCoordinate >> linkRightTo: aChildWindow [
	ratio := 1.
	pane := aChildWindow]

{ #category : #inquiries }
FrameCoordinate >> linkSymbol [
	ratio = 0.5 ifTrue: [^#center].
	^#proportional]

{ #category : #utility }
FrameCoordinate >> linkTopTo: aChildWindow [
	ratio := 0.
	pane := aChildWindow]

{ #category : #utility }
FrameCoordinate >> linkToSibling: aChildWindow in: aRectangle [
	| reference offset |
	reference := self referenceSegmentFrom: aRectangle.
	offset := self offsetIn: reference.
	pane := aChildWindow.
	reference := self referenceSegmentFrom: aRectangle.
	pixels := offset - (reference x + (reference y - reference x * ratio))]

{ #category : #utility }
FrameCoordinate >> move: anInteger [
	pixels := self insetInPixels + anInteger.
	self updateInset]

{ #category : #services }
FrameCoordinate >> moveTo: offset in: rectangle [
	self subclassResponsibility]

{ #category : #utility }
FrameCoordinate >> offsetIn: segmentPoint [
	| v |
	v := segmentPoint y - segmentPoint x.
	^v * ratio + self insetInPixels]

{ #category : #accessing }
FrameCoordinate >> owner: aFramingLayout [
	owner := aFramingLayout]

{ #category : #accessing }
FrameCoordinate >> pane [
	^pane]

{ #category : #accessing }
FrameCoordinate >> pane: aChildWindow [
	pane := aChildWindow]

{ #category : #utility }
FrameCoordinate >> pixels [
	^pixels]

{ #category : #printing }
FrameCoordinate >> printOn: aStream [
	aStream nextPutAll: self label , 'Ratio: '.
	ratio printOn: aStream.
	inset notNil
		ifTrue: [
			aStream nextPutAll: ' insetDU: '.
			inset printOn: aStream]
		ifFalse: [
			aStream nextPutAll: ' inset: '.
			pixels printOn: aStream].
	self hasLinkedPanes
		ifTrue: [aStream nextPutAll: ' linkTo: '; nextPutAll: pane printString]]

{ #category : #accessing }
FrameCoordinate >> ratio [
	^ratio]

{ #category : #accessing }
FrameCoordinate >> ratio: aFraction [
	ratio := aFraction]

{ #category : #inquiries }
FrameCoordinate >> ratioFor: aSymbol [
	aSymbol == #center ifTrue: [^0.5].
	self ASSERT: false]

{ #category : #private }
FrameCoordinate >> referenceRectangleFrom: aRectangle [
	| rect |
	^pane isNil ifTrue: [aRectangle] ifFalse: [
		rect := pane rectangleFromParent: aRectangle.
		pane isComboBox ifTrue: [rect height: pane itemHeight + 6].
		rect]]

{ #category : #inquiries }
FrameCoordinate >> referenceSymbol [
	ratio = 0.5 ifTrue: [^#center].
	self ASSERT: false]

{ #category : #utility }
FrameCoordinate >> relativeTo: aRectangle [
	| coordinate |
	coordinate := skipHidden ifTrue: [self skippingHiddenCopy] ifFalse: [self].
	^coordinate valueAt: aRectangle]

{ #category : #utility }
FrameCoordinate >> relativeToScreen [
	^self relativeTo: VirtualScreen current boundingRectangle]

{ #category : #utility }
FrameCoordinate >> removePane: aChildWindow [
	pane == aChildWindow ifFalse: [^self].
	pane := aChildWindow framingLayout paneFromConnection: self]

{ #category : #utility }
FrameCoordinate >> replaceFrom: aFrameCoordinate [
	ratio := aFrameCoordinate ratio.
	inset := aFrameCoordinate insetDU.
	pane := aFrameCoordinate pane.
	pixels := aFrameCoordinate pixels]

{ #category : #utility }
FrameCoordinate >> replaceLinkedPanes: aDictionary [
	pane := aDictionary at: pane ifAbsent: [^self]]

{ #category : #utility }
FrameCoordinate >> replacePane: aChildWindow with: anotherSubpane [
	pane == aChildWindow ifTrue: [pane := anotherSubpane]]

{ #category : #private }
FrameCoordinate >> selector [
	^self name]

{ #category : #accessing }
FrameCoordinate >> skipHidden: aBoolean [
	skipHidden := aBoolean]

{ #category : #private }
FrameCoordinate >> skippingHiddenCopy [
	| reference |
	skipHidden ifFalse: [^self].
	reference := self visibleLinkedCoordinate.
	reference == self ifTrue: [^self].
	^self shallowCopy
		skipHidden: false;
		pane: reference pane;
		ratio: reference ratio]

{ #category : #testing }
FrameCoordinate >> skipsHidden [
	^skipHidden]

{ #category : #updating }
FrameCoordinate >> updateInset [
	inset notNil ifTrue: [inset := pixels / self displayUnit]]

{ #category : #updating }
FrameCoordinate >> updateLinkedPanesFrom: aWindow [
	| name |
	name := pane isWindow ifTrue: [pane name] ifFalse: [pane].
	name notNil ifTrue: [pane := aWindow paneNamed: name]]

{ #category : #accessing }
FrameCoordinate >> valueAt: aRectangle [
	| segment size |
	segment := self referenceSegmentFrom: aRectangle.
	size := segment y - segment x.
	^segment x + (size * ratio + self insetInPixels)]

{ #category : #private }
FrameCoordinate >> visibleLinkedCoordinate [
	(pane notNil and: [pane isHidden]) ifTrue: [
		pane framingLayout class == FramingLayout
			ifTrue: [^(pane framingLayout perform: self selector) visibleLinkedCoordinate]].
	^self]

