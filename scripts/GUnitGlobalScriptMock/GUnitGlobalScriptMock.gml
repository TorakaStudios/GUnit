/**
* @description This constructor is NOT intended to be called directly. It is provided for you by calling gunit().get_global_script_mock().
* */
function GUnitGlobalScriptMock() : GUnitMock() constructor {
    #region Public methods
    /**
    * @description Mock a global script with the given _function_name. Remember to define an arguments list and return value as by the examples below.
    *              NOTE: You MUST change your code to call the script from the global struct. Otherwise, the mock will not be able to replace the script properly.
    *              Example: Instead of "gunit_get_global_script_mock();", call "global.gunit_get_global_script_mock();"
    *              Your code will function the same way. Using the "global." prefix avoids a GML compiler optimisation that would prevent mocking.
    * 
    *              NOTE 2: Global script mocks will be automatically undone at the end of each test's execution. If you want a script to be mocked
    *              the same way during multiple tests, consider mocking it during that suite's before_each method.
    *              See the Mocking section of the readme for more information.
    * 
    *              Usage:
    *              gunit().get_global_script_mock().when("gunit_example_describe").is_called_with("car").then_return(_expected);
    * 
    * @parameter       {String}        _function_name      The name of the function to mock.
    * @return          {Struct.GUnitMockConfiguration}
    * */
    static when = function(_function_name) {
        if (!struct_exists(private.original_values, _function_name)) {
            private.store_original_value(_function_name);
            var _mock_function = private.set_up_mock_function(_function_name);
            variable_global_set(_function_name, _mock_function);
        }
        
        return private.get_configuration(_function_name);
    }
    #endregion
    
    #region Internal methods
    /**
    * @description NOTE: This method is not meant to be called by you. It is an internal method to undo global script mocks after each test execution.
    *  My kingdom for access modifiers :<
    * */
    static restore_original_values = function() {
        var _function_names = struct_get_names(private.original_values);
        if (array_length(_function_names == 0)) {
            return;
        }
        for (var i = 0; i < array_length(_function_names); i++) {
            var _function_name = _function_names[i];
            variable_global_set(_function_name, struct_get(private.original_values, _function_name));
        }
        private.original_values = {};
    }
    #endregion
    
    #region Private data
    private.original_values = {};
    
    private.store_original_value = function(_function_name) {
        if (!variable_global_exists(_function_name)) {
            throw new GUnitException($"Tried to mock global function {_function_name} which does not exist!");
        }
        var _original_value = variable_global_get(_function_name);
        struct_set(private.original_values, _function_name, _original_value);
    };
    #endregion 
}