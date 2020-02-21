Class {
	#name : #BGPiDigitSpigot,
	#superclass : #Object,
	#instVars : [
		'#numer',
		'#accum',
		'#denom',
		'#k'
	],
	#category : #Game
}

{ #category : #'instance creation' }
BGPiDigitSpigot class >> new [
	^self basicNew initialize
]

{ #category : #testing }
BGPiDigitSpigot >> atEnd [
    ^false
]

{ #category : #'pi digit generation' }
BGPiDigitSpigot >> eliminate: digit [
    accum := accum - (denom * digit).
    accum := accum * 10.
    numer := numer * 10
]

{ #category : #'pi digit generation' }
BGPiDigitSpigot >> extract [
    | tmp |
    numer > accum ifTrue: [^nil].
    tmp := numer + numer + numer + accum.
    tmp \\ denom >= (denom - numer) ifTrue: [^nil].
    ^tmp // denom
]

{ #category : #'initialize-release' }
BGPiDigitSpigot >> initialize [
    numer := denom := 1.
    k := accum := 0.
]

{ #category : #accessing }
BGPiDigitSpigot >> next [
    | digit |
    [ self step. (digit := self extract) isNil ] whileTrue.
    self eliminate: digit.
    ^digit
]

{ #category : #'stepping and presenter' }
BGPiDigitSpigot >> step [
    | y2 |
    k := k + 1.
    y2 := k * 2 + 1.
    accum := (numer + numer + accum) * y2.
    numer := numer * k.
    denom := denom * y2.
]

