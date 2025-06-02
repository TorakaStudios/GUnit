/**
* @description Register the given test suite struct. The object will be introspected, automatically finding methods by name.
*  The name of test methods must start with "test_". Setup methods must be named *exactly* "before_all", "before_each", "after_each", or "after_all".
*  The struct may have other methods which will be ignored, and it may omit one or more setup methods.
*  This function can be called using an object instance, but it is highly encouraged to call register_test_suite with its object index instead.
* @param    {Asset.GMObject}            _struct         The test suite struct to register
* @param    {String}                    _name           What the new test suite should be named in the test log. If omitted, the test suite
*  will be named the same as the object_index's name.
* @return   {Struct.GUnitController}                    This controller instance for chaining
* */
function gunit_register_test_suite_struct(_struct, _name) {
    return gunit().register_test_suite_struct(_struct, _name);
}