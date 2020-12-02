"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssPaintingVisitor,
	#superclass : #CssFormattingVisitor,
	#category : #CSS
}

{ #category : #colors }
CssPaintingVisitor >> nameColor [
	^Color darkBlue]

{ #category : #colors }
CssPaintingVisitor >> operatorColor [
	^Color red: 185 green: 126 blue: 148]

{ #category : #printing }
CssPaintingVisitor >> printOperator: aCharacter [
	stream
		useColor: self operatorColor
		while: [super printOperator: aCharacter]]

{ #category : #printing }
CssPaintingVisitor >> printPropertyName: aString [
	stream useColor: self nameColor while: [super printPropertyName: aString]]

{ #category : #printing }
CssPaintingVisitor >> printPropertyValue: aString [
	stream useColor: self valueColor while: [super printPropertyValue: aString]]

{ #category : #printing }
CssPaintingVisitor >> printSelector: aCssSelector [
	stream
		useColor: self selectorColor
		while: [super printSelector: aCssSelector]]

{ #category : #colors }
CssPaintingVisitor >> selectorColor [
	^Color red: 220 green: 40 blue: 0]

{ #category : #colors }
CssPaintingVisitor >> valueColor [
	^Color darkGreen]

