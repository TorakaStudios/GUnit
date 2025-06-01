function GUnitController() constructor {
    #region Public methods
    static register_test_suite = function(_object_index) {
        var _test_suite = instance_create_depth(0, 0, 0, _object_index);
        array_push(private.test_suites, new GUnitTestSuite(_test_suite));
        return self;
    }
    
    static log_to_file = function(_file_name) {
        private.logging_filename = _file_name;
        return self;
    }
     
    static create_mock = function() {
        return new GUnitInstanceMock();
    }
    
    static get_global_script_mock = function() {
        static GLOBAL_SCRIPT_MOCK = new GUnitGlobalScriptMock();
        return GLOBAL_SCRIPT_MOCK;
    }
    
    static create_instance = function(_object_index, _precreate_variables = {}, _x = 0, _y = 0, _depth = 0) {
        var _instance = instance_create_depth(
            _x,
            _y,
            _depth,
            _object_index,
            _precreate_variables
        );
        private.add_created_instance(_instance);
        return _instance;
    }
    
    static run = function() {
        random_set_seed(57685);
        
        var _result_messages = array_create(array_length(private.test_suites));
        for (var i = 0; i < array_length(private.test_suites); i++) {
            var _test_suite = private.test_suites[i];
            _test_suite.run();
            _result_messages[i] = _test_suite.build_result_message();
        }
        
        var _output = string_join_ext("\n", _result_messages);
        show_debug_message(_output);
        private.log_to_file_if_appropriate(_output);
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
    
    static clean_up_after_test = function() {
        get_global_script_mock().restore_original_values();
        private.annihilate_all_created_instances();
    }
    #endregion
    
    #region Private variables & methods
    private = {
        starting_random_seed: random_get_seed(),
        logging_filename: undefined,
        test_suites: [],
        created_instances: [],
        
        perform_global_teardown: function() {
            random_set_seed(starting_random_seed);
        },
        
        add_created_instance: function(_instance) {
            array_push(created_instances, _instance);
        },
        
        annihilate_all_created_instances: function() {
            array_foreach(created_instances, function(_element, _index) {
                instance_destroy(_element);
            });
            if (array_length(created_instances) != 0) {
                created_instances = [];
            }
        },
        
        log_to_file_if_appropriate: function(_output) {
            if (logging_filename == undefined) {
                return;
            }
            
            if (file_exists(logging_filename)) {
                file_delete(logging_filename);
            }
            var _fileid = file_text_open_write(logging_filename);
            file_text_write_string(_fileid, _output);
            file_text_close(_fileid);
        },
        
        assert: function(_condition, _message) {
            if (_condition) {
                return;
            }
            
            throw new GUnitControllerException(_message, $"AssertionError: {_message}", true);
        },
    };
    #endregion
}