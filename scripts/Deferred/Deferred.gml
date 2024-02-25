// AsyncOperation is a declaration of an async function (i.e. return promise)
// which is not run yet upon creation.
// It run when "process" is involved, and the promise object would behaviour respectively
function AsyncOperation(_callback) constructor {
	__ = {
		deferred: new Deferred(),
		callback: _callback,
	};
	static getPromise = function() {
		return __.deferred.promise;
	};
	static process = function (value) {
		var result = undefined;
		var success = false;
		try {
			result = __.callback(value);
			success = true;
		} catch (e) {
			__.deferred.reject(e);
		}
		if (success) {
			if (is_instanceof(result, Promise)) {
				result.chainDeferred(__.deferred);
			} else {
				__.deferred.resolve(result);
			}
		}
	};
	static cancel = function (error) {
		__.deferred.reject(error);
	};
	static skip = function (value) {
		__.deferred.resolve(value);
	}
}
// --------------------
// Deferred is to notify the Promise if the operation is resolved or rejected
// It encapsulate the private functions "resolve" and "reject" in Promise
// The corresponding async operation should be running on Deferred is created
// as so the Promise is created
function Deferred() constructor {
	promise = new Promise();
	static resolve = function(_returnValue = undefined) {
		promise.__resolve(_returnValue);
	}
	static reject = function(_error) {
		promise.__reject(_error);
	}
}
// --------------------
// It represents the behaviour of an async operation
// The corresponding async operation should be running on Promise is created
// Promise should not be created directly. Deferred or AsyncOperation should be created instead
function Promise() constructor {
	enum Status {
		Unresolved,
		Resolved,
		Rejected,
	}
	// TODO: study private variable
	__ = {
		status: Status.Unresolved,
		returnValue: undefined,
		error: undefined,
		nextOperations: [],
		errorOperations: [],
		chainedDeferreds: [],
	};
	// TODO: study private functions
	static __resolve = function(returnValue) {
		if (__.status != Status.Unresolved) throw new Exception("invalid status to resolve");
		__.status = Status.Resolved;
		__.returnValue = returnValue;
		array_foreach(__.nextOperations, function(operation) { operation.process(__.returnValue); });
		array_foreach(__.errorOperations, function(operation) { operation.skip(__.returnValue); });
		array_foreach(__.chainedDeferreds, function(deferred) { deferred.resolve(__.returnValue); });
	};
	static __reject = function(_error) {
		if (__.status != Status.Unresolved) throw new Exception("invalid status to reject");
		__.status = Status.Rejected;
		__.error = _error;
		if (array_length(__.nextOperations) == 0 && array_length(__.errorOperations) == 0 && array_length(__.chainedDeferreds) == 0) {
			throw _error;
		}
		array_foreach(__.nextOperations, function(operation) { operation.cancel(__.error); });
		array_foreach(__.errorOperations, function(operation) { operation.process(__.error); });
		array_foreach(__.chainedDeferreds, function(deferred) { deferred.reject(__.error); });
	};
	// public functions
	// TODO: then is a reserved word
	static next = function(cb) {
		var operation = new AsyncOperation(cb);
		switch(__.status) {
			case Status.Unresolved:
				array_push(__.nextOperations, operation);
				break;
			case Status.Resolved:
				operation.process(__.returnValue);
				break;
			case Status.Rejected:
				operation.cancel(__.returnValue);
				break;
		}
		return operation.getPromise();
	};
	// TODO: catch is a reserved word
	static error = function(cb) {
		var operation = new AsyncOperation(cb);
		switch(__.status) {
			case Status.Unresolved:
				array_push(__.errorOperations, operation);
				break;
			case Status.Resolved:
				operation.skip(__.returnValue);
				break;
			case Status.Rejected:
				operation.process(__.returnValue);
				break;
		}
		return operation.getPromise();
	};
	// for processing async operation
	// wait for the operation finish and control the deferred respectively
	static chainDeferred = function (deferred) {
		array_push(__.chainedDeferreds, deferred);
	}
}

// helpers

Promise.Resolved = function () {
	var deferred = new Deferred();
	deferred.resolve();
	return deferred.promise;
};
