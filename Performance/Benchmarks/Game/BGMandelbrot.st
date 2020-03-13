"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #BGMandelbrot,
	#superclass : #Object,
	#category : #Game
}

{ #category : #defaults }
BGMandelbrot class >> defaultProblemSize [
	^ 200
]

{ #category : #'test data' }
BGMandelbrot class >> output [
	^'UDQNCjIwMCAyMDANCgAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAADwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAegAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAXwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB8AAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAfAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC/gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//
gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAF//4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA///QAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAP///AAAAAAAAAAAAAAAAAAAAAAAAAAAAAB///gAAAAAAAAAAAAAAAAA
AAAAAAAAAAAB///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP//+AAAAAAAAAAAAAAAAAAAAAAAAAAA
AAX///AAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///AAA
AAAAAAAAAAAAAAAAAAAAAAAAAAL///AAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///kAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAP///AAAAAAAAAAAAAAAAAAAAAAAAAAAAAB//+AAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAP//gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB//wAAAAAAAAAAAAAAAAAAAAAAAAEAAQAAf
/4AAAAAAAAAAAAAAAAAAAAAAAAAAAADAB/4BGCAAAAAAAAAAAAAAAAAAAAAAAAJBj///9YAAAAAA
AAAAAAAAAAAAAAAAAAAAaM////+wCAAAAAAAAAAAAAAAAAAAAAACAXr/////+ngAAAAAAAAAAAAA
AAAAAAABQgH///////58AAAAAAAAAAAAAAAAAAAAAsYA////////eABAAAAAAAAAAAAAAAAAAAL/
Db////////AAAAAAAAAAAAAAAAAAAAAAfwf////////8AAAAAAAAAAAAAAAAAAAAAP+X////////
/YBiQAAAAAAAAAAAAAAAAAT/v/////////+B+4AAAAAAAAAAAAAAAAAH/3//////////of8AAAAA
AAAAAAAAAAAAA////////////+P+AAAAAAAAAAAAAAAAAAH////////////3/gAAAAAAAAAAAAAA
AAAAf///////////+/4AAAAAAAAAAAAAAAAAAA//////////////AAAAAAAAAAAAAAAAAAA/////
/////////4AAAAAAAAAAAAAAAAAB//////////////wAAAAAAAAAAAAAAAAADP/////////////6
AAAAAAAAAAAAAAAAAA//////////////wAAAAAAAAAAAAAAAAIAH//////////////AAAAAAAAAA
AAAAAAARy//////////////oAAAAAAAAAAAAAAAAH9//////////////9gAAAAAAAAAAAAAAACf/
//////////////wAAAAAAAAAAAAAAAAj///////////////9AAAAAAAAAAAAAAAAC///////////
/////cAAAAAAAAAAAAAAAAP///////////////+AAAAAAAAAAAAAAAAB///////////////+gAAA
AAAAAAAAAAAAAf///////////////wAAAAAAAAAAAAAAAEX///////////////+EAAAAAAAAAAAA
AAAH////////////////0AAAAAAAAAAAAAAAp////////////////9wAAAAAAAAAAAAAAf//////
///////////+AAAAAAAAAAAAAAB//////////////////4AAAAAAAAAAAAAAf///////////////
//4AAAAAAAAAAAAAAB/////////////////8AAAAAAAAAAAAAAFf////////////////6AAAAAAA
AAAQAAAAP/////////////////AAAAAAACAAIGAAD7/////////////////gAAAAAAAAAHgAAAP/
////////////////8AAAAAAAegDwAAAB//////////////////wAAAAAAD8YczIAAP//////////
///////4AAAAAAB+L/9wAAD/////////////////+AAAAAABf3//8AAH//////////////////gA
AAAAAD////kAA//////////////////+AAAAAAA/////AAP//////////////////gAAAAAAL///
/5AP///////////////////AAAAAAD/////gA//////////////////wAAAAAAF/////8Af/////
////////////+AAAAAAA//////gP//////////////////wAAAAANf/////+D///////////////
///wAAAAAA///////Af/////////////////+AAAAAAf//////+P//////////////////gAAAAA
B///////D//////////////////+AAAAAA///////4//////////////////6AAAAAA///////+P
//////////////////AAAAAAP///////z//////////////////wAAAAAB///////8//////////
////////8AAAAAA////////P/////////////////7AAAAAAP///////7/////////////////+A
AAABkH///////+//////////////////wAAAAf5//////////////////////////wAAAAH+P///
//////////////////////6AAAAD///////////////////////////+AAAAA///////////////
/////////////AAAAAf///////////////////////////AAAAAf////////////////////////
///AAAD/////////////////////////////AAAAAB///////////////////////////8AAAAAH
///////////////////////////wAAAAA////////////////////////////AAAAAP/////////
//////////////////4AAAAB/j/////////////////////////+gAAAAf5/////////////////
/////////wAAAAGQf///////7//////////////////AAAAAAD///////+//////////////////
gAAAAAA////////P/////////////////7AAAAAAH///////z//////////////////wAAAAAD//
/////8//////////////////8AAAAAA///////+P//////////////////AAAAAAD///////j///
///////////////oAAAAAAf//////w///////////////////gAAAAAf//////+P////////////
//////gAAAAAD//////8B//////////////////4AAAAADX//////g//////////////////8AAA
AAAA//////gP//////////////////wAAAAAAX/////wB//////////////////4AAAAAAA/////
4AP/////////////////8AAAAAAAL////5AP///////////////////AAAAAAD////8AA///////
///////////+AAAAAAA////5AAP//////////////////gAAAAABf3//8AAH////////////////
//gAAAAAAH4v/3AAAP/////////////////4AAAAAAA/GHMyAAD/////////////////+AAAAAAA
egDwAAAB//////////////////wAAAAAAAAAeAAAA//////////////////wAAAAAAAgACBgAA+/
////////////////4AAAAAAAAAAQAAAAP/////////////////AAAAAAAAAAAAAAAV//////////
///////oAAAAAAAAAAAAAAAf/////////////////AAAAAAAAAAAAAAAf/////////////////4A
AAAAAAAAAAAAAH//////////////////gAAAAAAAAAAAAAH//////////////////gAAAAAAAAAA
AAAAp////////////////9wAAAAAAAAAAAAAAAf////////////////QAAAAAAAAAAAAAABF////
////////////hAAAAAAAAAAAAAAAAf///////////////wAAAAAAAAAAAAAAAAH/////////////
//6AAAAAAAAAAAAAAAAD////////////////gAAAAAAAAAAAAAAAC////////////////cAAAAAA
AAAAAAAAACP///////////////0AAAAAAAAAAAAAAAAn///////////////8AAAAAAAAAAAAAAAA
H9//////////////9gAAAAAAAAAAAAAAABHL/////////////+gAAAAAAAAAAAAAAACAB///////
///////wAAAAAAAAAAAAAAAAAA//////////////wAAAAAAAAAAAAAAAAAAM//////////////oA
AAAAAAAAAAAAAAAAAf/////////////8AAAAAAAAAAAAAAAAAAA//////////////4AAAAAAAAAA
AAAAAAAAD/////////////8AAAAAAAAAAAAAAAAAAH////////////v+AAAAAAAAAAAAAAAAAAH/
///////////3/gAAAAAAAAAAAAAAAAAD////////////4/4AAAAAAAAAAAAAAAAAB/9/////////
/6H/AAAAAAAAAAAAAAAAAAT/v/////////+B+4AAAAAAAAAAAAAAAAAA/5f////////9gGJAAAAA
AAAAAAAAAAAAAH8H/////////AAAAAAAAAAAAAAAAAAAAAL/Db////////AAAAAAAAAAAAAAAAAA
AAACxgD///////94AEAAAAAAAAAAAAAAAAAAAUIB///////+fAAAAAAAAAAAAAAAAAAAAAACAXr/
////+ngAAAAAAAAAAAAAAAAAAAAAAABoz////7AIAAAAAAAAAAAAAAAAAAAAAAACQY////WAAAAA
AAAAAAAAAAAAAAAAAAAAAADAB/4BGCAAAAAAAAAAAAAAAAAAAAAAQABAAB//gAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAf/8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP//gAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAH//4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///k
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAv//8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///wAAAAAAAAA
AAAAAAAAAAAAAAAAAAAD///4AAAAAAAAAAAAAAAAAAAAAAAAAAAABf//8AAAAAAAAAAAAAAAAAAA
AAAAAAAAAAD///gAAAAAAAAAAAAAAAAAAAAAAAAAAAAB///wAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AH//+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAA///QAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAX//gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP/4AAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAC/gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB8AAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAfAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAXwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB6
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' asBase64DecodedString
]

{ #category : #runmarking }
BGMandelbrot >> mandelbrot2: n [
	| output outputArray |
	(output := '' writeStream)
		nextPutAll: 'P4';
		cr;
		print: n;
		space;
		print: n;
		cr
		";
      binary".
	outputArray := Array new: n * n + 7 // 8.
	self mandelbrot2: n to: outputArray.
	outputArray do: [:elem | output nextPut: elem asCharacter].
	^output
]

{ #category : #benchmarking }
BGMandelbrot >> mandelbrot2: extent to: output [
	| limit2 m bits zr zi cr ci i tr stepr stepi outputI |
	limit2 := 4.0.
	m := 50.
	outputI := 1.
	stepr := 2.0 / extent.
	stepi := 2.0 / extent.
	0 to: extent - 1 do: [:y | 
		bits := 0.
		ci := stepi * y asFloat - 1.0.
		0 to: extent - 1 do: [:x | 
			cr := stepr * x asFloat - 1.5.
			zr := cr.
			zi := ci.
			bits := bits bitShift: 1.
			i := 1.
			[
				tr := zr * zr - (zi * zi) + cr.
				zi := 2.0 * zr * zi + ci.
				zr := tr.
				zr * zr + (zi * zi) < limit2 and: [(i := i + 1) < m]] whileTrue.
			i = m ifTrue: [bits := bits + 1].
			(x bitAnd: 7) == 7 ifTrue: [
				output at: outputI put: bits.
				outputI := outputI + 1.
				bits := 0]].
		(extent bitAnd: 7) == 0 ifFalse: [
			bits := bits bitShift: 8 - (extent bitAnd: 7).
			output at: outputI put: bits.
			outputI := outputI + 1]]
]

