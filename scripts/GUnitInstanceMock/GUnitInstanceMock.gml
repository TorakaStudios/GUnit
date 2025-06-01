function GUnitInstanceMock() : GUnitMock() constructor {
    #region Public methods
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