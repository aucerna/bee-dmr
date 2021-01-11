"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MediaTypeParser,
	#superclass : #MediaTypeGrammar,
	#category : #HTTP
}

{ #category : #'pm support' }
MediaTypeParser class >> aboutToSaveLibraryOn: aCodeSegmentBuilder [
	aCodeSegmentBuilder map: current to: nil.
	super aboutToSaveLibraryOn: aCodeSegmentBuilder]

{ #category : #accessing }
MediaTypeParser class >> current [
	current isNil ifTrue: [self initializeCurrent].
	^current]

{ #category : #initialization }
MediaTypeParser class >> initializeCurrent [
	current := self new]

{ #category : #productions }
MediaTypeParser >> mediaType [
	^super mediaType ==> [:nodes | | type |
		type := MediaType new
			type: nodes first;
			tree: nodes third;
			subtype: nodes fourth;
			suffix: nodes fifth.
		nodes sixth do: [:p | type parametersAt: p key put: p value].
		type]]

{ #category : #productions }
MediaTypeParser >> parameter [
	^super parameter ==> [:nodes | nodes second -> nodes fourth]]

{ #category : #productions }
MediaTypeParser >> suffix [
	^super suffix ==> [:nodes | nodes second]]

{ #category : #productions }
MediaTypeParser >> tree [
	^super tree ==> [:nodes | nodes first]]

