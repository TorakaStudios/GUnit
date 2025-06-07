/**
* @description This constructor is NOT intended to be called directly. It is created as part of setting up a mock, during is_called_with_any_arguments().
* Stores the mocked return value regardless of which arguments were used, and how often the mocked method was called AND NOT MATCHED BY A DIFFERENT MATCHER.
* 
* Note: If you use is_called_with_any_arguments(), it is discouraged to also mock the same method for specific arguments using is_called_with().
* 
* If you do so anyway, understand that the MOST RECENT matcher will be checked first. Always use is_called_with() AFTER is_called_with_any_arguments().
* Otherwise, the universal matcher would match all calls and the argument-specific matcher would never be used.
* */
function GUnitUniversalMatcher() : GUnitMatcher() constructor {
    #region Internal methods
    /**
    * @description NOTE: This method is not meant to be called by you. It is an internal method to check whether this matcher applies to a function call.
    *  My kingdom for access modifiers :<
    * @return    {Bool}                             Always true; This matcher matches all function calls.
    * */
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