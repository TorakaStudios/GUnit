/**
* @description This constructor is NOT intended to be called directly. It is created for you by calling _mock.when(<FUNCTION_NAME>), where _mock
*              is a GUnitMock as returned by gunit().create_mock() or gunit().get_global_script_mock().
* */
function GUnitMockConfiguration() constructor {
    #region Public methods
    /**
    * @description  Catch ALL calls to the mocked function regardless of arguments. Remember to call .then_return(<VALUE>) or .then_do_nothing().
    *               NOTE: If a function is mocked with both a specific argument list and "with any arguments", the MOST RECENT mocking wins.
    *               This means you almost always want to FIRST set up a general mocking with this method, THEN use .is_called_with() to set
    *               a specific argument list. This also applies to .is_called_with_no_arguments().
    * 
    *               See the Mocking section of the readme for more information.
    * 
    *               Usage:
    *               var _fuel_tank_mock = gunit().create_mock();
    *               _fuel_tank_mock.when("fill").is_called_with_any_arguments().then_do_nothing();
    * 
    * @return       {Struct.GUnitUniversalMatcher}
    **/
    static is_called_with_any_arguments = function() {
        return private.add_matcher(new GUnitUniversalMatcher());
    }
    
    /**
     * @description Catch calls to the mocked function with no arguments. This method is an alias to .is_called_with() if passed no arguments.
     *              See the documentation of is_called_with() for more information.
     * @return      {Struct.GUnitCallMatcher}
     **/
    static is_called_with_no_arguments = function() {
        return is_called_with();
    }
    
    /**
     * @description Catch calls to the mocked function with exactly the same number and values of arguments as passed to this method. Remember to call .then_return(<VALUE>) or .then_do_nothing().
     *              Even though this function declares no arguments, you may pass any number of arguments just as if you were calling the real function.
     *              GUnit will collect the arguments internally. Do NOT pass them inside an array (unless the function takes an array as an argument, of course.)
     *
     *              Note that the arguments passed to this function and to the actual function call must exactly match. There must be the same number
     *              of arguments and they must have exactly the same value, such that _expected_argument == _actual_argument. In the case of reference
     *              values (arrays, structs, instances, ...), this means the same array, struct, or instance.
     * 
     *              This function may be called multiple times to set up multiple argument lists. You must do so for each expected argument list, or
     *              use is_called_with_any_arguments() if the arguments don't actually matter and you always want the same return value (or to do nothing).
     *              If you set up the same argument list multiple times, the MOST RECENT mocking set up will win.
     * 
     *               See the Mocking section of the readme for more information.
     * 
     *               Usage:
     *               var _fuel_tank_mock = gunit().create_mock();
     *               _fuel_tank_mock.when("fill").is_called_with(5, FuelType.UNLEADED).then_do_nothing();
     * 
     * @parameter       {Any}       ...     If any arguments should be checked, pass them to this function as you would to the function being mocked.
     * @return          {Struct.GUnitCallMatcher}
     **/
    static is_called_with = function() {
        var _sane_argument_array = array_create(argument_count);
        for (var i = 0; i < argument_count; i++) {
            _sane_argument_array[i] = argument[i];
        }
        return private.add_matcher(new GUnitCallMatcher(_sane_argument_array))
    }
    
    /**
     * @description Set up to assert that the mocked function was called with no arguments a certain number of times. This method is an alias to
     *              was_called_with() if passed no arguments. See the documentation of was_called_with() for more information.
     * @return          {Struct.GUnitCallMatcher}
     **/
    static was_called_with_no_arguments = function() {
        return was_called_with();
    }
    
    /**
     * @description Set up to assert that the mocked function was called with the provided arguments a certain number of times. See is_called_with()
     *              for more information on how the method should be mocked. It MUST be mocked first to collect method calls.
     *              THIS METHOD DOES NOT ASSERT ANYTHING BY ITSELF. You MUST call .never(), .once(), or .times(_number_of_times_called) to assert.
     * 
     *              Note: If the same function is mocked with the same argument list multiple times, the number of method calls is reset each time.
     *              In this case, you should assert the number of calls before mocking the function a second time. This only applies if the argument
     *              list used for both mockings is the exact same.
     * 
     *              Usage:
     *              var _fuel_tank_mock = gunit().create_mock();
     *              _fuel_tank_mock.when("fill").is_called_with(5, FuelType.UNLEADED).then_do_nothing();
     *              // run some code for stopping at the gas station...
     *              _fuel_tank_mock.assert_that("fill").was_called_with(5, FuelType.UNLEADED).once();
     * 
     * @parameter       {Any}       ...     If any arguments should be checked, pass them to this function as you would to the function being mocked.
     * @return          {Struct.GUnitCallMatcher}
     **/
    static was_called_with = function() {
        var _sane_argument_array = array_create(argument_count);
        for (var i = 0; i < argument_count; i++) {
            _sane_argument_array[i] = argument[i];
        }
        var _matcher = private.find_matcher_for_arguments(_sane_argument_array);
        if (_matcher == noone) {
            throw new GUnitException($"The function was never mocked for arguments {_sane_argument_array}! Use \"<MOCK>.when(<FUNCTION_NAME>).is_called_with(<ARGUMENTS_ARRAY>).then_return(<VALUE>);\""
                + " to define what the mock should do. If it shouldn't do anything, use .then_do_nothing() instead of .then_return().  [No .is_called_with... function was used!]");
        }
        return _matcher;
    }
    
    /**
     * @description Assert that the mocked function was never called with any arguments.
     * 
     *              Usage:
     *              var _fuel_tank_mock = gunit().create_mock();
     *              _fuel_tank_mock.when("explode").is_called_with(ExplosionType.VIOLENTLY).then_do_nothing();
     *              // run some code for safe driving...
     *              _fuel_tank_mock.assert_that("explode").was_never_called("Exploded despite safe driving 3:");
     * 
     * @parameter       {String}    _message    The message to log if this assertion fails. Default $"Expected no calls with any arguments but the function was called {number_of_calls} times!"
     **/
    static was_never_called = function(_message = $"Expected no calls with any arguments but the function was called {private.determine_total_number_of_calls()} times!") {
        was_called_times_with_any_arguments(0, _message);
    }
    
    /**
    * @description Assert that the mocked function was called exactly once with any arguments. This assertion fails if the function was never called,
    *              or if the function was called more than once.
    * 
    *              Usage:
    *              var _fuel_tank_mock = gunit().create_mock();
    *              _fuel_tank_mock.when("explode").is_called_with_any_arguments().then_do_nothing();
    *              // run some code for some sick wheelies...
    *              _fuel_tank_mock.assert_that("explode").was_called_once_with_any_arguments("Exploded more than a little bit, or not at all 3:");
    * 
    * @parameter       {String}    _message    The message to log if this assertion fails. Default $"Expected the function to be called once with any arguments but the function was called {number_of_calls} times!"
    **/
    static was_called_once_with_any_arguments = function(_message = $"Expected the function to be called once with any arguments but it was called {private.determine_total_number_of_calls()} times!") {
        was_called_times_with_any_arguments(1, _message);
    }
    
    /**
    * @description Assert that the mocked function was called exactly _calls times with any arguments.
    * 
    *              Usage:
    *              var _fuel_tank_mock = gunit().create_mock();
    *              _fuel_tank_mock.when("explode").is_called_with_any_arguments().then_do_nothing();
    *              // run some code for jumping through a flaming hoop onto a springboard while playing a lead guitar with your teeth...
    *              _fuel_tank_mock.assert_that("explode").was_called_times_with_any_arguments(3, "Didn't explode the right number of times 3:");
    * 
    * @parameter       {Real}      _calls      The number of times we expect the mocked function to be called.
    * @parameter       {String}    _message    The message to log if this assertion fails. Default $"Expected {_calls} with any arguments but the function was called {number_of_calls} times!"
    **/
    static was_called_times_with_any_arguments = function(_calls, _message = $"Expected {_calls} calls with any arguments but the function was called {private.determine_total_number_of_calls()} times!") {
        gunit().assert_equals(private.determine_total_number_of_calls(), _calls, _message);
    }
    #endregion
    
    #region Internal methods
    /**
    * @description NOTE: This method is not meant to be called by you. It is an internal method to track how often this specific mock path was used.
    *  My kingdom for access modifiers :<
    * */
    static find_return_value = function(_arguments) {
        var _matcher = private.find_matcher_for_arguments(_arguments);
        if (_matcher == noone) {
            throw new GUnitException($"The function was never mocked for arguments {_arguments}! Use \"<MOCK>.when(<FUNCTION_NAME>).is_called_with(<ARGUMENTS_ARRAY>).then_return(<VALUE>);\""
                + " to define what the mock should do. [No .is_called_with... function was used!]");
        }
        _matcher.record_call();
        return _matcher.get_return_value();
    }
    #endregion
    
    #region Private data
    private = {
        matchers: [],
        
        add_matcher: function(_matcher) {
            array_insert(matchers, 0, _matcher);
            return _matcher;
        },
        
        /**
         * @return {Struct.GUnitMatcher}
         * */
        find_matcher_for_arguments: function(_arguments) {
            for (var i = 0; i < array_length(matchers); i++) {
                var _matcher = matchers[i];
                if (_matcher.matches(_arguments)) {
                    return _matcher;
                }
            }
            return noone;
        },
        
        determine_total_number_of_calls: function() {
            return array_reduce(matchers, function(_sum, _matcher, _index) {
                return _sum + _matcher.get_number_of_times_called();
            }, 0);
        }
    }
    #endregion
}