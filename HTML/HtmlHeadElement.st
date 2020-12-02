"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlHeadElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #scripts }
HtmlHeadElement >> addDeferredScriptFrom: url [
	self add: (HtmlScriptElement new src: url; defer)]

{ #category : #links }
HtmlHeadElement >> addIconFrom: url [
	self addLinkTo: url relationship: 'icon']

{ #category : #links }
HtmlHeadElement >> addLinkTo: url relationship: relationship [
	self add: (HtmlLinkElement new href: url; rel: relationship)]

{ #category : #scripts }
HtmlHeadElement >> addScriptFrom: url [
	self add: (HtmlScriptElement new src: url)]

{ #category : #style }
HtmlHeadElement >> addStyle: code [
	self add: (HtmlStyleElement with: code)]

{ #category : #links }
HtmlHeadElement >> addStylesheetFrom: url [
	self addLinkTo: url relationship: 'stylesheet']

{ #category : #meta }
HtmlHeadElement >> author: aString [
	self add: (HtmlMetaElement new author: aString)]

{ #category : #meta }
HtmlHeadElement >> charset: aString [
	self add: (HtmlMetaElement new charset: aString)]

{ #category : #meta }
HtmlHeadElement >> description: aString [
	self add: (HtmlMetaElement new description: aString)]

{ #category : #meta }
HtmlHeadElement >> httpequiv: httpequiv content: content [
	self add: (HtmlMetaElement new httpequiv: httpequiv content: content)]

{ #category : #testing }
HtmlHeadElement >> isHead [
	^true]

{ #category : #meta }
HtmlHeadElement >> keywords: aCollection [
	self add: (HtmlMetaElement new keywords: aCollection)]

{ #category : #title }
HtmlHeadElement >> title [
	^self detect: [:e | e class == HtmlTitleElement]]

{ #category : #title }
HtmlHeadElement >> title: aString [
	self add: (HtmlTitleElement with: aString)]

{ #category : #meta }
HtmlHeadElement >> viewport: aString [
	self add: (HtmlMetaElement new viewport: aString)]

