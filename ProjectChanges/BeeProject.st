"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #BeeProject }

{ #category : '*ProjectChanges' }
BeeProject >> fileOutExclusion: anAssociation on: aStream [
	MethodForget basicNew
		className: anAssociation key name;
		selector: anAssociation value;
		project: self;
		fileOutOn: aStream.
	aStream cr]

{ #category : '*ProjectChanges' }
BeeProject >> fileOutSettingsOn: aStream [
	| settings |
	settings := self settings ifNil: [^self].
	settings keys asArray sort do: [:key | | value |
		value := settings at: key.
		ProjectSettingDefinition basicNew
			setting: key value: value;
			project: self;
			fileOutOn: aStream.
		aStream cr; cr]]

{ #category : '*ProjectChanges' }
BeeProject >> readFrom: aStream [
	Compiler evaluate: aStream nextChunk for: self.
	changes := self fileInChangesFrom: aStream.
	self computeUnresolved]

