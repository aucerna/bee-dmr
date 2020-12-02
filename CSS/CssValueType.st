"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssValueType,
	#superclass : #Object,
	#category : #CSS
}

{ #category : #'instance creation' }
CssValueType class >> fromString: aString [
	| in |
	in := aString readStream.
	^self readFrom: in]

{ #category : #'instance creation' }
CssValueType class >> readFrom: aStream [
	| in val pos operator |
	in := aStream.
	"in is easier to type"
	val := nil.
	operator := nil.
	pos := -100.
	[in atEnd] whileFalse: [
		in skipSeparators.
		in position = pos ifTrue: [self halt].
		pos := in position.
		(in peek isAlphanumeric or: [',/' includes: in peek])
			ifTrue: [
				val isNil
					ifTrue: [val := CssValueTypeLiteral readFrom: aStream]
					ifFalse: [
						((val respondsTo: #addType:) and: [val operator = operator]) ifFalse: [
							val := CssValueTypeAND new addType: val.
							operator := val operator].
						val addType: (CssValueTypeLiteral readFrom: aStream)]]
			ifFalse: [
				in peek = $|
					ifTrue: [
						in next.
						in peek = $|
							ifTrue: [
								in next.
								operator isNil ifTrue: [
									val := CssValueTypeANDOR new addType: val.
									operator := val operator]]
							ifFalse: [
								operator isNil ifTrue: [
									val := CssValueTypeOR new addType: val.
									operator := val operator]]]
					ifFalse: [
						in peek = $[
							ifTrue: [
								in next.
								val isNil ifTrue: [val := self readFrom: in] ifFalse: [
									(val respondsTo: #addType:) ifFalse: [
										val := CssValueTypeAND new addType: val.
										operator = val operator].
									val addType: (self readFrom: in)]]
							ifFalse: [
								in peek = $]
									ifTrue: [
										in next.
										(CssValueTypeConstraint allTypes includes: in peek)
											ifTrue: [val := (CssValueTypeConstraint readFrom: in) type: val].
										^val]
									ifFalse: [
										in peek = $<
											ifTrue: [
												val isNil
													ifTrue: [val := CssValueTypeValue readFrom: in]
													ifFalse: [
														(val respondsTo: #addType:) ifFalse: [
															val := CssValueTypeAND new addType: val.
															operator := val operator].
														val addType: (CssValueTypeValue readFrom: in)]]
											ifFalse: [
												in peek = $' ifTrue: [
													val isNil
														ifTrue: [val := CssValueTypeProperty readFrom: in]
														ifFalse: [
															(val respondsTo: #addType:) ifFalse: [
																val := CssValueTypeAND new addType: val.
																operator := val operator].
															val addType: (CssValueTypeProperty readFrom: in)]]]]]]]].
	^val]

{ #category : #accessing }
CssValueType >> addValues: aCollection fromStream: in [
	self subclassResponsibility]

{ #category : #testing }
CssValueType >> isTypeAND [
	^false]

{ #category : #testing }
CssValueType >> isTypeANDOR [
	^false]

{ #category : #testing }
CssValueType >> isTypeOneOf [
	^false]

{ #category : #testing }
CssValueType >> isTypeOneOrMoreOf [
	^false]

{ #category : #testing }
CssValueType >> isTypeOR [
	^false]

{ #category : #testing }
CssValueType >> isValidValue: anObject [
	self subclassResponsibility]

