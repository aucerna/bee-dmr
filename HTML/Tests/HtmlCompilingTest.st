"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlCompilingTest,
	#superclass : #TestCase,
	#category : #'HTML\Tests'
}

{ #category : #compilation }
HtmlCompilingTest class >> configureCompiler: aCompiler [
	aCompiler optionAt: #compilerClass put: HybridCompiler]

{ #category : #all }
HtmlCompilingTest >> testEmptyHtml [
	| cm |
	cm := self compile: 'm <html>
<!DOCTYPE html>'.
	self
		assert: cm notNil;
		assert: (cm executeOn: self) trimBlanks = '<!DOCTYPE html>']

{ #category : #all }
HtmlCompilingTest >> testInlinedTag [
	| cm |
	cm := self compile: 'm 
^<html><p>This is an HTML paragraph</p></html>'.
	self
		assert: cm notNil;
		assert: (cm executeOn: self) trimBlanks = '<p>This is an HTML paragraph</p>']

{ #category : #all }
HtmlCompilingTest >> testSimplePageMethod [
	| cm |
	cm := self
		compile: 'm <html>
<!DOCTYPE html>
<html>
<body>

<h1>My First Heading</h1>

<p>My first paragraph.</p>

</body>
</html>'.
	self
		assert: cm notNil;
		assert: (cm executeOn: self) trimBlanks
			= '<!DOCTYPE html>
	<html>
		<body>
			<h1>My First Heading</h1>
			<p>My first paragraph.</p>
		</body>
	</html>']

