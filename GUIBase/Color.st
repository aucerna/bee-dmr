"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Color,
	#superclass : #Object,
	#category : #GUIbase
}

{ #category : #'default colors' }
Color class >> black [
	^self defaultNamed: #black]

{ #category : #'default colors' }
Color class >> blue [
	^self defaultNamed: #blue]

{ #category : #'default colors' }
Color class >> brown [
	^self defaultNamed: #brown]

{ #category : #'system colors' }
Color class >> COLOR_ACTIVEBORDER [
	^self systemColorAt: COLOR_ACTIVEBORDER]

{ #category : #'system colors' }
Color class >> COLOR_ACTIVECAPTION [
	^self systemColorAt: COLOR_ACTIVECAPTION]

{ #category : #'system colors' }
Color class >> COLOR_BTNFACE [
	^self systemColorAt: COLOR_BTNFACE]

{ #category : #'system colors' }
Color class >> COLOR_BTNHIGHLIGHT [
	^self systemColorAt: COLOR_BTNHIGHLIGHT]

{ #category : #'system colors' }
Color class >> COLOR_BTNSHADOW [
	^self systemColorAt: COLOR_BTNSHADOW]

{ #category : #'system colors' }
Color class >> COLOR_BTNTEXT [
	^self systemColorAt: COLOR_BTNTEXT]

{ #category : #'system colors' }
Color class >> COLOR_CAPTIONTEXT [
	^self systemColorAt: COLOR_CAPTIONTEXT]

{ #category : #'system colors' }
Color class >> COLOR_DESKTOP [
	^self systemColorAt: COLOR_DESKTOP]

{ #category : #'system colors' }
Color class >> COLOR_GRAYTEXT [
	^self systemColorAt: COLOR_GRAYTEXT]

{ #category : #'system colors' }
Color class >> COLOR_HIGHLIGHT [
	^self systemColorAt: COLOR_HIGHLIGHT]

{ #category : #'system colors' }
Color class >> COLOR_HIGHLIGHTTEXT [
	^self systemColorAt: COLOR_HIGHLIGHTTEXT]

{ #category : #'system colors' }
Color class >> COLOR_INACTIVEBORDER [
	^self systemColorAt: COLOR_INACTIVEBORDER]

{ #category : #'system colors' }
Color class >> COLOR_INACTIVECAPTION [
	^self systemColorAt: COLOR_INACTIVECAPTION]

{ #category : #'system colors' }
Color class >> COLOR_MENU [
	^self systemColorAt: COLOR_MENU]

{ #category : #'system colors' }
Color class >> COLOR_MENUTEXT [
	^self systemColorAt: COLOR_MENUTEXT]

{ #category : #'system colors' }
Color class >> COLOR_WINDOW [
	^self systemColorAt: COLOR_WINDOW]

{ #category : #'system colors' }
Color class >> COLOR_WINDOWFRAME [
	^self systemColorAt: COLOR_WINDOWFRAME]

{ #category : #'system colors' }
Color class >> COLOR_WINDOWTEXT [
	^self systemColorAt: COLOR_WINDOWTEXT]

{ #category : #themes }
Color class >> commentColor [
	^self theme ifNil: [Color darkGray] ifNotNil: [:t | t commentColor]]

{ #category : #'default colors' }
Color class >> cyan [
	^self defaultNamed: #cyan]

{ #category : #'default colors' }
Color class >> darkBlue [
	^self defaultNamed: #darkBlue]

{ #category : #'default colors' }
Color class >> darkCyan [
	^self defaultNamed: #darkCyan]

{ #category : #'default colors' }
Color class >> darkGray [
	^self defaultNamed: #darkGray]

{ #category : #'default colors' }
Color class >> darkGreen [
	^self defaultNamed: #darkGreen]

{ #category : #'default colors' }
Color class >> darkPink [
	^self defaultNamed: #darkPink]

{ #category : #'default colors' }
Color class >> darkRed [
	^self defaultNamed: #darkRed]

{ #category : #themes }
Color class >> defaultBackColor [
	^(self theme ifNotNil: [:t | t textEditorBackColor])
		ifNil: [self COLOR_WINDOW]]

{ #category : #private }
Color class >> defaultClass [
	^self == Color ifTrue: [RGBColor] ifFalse: [self]]

{ #category : #'instance accessing' }
Color class >> defaultNamed: aSymbol [
	^self defaultClass namedColors at: aSymbol]

{ #category : #themes }
Color class >> defaultTextColor [
	^(self theme ifNotNil: [:t | t defaultCodeColor])
		ifNil: [self COLOR_WINDOWTEXT]]

{ #category : #themes }
Color class >> disabledColor [
	^self theme ifNil: [Color COLOR_GRAYTEXT] ifNotNil: [:t | t disabledColor]]

{ #category : #'default colors' }
Color class >> gray [
	^self defaultNamed: #gray]

{ #category : #accessing }
Color class >> gray: byte [
	^self red: byte green: byte blue: byte]

{ #category : #'default colors' }
Color class >> green [
	^self defaultNamed: #green]

{ #category : #'default colors' }
Color class >> lilac [
	^Color red: 156 green: 97 blue: 175]

{ #category : #themes }
Color class >> literalColor [
	^self theme ifNil: [Color darkGreen] ifNotNil: [:t | t literalColor]]

{ #category : #accessing }
Color class >> namedColors [
	^colors]

{ #category : #'instance creation' }
Color class >> new [
	^super new initialize]

{ #category : #'default colors' }
Color class >> paleGray [
	^self defaultNamed: #paleGray]

{ #category : #'default colors' }
Color class >> pink [
	^self defaultNamed: #pink]

{ #category : #'instance creation' }
Color class >> r: red g: green b: blue [
	^self red: red green: green blue: blue]

{ #category : #'default colors' }
Color class >> red [
	^self defaultNamed: #red]

{ #category : #'instance creation' }
Color class >> red: red green: green blue: blue [
	^RGBColor red: red green: green blue: blue]

{ #category : #'instance creation' }
Color class >> relativeR: red G: green B: blue [
	^RGBColor relativeR: red G: green B: blue]

{ #category : #'instance creation' }
Color class >> rgbValue: anInteger [
	| r g b |
	r := (anInteger bitShift: -16) bitAnd: 16rFF.
	g := (anInteger bitShift: -8) bitAnd: 16rFF.
	b := anInteger bitAnd: 16rFF.
	^self red: r green: g blue: b]

{ #category : #'instance creation' }
Color class >> scrollbar [
	^self systemColorAt: COLOR_SCROLLBAR]

{ #category : #themes }
Color class >> symbolColor [
	^self theme
		ifNil: [Color red: 5 green: 150 blue: 150]
		ifNotNil: [:t | t symbolColor]]

{ #category : #'instance accessing' }
Color class >> systemColorAt: index [
	^WinSettings current systemColorAt: index]

{ #category : #'default colors' }
Color class >> teal [
	^self defaultNamed: #teal]

{ #category : #themes }
Color class >> theme [
	^nil]

{ #category : #themes }
Color class >> undefinedColor [
	^self theme ifNil: [Color red] ifNotNil: [:t | t undefinedColor]]

{ #category : #themes }
Color class >> varColor [
	^self theme ifNil: [Color darkPink] ifNotNil: [:t | t varColor]]

{ #category : #'default colors' }
Color class >> violet [
	^Color red: 120 green: 97 blue: 170]

{ #category : #'default colors' }
Color class >> white [
	^self defaultNamed: #white]

{ #category : #'default colors' }
Color class >> yellow [
	^self defaultNamed: #yellow]

{ #category : #accessing }
Color >> alpha [
	^0]

{ #category : #converting }
Color >> asARGBColor [
	| rgb |
	rgb := self asRGBColor.
	^ARGBColor
		alpha: 255
		red: rgb red
		green: rgb green
		blue: rgb blue]

{ #category : #converting }
Color >> asInteger [
	^self asRGBColor asInteger]

{ #category : #converting }
Color >> asParameter [
	^self asRGBColor asParameter]

{ #category : #converting }
Color >> asRGBColor [
	self subclassResponsibility]

{ #category : #variations }
Color >> averageWith: aColor [
	^self class
		red: self red + aColor red // 2
		green: self green + aColor green // 2
		blue: self blue + aColor blue // 2]

{ #category : #accessing }
Color >> blue [
	^self asRGBColor blue]

{ #category : #inquiries }
Color >> blueLevel [
	^self blue asFloat / 255.0]

{ #category : #inquiries }
Color >> brightness [
	^self asRGBColor brightness]

{ #category : #accessing }
Color >> green [
	^self asRGBColor green]

{ #category : #inquiries }
Color >> greenLevel [
	^self green asFloat / 255.0]

{ #category : #printing }
Color >> hex [
	^'#' , (self red hex , self green hex , self blue hex) asLowercase]

{ #category : #testing }
Color >> isColor [
	^true]

{ #category : #testing }
Color >> isRGBColor [
	^false]

{ #category : #accessing }
Color >> red [
	^self asRGBColor red]

{ #category : #inquiries }
Color >> redLevel [
	^self red asFloat / 255.0]

