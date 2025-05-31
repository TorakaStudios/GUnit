function GUnitTest(_name, _test_method) constructor {
    #region Public methods
    static get_name = function() {
        return private.name;
    }
    
    static get_test_method = function() {
        return private.test_method;
    }
    
    static pass = function() {
        private.result = TestResult.PASS;
    }
    
    static fail_with_cause = function(_cause) {
        // Do some logic to determine assertion or error
        if (struct_exists(_cause, "is_assertion_error")) {
            private.result = TestResult.ASSERTION_FAILED;
        }
        else {
            private.result = TestResult.ERROR;
        }
        
        private.failure_context = _cause;
    }
    
    static is_passed = function() {
        return private.is_passed();
    }
    
    static is_assertion_failed = function() {
        return private.is_assertion_failed();
    }
    
    static is_error = function() {
        return private.is_error();
    }
    
    static build_result_message = function() {
        return is_passed() ? private.build_passed_message() : private.build_failure_message();
    }
    #endregion
    
    #region Private data
    private = {
        name:  string_copy(_name, 6, string_length(_name) - 5),
        test_method: _test_method,
        result: undefined,
        failure_context: undefined,
        
        is_passed: function() {
            return result == TestResult.PASS;
        },
        
        is_assertion_failed: function() {
            return result == TestResult.ASSERTION_FAILED;
        },
        
        is_error: function() {
            return result == TestResult.ERROR;
        },
        
        build_passed_message: function() {
            return $"Passed {name}";
        },
        
        build_failure_message: function() {
            var _result_string = is_assertion_failed() ? "Failed assertion" : "ERROR";
            return $"{_result_string}\t{name}\t{failure_context.message}\t{string_join_ext("\n", clean_stacktrace(failure_context.stacktrace))}";
        },
        
        clean_stacktrace: function(_stacktrace) {
            var _result = [];
            var _start_index = 0;
            while (string_contains("GUnitController", _stacktrace[_start_index])) {
                _start_index++;
            }
            for (var i = _start_index; i < array_length(_stacktrace) && !string_contains("GUnitTestSuite", _stacktrace[i]); i++) {
                array_push(_result, _stacktrace[i]);
            }
            return _result;
        }
    }
    #endregion
}

enum TestResult {
    PASS,
    ASSERTION_FAILED,
    ERROR
}