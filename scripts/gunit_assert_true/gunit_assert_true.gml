/**
* @description Assert that _condition is true or some truthy value (a number above 0, a non-empty string, or a defined reference). If it is not, the test will fail with the given _message.
* @param    {Any}                       _condition     The value that should be truthy
* @param    {String}                    _message       The message to log if this assertion fails. Default $"Expected {_condition} to be true"
* */
function gunit_assert_true(_condition, _message = undefined) {
    gunit().assert_true(_condition, _message);
}