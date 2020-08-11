"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PPJsonParser,
	#superclass : #PPJsonGrammar,
	#category : #JSON
}

{ #category : #grammar }
PPJsonParser >> array [
	^super array ==> [:nodes | Array withAll: (nodes second ifNil: [#()])]]

{ #category : #primitives }
PPJsonParser >> charEscape [
	^super charEscape ==> [:nodes | CharacterTable at: nodes last]]

{ #category : #primitives }
PPJsonParser >> charOctal [
	^super charOctal ==> [:nodes | | code |
		code := Integer readFrom: nodes last asUppercase readStream radix: 16.
		Character codePoint: code]]

{ #category : #grammar }
PPJsonParser >> elements [
	^super elements
		==> [:nodes | nodes reject: [:each | each isKindOf: PPToken]]]

{ #category : #tokens }
PPJsonParser >> falseToken [
	^super falseToken ==> [:token | false]]

{ #category : #grammar }
PPJsonParser >> members [
	^super members
		==> [:nodes | nodes reject: [:each | each isKindOf: PPToken]]]

{ #category : #tokens }
PPJsonParser >> nullToken [
	^super nullToken ==> [:token | ]]

{ #category : #tokens }
PPJsonParser >> numberToken [
	^super numberToken
		==> [:token | (token value copyWithout: $+) asLowercase asNumber]]

{ #category : #grammar }
PPJsonParser >> object [
	^super object ==> [:nodes | | result class |
		array := nodes second.
		array isNil ifTrue: [result := Dictionary new] ifFalse: [
			class := array detect: [:assoc | assoc key = 'Class'] ifNone: ''.
			class := Smalltalk at: class asSymbol ifAbsent: [
				result := Dictionary new addAll: array; yourself.
				nil].
			class notNil ifTrue: [
				result := class new.
				array keysAndValuesDo: [:var :obj | result instVarNamed: var put: obj]]].
		result]]

{ #category : #grammar }
PPJsonParser >> pair [
	^super pair map: [:key :sep :val | key -> val]]

{ #category : #tokens }
PPJsonParser >> stringToken [
	^string trim ==> [:nodes | | chars |
		chars := nodes second.
		(chars isEmpty or: [chars anyone asInteger < 256])
			ifTrue: [String withAll: chars]
			ifFalse: [WideString withAll: chars]]]

{ #category : #tokens }
PPJsonParser >> trueToken [
	^super trueToken ==> [:token | true]]

