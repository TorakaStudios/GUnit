/**
* @description Instantiate and register the given test suite object. The object will be introspected, automatically finding methods by name.
*  These methods must be set during the object's Create event. The name of test methods must start with "test_". Setup methods must be named
*  *exactly* "before_all", "before_each", "after_each", or "after_all". The object may have other methods which will be ignored, and it may
*  omit one or more setup methods.
* @param    {Asset.GMObject}            _object_index   The asset index of the test suite object to instantiate (such as test_obj_car)
* @param    {String}                    _name           What the new test suite should be named in the test log. If omitted, the test suite
*  will be named the same as the object_index's name.
* @return   {Struct.GUnitController}                    This controller instance for chaining
* */
function gunit_register_test_suite(_object_index) {
    return gunit().register_test_suite(_object_index);
}