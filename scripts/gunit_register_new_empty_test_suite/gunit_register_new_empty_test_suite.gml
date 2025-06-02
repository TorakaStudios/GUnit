/**
* @description Note: It is *highly* recommended you call register_test_suite or register_test_suite_struct instead of this method!
*  Create, register, and return a test suite you will manually populate by calling its add_test, set_before_all, set_before_each,
*  set_after_each, and set_after_all methods.
* @param   {String}                    _name           What the new test suite should be named in the test log.
* @return  {Struct.GUnitTestSuite}                     The created test suite constructor instance.
* */
function register_new_empty_test_suite(_name) {
    return gunit().register_new_empty_test_suite(_name);
}