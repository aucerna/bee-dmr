"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ProjectDefinition,
	#superclass : #ClusterChange,
	#category : #ProjectChanges
}

{ #category : #accessing }
ProjectDefinition >> resolveProject [
	(BeeModule exists: childProject)
		ifTrue: [ModuleAlreadyExistsException signalOn: childProject].
	^BeeProject new name: childProject]

{ #category : #accessing }
ProjectDefinition >> sourceCode [
	^self project referenceString , ' ' , #addNewProject: , ' '
		, childProject storeString]

