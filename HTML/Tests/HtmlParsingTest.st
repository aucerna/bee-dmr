"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlParsingTest,
	#superclass : #TestCase,
	#category : #'HTML\Tests'
}

{ #category : #private }
HtmlParsingTest >> parse: aString [
	^HtmlDocument new parseContents: aString readStream]

{ #category : #all }
HtmlParsingTest >> testAbbrElement [
	| document p abbr |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>The <abbr title="World Health Organization">WHO</abbr> was founded in 1948.</p>

</body>
</html>'.
	self assert: document body children size = 1.
	p := document body children anyone.
	abbr := p children second.
	self
		assert: abbr class = HtmlAbbrElement;
		assert: (abbr attributeAt: 'title') = 'World Health Organization';
		assert: abbr children anyone asString = 'WHO']

{ #category : #all }
HtmlParsingTest >> testAcronymElement [
	| document acronym |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

Can I get this <acronym title="as soon as possible">ASAP</acronym>?

<p><strong>Note:</strong> The acronym element is not supported in HTML5.</p>

</body>
</html>'.
	self assert: document body children size = 4.
	acronym := document body children second.
	self
		assert: acronym class = HtmlAcronymElement;
		assert: (acronym attributeAt: 'title') = 'as soon as possible';
		assert: acronym children anyone asString = 'ASAP']

{ #category : #all }
HtmlParsingTest >> testAddressElement [
	| document memory |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<address>
Written by <a href="mailto:webmaster@example.com">Jon Doe</a>.<br> 
Visit us at:<br>
Example.com<br>
Box 564, Disneyland<br>
USA
</address>

</body>
</html>'.
	self assert: document body children size = 1.
	memory := document body children anyone.
	self
		assert: memory class = HtmlAddressElement;
		assert: memory children notEmpty]

{ #category : #all }
HtmlParsingTest >> testAElement [
	| document a |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<a href="https://www.w3schools.com">Visit W3Schools.com!</a>

</body>
</html>'.
	self assert: document body children size = 1.
	a := document body children anyone.
	self
		assert: a class = HtmlAElement;
		assert: a href = 'https://www.w3schools.com';
		assert: a children anyone asString = 'Visit W3Schools.com!']

{ #category : #all }
HtmlParsingTest >> testAreaElement [
	| document areas |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>Click on the sun or on one of the planets to watch it closer:</p>

<img src="planets.gif" width="145" height="126" alt="Planets" usemap="#planetmap">

<map name="planetmap">
  <area shape="rect" coords="0,0,82,126" alt="Sun" href="sun.htm">
  <area shape="circle" coords="90,58,3" alt="Mercury" href="mercur.htm">
  <area shape="circle" coords="124,58,8" alt="Venus" href="venus.htm">
</map>

</body>
</html>'.
	areas := document select: [:e | e class == HtmlAreaElement].
	self
		assert: areas size = 3;
		assert: (areas first attributeAt: 'shape') = 'rect';
		assert: (areas second attributeAt: 'shape') = 'circle';
		assert: (areas third attributeAt: 'alt') = 'Venus']

{ #category : #all }
HtmlParsingTest >> testBaseElement [
	| document base |
	document := self
		parse: '<!DOCTYPE html>
<html>
<head>
  <base href="https://www.w3schools.com/images/" target="_blank">
</head>
<body>

<p><img src="stickman.gif" width="24" height="39" alt="Stickman"> - Notice that we have only specified a relative address for the image. Since we have specified a base URL in the head section, the browser will look for the image at "https://www.w3schools.com/images/stickman.gif".</p>

<p><a href="https://www.w3schools.com">W3Schools</a> - Notice that the link opens in a new window, even if it has no target="_blank" attribute. This is because the target attribute of the base element is set to "_blank".</p>

</body>
</html>'.
	self assert: document head children size = 1.
	base := document head children anyone.
	self
		assert: base class = HtmlBaseElement;
		assert: base href = 'https://www.w3schools.com/images/']

{ #category : #all }
HtmlParsingTest >> testBasefontElement [
	| document basefont |
	document := self
		parse: '<!DOCTYPE html>
<html>
<head>
<basefont color="red" size="5">
</head>

<body>
<h1>This is a heading</h1>
<p>This is a paragraph.</p>

<p>The basefont element is not supported in HTML5. Use CSS instead.</p>

</body>
</html>'.
	self assert: document head children size = 1.
	basefont := document head children anyone.
	self
		assert: basefont class = HtmlBasefontElement;
		assert: (basefont attributeAt: 'color') = 'red';
		assert: (basefont attributeAt: 'size') = '5']

{ #category : #all }
HtmlParsingTest >> testBdoElement [
	| document p bdo |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>This paragraph will go left-to-right.</p>  
<p><bdo dir="rtl">This paragraph will go right-to-left.</bdo></p>  

</body>
</html>'.
	self assert: document body children size = 2.
	p := document body children second.
	bdo := p children first.
	self
		assert: bdo class = HtmlBdoElement;
		assert: (bdo attributeAt: 'dir') = 'rtl']

{ #category : #all }
HtmlParsingTest >> testBElement [
	| document p b |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>This is normal text - <b>and this is bold text</b>.</p>

</body>
</html>'.
	self assert: document body children size = 1.
	p := document body children anyone.
	self assert: p children size = 3.
	b := p children second.
	self
		assert: b class = HtmlBElement;
		assert: b children anyone asString = 'and this is bold text']

{ #category : #all }
HtmlParsingTest >> testBigElement [
	| document p big |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>This text is normal.</p>
<p><big>This text is bigger.</big></p>

<p><strong>Note:</strong> The big element is not supported in HTML5.</p>

</body>
</html>'.
	self assert: document body children size = 3.
	p := document body children second.
	big := p children first.
	self
		assert: big class = HtmlBigElement;
		assert: big children anyone asString = 'This text is bigger.']

{ #category : #all }
HtmlParsingTest >> testBlockquoteElement [
	| document blockquote |
	document := self
		parse: '<<!DOCTYPE html>
<html>
<body>

<h1>About WWF</h1>
<p>Here is a quote from WWF''s website:</p>

<blockquote cite="http://www.worldwildlife.org/who/index.html">
For 50 years, WWF has been protecting the future of nature. The world''s leading conservation organization, WWF works in 100 countries and is supported by 1.2 million members in the United States and close to 5 million globally.
</blockquote>

</body>
</html>'.
	self assert: document body children size = 3.
	blockquote := document body children third.
	self
		assert: blockquote class = HtmlBlockquoteElement;
		assert: (blockquote attributeAt: 'cite')
			= 'http://www.worldwildlife.org/who/index.html';
		assert: blockquote children size = 1;
		assert: (blockquote children anyone asString
			beginsWith: 'For 50 years, WWF')]

{ #category : #all }
HtmlParsingTest >> testBodyElement [
	| document html body |
	document := self
		parse: '<!DOCTYPE html>
<html>
<head>
<title>Title of the document</title>
</head>

<body>
The content of the document......
</body>

</html>'.
	self assert: document children size = 1.
	html := document children anyone.
	self assert: html children size = 2.
	body := html children second.
	self
		assert: body class = HtmlBodyElement;
		assert: body children size = 1;
		assert: body children anyone asString trimBlanks
			= 'The content of the document......']

{ #category : #all }
HtmlParsingTest >> testBrElement [
	| document p br |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>
To break lines<br>in a text,<br>use the br element.
</p>

</body>
</html>'.
	self assert: document body children size = 1.
	p := document body children anyone.
	self
		assert: p children size = 5;
		assert: p children second class = HtmlBrElement;
		assert: p children fourth class = HtmlBrElement]

{ #category : #all }
HtmlParsingTest >> testButtonElement [
	| document button |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<h2>The Button Element</h2>
<button type="button" onclick="alert(''Hello world!'')">Click Me!</button>
 
</body>
</html>'.
	self assert: document body children size = 2.
	button := document body children second.
	self
		assert: button class = HtmlButtonElement;
		assert: (button attributeAt: 'type') = 'button';
		assert: (button attributeAt: 'onclick') = 'alert(''Hello world!'')';
		assert: button children size = 1;
		assert: button children anyone asString = 'Click Me!']

{ #category : #all }
HtmlParsingTest >> testCaptionElement [
	| document table caption |
	document := self
		parse: '<!DOCTYPE html>
<html>
<head>
<style>
table, th, td {
    border: 1px solid black;
}
</style>
</head>
<body>

<table>
  <caption>Monthly savings</caption>
  <tr>
    <th>Month</th>
    <th>Savings</th>
  </tr>
  <tr>
    <td>January</td>
    <td>$100</td>
  </tr>
  <tr>
    <td>February</td>
    <td>$50</td>
  </tr>
</table>

</body>
</html>'.
	self assert: document body children size = 1.
	table := document body children anyone.
	self
		assert: table class == HtmlTableElement;
		assert: table children size = 4.
	caption := table children first.
	self
		assert: caption class = HtmlCaptionElement;
		assert: caption children anyone asString = 'Monthly savings']

{ #category : #all }
HtmlParsingTest >> testCenterElement [
	| document center |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>This is some text.</p>
<center>This text will be center-aligned.</center>
<p>This is some text.</p>

<p>The center element is not supported in HTML5. Use CSS instead.</p>

</body>
</html>'.
	self assert: document body children size = 4.
	center := document body children second.
	self
		assert: center class = HtmlCenterElement;
		assert: center children anyone asString
			= 'This text will be center-aligned.']

{ #category : #all }
HtmlParsingTest >> testCiteElement [
	| document p cite |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<img src="img_the_scream.jpg" width="220" height="277" alt="The Scream">
<p><cite>The Scream</cite> by Edward Munch. Painted in 1893.</p>

</body>
</html>'.
	self assert: document body children size = 2.
	p := document body children second.
	cite := p children first.
	self
		assert: cite class = HtmlCiteElement;
		assert: cite children anyone asString = 'The Scream']

{ #category : #all }
HtmlParsingTest >> testCodeElement [
	| document code |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<em>Emphasized text</em><br>
<strong>Strong text</strong><br>
<code>A piece of computer code</code><br>
<samp>Sample output from a computer program</samp><br>
<kbd>Keyboard input</kbd><br>
<var>Variable</var>

</body>
</html>'.
	self assert: document body children size = 11.
	code := document body children fifth.
	self
		assert: code class == HtmlCodeElement;
		assert: code children anyone asString = 'A piece of computer code']

{ #category : #all }
HtmlParsingTest >> testColElement [
	| document table colgroup |
	document := self
		parse: '<!DOCTYPE html>
<html>
<head>
<style>
table, th, td {
    border: 1px solid black;
}
</style>
</head>
<body>

<table>
  <colgroup>
    <col span="2" style="background-color:red">
    <col style="background-color:yellow">
  </colgroup>
  <tr>
    <th>ISBN</th>
    <th>Title</th>
    <th>Price</th>
  </tr>
  <tr>
    <td>3476896</td>
    <td>My first HTML</td>
    <td>$53</td>
  </tr>
  <tr>
    <td>5869207</td>
    <td>My first CSS</td>
    <td>$49</td>
  </tr>
</table>

</body>
</html>'.
	self assert: document body children size = 1.
	table := document body children anyone.
	self assert: table children size = 4.
	colgroup := table children first.
	self
		assert: colgroup children size = 2;
		assert: (colgroup children conform: [:c | c class == HtmlColElement]);
		assert: (colgroup children first attributeAt: 'span') = '2';
		assert: (colgroup children first attributeAt: 'style')
			= 'background-color:red';
		assert: (colgroup children second attributeAt: 'style')
			= 'background-color:yellow']

{ #category : #all }
HtmlParsingTest >> testColgroupElement [
	| document table colgroup |
	document := self
		parse: '<!DOCTYPE html>
<html>
<head>
<style>
table, th, td {
    border: 1px solid black;
}
</style>
</head>
<body>

<table>
  <colgroup>
    <col span="2" style="background-color:red">
    <col style="background-color:yellow">
  </colgroup>
  <tr>
    <th>ISBN</th>
    <th>Title</th>
    <th>Price</th>
  </tr>
  <tr>
    <td>3476896</td>
    <td>My first HTML</td>
    <td>$53</td>
  </tr>
  <tr>
    <td>5869207</td>
    <td>My first CSS</td>
    <td>$49</td>
  </tr>
</table>

</body>
</html>'.
	self assert: document body children size = 1.
	table := document body children anyone.
	self assert: table children size = 4.
	colgroup := table children first.
	self
		assert: colgroup children size = 2;
		assert: (colgroup children conform: [:c | c class == HtmlColElement]);
		assert: (colgroup children first attributeAt: 'span') = '2';
		assert: (colgroup children first attributeAt: 'style')
			= 'background-color:red';
		assert: (colgroup children second attributeAt: 'style')
			= 'background-color:yellow']

{ #category : #all }
HtmlParsingTest >> testDdElement [
	| document dl |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<dl>
  <dt>Coffee</dt>
  <dd>Black hot drink</dd>
  <dt>Milk</dt>
  <dd>White cold drink</dd>
</dl>

</body>
</html>'.
	self assert: document body children size = 1.
	dl := document body children anyone.
	self
		assert: dl children size = 4;
		assert: dl children second class == HtmlDdElement;
		assert: dl children second children anyone asString = 'Black hot drink';
		assert: dl children fourth class == HtmlDdElement;
		assert: dl children fourth children anyone asString = 'White cold drink']

{ #category : #all }
HtmlParsingTest >> testDelElement [
	| document p del |
	#knownIssue.
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>My favorite color is <del>blue</del> <ins>red</ins>!</p>

</body>
</html>'.
	self assert: document body children size = 1.
	p := document body children anyone.
	self assert: p children size = 5.
	del := p children second.
	self
		assert: del class == HtmlDelElement;
		assert: del children anyone asString = 'blue']

{ #category : #all }
HtmlParsingTest >> testDfnElement [
	| document p dfn |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p><dfn>HTML</dfn> is the standard markup language for creating web pages.</p>

</body>
</html>'.
	self assert: document body children size = 1.
	p := document body children anyone.
	self assert: p children size = 2.
	dfn := p children first.
	self
		assert: dfn class == HtmlDfnElement;
		assert: dfn children anyone asString = 'HTML']

{ #category : #all }
HtmlParsingTest >> testDirElement [
	| document dir |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<dir>
  <li>html</li>
  <li>xhtml</li>
  <li>css</li>
</dir>

<p>The dir element is not supported in HTML5. Use CSS instead.</p>

</body>
</html>'.
	self assert: document body children size = 2.
	dir := document body children first.
	self
		assert: dir class == HtmlDirElement;
		assert: dir children size = 3;
		assert: (dir children conform: [:i | i class == HtmlLiElement])]

{ #category : #all }
HtmlParsingTest >> testDivElement [
	| document div |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>This is some text.</p>

<div style="background-color:lightblue">
  <h3>This is a heading in a div element</h3>
  <p>This is some text in a div element.</p>
</div>

<p>This is some text.</p>

</body>
</html>'.
	self assert: document body children size = 3.
	div := document body children second.
	self
		assert: div class == HtmlDivElement;
		assert: div children size = 2;
		assert: (div attributeAt: 'style') = 'background-color:lightblue']

{ #category : #all }
HtmlParsingTest >> testDlElement [
	| document dl |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<dl>
  <dt>Coffee</dt>
  <dd>Black hot drink</dd>
  <dt>Milk</dt>
  <dd>White cold drink</dd>
</dl>

</body>
</html>'.
	self assert: document body children size = 1.
	dl := document body children anyone.
	self
		assert: dl children size = 4;
		assert: (dl children
			conform: [:e | e class == HtmlDdElement or: [e class == HtmlDtElement]])]

{ #category : #all }
HtmlParsingTest >> testDtElement [
	| document dl |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<dl>
  <dt>Coffee</dt>
  <dd>Black hot drink</dd>
  <dt>Milk</dt>
  <dd>White cold drink</dd>
</dl>

</body>
</html>'.
	self assert: document body children size = 1.
	dl := document body children anyone.
	self
		assert: dl children size = 4;
		assert: dl children first class == HtmlDtElement;
		assert: dl children first children anyone asString = 'Coffee';
		assert: dl children third class == HtmlDtElement;
		assert: dl children third children anyone asString = 'Milk']

{ #category : #all }
HtmlParsingTest >> testEmbedElement [
	| document embed |
	document := self
		parse: '<<!DOCTYPE html>
<html>
<body>

<embed src="helloworld.swf">

</body>
</html>'.
	self assert: document body children size = 1.
	embed := document body children first.
	self
		assert: embed class == HtmlEmbedElement;
		assert: (embed attributeAt: 'src') = 'helloworld.swf']

{ #category : #all }
HtmlParsingTest >> testEmElement [
	| document em |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<em>Emphasized text</em><br>
<strong>Strong text</strong><br>
<code>A piece of computer code</code><br>
<samp>Sample output from a computer program</samp><br>
<kbd>Keyboard input</kbd><br>
<var>Variable</var>

</body>
</html>'.
	self assert: document body children size = 11.
	em := document body children first.
	self
		assert: em class == HtmlEmElement;
		assert: em children anyone asString = 'Emphasized text']

{ #category : #all }
HtmlParsingTest >> testFieldsetElement [
	| document form fieldset |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<form>
 <fieldset>
  <legend>Personalia:</legend>
  Name: <input type="text"><br>
  Email: <input type="text"><br>
  Date of birth: <input type="text">
 </fieldset>
</form>

</body>
</html>'.
	self assert: document body children size = 1.
	form := document body children first.
	self assert: form children size = 1.
	fieldset := form children anyone.
	self
		assert: fieldset class == HtmlFieldsetElement;
		assert: fieldset children first class == HtmlLegendElement;
		assert: (fieldset children count: [:e | e class == HtmlInputElement]) = 3]

{ #category : #all }
HtmlParsingTest >> testFontElement [
	| document paragraphs font1 font2 font3 |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p><font size="3" color="red">This is some text!</font></p>

<p><font size="2" color="blue">This is some text!</font></p>

<p><font face="verdana" color="green">This is some text!</font></p>

<p><strong>Note:</strong> The font element is not supported in HTML5. Use CSS instead.</p>

</body>
</html>'.
	self
		assert: document body children size = 4;
		assert: (document body children conform: [:e | e class == HtmlPElement]).
	paragraphs := document body children.
	font1 := paragraphs first children first.
	font2 := paragraphs second children first.
	font3 := paragraphs third children first.
	self
		assert: font1 class == HtmlFontElement;
		assert: (font1 attributeAt: 'size') = '3';
		assert: (font1 attributeAt: 'color') = 'red';
		assert: font2 class == HtmlFontElement;
		assert: (font2 attributeAt: 'size') = '2';
		assert: (font2 attributeAt: 'color') = 'blue';
		assert: font3 class == HtmlFontElement;
		assert: (font3 attributeAt: 'face') = 'verdana';
		assert: (font3 attributeAt: 'color') = 'green']

{ #category : #all }
HtmlParsingTest >> testFormElement [
	| document form |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<form action="/action_page.php">
First name: <input type="text" name="FirstName" value="Mickey"><br>
Last name: <input type="text" name="LastName" value="Mouse"><br>
<input type="submit" value="Submit">
</form>

<p>Click the "Submit" button and the form-data will be sent to a page on the server called "/action_page.php".</p>

</body>
</html>'.
	self assert: document body children size = 2.
	form := document body children first.
	self
		assert: form class == HtmlFormElement;
		assert: (form attributeAt: 'action') = '/action_page.php';
		assert: form children second class == HtmlInputElement;
		assert: (form children second attributeAt: 'type') = 'text';
		assert: (form children second attributeAt: 'name') = 'FirstName';
		assert: (form children second attributeAt: 'value') = 'Mickey';
		assert: form children fifth class == HtmlInputElement;
		assert: (form children fifth attributeAt: 'type') = 'text';
		assert: (form children fifth attributeAt: 'name') = 'LastName';
		assert: (form children fifth attributeAt: 'value') = 'Mouse';
		assert: form children seventh class == HtmlInputElement;
		assert: (form children seventh attributeAt: 'type') = 'submit';
		assert: (form children seventh attributeAt: 'value') = 'Submit']

{ #category : #all }
HtmlParsingTest >> testFrameElement [
	| document frameset |
	#knownIssue.
	document := self
		parse: '<!DOCTYPE html>
<html>

<frameset cols="25%,*,25%">
  <frame src="frame_a.htm">
  <frame src="frame_b.htm">
  <frame src="frame_c.htm">
</frameset>

</html>'.
	frameset := document detect: [:e | e class == HtmlFramesetElement].
	self
		assert: frameset notNil;
		assert: frameset children size = 3;
		assert: frameset children first class = HtmlFrameElement;
		assert: (frameset children first attributeAt: 'src') = 'frame_a.htm';
		assert: frameset children second class = HtmlFrameElement;
		assert: (frameset children second attributeAt: 'src') = 'frame_b.htm';
		assert: frameset children third class = HtmlFrameElement;
		assert: (frameset children third attributeAt: 'src') = 'frame_c.htm']

{ #category : #all }
HtmlParsingTest >> testFramesetElement [
	| document frameset |
	document := self
		parse: '<!DOCTYPE html>
<html>

<frameset cols="25%,*,25%">
  <frame src="frame_a.htm">
  <frame src="frame_b.htm">
  <frame src="frame_c.htm">
</frameset>

</html>'.
	frameset := document detect: [:e | e class == HtmlFramesetElement].
	self
		assert: frameset notNil;
		assert: (frameset attributeAt: 'cols') = '25%,*,25%';
		assert: (frameset children conform: [:e | e class == HtmlFrameElement])]

{ #category : #all }
HtmlParsingTest >> testH1toH6Element [
	| document children |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<h1>This is heading 1</h1>
<h2>This is heading 2</h2>
<h3>This is heading 3</h3>
<h4>This is heading 4</h4>
<h5>This is heading 5</h5>
<h6>This is heading 6</h6>

<p><b>Tip:</b> Use h1 to h6 elements only for headings. Do not use them just to make text bold or big. Use other tags for that.</p>

</body>
</html>'.
	children := document body select: [:e | e class name beginsWith: 'HtmlH'].
	self
		assert: children first class == HtmlH1Element;
		assert: children first children anyone asString = 'This is heading 1';
		assert: children second class == HtmlH2Element;
		assert: children second children anyone asString = 'This is heading 2';
		assert: children third class == HtmlH3Element;
		assert: children third children anyone asString = 'This is heading 3';
		assert: children fourth class == HtmlH4Element;
		assert: children fourth children anyone asString = 'This is heading 4';
		assert: children fifth class == HtmlH5Element;
		assert: children fifth children anyone asString = 'This is heading 5';
		assert: children sixth class == HtmlH6Element;
		assert: children sixth children anyone asString = 'This is heading 6']

{ #category : #all }
HtmlParsingTest >> testHeadElement [
	| document head |
	document := self
		parse: '<!DOCTYPE html>
<html>
<head>
<title>Title of the document</title>
</head>

<body>
The content of the document......
</body>

</html>'.
	head := document detect: [:e | e class == HtmlHeadElement].
	self
		assert: head notNil;
		assert: head children size = 1;
		assert: head children anyone class == HtmlTitleElement]

{ #category : #all }
HtmlParsingTest >> testHrElement [
	| document body |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<h1>HTML</h1>
<p>HTML is a language for describing web pages.</p>

<hr>

<h1>CSS</h1>
<p>CSS defines how to display HTML elements.</p>

</body>
</html>'.
	body := document detect: [:e | e class == HtmlBodyElement].
	self
		assert: body children size = 5;
		assert: body children third class == HtmlHrElement]

{ #category : #all }
HtmlParsingTest >> testHtmlElement [
	| document |
	document := self
		parse: '<!DOCTYPE html>
<html>
<head>
<title>Title of the document</title>
</head>

<body>
The content of the document......
</body>

</html>'.
	self assert: document children first class == HtmlHtmlElement]

{ #category : #all }
HtmlParsingTest >> testIElement [
	| document p i |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>He named his car <i>The lightning</i>, because it was very fast.</p>

</body>
</html>'.
	p := document body children anyone.
	self assert: p children size = 3.
	i := p children second.
	self
		assert: i class == HtmlIElement;
		assert: i children anyone asString = 'The lightning']

{ #category : #all }
HtmlParsingTest >> testIframeElement [
	| document iframe |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<iframe src="https://www.w3schools.com">
  <p>Your browser does not support iframes.</p>
</iframe>

</body>
</html>​'.
	iframe := document body children anyone.
	self
		assert: iframe class == HtmlIframeElement;
		assert: (iframe attributeAt: 'src') = 'https://www.w3schools.com';
		assert: iframe children size = 1;
		assert: iframe children anyone class == HtmlPElement]

{ #category : #all }
HtmlParsingTest >> testImgElement [
	| document img |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<img src="smiley.gif" alt="Smiley face" width="42" height="42">

</body>
</html>'.
	img := document body children anyone.
	self
		assert: img class == HtmlImgElement;
		assert: (img attributeAt: 'src') = 'smiley.gif';
		assert: (img attributeAt: 'alt') = 'Smiley face';
		assert: (img attributeAt: 'width') = '42';
		assert: (img attributeAt: 'height') = '42']

{ #category : #all }
HtmlParsingTest >> testInsElement [
	| document p ins |
	#knownIssue.
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>My favorite color is <del>blue</del> <ins>red</ins>!</p>

</body>
</html>'.
	p := document body children anyone.
	self assert: p children size = 4.
	ins := p children third.
	self
		assert: ins class == HtmlInsElement;
		assert: ins children anyone asString = 'red']

{ #category : #all }
HtmlParsingTest >> testKbdElement [
	| document body kbd |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<em>Emphasized text</em><br>
<strong>Strong text</strong><br>
<code>A piece of computer code</code><br>
<samp>Sample output from a computer program</samp><br>
<kbd>Keyboard input</kbd><br>
<var>Variable</var>

</body>
</html>'.
	body := document body.
	self assert: body children size = 11.
	kbd := body children at: 9.
	self
		assert: kbd class == HtmlKbdElement;
		assert: kbd children anyone asString = 'Keyboard input']

{ #category : #all }
HtmlParsingTest >> testLabelElement [
	| document body form labels |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>Click on one of the text labels to toggle the related control:</p>

<form action="/action_page.php">
  <label for="male">Male</label>
  <input type="radio" name="gender" id="male" value="male"><br>
  <label for="female">Female</label>
  <input type="radio" name="gender" id="female" value="female"><br>
  <label for="other">Other</label>
  <input type="radio" name="gender" id="other" value="other"><br><br>
  <input type="submit" value="Submit">
</form>

</body>
</html>'.
	body := document body.
	self assert: body children size = 2.
	form := body children second.
	labels := form children select: [:e | e class == HtmlLabelElement].
	self
		assert: labels size = 3;
		assert: (labels first attributeAt: 'for') = 'male';
		assert: labels first children anyone asString = 'Male';
		assert: (labels second attributeAt: 'for') = 'female';
		assert: labels second children anyone asString = 'Female';
		assert: (labels third attributeAt: 'for') = 'other';
		assert: labels third children anyone asString = 'Other']

{ #category : #all }
HtmlParsingTest >> testLegendElement [
	| document fieldset legend |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<form>
 <fieldset>
  <legend>Personalia:</legend>
  Name: <input type="text"><br>
  Email: <input type="text"><br>
  Date of birth: <input type="text">
 </fieldset>
</form>

</body>
</html>'.
	fieldset := document detect: [:e | e class == HtmlFieldsetElement].
	self
		assert: fieldset notNil;
		assert: fieldset children size = 9.
	legend := fieldset children anyone.
	self
		assert: legend class == HtmlLegendElement;
		assert: legend children anyone asString = 'Personalia:']

{ #category : #all }
HtmlParsingTest >> testLiElement [
	| document body ol ul |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>An ordered list:</p>
<ol>
  <li>Coffee</li>
  <li>Tea</li>
  <li>Milk</li>
</ol>

<p>An unordered list:</p>
<ul>
  <li>Coffee</li>
  <li>Tea</li>
  <li>Milk</li>
</ul>

</body>
</html>'.
	body := document body.
	ol := body detect: [:e | e class == HtmlOlElement].
	ul := body detect: [:e | e class == HtmlUlElement].
	self
		assert: ol children size = 3;
		assert: (ol children conform: [:li | li class == HtmlLiElement]);
		assert: ul children size = 3;
		assert: (ul children conform: [:li | li class == HtmlLiElement])]

{ #category : #all }
HtmlParsingTest >> testLinkElement [
	| document head link |
	document := self
		parse: '<!DOCTYPE html>
<html>
<head>
  <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>

<h1>I am formatted with a linked style sheet</h1>
<p>Me too!</p>

</body>
</html>'.
	head := document head.
	link := head children anyone.
	self
		assert: link class == HtmlLinkElement;
		assert: (link attributeAt: 'rel') = 'stylesheet';
		assert: (link attributeAt: 'type') = 'text/css';
		assert: (link attributeAt: 'href') = 'styles.css']

{ #category : #all }
HtmlParsingTest >> testMapElement [
	| document body map |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>Click on the sun or on one of the planets to watch it closer:</p>

<img src="planets.gif" width="145" height="126" alt="Planets" usemap="#planetmap">

<map name="planetmap">
  <area shape="rect" coords="0,0,82,126" alt="Sun" href="sun.htm">
  <area shape="circle" coords="90,58,3" alt="Mercury" href="mercur.htm">
  <area shape="circle" coords="124,58,8" alt="Venus" href="venus.htm">
</map>

</body>
</html>'.
	body := document body.
	map := body detect: [:e | e class == HtmlMapElement].
	self
		assert: map class == HtmlMapElement;
		assert: (map attributeAt: 'name') = 'planetmap';
		assert: map children size = 3;
		assert: (map children conform: [:e | e class == HtmlAreaElement])]

{ #category : #all }
HtmlParsingTest >> testMetaElement [
	| document meta |
	document := self
		parse: '<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="description" content="Free Web tutorials">
  <meta name="keywords" content="HTML,CSS,XML,JavaScript">
  <meta name="author" content="John Doe">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>

<p>All meta information goes in the head section...</p>

</body>
</html>'.
	meta := document head children.
	self
		assert: (meta conform: [:e | e class == HtmlMetaElement]);
		assert: (meta first attributeAt: 'charset') = 'UTF-8';
		assert: (meta second attributeAt: 'name') = 'description';
		assert: (meta second attributeAt: 'content') = 'Free Web tutorials';
		assert: (meta third attributeAt: 'name') = 'keywords';
		assert: (meta third attributeAt: 'content') = 'HTML,CSS,XML,JavaScript';
		assert: (meta fourth attributeAt: 'name') = 'author';
		assert: (meta fourth attributeAt: 'content') = 'John Doe';
		assert: (meta fifth attributeAt: 'name') = 'viewport';
		assert: (meta fifth attributeAt: 'content')
			= 'width=device-width, initial-scale=1.0']

{ #category : #all }
HtmlParsingTest >> testNavElement [
	| document nav |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<nav>
<a href="/html/">HTML</a> |
<a href="/css/">CSS</a> |
<a href="/js/">JavaScript</a> |
<a href="/jquery/">jQuery</a>
</nav>

<p><strong>Note:</strong> The nav tag is not supported in Internet Explorer 8 and earlier versions.</p>

</body>
</html>'.
	nav := document body children anyone.
	self
		assert: nav class == HtmlNavElement;
		assert: (nav children count: [:e | e class = HtmlAElement]) = 4]

{ #category : #all }
HtmlParsingTest >> testNoframesElement [
	| document frameset noframes |
	#knownIssue.
	document := self
		parse: '<!DOCTYPE html>
<html>

<frameset cols="25%,50%,25%">
  <frame src="frame_a.htm">
  <frame src="frame_b.htm">
  <frame src="frame_c.htm">
  <noframes>Sorry, your browser does not handle frames!</noframes>
</frameset>

</html>'.
	frameset := document detect: [:e | e class == HtmlFramesetElement].
	noframes := frameset children last.
	self
		assert: noframes class == HtmlNoframesElement;
		assert: noframes children anyone asString
			= 'Sorry, your browser does not handle frames!']

{ #category : #all }
HtmlParsingTest >> testNoscriptElement [
	| document body noscript |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<script>
document.write("Hello World!")
</script>
<noscript>Sorry, your browser does not support JavaScript!</noscript>

<p>A browser without support for JavaScript will show the text inside the noscript element.</p>
 
</body>
</html>'.
	body := document body.
	noscript := body children detect: [:e | e class == HtmlNoscriptElement].
	self
		assert: noscript children anyone asString
			= 'Sorry, your browser does not support JavaScript!']

{ #category : #all }
HtmlParsingTest >> testObjectElement [
	| document body object |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<object width="400" height="400" data="helloworld.swf">
</object>
 
</body>
</html>'.
	body := document body.
	self assert: body children size = 1.
	object := body children anyone.
	self
		assert: object class == HtmlObjectElement;
		assert: (object attributeAt: 'width') = '400';
		assert: (object attributeAt: 'height') = '400';
		assert: (object attributeAt: 'data') = 'helloworld.swf']

{ #category : #all }
HtmlParsingTest >> testOlElement [
	| document body ol1 ol2 |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<ol>
  <li>Coffee</li>
  <li>Tea</li>
  <li>Milk</li>
</ol>

<ol start="50">
  <li>Coffee</li>
  <li>Tea</li>
  <li>Milk</li>
</ol>
 
</body>
</html>'.
	body := document body.
	self assert: body children size = 2.
	ol1 := body children first.
	ol2 := body children first.
	self
		assert: ol1 class == HtmlOlElement;
		assert: ol1 children size = 3;
		assert: (ol1 children conform: [:li | li class = HtmlLiElement]);
		assert: ol2 class == HtmlOlElement;
		assert: ol2 children size = 3;
		assert: (ol2 children conform: [:li | li class = HtmlLiElement])]

{ #category : #all }
HtmlParsingTest >> testOptgroupElement [
	| document select og1 og2 |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<select>
  <optgroup label="Swedish Cars">
    <option value="volvo">Volvo</option>
    <option value="saab">Saab</option>
  </optgroup>
  <optgroup label="German Cars">
    <option value="mercedes">Mercedes</option>
    <option value="audi">Audi</option>
  </optgroup>
</select>
 
</body>
</html>'.
	select := document body children anyone.
	self assert: select children size = 2.
	og1 := select children first.
	og2 := select children second.
	self
		assert: og1 class == HtmlOptgroupElement;
		assert: og1 children size = 2;
		assert: (og1 children conform: [:o | o class = HtmlOptionElement]);
		assert: og2 class == HtmlOptgroupElement;
		assert: og2 children size = 2;
		assert: (og2 children conform: [:o | o class = HtmlOptionElement])]

{ #category : #all }
HtmlParsingTest >> testOptionElement [
	| document select options |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<select>
  <option value="volvo">Volvo</option>
  <option value="saab">Saab</option>
  <option value="opel">Opel</option>
  <option value="audi">Audi</option>
</select>
  
</body>
</html>'.
	select := document body children anyone.
	self assert: select children size = 4.
	options := select children.
	self
		assert: (options conform: [:o | o class == HtmlOptionElement]);
		assert: (options first attributeAt: 'value') = 'volvo';
		assert: options first children anyone asString = 'Volvo';
		assert: (options second attributeAt: 'value') = 'saab';
		assert: options second children anyone asString = 'Saab';
		assert: (options third attributeAt: 'value') = 'opel';
		assert: options third children anyone asString = 'Opel';
		assert: (options fourth attributeAt: 'value') = 'audi';
		assert: options fourth children anyone asString = 'Audi']

{ #category : #all }
HtmlParsingTest >> testParamElement [
	| document body object param |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p><b>Note:</b> Internet Explorer 8, and earlier versions, does not support .wav files. Try to rename the file to "horse.mp3" to test the example in these versions of IE.</p>

<object data="horse.wav">
<param name="autoplay" value="true">
</object>

</body>
</html>'.
	body := document body.
	self assert: body children size = 2.
	object := body children second.
	self
		assert: object class == HtmlObjectElement;
		assert: object children size = 1.
	param := object children anyone.
	self
		assert: param class == HtmlParamElement;
		assert: (param attributeAt: 'name') = 'autoplay';
		assert: (param attributeAt: 'value') = 'true']

{ #category : #all }
HtmlParsingTest >> testPElement [
	| document body |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>This is a paragraph.</p>
<p>This is a paragraph.</p>
<p>This is a paragraph.</p>

</body>
</html>'.
	body := document body.
	self
		assert: body children size = 3;
		assert: (body children conform: [:p | p class == HtmlPElement]);
		assert: (body children
			conform: [:p | p children anyone asString = 'This is a paragraph.'])]

{ #category : #all }
HtmlParsingTest >> testPreElement [
	| document body pre |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<pre>
Text in a pre element
is displayed in a fixed-width
font, and it preserves
both      spaces and
line breaks
</pre>

</body>
</html>'.
	body := document body.
	self assert: body children size = 1.
	pre := body children anyone.
	self
		assert: pre class = HtmlPreElement;
		assert: pre children anyone asString
			= 'Text in a pre element
is displayed in a fixed-width
font, and it preserves
both      spaces and
line breaks
']

{ #category : #all }
HtmlParsingTest >> testQElement [
	| document body p q |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>WWF''s goal is to: 
<q>Build a future where people live in harmony with nature.</q>
We hope they succeed.</p>

</body>
</html>'.
	body := document body.
	self assert: body children size = 1.
	p := body children anyone.
	self
		assert: p class == HtmlPElement;
		assert: p children size = 3.
	q := p children second.
	self
		assert: q class = HtmlQElement;
		assert: q children anyone asString
			= 'Build a future where people live in harmony with nature.']

{ #category : #all }
HtmlParsingTest >> testSampElement [
	| document body samp |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<em>Emphasized text</em><br>
<strong>Strong text</strong><br>
<code>A piece of computer code</code><br>
<samp>Sample output from a computer program</samp><br>
<kbd>Keyboard input</kbd><br>
<var>Variable</var>

</body>
</html>'.
	body := document body.
	self assert: body children size = 11.
	samp := body children seventh.
	self
		assert: samp class == HtmlSampElement;
		assert: samp children anyone asString
			= 'Sample output from a computer program']

{ #category : #all }
HtmlParsingTest >> testScriptElement [
	| document body script |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p id="demo"></p>

<script>
document.getElementById("demo").innerHTML = "Hello JavaScript!";
</script> 

</body>
</html>'.
	body := document body.
	self assert: body children size = 2.
	script := body children second.
	self
		assert: script children anyone asString trimBlanks
			= 'document.getElementById("demo").innerHTML = "Hello JavaScript!";']

{ #category : #all }
HtmlParsingTest >> testSelectElement [
	| document body select |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<select>
  <option value="volvo">Volvo</option>
  <option value="saab">Saab</option>
  <option value="opel">Opel</option>
  <option value="audi">Audi</option>
</select>
  
</body>
</html>'.
	body := document body.
	self assert: body children size = 1.
	select := body children anyone.
	self
		assert: select class == HtmlSelectElement;
		assert: select children size = 4;
		assert: (select children conform: [:o | o class == HtmlOptionElement])]

{ #category : #all }
HtmlParsingTest >> testSElement [
	| document body p s |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p><s>My car is blue.</s></p>
<p>My new car is silver.</p>

</body>
</html>'.
	body := document body.
	self assert: body children size = 2.
	p := body children first.
	self assert: p children size = 1.
	s := p children anyone.
	self
		assert: s class == HtmlSElement;
		assert: s children anyone asString = 'My car is blue.']

{ #category : #all }
HtmlParsingTest >> testSmallElement [
	| document body p small |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>W3Schools.com - the world''s largest web development site.</p>
<p><small>Copyright 1999-2050 by Refsnes Data.</small></p>

</body>
</html>'.
	body := document body.
	self assert: body children size = 2.
	p := body children second.
	self assert: p children size = 1.
	small := p children anyone.
	self
		assert: small class == HtmlSmallElement;
		assert: small children anyone asString
			= 'Copyright 1999-2050 by Refsnes Data.']

{ #category : #all }
HtmlParsingTest >> testSourceElement [
	| document body audio ogg mp3 |
	#knownIssue.
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<audio controls>
<source src="horse.ogg" type="audio/ogg">
<source src="horse.mp3" type="audio/mpeg">
Your browser does not support the audio element.
</audio>

<p><strong>Note:</strong> The source tag is not supported in Internet 
Explorer 8 and earlier versions.</p>

</body>
</html>'.
	body := document body.
	self assert: body children size = 2.
	audio := body children first.
	self assert: audio children size = 3.
	ogg := audio children first.
	mp3 := audio children second.
	self
		assert: ogg class == HtmlSourceElement;
		assert: (ogg attributeAt: 'src') = 'horse.ogg';
		assert: (ogg attributeAt: 'type') = 'audio/ogg';
		assert: mp3 class == HtmlSourceElement;
		assert: (mp3 attributeAt: 'src') = 'horse.mp3';
		assert: (mp3 attributeAt: 'type') = 'audio/mpeg']

{ #category : #all }
HtmlParsingTest >> testSpanElement [
	| document body p span1 span2 |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>My mother has <span style="color:blue;font-weight:bold">blue</span> eyes and my father has <span style="color:darkolivegreen;font-weight:bold">dark green</span> eyes.</p>

</body>
</html>'.
	body := document body.
	self assert: body children size = 1.
	p := body children first.
	self assert: p children size = 5.
	span1 := p children second.
	span2 := p children fourth.
	self
		assert: span1 class == HtmlSpanElement;
		assert: (span1 attributeAt: 'style') = 'color:blue;font-weight:bold';
		assert: span1 children anyone asString = 'blue';
		assert: span2 class == HtmlSpanElement;
		assert: (span2 attributeAt: 'style')
			= 'color:darkolivegreen;font-weight:bold';
		assert: span2 children anyone asString = 'dark green']

{ #category : #all }
HtmlParsingTest >> testStrikeElement [
	| document body p strike |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>Version 2.0 is <strike>not yet available!</strike> now available!</p>

<p>The strike element is not supported in HTML5. Use CSS instead.</p>
 
</body>
</html>'.
	body := document body.
	self assert: body children size = 2.
	p := body children first.
	self assert: p children size = 3.
	strike := p children second.
	self
		assert: strike class == HtmlStrikeElement;
		assert: strike children anyone asString = 'not yet available!']

{ #category : #all }
HtmlParsingTest >> testStrongElement [
	| document body strong |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<em>Emphasized text</em><br>
<strong>Strong text</strong><br>
<code>A piece of computer code</code><br>
<samp>Sample output from a computer program</samp><br>
<kbd>Keyboard input</kbd><br>
<var>Variable</var>

</body>
</html>'.
	body := document body.
	self assert: body children size = 11.
	strong := body children third.
	self
		assert: strong class == HtmlStrongElement;
		assert: strong children anyone asString = 'Strong text']

{ #category : #all }
HtmlParsingTest >> testStyleElement [
	| document head style |
	document := self
		parse: '<!DOCTYPE html>
<html>
<head>
<style>
h1 {color:red;}
p {color:blue;}
</style>
</head>
<body>

<h1>This is a heading</h1>
<p>This is a paragraph.</p>

</body>
</html>'.
	head := document head.
	self assert: head children size = 1.
	style := head children anyone.
	self
		assert: style class == HtmlStyleElement;
		assert: style children anyone asString = 'h1 {color:red;}
p {color:blue;}']

{ #category : #all }
HtmlParsingTest >> testSubElement [
	| document body p sub |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>This text contains <sub>subscript</sub> text.</p>
<p>This text contains <sup>superscript</sup> text.</p>

</body>
</html>'.
	body := document body.
	self assert: body children size = 2.
	p := body children first.
	self assert: p children size = 3.
	sub := p children second.
	self
		assert: sub class == HtmlSubElement;
		assert: sub children anyone asString = 'subscript']

{ #category : #all }
HtmlParsingTest >> testSupElement [
	| document body p sup |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>This text contains <sub>subscript</sub> text.</p>
<p>This text contains <sup>superscript</sup> text.</p>

</body>
</html>'.
	body := document body.
	self assert: body children size = 2.
	p := body children second.
	self assert: p children size = 3.
	sup := p children second.
	self
		assert: sup class == HtmlSupElement;
		assert: sup children anyone asString = 'superscript']

{ #category : #all }
HtmlParsingTest >> testTableElement [
	| document body table |
	document := self
		parse: '<!DOCTYPE html>
<html>
<head>
<style>
table, th, td {
    border: 1px solid black;
}
</style>
</head>
<body>

<table>
  <tr>
    <th>Month</th>
    <th>Savings</th>
  </tr>
  <tr>
    <td>January</td>
    <td>$100</td>
  </tr>
  <tr>
    <td>February</td>
    <td>$80</td>
  </tr>
</table>

</body>
</html>'.
	body := document body.
	self assert: body children size = 1.
	table := body children anyone.
	self
		assert: table class == HtmlTableElement;
		assert: table rows size = 3]

{ #category : #all }
HtmlParsingTest >> testTbodyElement [
	| document body table |
	document := self
		parse: '<!DOCTYPE html>
<html>
<head>
<style>
thead {color:green;}
tbody {color:blue;}
tfoot {color:red;}

table, th, td {
    border: 1px solid black;
}
</style>
</head>

<body>

<table>
  <thead>
    <tr>
      <th>Month</th>
      <th>Savings</th>
    </tr>
  </thead>
  <tfoot>
    <tr>
      <td>Sum</td>
      <td>$180</td>
    </tr>
  </tfoot>
  <tbody>
    <tr>
      <td>January</td>
      <td>$100</td>
    </tr>
    <tr>
      <td>February</td>
      <td>$80</td>
    </tr>
  </tbody>
</table>

<p><b>Tip:</b> The thead, tbody, and tfoot elements will not affect the layout of the table by default. However, you can use CSS to style these elements.</p>

</body>
</html>'.
	body := document body.
	self assert: body children size = 2.
	table := body children anyone.
	self assert: table class == HtmlTableElement.
	body := table body.
	self
		assert: body class == HtmlTbodyElement;
		assert: (body children conform: [:r | r class == HtmlTrElement])]

{ #category : #all }
HtmlParsingTest >> testTdElement [
	| document body table tr |
	document := self
		parse: '<!DOCTYPE html>
<html>
<head>
<style>
table, th, td {
    border: 1px solid black;
}
</style>
</head>
<body>

<table>
  <tr>
    <td>Cell A</td>
    <td>Cell B</td>
  </tr>
</table>

</body>
</html>'.
	body := document body.
	self assert: body children size = 1.
	table := body children anyone.
	self
		assert: table class == HtmlTableElement;
		assert: table children size = 1.
	tr := table children anyone.
	self
		assert: tr class == HtmlTrElement;
		assert: tr children size = 2;
		assert: (tr children conform: [:d | d class == HtmlTdElement]);
		assert: tr children first children anyone asString = 'Cell A';
		assert: tr children second children anyone asString = 'Cell B']

{ #category : #all }
HtmlParsingTest >> testTextareaElement [
	| document body textarea |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<textarea rows="4" cols="50">
At w3schools.com you will learn how to make a website. We offer free tutorials in all web development technologies.
</textarea>

</body>
</html>'.
	body := document body.
	self assert: body children size = 1.
	textarea := body children anyone.
	self
		assert: textarea class == HtmlTextareaElement;
		assert: (textarea attributeAt: 'rows') = '4';
		assert: (textarea attributeAt: 'cols') = '50']

{ #category : #all }
HtmlParsingTest >> testTfootElement [
	| document body table tfoot |
	document := self
		parse: '<!DOCTYPE html>
<html>
<head>
<style>
thead {color:green;}
tbody {color:blue;}
tfoot {color:red;}

table, th, td {
    border: 1px solid black;
}
</style>
</head>

<body>

<table>
  <thead>
    <tr>
      <th>Month</th>
      <th>Savings</th>
    </tr>
  </thead>
  <tfoot>
    <tr>
      <td>Sum</td>
      <td>$180</td>
    </tr>
  </tfoot>
  <tbody>
    <tr>
      <td>January</td>
      <td>$100</td>
    </tr>
    <tr>
      <td>February</td>
      <td>$80</td>
    </tr>
  </tbody>
</table>

<p><b>Tip:</b> The thead, tbody, and tfoot elements will not affect the layout of the table by default. However, you can use CSS to style these elements.</p>

</body>
</html>'.
	body := document body.
	self assert: body children size = 2.
	table := body children anyone.
	self assert: table children size = 3.
	tfoot := table children second.
	self
		assert: tfoot class == HtmlTfootElement;
		assert: tfoot children size = 1;
		assert: tfoot children anyone class == HtmlTrElement]

{ #category : #all }
HtmlParsingTest >> testTheadElement [
	| document body table thead |
	document := self
		parse: '<!DOCTYPE html>
<html>
<head>
<style>
thead {color:green;}
tbody {color:blue;}
tfoot {color:red;}

table, th, td {
    border: 1px solid black;
}
</style>
</head>

<body>

<table>
  <thead>
    <tr>
      <th>Month</th>
      <th>Savings</th>
    </tr>
  </thead>
  <tfoot>
    <tr>
      <td>Sum</td>
      <td>$180</td>
    </tr>
  </tfoot>
  <tbody>
    <tr>
      <td>January</td>
      <td>$100</td>
    </tr>
    <tr>
      <td>February</td>
      <td>$80</td>
    </tr>
  </tbody>
</table>

<p><b>Tip:</b> The thead, tbody, and tfoot elements will not affect the layout of the table by default. However, you can use CSS to style these elements.</p>

</body>
</html>'.
	body := document body.
	self assert: body children size = 2.
	table := body children first.
	self assert: table children size = 3.
	thead := table children first.
	self
		assert: thead class == HtmlTheadElement;
		assert: thead children size = 1;
		assert: thead children anyone class == HtmlTrElement]

{ #category : #all }
HtmlParsingTest >> testThElement [
	| document body table header |
	document := self
		parse: '<!DOCTYPE html>
<html>
<head>
<style>
table, th, td {
    border: 1px solid black;
}
</style>
</head>
<body>

<table>
  <tr>
    <th>Month</th>
    <th>Savings</th>
  </tr>
  <tr>
    <td>January</td>
    <td>$100</td>
  </tr>
  <tr>
    <td>February</td>
    <td>$80</td>
  </tr>
</table>

</body>
</html>'.
	body := document body.
	self assert: body children size = 1.
	table := body children anyone.
	self assert: table children size = 3.
	header := table children first.
	self
		assert: (header children conform: [:d | d class == HtmlThElement]);
		assert: header children first children anyone asString = 'Month';
		assert: header children second children anyone asString = 'Savings']

{ #category : #all }
HtmlParsingTest >> testTitleElement [
	| document head title |
	document := self
		parse: '<!DOCTYPE html>
<html>
<head>
<title>Title of the document</title>
</head>

<body>
The content of the document......
</body>

</html>'.
	head := document head.
	self assert: head children size = 1.
	title := head children anyone.
	self
		assert: title class == HtmlTitleElement;
		assert: title children anyone asString = 'Title of the document']

{ #category : #all }
HtmlParsingTest >> testTrElement [
	| document body table |
	document := self
		parse: '<!DOCTYPE html>
<html>
<head>
<style>
table, th, td {
    border: 1px solid black;
}
</style>
</head>
<body>

<table>
  <tr>
    <th>Month</th>
    <th>Savings</th>
  </tr>
  <tr>
    <td>January</td>
    <td>$100</td>
  </tr>
  <tr>
    <td>February</td>
    <td>$80</td>
  </tr>
</table>

</body>
</html>'.
	body := document body.
	self assert: body children size = 1.
	table := body children anyone.
	self assert: (table children conform: [:r | r class == HtmlTrElement])]

{ #category : #all }
HtmlParsingTest >> testTtElement [
	| document body p tt |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>This text is normal.</p>
<p><tt>This text is teletype text.</tt></p>

<p><strong>Note:</strong> The tt element is not supported in HTML5.</p>

</body>
</html>'.
	body := document body.
	self assert: body children size = 3.
	p := body children second.
	self assert: p children size = 1.
	tt := p children anyone.
	self
		assert: tt class == HtmlTtElement;
		assert: tt children anyone asString = 'This text is teletype text.']

{ #category : #all }
HtmlParsingTest >> testUElement [
	| document body p u |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<p>This is a <u>parragraph</u>.</p>

</body>
</html>'.
	body := document body.
	self assert: body children size = 1.
	p := body children anyone.
	self assert: p children size = 3.
	u := p children second.
	self
		assert: u class == HtmlUElement;
		assert: u children anyone asString = 'parragraph']

{ #category : #all }
HtmlParsingTest >> testUlElement [
	| document body ul |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<h4>An Unordered List:</h4>
<ul>
  <li>Coffee</li>
  <li>Tea</li>
  <li>Milk</li>
</ul>

</body>
</html>'.
	body := document body.
	self assert: body children size = 2.
	ul := body children second.
	self
		assert: ul class == HtmlUlElement;
		assert: ul children size = 3;
		assert: (ul children conform: [:i | i class == HtmlLiElement])]

{ #category : #all }
HtmlParsingTest >> testVarElement [
	| document body var |
	document := self
		parse: '<!DOCTYPE html>
<html>
<body>

<em>Emphasized text</em><br>
<strong>Strong text</strong><br>
<code>A piece of computer code</code><br>
<samp>Sample output from a computer program</samp><br>
<kbd>Keyboard input</kbd><br>
<var>Variable</var>

</body>
</html>'.
	body := document body.
	self assert: body children size = 11.
	var := body children last.
	self
		assert: var class == HtmlVarElement;
		assert: var children anyone asString = 'Variable']

