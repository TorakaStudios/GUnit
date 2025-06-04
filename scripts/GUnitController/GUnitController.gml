/**
 * @description The main GUnit controller. This constructor is NOT intended to be called directly. Instead, call gunit() to receive the singleton instance.
 *  This constructor serves as your entry point to GUnit, registering tests and configuration, starting test execution, and running assertions.
 * */
function GUnitController() constructor { 
    #region Public methods
    /**
    * @description Instantiate and register the given test suite object. The object will be introspected, automatically finding methods by name.
    *  These methods must be set during the object's Create event. The name of test methods must start with "test_". Setup methods must be named
    *  *exactly* "before_all", "before_each", "after_each", or "after_all". The object may have other methods which will be ignored, and it may
    *  omit one or more setup methods.
    * 
    * @param    {Asset.GMObject}            _object_index   The asset index of the test suite object to instantiate (such as test_obj_car)
    * @param    {String}                    _name           What the new test suite should be named in the test log. If omitted, the test suite
     *  will be named the same as the object_index's name.
    * @return   {Struct.GUnitController}                    This controller instance for chaining
    * */
    static register_test_suite = function(_object_index, _name = undefined) {
        var _instance = create_instance(_object_index);
        return register_test_suite_struct(_instance, _name);
    }
    
    /**
    * @description Register the given test suite struct. The object will be introspected, automatically finding methods by name.
    *  The name of test methods must start with "test_". Setup methods must be named *exactly* "before_all", "before_each", "after_each", or "after_all".
    *  The struct may have other methods which will be ignored, and it may omit one or more setup methods.
    *  This function can be called using an object instance, but it is highly encouraged to call register_test_suite with its object index instead.
    * 
    * @param    {Asset.GMObject}            _struct         The test suite struct to register
    * @param    {String}                    _name           What the new test suite should be named in the test log. If omitted, the test suite
    *  will be named the same as the object_index's name.
    * @return   {Struct.GUnitController}                    This controller instance for chaining
    * */
    static register_test_suite_struct = function(_struct, _name) {
        array_push(private.test_suites, new GUnitTestSuite(_struct, _name));
        return self;
    }
    
    /**
     * @description Note: It is *highly* recommended you call register_test_suite or register_test_suite_struct instead of this method!
     *  Create, register, and return a test suite you will manually populate by calling its add_test, set_before_all, set_before_each,
     *  set_after_each, and set_after_all methods.
     * 
     * @param   {String}                    _name           What the new test suite should be named in the test log.
     * @return  {Struct.GUnitTestSuite}                     The created test suite constructor instance.
     * */
    static register_new_empty_test_suite = function(_name) {
        var _test_suite = new GUnitTestSuite(noone, _name);
        array_push(private.test_suites, _test_suite);
        return _test_suite;
    }
    
    /**
    * @description Configure GUnit to output test results to a file as well as the debug console. The file will be deleted and recreated on each run.
    * 
    * @param    {String}                    _file_name      The file name to output to. Includes file ending.
    *  It is recommended to end with ".txt", ".log", or a similar text-based ending to be nice to your operating system.
    * @return   {Struct.GUnitController}                    This controller instance for chaining
    * */
    static log_to_file = function(_file_name) {
        private.logging_filename = _file_name;
        return self;
    }
    
    /**
    * @description Create and return a mock struct. The mock can be used in place of "real" instances and structs, returning fixed values when its methods are called.
    *  Use the mock's when method to configure methods with return values.
    *  See the "Mocking" section of the readme as well as GUnitInstanceMock and GUnitMockConfiguration for more information.
    * @return   {Struct.GUnitInstanceMock}                  The created mock
    * */
    static create_mock = function() {
        return new GUnitInstanceMock();
    }
    
    /**
    * @description Retrieve the global script mock controller. This special mock allows you to replace a global script asset with a mocked function returning a fixed value.
    *  NOTE 1: The object being tested MUST call the script asset with a prefix of "global." instead of just its name. E.g. "global.gunit()" instead of "gunit()"
    *  NOTE 2: The original script asset will be put back after every completed test. If you need a script to be mocked for each test in a suite, consider setting it in before_each.
    *  NOTE 3: Built-in functions cannot be mocked. Only script assets in your project can be.
    * @return   {Struct.GUnitGlobalScriptMock}              This controller instance for chaining
    * */
    static get_global_script_mock = function() {
        static GLOBAL_SCRIPT_MOCK = new GUnitGlobalScriptMock();
        return GLOBAL_SCRIPT_MOCK;
    }
    
    /**
    * @description Instantiate the given object as by instance_create_depth and return it. The instance will be destroyed for you after the test completes.
    *  If you need an instance to exist for each test in a suite, consider calling this function in before_each or instantiating (and destroying) it manually.
    * 
    * @param    {Asset.GMObject}            _object_index  The asset index to instantiate as per the fourth argument to instance_create_depth
    * @param    {Struct}                    _data          A struct containing any additional variables for the instance as per the fifth argument to instance_create_depth
    * @param    {Real}                      _x             The instance's x coordinate as per the first argument to instance_create_depth. Default 0
    * @param    {Real}                      _y             The instance's y coordinate as per the second argument to instance_create_depth. Default 0
    * @param    {Real}                      _depth         The instance's depth as per the third argument to instance_create_depth. Default 0
    * @return   {Id.Instance}                              The created instance
    * */
    static create_instance = function(_object_index, _data = {}, _x = 0, _y = 0, _depth = 0) {
        var _instance = instance_create_depth(
            _x,
            _y,
            _depth,
            _object_index,
            _data
        );
        private.add_created_instance(_instance);
        return _instance;
    }
    
    /**
    * @description Execute all registered test suites and output results to the console (and file, if configured).
    *  During test execution, the random seed will be reset just before each test to ensure consistent randomness.
    *  The setup method call order for each test suite is as follows:
    *  before_all
    *  For each test method:
    *       before_each
    *       test method
    *       after_each
    *  after_all
    *  
    *  Any setup methods that aren't defined in a test suite will be skipped.
    * */
    static run = function() {
        var _result_messages = array_create(array_length(private.test_suites));
        for (var i = 0; i < array_length(private.test_suites); i++) {
            var _test_suite = private.test_suites[i];
            _result_messages[i] = _test_suite.run();
        }
        
        var _output = string_join_ext("\n", _result_messages);
        show_debug_message(_output);
        private.log_to_file_if_appropriate(_output);
        private.perform_global_teardown();
    }
    
    /**
    * @description Assert that _actual == _expected. If it is not, the test will fail with the given _message.
    * 
    * @param    {Any}                       _actual        The actual value produced by your code
    * @param    {Any}                       _expected      The expected value to compare against
    * @param    {String}                    _message       The message to log if this assertion fails. Default $"Actual {_actual} did not equal expected {_expected}"
    * */
    static assert_equals = function(_actual, _expected, _message = $"Actual {_actual} did not equal expected {_expected}") {
        assert_true(_actual == _expected, _message);
    }
    
    /**
    * @description Assert that _condition is true or some truthy value (a number above 0, a non-empty string, or a defined reference). If it is not, the test will fail with the given _message.
    *
    * @param    {Any}                       _condition     The value that should be truthy
    * @param    {String}                    _message       The message to log if this assertion fails. Default $"Expected {_condition} to be true"
    * */
    static assert_true = function(_condition, _message = $"Expected {_condition} to be true") {
        private.assert(_condition, _message);
    }
    
    /**
    * @description Assert that _condition is false or some falsy value (0 or a negative number, an empty string, or an undefined reference). If it is truthy, the test will fail with the given _message.
    *  This function is equivalent to calling assert_true(!_condition, _message). It is simply a convenience to make reading tests easier.
    * 
    * @param    {Any}                       _condition     The value that should be falsy
    * @param    {String}                    _message       The message to log if this assertion fails. Default $"Expected {_condition} to be false"
    * */
    static assert_false = function(_condition, _message = $"Expected {_condition} to be false") {
        assert_true(!_condition, _message);
    }
        
    /**
    * @description NOTE: This method is not meant to be called by you. It is an internal method to restore mocked global scripts and destroy any instances created during a test.
    *  My kingdom for access modifiers :<
    * */
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
            
            throw new GUnitException(_message, $"AssertionError: {_message}", true);
        },
    };
    #endregion
}