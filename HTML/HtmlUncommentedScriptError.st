"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlUncommentedScriptError,
	#superclass : #HtmlSyntaxError,
	#category : #HTML
}

{ #category : #testing }
HtmlUncommentedScriptError >> isStructuralError [
	^true]

{ #category : #printing }
HtmlUncommentedScriptError >> printOn: aStream [
	'Script should be surrounded by html comments: <!-- script -->'
		printOn: aStream]

