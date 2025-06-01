function GUnitUniversalMatcher() : GUnitMatcher() constructor {
    #region Public methods
    static matches = function() {
        return true;
    }
    #endregion
    
    #region Private data    
    private.get_expected_arguments_string = function() {
        return "with any arguments";
    }
    #endregion
}