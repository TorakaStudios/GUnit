function GUnitController() constructor {
    #region Public methods
    static register_test_suite = function(_object_index) {
        var _test_suite = instance_create_depth(0, 0, 0, _object_index);
        array_push(private.test_suites, new GUnitTestSuite(_test_suite));
        return self;
    }
    
    static run = function() {
        array_foreach(private.test_suites, function(_test_suite, _index) {
            _test_suite.run();
        });
        private.perform_global_teardown();
    }
    
    static assert_equals = function(_actual, _expected, _message = $"Actual {_actual} did not equal expected {_expected}") {
        private.assert(_actual == _expected, _message);
    }
    
    static assert_true = function(_condition, _message = $"Expected {_condition} to be true") {
        private.assert(_condition, _message);
    }
    
    static assert_false = function(_condition, _message = $"Expected {_condition} to be false") {
        assert_true(!_condition, _message);
    }
    #endregion
    
    #region Private variables & methods
    private = {
        starting_random_seed: random_get_seed(),
        test_suites: [],
        
        perform_global_teardown: function() {
            random_set_seed(starting_random_seed);
        },
        
        assert: function(_condition, _message) {
            if (_condition) {
                return;
            }
            
            var _stacktrace = debug_get_callstack();
            throw {
                message: _message,
                longMessage: $"AssertionError: {_message}",
                script: array_first(_stacktrace),
                stacktrace: _stacktrace,
                is_assertion_error: true
            }
        },
    };
    #endregion
    
    #region Global setup
    random_set_seed(57685);
    #endregion
}