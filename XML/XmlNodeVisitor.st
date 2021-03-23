"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #XmlNodeVisitor,
	#superclass : #Object,
	#category : #XML
}

{ #category : #visiting }
XmlNodeVisitor >> visit: anXmlNode [
	anXmlNode acceptVisitor: self]

{ #category : #visiting }
XmlNodeVisitor >> visitXmlAttribute: anXmlAttribute [
	self visitXmlNode: anXmlAttribute]

{ #category : #visiting }
XmlNodeVisitor >> visitXmlComment: anXmlComment [
	self visitXmlNode: anXmlComment]

{ #category : #visiting }
XmlNodeVisitor >> visitXmlDoctype: anXmlDoctype [
	self visitXmlNode: anXmlDoctype]

{ #category : #visiting }
XmlNodeVisitor >> visitXmlDocument: anXmlDocument [
	self visitXmlNode: anXmlDocument]

{ #category : #visiting }
XmlNodeVisitor >> visitXmlElement: anXmlElement [
	self visitXmlNode: anXmlElement]

{ #category : #visiting }
XmlNodeVisitor >> visitXmlName: anXmlName [
	self visitXmlNode: anXmlName]

{ #category : #visiting }
XmlNodeVisitor >> visitXmlNode: anXmlNode [
	]

{ #category : #visiting }
XmlNodeVisitor >> visitXmlProcessing: anXmlProcessing [
	self visitXmlNode: anXmlProcessing]

{ #category : #visiting }
XmlNodeVisitor >> visitXmlText: anXmlText [
	self visitXmlNode: anXmlText]

