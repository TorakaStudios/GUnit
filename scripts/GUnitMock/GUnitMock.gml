function GUnitMock() constructor {
    #region Public methods
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