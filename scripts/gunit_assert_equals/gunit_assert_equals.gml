/**
* @description Assert that _actual == _expected. If it is not, the test will fail with the given _message.
* @param    {Any}                       _actual        The actual value produced by your code
* @param    {Any}                       _expected      The expected value to compare against
* @param    {String}                    _message       The message to log if this assertion fails. Default $"Actual {_actual} did not equal expected {_expected}"
* */
function gunit_assert_equals(_actual, _expected, _message = undefined) {
    gunit().assert_equals(_actual, _expected, _message);
}