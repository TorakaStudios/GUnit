/**
 * @description A lookalike extension of the default GML error struct. While you would usually call an assert method of GUnitController instead of
 * manually calling this constructor, it may be useful for custom assertion methods. If thrown during a test's execution, it will be caught by GUnit,
 * causing the test to fail and be logged accordingly. See _is_assertion_error's parameter entry.
 * 
 * Usage:
 * throw new GUnitException("The object zigged but we expected it to zag", , true);
 * 
 * @parameter {String}      _message                The message to display in the test log
 * @parameter {String}      _long_message           A longer message with more context. Not used by GUnit, but was defined by GML's error struct.
 * @parameter {Bool}        _is_assertion_error     If false, it is assumed this is a technical error instead of a failed assertion.
 *                                                  i.e. the method under test would crash the game and MUST be fixed.
 *                                                  If true, it was a failed assertion that must still be addressed, but the game wouldn't crash.
 * */
function GUnitException(_message, _long_message = _message, _is_assertion_error = false) constructor {
    var _stacktrace = debug_get_callstack();
    
    message = _message;
    longMessage = _long_message;
    script =  array_first(_stacktrace);
    stacktrace = _stacktrace;
    is_assertion_error = _is_assertion_error;
}