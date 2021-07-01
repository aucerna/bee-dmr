"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #RTF,
	#requires : [
		'GUIbase',
		'Kernel'
	],
	#classes : [
		'CHARSETINFO',
		'FONTSIGNATURE',
		'NullText',
		'Rtf',
		'RtfCommandIterator',
		'RtfFont',
		'RtfFontTable',
		'RtfFormattedTextFinder',
		'RtfFormattingFinder',
		'RtfFormattingReplacer',
		'RtfParseError',
		'RtfParser',
		'RtfParserState',
		'RtfProcessor',
		'RtfStringExtractor',
		'RtfStringProcessor',
		'RtfStringReplacer'
	]
}

