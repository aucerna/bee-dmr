"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #BeeCluster }

{ #category : '*ProjectChanges' }
BeeCluster >> fileOutLoadActionsOn: aStream [
	self fileOutLoadAction: loadAction on: aStream]

{ #category : '*ProjectChanges' }
BeeCluster >> fileOutOn: aStream [
	super fileOutOn: aStream.
	aStream cr.
	parts do: [:p | | change |
		change := ProjectAddition basicNew.
		change
			childProject: p name;
			project: self;
			fileOutOn: aStream.
		aStream cr].
	aStream cr]

{ #category : '*ProjectChanges' }
BeeCluster >> fileOutUnloadActionsOn: aStream [
	self fileOutUnloadAction: unloadAction on: aStream]

