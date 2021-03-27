"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DataflowQuery,
	#superclass : #WebServiceQuery,
	#category : #OData
}

{ #category : #private }
DataflowQuery >> function: aString arguments: aCollection [
	self entity: entity / aString.
	aCollection do: [:arg | self entity: entity / arg asString]]

