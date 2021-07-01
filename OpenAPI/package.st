"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #OpenAPI,
	#requires : [
		'EDM',
		'HTTP',
		'JSON',
		'Kernel',
		'WebApplications'
	],
	#classes : [
		'OpenAPI.Callback',
		'OpenAPI.Components',
		'OpenAPI.Contact',
		'OpenAPI.Discriminator',
		'OpenAPI.Encoding',
		'OpenAPI.Example',
		'OpenAPI.ExternalDocumentation',
		'OpenAPI.Header',
		'OpenAPI.Info',
		'OpenAPI.License',
		'OpenAPI.Link',
		'OpenAPI.MediaType',
		'OpenAPI.Node',
		'OpenAPI.OAuthFlow',
		'OpenAPI.OAuthFlows',
		'OpenAPI.Object',
		'OpenAPI.Operation',
		'OpenAPI.Parameter',
		'OpenAPI.PathItem',
		'OpenAPI.Paths',
		'OpenAPI.Reference',
		'OpenAPI.RequestBody',
		'OpenAPI.Response',
		'OpenAPI.Responses',
		'OpenAPI.Schema',
		'OpenAPI.SecurityRequirement',
		'OpenAPI.SecurityScheme',
		'OpenAPI.Server',
		'OpenAPI.ServerVariable',
		'OpenAPI.Tag',
		'OpenAPI.Writer',
		'OpenAPI.XML'
	]
}

