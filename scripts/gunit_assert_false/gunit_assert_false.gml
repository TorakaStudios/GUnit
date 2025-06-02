/**
* @description Assert that _condition is false or some falsy value (0 or a negative number, an empty string, or an undefined reference). If it is truthy, the test will fail with the given _message.
*  This function is equivalent to calling assert_true(!_condition, _message). It is simply a convenience to make reading tests easier.
* @param    {Any}                       _condition     The value that should be falsy
* @param    {String}                    _message       The message to log if this assertion fails. Default $"Expected {_condition} to be false"
* */
function gunit_assert_false(_condition, _message = undefined) {
    gunit().assert_false(_condition, _message);
}