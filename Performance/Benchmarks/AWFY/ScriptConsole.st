Class {
	#name : #ScriptConsole,
	#superclass : #Object,
	#category : #AWFY
}

{ #category : #private }
ScriptConsole class >> println: aString [
	| all |
	all := aString replaceAll: '\n' with: String cr.
	(Smalltalk at: #Transcript) nextPutAll: all , String cr
]

{ #category : #private }
ScriptConsole >> println: aString [
	(Smalltalk at: #Transcript) nextPutAll: aString
]

