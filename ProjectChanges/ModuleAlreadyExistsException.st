"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ModuleAlreadyExistsException,
	#superclass : #Warning,
	#category : #ProjectChanges
}

{ #category : #'instance creation' }
ModuleAlreadyExistsException class >> signalOn: aString [
	^self signal: aString]

{ #category : #accessing }
ModuleAlreadyExistsException >> description [
	^'Module named ' , description , ' already exists']

