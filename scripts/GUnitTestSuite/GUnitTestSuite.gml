function GUnitTestSuite(_instance, _name = object_get_name(_instance.object_index)) constructor {
    #region "Public" methods
    run = function() {
        try {
            private.call_if_defined(private.before_all);
        }
        catch (_error) {
            private.error_during_before_all = _error;
            return;
        }
        array_foreach(private.tests, execute_test);
        try {
            private.call_if_defined(private.after_all);
        }
        catch (_error) {
            private.error_during_after_all = _error;
        }
        private.annihilate_instance();
    }
    
    execute_test = function (_test, _index) {
        try {
            private.call_if_defined(private.before_each);
            var _test_method = _test.get_test_method();
            _test_method();
            private.call_if_defined(private.after_each);
            _test.pass();
            array_push(private.passed_tests, _test);
        }
        catch (_error) {
            _test.fail_with_cause(_error);
            var _collection = _test.is_assertion_failed() ? private.failed_tests : private.error_tests;
            array_push(_collection, _test);
        }
        gunit().clean_up_after_test();
    }
    
    build_result_message = function() {
        if (private.error_during_before_all != undefined) {
            return private.build_error_during_before_all_message();
        }
        
        var _number_of_passed = array_length(private.passed_tests);
        var _number_of_failed = array_length(private.failed_tests);
        var _number_of_errors = array_length(private.error_tests);
        var _result = $"Suite test_obj_car: {_number_of_passed} Passed, {_number_of_failed} Failed, {_number_of_errors} Error\n";
        
        if (_number_of_failed > 0 || _number_of_errors > 0) {
            _result += $"{private.build_results_list()}\n";
        }
        
        if (private.error_during_after_all != undefined) {
            _result += $"{private.build_error_during_after_all_message()}\n";
        }
        
        return _result;
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
        name: _name,
        error_during_before_all: undefined,
        error_during_after_all: undefined,
        
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
        
        call_if_defined: function(_function) {
            if (_function != undefined) {
                _function();
            }
        },
        
        annihilate_instance: function() {
            instance_destroy(instance);
            instance = undefined;
        },
        
        build_error_during_before_all_message: function() {
            return $"Suite {name} threw an error during before_all. No tests were run. Cause:\n"
                + format_error(error_during_before_all);
        },
        
        build_results_list: function() {
            return 
                "Passed:\n"
                    + format_test_results(passed_tests)
              + "Failed:\n"
                    + format_test_results(failed_tests)
              + "Error:\n"
                    + format_test_results(error_tests)
            ;
        },
        
        format_test_results: function(_tests) {
            return $"{string_join_ext("\n", array_map(_tests, map_to_result_message))}\n";
        },
        
        map_to_result_message: function(_test, _index) {
            return $"\t{_test.build_result_message()}";
        },
        
        build_error_during_after_all_message: function() {
            return "However, the test suite throw an error during after_all:"
                + format_error(error_during_after_all);
        },
        
        format_error: function(_error) {
            return $"{_error.message}\t{string_join_ext("\n", clean_stacktrace(_error.stacktrace))}";
        },
                
        clean_stacktrace: function(_stacktrace) {
            var _result = [];
            for (var i = 0; i < array_length(_stacktrace); i++) {
                if (string_pos("GUnitTestSuite", _stacktrace[i]) != 0) {
                    break;
                }
                array_push(_result, _stacktrace[i]);
            }
            return _result;
        }
    }
    #endregion
    
    #region Setup
    private.introspect_instance();
    #endregion
}