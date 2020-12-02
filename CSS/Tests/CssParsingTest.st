"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssParsingTest,
	#superclass : #TestCase,
	#category : #'CSS\Tests'
}

{ #category : #parsing }
CssParsingTest >> parse: aString [
	^CssStyleSheet parse: aString]

{ #category : #all }
CssParsingTest >> testClassStyle [
	| ss rule div |
	ss := self parse: '.intro {
    background-color: yellow;
}'.
	self
		assert: ss children size = 1;
		assert: ss children anyone isStyleRule.
	rule := ss children anyone.
	div := HtmlDivElement new class: 'intro'.
	self assert: (rule selector matches: div)]

{ #category : #all }
CssParsingTest >> testElementStyle [
	| ss rule dom p |
	ss := self parse: 'p {
    color: red;
    text-align: center;
}'.
	self
		assert: ss children size = 1;
		assert: ss children anyone isStyleRule.
	rule := ss children anyone.
	dom := HtmlDocument new.
	p := dom add: HtmlPElement new.
	self
		assert: (rule selector matches: p);
		assert: rule properties size = 2;
		assert: (rule propertyNamed: 'color') valueIsValid;
		assert: (rule propertyNamed: 'color') propertyValue anyone isNamedColor]

