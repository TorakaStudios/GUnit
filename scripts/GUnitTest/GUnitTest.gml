/**
* @description  This constructor is NOT intended to be called or referenced directly. It is used internally by GUnit to collate data about a test case.
*               GUnitTests are created internally during a GUnitTestSuite's introspection or when you call add_test(). Either way, you should not need
*               to retrieve or use a GUnitTest in any way.
* */
function GUnitTest(_name, _test_method) constructor {
    #region Internal methods
    /**
    * @description NOTE: This method is not meant to be called by you. It is an internal method to retrieve this test's name.
    *  My kingdom for access modifiers :<
    * */
    static get_name = function() {
        return private.name;
    }
    
    /**
    * @description NOTE: This method is not meant to be called by you. It is an internal method to retrieve the test function for execution.
    *  My kingdom for access modifiers :<
    * */
    static get_test_method = function() {
        return private.test_method;
    }
    
    /**
    * @description NOTE: This method is not meant to be called by you. It is an internal method to mark the test as successfully passed.
    *  My kingdom for access modifiers :<
    * */
    static pass = function() {
        private.result = TestResult.PASS;
    }
    
    /**
    * @description  NOTE: This method is not meant to be called by you. It is an internal method to mark the test as having failed, either because
    *               an assertion was not met or an error was thrown during execution.
    *  My kingdom for access modifiers :<
    * */
    static fail_with_cause = function(_cause) {
        if (struct_exists(_cause, "is_assertion_error") && _cause.is_assertion_error) {
            private.result = TestResult.ASSERTION_FAILED;
        }
        else {
            private.result = TestResult.ERROR;
        }
        
        private.failure_context = _cause;
    }
    
    /**
    * @description NOTE: This method is not meant to be called by you. It is an internal method to check whether this test passed.
    *  My kingdom for access modifiers :<
    * */
    static is_passed = function() {
        return private.is_passed();
    }
    
    /**
    * @description NOTE: This method is not meant to be called by you. It is an internal method to check whether this test failed due to an assertion.
    *  My kingdom for access modifiers :<
    * */
    static is_assertion_failed = function() {
        return private.is_assertion_failed();
    }
    
    /**
    * @description NOTE: This method is not meant to be called by you. It is an internal method to check whether this test threw a (game-crashing!) error.
    *  My kingdom for access modifiers :<
    * */
    static is_error = function() {
        return private.is_error();
    }
    
    /**
    * @description NOTE: This method is not meant to be called by you. It is an internal method to build the test log entry for this test.
    *  My kingdom for access modifiers :<
    * */
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
            return $"{name}";
        },
        
        build_failure_message: function() {
            return $"{name}\t{failure_context.message}\t{string_join_ext("\n", clean_stacktrace(failure_context.stacktrace))}";
        },
        
        clean_stacktrace: function(_stacktrace) {
            var _result = [];
            var _start_index = 0;
            while (string_pos("GUnit", _stacktrace[_start_index]) != 0) {
                _start_index++;
            }
            for (var i = _start_index; i < array_length(_stacktrace) && string_pos("GUnit", _stacktrace[i]) == 0; i++) {
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