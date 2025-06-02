function GUnitTestSuite(_instance, _name = "") constructor {
    if (_name == "" && struct_exists(_instance, "object_index")) {
        _name = object_get_name(_instance.object_index);
    }
    
    #region Public methods
    /**
     * @description Add a function to be executed during the test run. This function is usually called by the framework, but is provided
     * in case you want to manually set up a test suite created with gunit().register_new_empty_test_suite(_name).
     * Note: Test functions should function the same no matter what order they are executed, i.e. no outside variables should be relied upon.
     * See the Test Setup section of the readme.
     * @parameter   {String}            _name           The test's name in the log. May be any string, but it's usually best to use the method's name.
     * @parameter   {Function}          _test_function  The test function to execute. Remember to provide the reference WITHOUT parentheses ()!
     * @return      {Struct.GUnitTestSuite}             This instance for chaining.
     * */
    static add_test = function(_name, _test_function) {
        private.add_test(_name, _test_function);
        return self;
    }
    
    /**
     * @description Define the function to be executed ONCE before any tests in this suite are run. This function is usually called by the framework, but is provided
     * in case you want to manually set up a test suite created with gunit().register_new_empty_test_suite(_name).
     * @parameter   {Function}          _function       The function to execute. Will be called ONCE, before ANY tests or the before_each function.
     * @return      {Struct.GUnitTestSuite}             This instance for chaining.
     * */
    static set_before_all = function(_function) {
        private.set_before_all(_function);
        return self;
    }
    
    /**
     * @description Define the function to be executed before each test in this suite. This function is usually called by the framework, but is provided
     * in case you want to manually set up a test suite created with gunit().register_new_empty_test_suite(_name).
     * @parameter   {Function}          _function       The function to execute. Will be called for each test, just before the test is run. 
     * @return      {Struct.GUnitTestSuite}             This instance for chaining.
     * */
    static set_before_each = function(_function) {
        private.set_before_each(_function);
        return self;
    }
    
    /**
    * @description Define the function to be executed after each test in this suite. If the test fails or throws an error, after_each will still
    * be executed. This function is usually called by the framework, but is provided in case you want to manually set up a test suite 
    * created with gunit().register_new_empty_test_suite(_name).
    * @parameter   {Function}          _function       The function to execute. Will be called for each test, just after the test is run.
    * @return      {Struct.GUnitTestSuite}             This instance for chaining.
    * */
    static set_after_each = function(_function) {
        private.set_after_each(_function);
        return self;
    }
    
    /**
    * @description Define the function to be executed ONCE after all tests in this suite. This function is usually called by the framework, but is provided
    * in case you want to manually set up a test suite created with gunit().register_new_empty_test_suite(_name).
    * @parameter   {Function}          _function       The function to execute. Will be called ONCE, after all tests and the after_each function.
    * @return      {Struct.GUnitTestSuite}             This instance for chaining.
    * */
    static set_after_all = function(_function) {
        private.set_after_all(_function);
        return self;
    }
    
    /**
     * @description NOTE: This method is not meant to be called by you. It is an internal method to start test execution for this suite.
     * Instead call gunit().run() or gunit_run() to execute all test suites and properly display results.
     *  My kingdom for access modifiers :<
     * @return     {String}                            The formatted results log entry
     * */
    static run = function() {
        try {
            private.call_if_defined(private.before_all);
        }
        catch (_error) {
            private.error_during_before_all = _error;
            return;
        }
        array_foreach(private.tests, private.execute_test);
        try {
            private.call_if_defined(private.after_all);
        }
        catch (_error) {
            private.error_during_after_all = _error;
        }
        private.annihilate_instance();
        return private.build_result_message();
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
                add_test(_name, _value);
                return;
            }
            
            switch (_name) {
                case "before_all":
                    set_before_all(_value);
                    break;
                case "before_each":
                    set_before_each(_value);
                    break;
                case "after_each":
                    set_after_each(_value);
                    break;
                case "after_all":
                    set_after_all(_value);
                    break;
                default:
                    break;
            }
        },
        
        add_test: function(_name, _function) {
            array_push(tests, new GUnitTest(_name, _function));
        },
                
        set_before_all: function(_function) {
            before_all = _function;
        },
        
        set_before_each: function(_function) {
            before_each = _function;
        },
        
        set_after_each: function(_function) {
            after_each = _function;
        },
        
        set_after_all: function(_function) {
            after_all = _function;
        },
        
        call_if_defined: function(_function) {
            if (_function != undefined) {
                _function();
            }
        },
        
        execute_test: function (_test, _index) {
            try {
                random_set_seed(57685);
                call_if_defined(before_each);
                var _test_method = _test.get_test_method();
                _test_method();
                _test.pass();
                array_push(passed_tests, _test);
            }
            catch (_error) {
                _test.fail_with_cause(_error);
                var _collection = _test.is_assertion_failed() ? failed_tests : error_tests;
                array_push(_collection, _test);
            }
            call_if_defined(after_each);
            gunit().clean_up_after_test();
        },
        
        build_result_message: function() {
            if (error_during_before_all != undefined) {
                return build_error_during_before_all_message();
            }
            
            var _number_of_passed = array_length(passed_tests);
            var _number_of_failed = array_length(failed_tests);
            var _number_of_errors = array_length(error_tests);
            var _result = $"{name != "" ? $"Suite {name}: " : ""}{_number_of_passed} Passed, {_number_of_failed} Failed, {_number_of_errors} Error\n";
            
            if (_number_of_failed > 0 || _number_of_errors > 0) {
                _result += $"{build_results_list()}\n";
            }
            
            if (error_during_after_all != undefined) {
                _result += $"{build_error_during_after_all_message()}\n";
            }
            
            return _result;
        },
        
        annihilate_instance: function() {
            if (instance_exists(instance) && struct_exists(instance, "object_index")) {
                instance_destroy(instance);
            }
            instance = undefined;
        },
        
        build_error_during_before_all_message: function() {
            return $"{name != "" ? $"Suite {name}" : "The suite"} threw an error during before_all. No tests were run. Cause:\n"
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