"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssElementVisitor,
	#superclass : #Object,
	#category : #CSS
}

{ #category : #'instance creation' }
CssElementVisitor class >> new [
	^super new initialize]

{ #category : #visiting }
CssElementVisitor >> visit: aCssElement [
	aCssElement acceptVisitor: self]

{ #category : #visiting }
CssElementVisitor >> visitaCssAtRule: aCssAtRule [
	self visitCssRule: aCssAtRule]

{ #category : #visiting }
CssElementVisitor >> visitCssComment: aCssComment [
	self visitCssElement: aCssComment]

{ #category : #visiting }
CssElementVisitor >> visitCssElement: aCssElement [
	]

{ #category : #visiting }
CssElementVisitor >> visitCssProperty: aCssProperty [
	self visitCssElement: aCssProperty]

{ #category : #visiting }
CssElementVisitor >> visitCssRule: aCssRule [
	self visitCssElement: aCssRule]

{ #category : #visiting }
CssElementVisitor >> visitCssStyleRule: aCssStyleRule [
	self visitCssRule: aCssStyleRule]

{ #category : #visiting }
CssElementVisitor >> visitCssStyleSheet: aCssStyleSheet [
	self visitCssElement: aCssStyleSheet]

