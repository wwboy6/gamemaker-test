var datas = [];
var _len = array_length(delayOpDatas);
//show_debug_message($"_len {_len}");
array_copy(datas, 0, delayOpDatas, 0, _len);
delayOpDatas = [];

array_foreach(datas, function (data) {
	data.deferred.resolve(data.num * 2);
});

alarm[0] = game_get_speed(gamespeed_fps); // 1 sec
