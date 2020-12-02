"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlHighchartElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #unclassified }
HtmlHighchartElement >> config: value [
	self attributeAt: 'config' put: value]

