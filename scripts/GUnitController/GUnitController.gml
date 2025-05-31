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
        if (_actual != _expected) {
            throw ($"AssertionError: {_message}");
        }
    }
    #endregion
    
    #region Private variables & methods
    private = {
        starting_random_seed: random_get_seed(),
        test_suites: [],
        
        perform_global_teardown: function() {
            random_set_seed(starting_random_seed);
        }
    };
    #endregion
    
    #region Global setup
    random_set_seed(57685);
    #endregion
}