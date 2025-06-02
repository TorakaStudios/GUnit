function GUnitException(_message, _longMessage = _message, _is_assertion_error = false) constructor {
    var _stacktrace = debug_get_callstack();
    
    message = _message;
    longMessage = $"AssertionError: {_message}";
    script =  array_first(_stacktrace);
    stacktrace = _stacktrace;
    is_assertion_error = _is_assertion_error;
}