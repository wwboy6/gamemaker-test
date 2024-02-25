requests = ds_map_create();

/*
function requestHttpGet(url) {
	var headers = ds_map_create();
	return requestHttp(url, "GET", headers, "");
}

function requestHttpPost(url, body) {
	var headers = ds_map_create();
	return request(url, "POST", headers, body);
}
*/

function requestHttpGet(_url) {
	var requestId = http_get(_url);
	var deferred = new Deferred();
	requests[? requestId] = {
		_requestId: requestId,
		url: _url,
		method: "GET",
		_deferred: deferred,
	};
	return deferred.promise;
}


function requestHttp(_url, _method, _headers, _body) {
	var requestId = http_request(_url, _method, _headers, _body);
	var deferred = new Deferred();
	requests[? requestId] = {
		_requestId: requestId,
		url: _url,
		method: _method,
		headers: _headers,
		body: _body,
		_deferred: deferred,
	};
	return deferred.promise;
}
