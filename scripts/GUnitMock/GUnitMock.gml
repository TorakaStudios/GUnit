/**
* @description This constructor is NOT intended to be called directly. It is created for you by calling gunit().create_mock() or gunit().get_global_script_mock().
*              Serves as the parent constructor to GUnitInstanceMock and GUnitGlobalScriptMock.
* */
function GUnitMock() constructor {
    #region Public methods
    /**
     * @description Part of the chain to assert the given function was called a certain number of times [with certain arguments].
     *              See the Mocking section of the readme for more information.
     * 
     *              Usage:
     *              var _fuel_tank_mock = gunit().create_mock();
     *              _fuel_tank_mock.when("fill").is_called_with(5, FuelType.UNLEADED).then_do_nothing();
     *              // run some code for stopping at the gas station...
     *              _fuel_tank_mock.assert_that("fill").was_called_with(5, FuelType.UNLEADED).once();
     * 
     * @parameter   {String}    _function_name      The function name to check, as was provided to when(_function_name).
     * @return      {Struct.GUnitMockConfiguration}
     * */
    static assert_that = function(_function_name) {
        return private.get_configuration(_function_name);
    }
    #endregion
    
    #region Private data
    private = {
        configurations: {},
        
        set_up_mock_function: function(_function_name) {  
            var _parent = self;
            return method({function_name: _function_name, parent: _parent}, function() {
                var _sane_argument_array = array_create(argument_count);
                for (var i = 0; i < argument_count; i++) {
                    _sane_argument_array[i] = argument[i];
                }
                return parent.get_configuration(function_name).find_return_value(_sane_argument_array);
            });
        },
        
        set_up_configuration: function(_function_name) {
            var _configuration = new GUnitMockConfiguration();
            struct_set(configurations, _function_name, _configuration);
        },
        
        get_configuration: function(_function_name) {
            if (!struct_exists(configurations, _function_name)) {
                set_up_configuration(_function_name);
            }
            
            return struct_get(configurations, _function_name);
        }
    }
    #endregion
}