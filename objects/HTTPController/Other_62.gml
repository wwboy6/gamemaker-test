var requestId = async_load[? "id"];
if (!ds_map_exists(requests, requestId)) exit;

var _request = requests[? requestId];
var deferred = _request._deferred;
_request._deferred = undefined;
ds_map_delete(requests, requestId);

deferred.resolve({
	request: _request,
	response: async_load,
});
