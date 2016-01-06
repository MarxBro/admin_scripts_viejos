#!/usr/bin/perl
######################################################################
# Machete con los codigos de respuesta de los servidores.
#   
#   * __DATA__ Sacada de: 
#   http://www.web-cache.com/Writings/http-status-codes.html
#
# MarxBro                                           2013.
######################################################################

use Text::Wrap;

my $code = shift;
my $r;
while (<DATA>) {
    if (/^$code/xms) {
        $r .= $_;
    }
}

$r =~ s/ -> /\n--------------------------\n/g;

$Text::Wrap::columns = 72;
print wrap( '', '', $r );

exit 0;

__DATA__
http://www.web-cache.com/Writings/http-status-codes.html

###########################
# 1xx Intermediate Status #
###########################

100 Continue -> This code informs the client that it should proceed with its request. This is useful when the client is sending a large message body. After sending the headers, the client waits for the 100 response, and then proceeds to send the message body. 

101 Switching Protocols -> This code allows clients and servers to negotiate the use of an alternate transfer protocol, or a different version of HTTP. 

###########################
# 2xx Successful Response #
###########################

200 OK -> This code indicates the request was successful. For GET requests, the body of a 200 response contains the entire object requested. 

201 Created -> This code informs the client that its request resulted in the successful creation of a new resource, which can now be referenced. 

202 Accepted -> This code means that the client's request was accepted and scheduled for further processing. The request may or may not be successful when eventually acted upon. 

203 Non-Authoritative Information -> This code may be used in place of 200 when the sender has reason to believe the information in the response's entity headers are different than what the origin server would send. 

204 No Content -> This code is used in cases where the request was successfully processed, but the response doesn't have a message body. 

205 Reset Content -> This code is similar to 204. The request was successful and the response doesn't include a message body. Furthermore, this code instructs the client to ``reset the document view,'' for example, by clearing the fields of an HTML form. 

206 Partial Content -> This code may be used in response to a range request (a.k.a. partial GET), whereby the client requests only a subset of the object data. 

#################
# 3xx Redirects #
#################

300 Multiple Choices -> This code informs users and user agents that the resource is available at multiple locations, perhaps in different representations. 

301 Moved Permanently -> This code redirects clients to a new location for the requested resource. This happens often when people relocate files on their servers, or when content is moved from one server to another. Because the redirection is permanent, clients and caches can remember the new location and automatically redirect future requests. 

302 Moved Temporarily -> This code is a temporary redirect to a new location. Apparently, many user agents always issue GET requests for the new URI, regardless of the original request method. This action violates even the older HTTP RFCs (1945 and 2068), but has become the expected behavior. RFC 2616 added two new status codes, 303 and 307, to ``fix'' this problem. 

303 See Other -> This code is the same as 302, except that the client should make a GET request for the new URI, regardless of the original request method. 

304 Not Modified -> This code is used when the client makes a conditional GET request (e.g. If-modified-since) and the resource has not changed. 

305 Use Proxy -> This code allows origin servers to redirect requests through a caching proxy. The proxy's address is given in the Location header. 

306 Unused -> A search of the HTTP working group archives reveals that, at one time, this code was named Switch Proxy. 

307 Temporary Redirect -> This code is similar to 302, indicating a temporary new location for the resource. However, clients must not use a different request method when requesting the new URI.

######################
# 4xx Request Errors #
######################

400 Bad Request -> This code indicates that the server could not understand the client's request, or found it to be incorrect in some way. 

401 Unauthorized -> This code is used when access to a resource is protected and the client did not provide valid authentication credentials. Often the 401 response includes information that causes the user agent to prompt the user for a username and password. 

402 Payment Required -> This code is reserved, but not yet described in the HTTP/1.1 specifications. 

403 Forbidden -> This code indicates that the resource cannot be accessed, regardless of any authentication credentials. For example, this happens if a directory or file is unreadable due to file permissions. 

404 Not Found -> This code indicates that the requested resource does not exist on the server. It may also be used in place of 403 if the server doesn't want to acknowledge that the resource exists, but cannot be accessed. 

405 Method Not Allowed -> This code indicates that the request method is inappropriate for the given URI. The response should include a list of methods that are allowed. 

406 Not Acceptable -> This code is used when the client's requirements, as given in the Accept header, conflict with the server's capabilities. For example, the client may indicate it will accept a GIF image, but the server is only able to generate JPEG images. 

407 Proxy Authentication Required -> This code is similar to 401, but is only returned by proxies. A proxy returns a 407 message upon receipt of a client request that doesn't have valid authentication credentials. 

408 Request Time-out -> This code is used when a server times out waiting for the client's request. 

409 Conflict -> This code indicates the server's resource is in a state of conflict, such that it cannot satisfy the request. Presumably, the user will be able to resolve the conflict after receiving this response. 

410 Gone -> This code is used when an origin server knows that the requested resource has been permanently removed. 

411 Length Required -> This code is used when the server requires, but did not receive, a &Contlen; header in the client's request. Requests for some methods, such as POST and PUT, have message bodies by default and therefore require &Contlen; headers. 

412 Precondition Failed -> This code indicates that the request was unsuccessful because one of the client's conditions was not met. For example, the client can tell the server ``only update this resource if the current version is X.'' If the current version is not ``X,'' the server returns a 412 response. 

413 Request Entity Too Large -> This code is used when a client's request is larger than the server is willing to accept. 

414 Request-URI Too Large -> This code indicates that the requested URI exceeds the server's limits. Although servers should accept URIs of any length, practical considerations may require actual limits. 

415 Unsupported Media Type -> This code is returned when a server refuses a request because the message body is in an inappropriate format. 

416 Requested Range Not Satisfiable -> This code indicates that the server could not process the client's partial GET request. 

417 Expectation Failed -> This code indicates that the client's expectation, given in an Expect header, can not be met. HTTP/1.1 clients typically use the Expect header to tell the server they expect to receive a 100 (Continue) status line. 

#####################
# 5xx Server Errors #
#####################

500 Internal Server Error -> This code is the default for an error condition when none of the other 5xx codes apply. 

501 Not Implemented -> This code indicates that the server does not implement the necessary features to satisfy the request. 

502 Bad Gateway -> This code indicates that the server received an invalid response from an upstream server. 

503 Service Unavailable -> This code indicates the server is temporarily unable to process the client's request. A server that becomes overloaded may use this code to let the client know that it can retry the request later. 

504 Gateway Time-out -> This code is used by proxies and some servers to indicate a timeout when forwarding the client's request. It's also used when a request with the only-if-cached directive would result in a cache miss. 

505 HTTP Version not supported -> This code indicates that the server refuses to handle this request because of the HTTP version in the request line.
