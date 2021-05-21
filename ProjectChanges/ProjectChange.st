"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ProjectChange,
	#superclass : #ChangeRecord,
	#category : #ProjectChanges
}

{ #category : #accessing }
ProjectChange >> refersTo [
	^{self class. self project name}]

