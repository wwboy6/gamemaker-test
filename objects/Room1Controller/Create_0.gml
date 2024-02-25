delayOpDatas = [];
function delayOp(_num) {
	_deferred = new Deferred();
	array_push(delayOpDatas, {
		deferred: _deferred,
		num: _num,
	});
	return _deferred.promise;
}
alarm[0] = game_get_speed(gamespeed_fps); // 1 sec

/*
deferred0 = new Deferred();
deferred1 = new Deferred();


deferred0.resolve("000");
deferred1.resolve("111");

show_debug_message(deferred0.returnValue);
*/

/*
show_debug_message(is_instanceof(new Deferred(), Deferred));
show_debug_message(is_instanceof(new Promise(), Promise));
show_debug_message(is_instanceof(new Promise(), Deferred));
*/

function someAsyncOp() {
	return Promise.Resolved().next(function () {
		return delayOp(1);
	})
	.next(function (num) {
		show_debug_message($"1 - {num}");
		return delayOp(num);
	})
	.next(function (num) {
		show_debug_message($"2 - {num}");
		return delayOp(num);
	})
	.next(function (num) {
		show_debug_message($"3 - {num}");
		return $"test {num}";
	})
	.next(function (str) {
		show_debug_message($"final {str}");
	})
	.next(function () {	
		throw new Exception("test error 2");
	});
}

delayOp(1)
	.next(function (num) {
		show_debug_message($"1 - {num}");
		return delayOp(num);
	})
	.next(function (num) {
		show_debug_message($"2 - {num}");
		//return delayOp(num);
		throw new Exception("test error");
	})
	.next(function (num) {
		show_debug_message($"3 - {num}");
		return $"test {num}";
	})
	.next(function (str) {
		show_debug_message($"final {str}");
	})
	.error(function (error) {
		show_debug_message($"err {error.message} {error.stacktrace}");
	})
	//.next(method(self, someAsyncOp))
	.next(function () {
		return someAsyncOp();
	})
	.error(function (error) {
		show_debug_message($"err {error.message} {error.stacktrace}");
	})
