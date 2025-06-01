function GUnitCallMatcher(_expected_arguments) : GUnitMatcher() constructor {
    #region Public methods
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