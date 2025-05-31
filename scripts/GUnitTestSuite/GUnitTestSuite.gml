function GUnitTestSuite(_instance) constructor {
    #region "Public" methods
    run = function() {
        call_if_defined(private.before_all);
        array_foreach(private.tests, execute_test);
        call_if_defined(private.after_all);
        private.annihilate_instance();
    }
    
    execute_test = function (_test, _index) {
        call_if_defined(private.before_each);
        try {
            var _test_method = _test.get_test_method();
            _test_method();
            _test.pass();
        }
        catch (_error) {
            _test.fail_with_cause(_error);
            var _collection = _test.is_assertion_failed() ? private.failed_tests : private.error_tests;
            array_push(_collection, _test);
        }
        show_debug_message(_test.build_result_message());
        call_if_defined(private.after_each);
    }
    #endregion
    
    #region Private data
    private = {
        before_all: undefined,
        before_each: undefined,
        tests: [],
        passed_tests: [],
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
                array_push(tests, new GUnitTest(_name, _value));
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
        },
        
        annihilate_instance: function() {
            instance_destroy(instance);
            instance = undefined;
        },
    }
    #endregion
    
    #region Setup
    private.introspect_instance();
    #endregion
}