"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlInputElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #attributes }
HtmlInputElement >> autofocus [
	self attributeAt: 'autofocus' put: nil]

{ #category : #attributes }
HtmlInputElement >> checked [
	self attributeAt: 'checked' put: nil]

{ #category : #testing }
HtmlInputElement >> isSelfClosing [
	^true]

{ #category : #attributes }
HtmlInputElement >> name: aString [
	self attributeAt: 'name' put: aString]

{ #category : #attributes }
HtmlInputElement >> placeholder: aString [
	self attributeAt: 'placeholder' put: aString]

{ #category : #attributes }
HtmlInputElement >> readonly [
	self attributeAt: 'readonly' put: nil]

{ #category : #attributes }
HtmlInputElement >> required [
	self attributeAt: 'required' put: nil]

{ #category : #attributes }
HtmlInputElement >> step: aString [
	self attributeAt: 'step' put: aString]

{ #category : #attributes }
HtmlInputElement >> type: aString [
	self attributeAt: 'type' put: aString]

{ #category : #AngularUI }
HtmlInputElement >> uibAltInputFormats: aString [
	self attributeAt: 'alt-input-formats' put: aString]

{ #category : #AngularUI }
HtmlInputElement >> uibCloseText: aString [
	self attributeAt: 'close-text' put: aString]

{ #category : #AngularUI }
HtmlInputElement >> uibDatepickerOptions: aString [
	self attributeAt: 'datepicker-options' put: aString]

{ #category : #AngularUI }
HtmlInputElement >> uibDatepickerPopup: aString [
	self attributeAt: 'uib-datepicker-popup' put: aString]

{ #category : #AngularUI }
HtmlInputElement >> uibIsOpen: aString [
	self attributeAt: 'is-open' put: aString]

{ #category : #attributes }
HtmlInputElement >> value: aString [
	self attributeAt: 'value' put: aString]

