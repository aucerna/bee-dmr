"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #URLTest,
	#superclass : #TestCase,
	#category : #'HTTP\Tests'
}

{ #category : #all }
URLTest >> testAddPath [
	| url |
	url := 'http://server/a' asURL.
	url addPath: 'b'.
	self assert: url = 'http://server/a/b' asURL.
	url addPath: 'c/d'.
	self assert: url = 'http://server/a/b/c/d' asURL.
	url addPath: '/e'.
	self assert: url = 'http://server/a/b/c/d/e' asURL]

{ #category : #all }
URLTest >> testBaseUri [
	| url |
	url := 'http://server/base' asURL.
	self assert: url baseUri = '/base'.
	url baseUri: 'base2'.
	self assert: url baseUri = '/base2'.
	url := 'http://server/' asURL.
	self assert: url isSlash.
	url baseUri: 'base'.
	self
		deny: url isSlash;
		assert: url baseUri = '/base'.
	url := 'http://server' asURL.
	url baseUri: '/base'.
	self assert: url baseUri = '/base']

{ #category : #all }
URLTest >> testBaseUrl [
	| base |
	base := 'http://server/home' asURL.
	self assert: 'http://server/home' asURL baseUrl = base.
	self assert: 'http://server/home/section' asURL baseUrl = base.
	self assert: 'http://server/home/section/subsection' asURL baseUrl = base.
	base port: 3333.
	self assert: 'http://server:3333/home/section' asURL baseUrl = base]

{ #category : #all }
URLTest >> testConcatenation [
	| url |
	url := 'http://host/my' asURL.
	url := url , '-site'.
	self assert: url path = '/my-site'.
	url := 'http://host' asURL.
	url := url , 'my-site'.
	self assert: url path = '/my-site'.
	url := 'relative/url' asURL.
	url := url / 'can/be/a/suffix'.
	self assert: url path = '/relative/url/can/be/a/suffix']

{ #category : #all }
URLTest >> testDefaultPort [
	self
		assert: 'http://server' asURL = 'http://server:80' asURL;
		deny: 'http://server:555' asURL = 'http://server' asURL;
		assert: 'https://server' asURL = 'https://server:443' asURL;
		deny: 'https://server:555' asURL = 'https://server:443' asURL;
		deny: 'https://server:555' asURL = 'https://server' asURL]

{ #category : #parsing }
URLTest >> testEncodedQuery [
	| url |
	url := 'http://host?first%20option=value' asURL.
	self
		assert: (url queryAt: 'first option') = 'value'
		description: 'Query options are decoded by an URL';
		assert: url queryString = '?first%20option=value'
		description: 'Query options are printed encoded']

{ #category : #all }
URLTest >> testEquality [
	'http://www.site.com' asURL = 'HTTP://WWW.SITE.COM' asURL]

{ #category : #parsing }
URLTest >> testFreeFormatter1 [
	| url |
	url := URLParser parse: 'ftp://ftp.is.co.za/rfc/rfc1808.txt'.
	self
		assert: url scheme = 'ftp';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host = 'ftp.is.co.za';
		assert: url port isNil;
		assert: url path = '/rfc/rfc1808.txt';
		deny: url hasQuery;
		assert: url fragment isNil]

{ #category : #parsing }
URLTest >> testFreeFormatter10 [
	| url |
	url := URLParser parse: 'https://secured.com:443'.
	self
		assert: url scheme = 'https';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host = 'secured.com';
		assert: url port = 443;
		assert: url path = '';
		deny: url hasQuery;
		assert: url hashFragment isNil]

{ #category : #parsing }
URLTest >> testFreeFormatter11 [
	| url |
	url := URLParser parse: 'ftp://ftp.bogus.com/~some/path/to/a/file.txt'.
	self
		assert: url scheme = 'ftp';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host = 'ftp.bogus.com';
		assert: url port isNil;
		assert: url path = '/~some/path/to/a/file.txt';
		deny: url hasQuery;
		assert: url hashFragment isNil]

{ #category : #parsing }
URLTest >> testFreeFormatter12 [
	| url |
	url := URLParser parse: 'urn:ietf:rfc:2648'.
	self
		assert: url scheme = 'urn';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host isNil;
		assert: url port isNil;
		assert: url path = '/ietf:rfc:2648';
		deny: url hasQuery;
		assert: url hashFragment isNil]

{ #category : #parsing }
URLTest >> testFreeFormatter13 [
	| url |
	url := URLParser parse: 'urn:uuid:6e8bc430-9c3a-11d9-9669-0800200c9a66'.
	self
		assert: url scheme = 'urn';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host isNil;
		assert: url port isNil;
		assert: url path = '/uuid:6e8bc430-9c3a-11d9-9669-0800200c9a66';
		deny: url hasQuery;
		assert: url hashFragment isNil]

{ #category : #parsing }
URLTest >> testFreeFormatter14 [
	| url |
	url := URLParser parse: 'ftp://username@host.com/'.
	self
		assert: url scheme = 'ftp';
		assert: url user = 'username';
		assert: url password isNil;
		assert: url host = 'host.com';
		assert: url port isNil;
		assert: url path = '/';
		deny: url hasQuery;
		assert: url hashFragment isNil]

{ #category : #parsing }
URLTest >> testFreeFormatter15 [
	| url |
	url := URLParser parse: 'username:password@host.com/'.
	self
		assert: url scheme = 'username';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host isNil;
		assert: url port isNil;
		assert: url path = '/password@host.com/';
		deny: url hasQuery;
		assert: url hashFragment isNil]

{ #category : #parsing }
URLTest >> testFreeFormatter16 [
	| url |
	url := URLParser parse: 'x:subdomain.domain.com'.
	self
		assert: url scheme = 'x';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host isNil;
		assert: url port isNil;
		assert: url path = '/subdomain.domain.com';
		deny: url hasQuery;
		assert: url hashFragment isNil]

{ #category : #parsing }
URLTest >> testFreeFormatter17 [
	| url |
	url := URLParser parse: 'www.superaddress.com:8080'.
	self
		assert: url scheme = 'www.superaddress.com';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host isNil;
		assert: url port isNil;
		assert: url path = '/8080';
		deny: url hasQuery;
		assert: url hashFragment isNil]

{ #category : #parsing }
URLTest >> testFreeFormatter18 [
	| url |
	url := URLParser parse: 'http://www.foo.bar/?listings.html#section-2'.
	self
		assert: url scheme = 'http';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host = 'www.foo.bar';
		deny: url hasExplicitPort;
		assert: url path = '/';
		assert: url queryString = 'listings.html';
		assert: url hashFragment = '#section-2']

{ #category : #parsing }
URLTest >> testFreeFormatter19 [
	| url |
	url := URLParser
		parse: 'http://www.foo.bar/segment1/segment2/some-resource.html'.
	self
		assert: url scheme = 'http';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host = 'www.foo.bar';
		deny: url hasExplicitPort;
		assert: url path = '/segment1/segment2/some-resource.html';
		deny: url hasQuery;
		assert: url hashFragment isNil]

{ #category : #parsing }
URLTest >> testFreeFormatter2 [
	| url |
	url := URLParser parse: 'http://www.ietf.org/rfc/rfc2396.txt'.
	self
		assert: url scheme = 'http';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host = 'www.ietf.org';
		deny: url hasExplicitPort;
		assert: url path = '/rfc/rfc2396.txt';
		deny: url hasQuery;
		assert: url fragment isNil]

{ #category : #parsing }
URLTest >> testFreeFormatter20 [
	| url |
	url := URLParser parse: 'http://www.foo.bar/image-2.html?w=100&h=50'.
	self
		assert: url scheme = 'http';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host = 'www.foo.bar';
		deny: url hasExplicitPort;
		assert: url path = '/image-2.html';
		deny: url queryString = 'w=100&h=50';
		assert: url fragment isNil]

{ #category : #parsing }
URLTest >> testFreeFormatter21 [
	| url |
	url := URLParser parse: 'ftp://ftp.foo.bar/~john/doe?w=100&h=50'.
	self
		assert: url scheme = 'ftp';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host = 'ftp.foo.bar';
		assert: url port isNil;
		assert: url path = '/~john/doe';
		deny: url queryString = 'w=100&h=50';
		assert: url fragment isNil]

{ #category : #parsing }
URLTest >> testFreeFormatter22 [
	| url |
	url := URLParser parse: 'http://www.foo.bar/image.jpg?height=150&width=100'.
	self
		assert: url scheme = 'http';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host = 'www.foo.bar';
		deny: url hasExplicitPort;
		assert: url path = '/image.jpg';
		deny: url queryString = 'height=150&width=100';
		assert: url fragment isNil]

{ #category : #parsing }
URLTest >> testFreeFormatter23 [
	| url |
	url := URLParser
		parse: 'https://www.secured.com:443/resource.html?id=6e8bc430-9c3a-11d9-9669-0800200c9a66#some-header'.
	self
		assert: url scheme = 'https';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host = 'www.secured.com';
		assert: url port = 443;
		assert: url path = '/resource.html';
		deny: url queryString = 'id=6e8bc430-9c3a-11d9-9669-0800200c9a66';
		assert: url fragment = 'some-header']

{ #category : #parsing }
URLTest >> testFreeFormatter3 [
	| url |
	url := URLParser parse: 'ldap://[2001:db8::7]/c=GB?objectClass?one'.
	self
		assert: url scheme = 'ldap';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host = '2001:db8::7';
		assert: url port isNil;
		assert: url path = '/c=GB';
		assert: url queryString = 'objectClass?one';
		assert: url fragment isNil]

{ #category : #parsing }
URLTest >> testFreeFormatter4 [
	| url |
	url := URLParser parse: 'news:comp.infosystems.www.servers.unix'.
	self
		assert: url scheme = 'news';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host isNil;
		assert: url port isNil;
		assert: url path = '/comp.infosystems.www.servers.unix';
		deny: url hasQuery;
		assert: url fragment isNil]

{ #category : #parsing }
URLTest >> testFreeFormatter5 [
	| url |
	url := URLParser parse: 'tel:+1-816-555-1212'.
	self
		assert: url scheme = 'tel';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host isNil;
		assert: url port isNil;
		assert: url path = '/+1-816-555-1212';
		deny: url hasQuery;
		assert: url fragment isNil]

{ #category : #parsing }
URLTest >> testFreeFormatter6 [
	| url |
	url := URLParser parse: 'telnet://192.0.2.16:80/'.
	self
		assert: url scheme = 'telnet';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host = '192.0.2.16';
		assert: url port = 80;
		assert: url path = '/';
		deny: url hasQuery;
		assert: url fragment isNil]

{ #category : #parsing }
URLTest >> testFreeFormatter7 [
	| url |
	url := URLParser
		parse: 'urn:oasis:names:specification:docbook:dtd:xml:4.1.2'.
	self
		assert: url scheme = 'urn';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host isNil;
		assert: url port isNil;
		assert: url path = '/oasis:names:specification:docbook:dtd:xml:4.1.2';
		deny: url hasQuery;
		assert: url fragment isNil]

{ #category : #parsing }
URLTest >> testFreeFormatter8 [
	| url |
	url := URLParser parse: 'http://www.google.com'.
	self
		assert: url scheme = 'http';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host = 'www.google.com';
		deny: url hasExplicitPort;
		assert: url path = '';
		deny: url hasQuery;
		assert: url fragment isNil]

{ #category : #parsing }
URLTest >> testFreeFormatter9 [
	| url |
	url := URLParser
		parse: 'http://foo:bar@w1.superman.com/very/long/path.html?p1=v1&p2=v2#more-details'.
	self
		assert: url scheme = 'http';
		assert: url user = 'foo';
		assert: url password cleartext = 'bar';
		assert: url host = 'w1.superman.com';
		deny: url hasExplicitPort;
		assert: url path = '/very/long/path.html';
		assert: (url queryAt: 'p1') = 'v1';
		assert: (url queryAt: 'p2') = 'v2';
		assert: url hashFragment = '#more-details']

{ #category : #parsing }
URLTest >> testHost [
	| url |
	url := URLParser parse: 'http://host/'.
	self
		assert: url notNil;
		assert: url host = 'host'.
	url := URLParser parse: 'http://1.180.2.66/'.
	self
		assert: url notNil;
		assert: url host = '1.180.2.66']

{ #category : #parsing }
URLTest >> testMakeAbsolute [
	| relative absolute url |
	relative := URL fromString: '/people/juliette?age=26'.
	self precondition: relative isRelative.
	absolute := URL fromString: 'http://server/root'.
	self precondition: absolute isAbsolute.
	url := absolute / relative.
	self
		assert: url isAbsolute;
		assert: url host = 'server';
		assert: url path = '/root/people/juliette';
		assert: (url queryAt: 'age') = '26']

{ #category : #parsing }
URLTest >> testODataQueryName [
	| url |
	url := URLParser parse: 'http://host/people?$filter=Id eq 1'.
	self
		assert: url notNil;
		assert: (url queryAt: '$filter') = 'Id eq 1']

{ #category : #parsing }
URLTest >> testPath [
	| url |
	url := URLParser parse: 'http://host/resource'.
	self
		assert: url notNil;
		assert: url path = '/resource'.
	url := URLParser parse: 'http://host/resource/property'.
	self
		assert: url notNil;
		assert: url path = '/resource/property']

{ #category : #all }
URLTest >> testProtocol [
	| url copy |
	url := 'http://server' asURL.
	self assert: url isHttp.
	url beHttps.
	self assert: url isHttps; assert: url isSecure.
	copy := url asHttp.
	self
		assert: copy !== url;
		assert: copy isHttp;
		assert: url isHttps.
	url beWs.
	self assert: url isWs.
	url beWss.
	self assert: url isWss]

{ #category : #parsing }
URLTest >> testQuery [
	| url |
	url := URLParser parse: 'http://host/people?name=William'.
	self
		assert: url notNil;
		assert: (url queryAt: 'name') = 'William'.
	url := URLParser parse: 'http://host/people?name=William%20Jr'.
	self
		assert: url notNil;
		assert: (url queryAt: 'name') = 'William Jr'.
	url := URLParser parse: 'http://host/people?name=William Jr'.
	self
		assert: url notNil;
		assert: (url queryAt: 'name') = 'William Jr'.
	url := URLParser parse: 'http://host/people?name='.
	self
		assert: url notNil;
		assert: (url queryAt: 'name') isEmpty]

{ #category : #parsing }
URLTest >> testRelative [
	| url |
	url := URLParser relativeUrlFrom: 'root/people/david'.
	self
		assert: url notNil;
		assert: url path = '/root/people/david'.
	url := URLParser relativeUrlFrom: '/people?name=William'.
	self
		assert: url notNil;
		assert: url path = '/people';
		assert: (url queryAt: 'name') = 'William']

{ #category : #all }
URLTest >> testRemoveSegment [
	| url |
	url := 'http://server/a/b/c' asURL.
	url removeSegment: 'a'.
	self assert: url = 'http://server/b/c' asURL.
	url removeSegment: 'c'.
	self assert: url = 'http://server/b' asURL.
	url removeSegment: 'z'.
	self assert: url = 'http://server/b' asURL]

{ #category : #all }
URLTest >> testRemoveSubpath [
	| url |
	url := 'http://server/a/b/c' asURL.
	url removeSubpath: 'a/b'.
	self assert: url = 'http://server/c' asURL.
	url := 'http://server/a/b' asURL.
	url removeSubpath: 'a/b/c'.
	self assert: url = 'http://server/a/b' asURL.
	url := 'http://server/a/b/c' asURL.
	url removeSubpath: 'a/b/c'.
	self assert: url = 'http://server' asURL]

{ #category : #all }
URLTest >> testRepeatedOption [
	| url |
	url := 'http://hostname/test?option=1&option=2' asURL.
	self assert: url queryOptions size = 2]

{ #category : #parsing }
URLTest >> testScheme [
	| url |
	url := URLParser parse: 'http://host/'.
	self
		assert: url notNil;
		assert: url scheme = 'http'.
	url := URLParser parse: 'ftp://1.180.2.66/'.
	self
		assert: url notNil;
		assert: url scheme = 'ftp']

{ #category : #all }
URLTest >> testSlashConcatenation [
	| url |
	url := 'http://host/a/' asURL.
	self assert: url / 'b' = 'http://host/a/b' asURL]

{ #category : #all }
URLTest >> testSlashInBetween [
	| url |
	url := 'http://server' asURL.
	url path: '/my/path/'.
	self assert: url path = '/my/path/'.
	url addSegment: 'end'.
	self assert: url path = '/my/path/end']

{ #category : #parsing }
URLTest >> testTP47103 [
	| encoded url |
	encoded := 'http://server/resource'
		/ (PercentEncoder encode: '000´1873').
	url := URLParser parse: encoded.
	self
		assert: url scheme = 'http';
		assert: url host = 'server';
		assert: url path = '/resoure/000´1873']

{ #category : #'encoding/decoding' }
URLTest >> testTP47702 [
	| encoder encoded decoded |
	encoder := PercentEncoder current.
	encoded := encoder encode: '#'.
	decoded := encoder decode: encoded.
	self
		assert: encoded = '%23';
		assert: decoded = '#'.
	encoded := encoder encode: '≈'.
	decoded := encoder decode: encoded.
	self
		assert: encoded = '%E2%89%88';
		assert: decoded = '≈']

{ #category : #'encoding/decoding' }
URLTest >> testTP53055 [
	| url |
	url := URLParser current parse: 'http://server?name={a'.
	self assert: (url queryAt: 'name') = '{a']

{ #category : #parsing }
URLTest >> testTP55349 [
	| url |
	url := URLParser
		relativeUrlFrom: '/api/v1/Requesters?where=Email eq "mark.d''arcy@aucerna.com"'.
	self
		assert: url notNil;
		assert: url path = '/api/v1/Requesters';
		assert: (url queryAt: 'where')
		equals: 'Email eq "mark.d''arcy@aucerna.com"']

{ #category : #'encoding/decoding' }
URLTest >> testTP56356 [
	| encoder encoded decoded |
	encoder := PercentEncoder current.
	encoded := encoder encode: '/'.
	decoded := encoder decode: encoded.
	self
		assert: encoded = '%2F';
		assert: decoded = '/'.
	encoded := encoder encode: '%'.
	decoded := encoder decode: encoded.
	self
		assert: encoded = '%25';
		assert: decoded = '%'.
	encoded := encoder encode: '.'.
	decoded := encoder decode: encoded.
	self
		assert: encoded = '.';
		assert: decoded = '.']

{ #category : #parsing }
URLTest >> testTrailingSlash [
	| url |
	url := 'http://server/base' asURL.
	self deny: url hasTrailingSlash.
	url addTrailingSlash.
	self
		assert: url hasTrailingSlash;
		assert: url path = '/base/'.
	url addTrailingSlash.
	self assert: url path = '/base/'.
	url := 'http://server.com' asURL.
	self deny: url hasTrailingSlash]

{ #category : #parsing }
URLTest >> testWikipedia1 [
	| url |
	url := URLParser
		parse: 'abc://username:password@example.com:123/path/data?key=value&key2=value2#fragid1'.
	self
		assert: url scheme = 'abc';
		assert: url user = 'username';
		assert: url password cleartext = 'password';
		assert: url host = 'example.com';
		assert: url port = 123;
		assert: url path = '/path/data';
		assert: (url queryAt: 'key') = 'value';
		assert: (url queryAt: 'key2') = 'value2';
		assert: url fragment = 'fragid1']

{ #category : #parsing }
URLTest >> testWikipedia2 [
	| url |
	url := URLParser parse: 'urn:example:mammal:monotreme:echidna'.
	self
		assert: url scheme = 'urn';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host isNil;
		assert: url port isNil;
		assert: url path = '/example:mammal:monotreme:echidna';
		deny: url hasQuery;
		assert: url fragment isNil]

{ #category : #parsing }
URLTest >> testWikipedia3 [
	"
	//example.org/scheme-relative/URI/with/absolute/path/to/resource.txt /relative/URI/with/absolute/path/to/resource.txt relative/path/to/resource.txt ../../../resource.txt ./resource.txt#frag01 resource.txt #frag01
	"
	| url |
	url := URLParser
		parse: 'https://example.org/absolute/URI/with/absolute/path/to/resource.txt'.
	self
		assert: url scheme = 'https';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host = 'example.org';
		deny: url hasExplicitPort;
		assert: url path = '/absolute/URI/with/absolute/path/to/resource.txt';
		deny: url hasQuery;
		assert: url fragment isNil]

{ #category : #parsing }
URLTest >> testWikipedia4 [
	| url |
	url := URLParser parse: 'ftp://example.org/resource.txt'.
	self
		assert: url scheme = 'ftp';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host = 'example.org';
		assert: url port isNil;
		assert: url path = '/resource.txt';
		deny: url hasQuery;
		assert: url fragment isNil]

{ #category : #parsing }
URLTest >> testWikipedia5 [
	| url |
	url := URLParser parse: 'urn:ISSN:1535-3613'.
	self
		assert: url scheme = 'urn';
		assert: url user isNil;
		assert: url password isNil;
		assert: url host isNil;
		assert: url port isNil;
		assert: url path = '/ISSN:1535-3613';
		deny: url hasQuery;
		assert: url fragment isNil]

