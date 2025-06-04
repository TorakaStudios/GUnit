/**
* @description This constructor is NOT intended to be called directly. It is created as part of setting up a mock, during is_called_with()
* or is_called_with_any_arguments(). Serves as the parent constructor for GUnitCallMatcher and GUnitUniversalMatcher.
* */
function GUnitMatcher() constructor {
    #region Public methods
    static then_return = function(_return_value) {
        private.return_value = _return_value;
    }
    
    static then_do_nothing = function() {
        private.return_value = undefined;
    }
    
    static get_return_value = function() {
        if (!struct_exists(private, "return_value")) {
            throw new GUnitException("Partial mocking detected! Use \"<MOCK>.when(<FUNCTION_NAME>).is_called_with(<ARGUMENTS_ARRAY>).then_return(<VALUE>);\""
                        + " to define what the mock should do. [No .then... function was used!]");
        }
        
        return private.return_value;
    }
    
    static record_call = function() {
        private.number_of_times_called++;
    }
    
    static get_number_of_times_called = function() {
        return private.number_of_times_called;
    }
    
    static never = function(_message = $"Expected no calls {private.get_expected_arguments_string()} but the function was called {private.number_of_times_called} times!") {
        times(0, _message);
    }
    
    static once = function(_message = $"Expected the function to be called once {private.get_expected_arguments_string()} but it was called {private.number_of_times_called} times!") {
        times(1, _message);
    }
    
    static times = function(_number_of_times_called, _message = $"Expected {_number_of_times_called} calls {private.get_expected_arguments_string()} but the function was called {private.number_of_times_called} times!") {
        gunit().assert_equals(private.number_of_times_called, _number_of_times_called, _message);
    }
    #endregion
    
    #region Private data
    private = {
        number_of_times_called: 0
    }
    #endregion
}