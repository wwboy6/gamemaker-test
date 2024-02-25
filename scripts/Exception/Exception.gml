function Exception(_message, _longMessage = "") constructor {
	message = _message;
	longMessage = _longMessage == "" ? _message : _longMessage;
	stacktrace = debug_get_callstack();
}
