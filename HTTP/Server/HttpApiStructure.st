"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpApiStructure,
	#superclass : #WindowsStructure,
	#category : #'HTTP\Server'
}

{ #category : #accessing }
HttpApiStructure class >> typedefTable [
	^HttpApiDLL typedefTable]

