/**
* @description This constructor is NOT intended to be called directly. It is created as part of setting up a mock, during is_called_with()
* or is_called_with_any_arguments(). Serves as the parent constructor for GUnitCallMatcher and GUnitUniversalMatcher.
* */
function GUnitMatcher() constructor {
    #region Public methods
    
    /**
     * @description Define the value to be returned by the mocked function (for the given arguments).
     *              Remember that reference values (structs, instances, arrays, ...) that are modified after being passed to this method WILL reflect
     *              those modifications when being returned. It is best not to modify them so that your test remains cleanly legible.
     * 
     *              Usage:
     *              var _fuel_tank_mock = gunit().create_mock();
     *              _fuel_tank_mock.when("is_empty").is_called_with_no_arguments().then_return(true);
     * 
     * @parameter       {Any}       _return_value       The value to return.
     * */
    static then_return = function(_return_value) {
        private.return_value = _return_value;
    }
    
    /**
     * @description Define that this mocked function shouldn't return anything meaningful. This method MUST be called even if the original function
     *              doesn't return anything or you don't use the return value. Otherwise, GUnit will assume you forgot to define the return value
     *              and fail the test.
     * 
     *              Note: In GML, functions that don't return anything technically still return undefined. Consequently, so will the mocked method.
     * 
     *              Usage:
     *              var _fuel_tank_mock = gunit().create_mock();
     *              _fuel_tank_mock.when("explode").is_called_with_no_arguments().then_do_nothing();
     * */
    static then_do_nothing = function() {
        private.return_value = undefined;
    }
    
    /**
     * @description Assert that the mocked function was never called with these arguments. If the same function was mocked with different arguments,
     *              or "with any arguments", those calls are NOT counted and the assertion still passes!
     * 
     * @parameter       {String}    _message        The message to output into the test log if this assertion fails.
     *                                              Default $"Expected no calls with arguments [<ARGUMENT>, <ARGUMENT>, ...] but the function was called {number_of_times_called} times!"
     * */
    static never = function(_message = $"Expected no calls {private.get_expected_arguments_string()} but the function was called {private.number_of_times_called} times!") {
        times(0, _message);
    }
    
    /**
    * @description Assert that the mocked function was called exactly once with these arguments. If the same function was mocked with different arguments,
    *              or "with any arguments", those calls are NOT counted and the assertion may pass or fail unexpectedly.
    * 
    * @parameter        {String}    _message        The message to output into the test log if this assertion fails.
    *                                              Default $"Expected the function to be called once with arguments [<ARGUMENT>, <ARGUMENT>, ...] but the function was called {number_of_times_called} times!"
    * */
    static once = function(_message = $"Expected the function to be called once {private.get_expected_arguments_string()} but it was called {private.number_of_times_called} times!") {
        times(1, _message);
    }
    
    /**
    * @description Assert that the mocked function was called exactly _number_of_times_called with these arguments. If the same function was mocked with different arguments,
    *              or "with any arguments", those calls are NOT counted and the assertion may pass or fail unexpectedly.
    * 
    * @parameter        {Real}      _number_of_times_called The expected number of times the function was called WITH THESE ARGUMENTS
    * @parameter        {String}    _message                The message to output into the test log if this assertion fails.
    *                                                       Default $"Expected {_number_of_times_called} calls with arguments [<ARGUMENT>, <ARGUMENT>, ...] but the function was called {actual_number_of_times_called} times!"
    * */
    static times = function(_number_of_times_called, _message = $"Expected {_number_of_times_called} calls {private.get_expected_arguments_string()} but the function was called {private.number_of_times_called} times!") {
        gunit().assert_equals(private.number_of_times_called, _number_of_times_called, _message);
    }
    #endregion
    
    #region Internal methods
    /**
    * @description NOTE: This method is not meant to be called by you. It is an internal method to retrieve the mocked return value, throwing an error if none was defined.
    *  My kingdom for access modifiers :<
    * @return           {Any}
    * */
    static get_return_value = function() {
        if (!struct_exists(private, "return_value")) {
            throw new GUnitException("Partial mocking detected! Use \"<MOCK>.when(<FUNCTION_NAME>).is_called_with(<ARGUMENTS_ARRAY>).then_return(<VALUE>);\""
                        + " to define what the mock should do. [No .then... function was used!]");
        }
        
        return private.return_value;
    }

    /**
    * @description NOTE: This method is not meant to be called by you. It is an internal method to track how often this specific mock path was used.
    *  My kingdom for access modifiers :<
    * */
    static record_call = function() {
        private.number_of_times_called++;
    }
    
    /**
    * @description NOTE: This method is not meant to be called by you. It is an internal method to retrieve how often this specific mock path was used.
     *              Instead use never(), once(), or times(_number_of_calls) to assert the method was called that often with these arguments.
    *  My kingdom for access modifiers :<
    * */
    static get_number_of_times_called = function() {
        return private.number_of_times_called;
    }
    #endregion
    
    #region Private data
    private = {
        number_of_times_called: 0
    }
    #endregion
}