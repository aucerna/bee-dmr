"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ClusterDefinition,
	#superclass : #ClusterChange,
	#category : #ProjectChanges
}

{ #category : #accessing }
ClusterDefinition >> resolveProject [
	(BeeModule exists: childProject)
		ifTrue: [ModuleAlreadyExistsException signalOn: childProject].
	^BeeCluster new name: childProject]

{ #category : #accessing }
ClusterDefinition >> sourceCode [
	^self project referenceString , ' ' , #addNewCluster: , ' '
		, childProject storeString]

