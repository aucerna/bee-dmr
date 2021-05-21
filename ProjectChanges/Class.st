"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Class }

{ #category : '*ProjectChanges' }
Class >> comment [
	^self organization
		ifNil: ['']
		ifNotNil: [:o | o comment copyWithout: 10 asCharacter]]

{ #category : '*ProjectChanges' }
Class >> commentStamp: aString prior: number [
	^ClassCommentDefinition new class: self]

{ #category : '*ProjectChanges' }
Class >> renameWithReferencesTo: aString [
	self project renameClass: self to: aString asSymbol renameReferences: true]

