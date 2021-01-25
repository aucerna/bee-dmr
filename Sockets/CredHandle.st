"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CredHandle,
	#superclass : #SecHandle,
	#category : #sockets
}

{ #category : #inspecting }
CredHandle class >> aspects [
	^SecHandle aspects]

