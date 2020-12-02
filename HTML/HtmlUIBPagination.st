"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlUIBPagination,
	#superclass : #HtmlUIBElement,
	#category : #HTML
}

{ #category : #accessing }
HtmlUIBPagination >> boundaryLinkNumbers: anInteger [
	self attributeAt: 'boundary-link-numbers' put: anInteger]

{ #category : #accessing }
HtmlUIBPagination >> boundaryLinks: aBoolean [
	self attributeAt: 'boundary-links' put: aBoolean]

{ #category : #accessing }
HtmlUIBPagination >> directionLinks: aBoolean [
	self attributeAt: 'direction-links' put: aBoolean]

{ #category : #accessing }
HtmlUIBPagination >> firstText: aString [
	self attributeAt: 'first-text' put: aString]

{ #category : #accessing }
HtmlUIBPagination >> forceEllipses: aBoolean [
	self attributeAt: 'force-ellipses' put: aBoolean]

{ #category : #accessing }
HtmlUIBPagination >> itemsPerPage: anInteger [
	self attributeAt: 'items-per-page' put: anInteger]

{ #category : #accessing }
HtmlUIBPagination >> lastText: aString [
	self attributeAt: 'last-text' put: aString]

{ #category : #accessing }
HtmlUIBPagination >> maxSize: anInteger [
	self attributeAt: 'max-size' put: anInteger]

{ #category : #accessing }
HtmlUIBPagination >> nextText: aString [
	self attributeAt: 'next-text' put: aString]

{ #category : #accessing }
HtmlUIBPagination >> numPages: anInteger [
	self attributeAt: 'num-pages' put: anInteger]

{ #category : #accessing }
HtmlUIBPagination >> previousText: aString [
	self attributeAt: 'previous-text' put: aString]

{ #category : #accessing }
HtmlUIBPagination >> rotate: aBoolean [
	self attributeAt: 'rotate' put: aBoolean]

{ #category : #accessing }
HtmlUIBPagination >> totalItems: anInteger [
	self attributeAt: 'total-items' put: anInteger]

