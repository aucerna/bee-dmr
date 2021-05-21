"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PoolDictionaryAddition,
	#superclass : #GlobalAddition,
	#category : #ProjectChanges
}

{ #category : #perform }
PoolDictionaryAddition >> defineGlobal [
	^Smalltalk at: globalName ifAbsentPut: [PoolDictionary new]]

{ #category : #accessing }
PoolDictionaryAddition >> sourceCode [
	^self project referenceString , ' addPoolDictionary: '
		, globalName storeString]

