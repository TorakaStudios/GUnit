/**
 * @description This constructor is NOT intended to be called directly. It is created as part of setting up a mock, during is_called_with().
 * Stores the mocked return value for a given array of expected arguments, and how often the mocked method was called with those arguments.
 * 
 * @parameter {Array.Any}   _expected_arguments     The exact array of arguments that should be mocked. NOTE: GameMaker still fills in arguments
 *                                                  that were not provided, using undefined if they have no default value. These arguments must also
 *                                                  be specified during mocking, using their default value or undefined as appropriate.
 * */
function GUnitCallMatcher(_expected_arguments) : GUnitMatcher() constructor {
    #region Public methods
    /**
    * @description NOTE: This method is not meant to be called by you. It is an internal method to check whether this matcher applies to a function call.
    *  My kingdom for access modifiers :<
    * 
    * @parameter {Array.Any}    _argument_array     The actual arguments provided. Will be populated by GUnit using the argument pseudo-array
    * @return    {Bool}                             true if an equal number of arguments was expected and provided, and each element in both arrays is equal.
    * */
    static matches = function(_argument_array) { 
        if (array_length(private.expected_arguments) != array_length(_argument_array)) {
            return false;
        }
        
        for (var i = 0; i < array_length(_argument_array); i++) {
            if (private.expected_arguments[i] != _argument_array[i]) {
                return false;
            }
        }
        
        return true;
    }
    #endregion
    
    #region Private data
    private.expected_arguments = _expected_arguments
    
    private.get_expected_arguments_string = function() {
        return $"with arguments {private.expected_arguments}";
    }
    #endregion
}