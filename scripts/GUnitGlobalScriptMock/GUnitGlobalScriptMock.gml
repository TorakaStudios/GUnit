function GUnitGlobalScriptMock() : GUnitMock() constructor {
    #region Public methods
    static when = function(_function_name) {
        if (!struct_exists(private.original_values, _function_name)) {
            private.store_original_value(_function_name);
            var _mock_function = private.set_up_mock_function(_function_name);
            variable_global_set(_function_name, _mock_function);
        }
        
        return private.get_configuration(_function_name);
    }
    
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