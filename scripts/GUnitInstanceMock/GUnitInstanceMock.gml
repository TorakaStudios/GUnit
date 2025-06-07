/**
* @description This constructor is NOT intended to be called directly. It is created for you by calling gunit().create_mock().
* */
function GUnitInstanceMock() : GUnitMock() constructor {
    #region Public methods
    /**
     * @description Mock a function with the given _function_name. Remember to define an arguments list and return value as by the examples below.
     *              You must fully mock all functions that will be called on the mock during the test. Consider setting up the mock during
     *              before_each() if the same methods are called the same way in multiple tests.
     *              See the Mocking section of the readme for more information.
     * 
     *              Usage:
     *              var _fuel_tank_mock = gunit().create_mock();
     *              _fuel_tank_mock.when("is_empty").is_called_with_no_arguments().then_return(true);
     *              _fuel_tank_mock.when("fill").is_called_with(5).then_do_nothing();
     * 
     * @parameter       {String}        _function_name      The name of the function to mock.
     * @return          {Struct.GUnitMockConfiguration}
     * */
    static when = function(_function_name) {
        if (!struct_exists(self, _function_name)) {
            var _mock_function = private.set_up_mock_function(_function_name);
            struct_set(self, _function_name, _mock_function);
        }
        
        return private.get_configuration(_function_name);
    }
    
    static pretend_to_be_object_instance = function(_object_index) {
        struct_set(self, "object_index", _object_index);
    }
    #endregion
}