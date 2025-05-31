function GUnitTestSuite(_instance) constructor {
    #region "Public" methods
    run = function() {
        call_if_defined(private.before_all);
        array_foreach(private.tests, execute_test);
        call_if_defined(private.after_all);
    }
    
    execute_test = function (_test, _index) {
        call_if_defined(private.before_each);
        try {
            _test();
            show_debug_message("Passed test!");
        } catch (_error) {
            show_debug_message("Failed test: " + _error);
        }
        call_if_defined(private.after_each);
    }
    #endregion
    
    #region Private data
    private = {
        before_all: undefined,
        before_each: undefined,
        tests: [],
        successful_tests: [],
        failed_tests: [],
        error_tests: [],
        after_each: undefined,
        after_all: undefined,
        instance: _instance,
        
        introspect_instance: function() {
            var _names = struct_get_names(instance);
            array_foreach(_names, add_potential_test_setup);
        },
            
        add_potential_test_setup: function(_name, _index) {
            var _value = struct_get(instance, _name);
            
            if (!is_method(_value)) {
                return;
            }
            
            if (string_starts_with(_name, "test_")) {
                array_push(tests, _value);
                return;
            }
            
            switch (_name) {
                case "before_all":
                    before_all = _value;
                    break;
                case "before_each":
                    before_each = _value;
                    break;
                case "after_each":
                    after_each = _value;
                    break;
                case "after_all":
                    after_all = _value;
                    break;
            }
        }
    }
    #endregion
    
    #region Setup
    private.introspect_instance();
    #endregion
}