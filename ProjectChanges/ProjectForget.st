"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ProjectForget,
	#superclass : #ClusterChange,
	#category : #ProjectChanges
}

{ #category : #perform }
ProjectForget >> basicPerform [
	self project forget: self resolveProject.]

{ #category : #testing }
ProjectForget >> changesSomething [
	^super changesSomething not]

{ #category : #accessing }
ProjectForget >> sourceCode [
	^self project referenceString , ' forget: ' , childProject storeString]

{ #category : #undo }
ProjectForget >> tip [
	^'Forget project ' , childProject , ' from ' , self project name]

{ #category : #undo }
ProjectForget >> undo [
	^self projectChanges addProject: self resolveProject]

