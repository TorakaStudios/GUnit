function GUnitMockConfiguration() constructor {
    #region Public methods
    static is_called_with_any_arguments = function() {
        return private.add_matcher(new GUnitUniversalMatcher());
    }
    
    static is_called_with_no_arguments = function() {
        return is_called_with();
    }
    
    static is_called_with = function() {
        var _sane_argument_array = array_create(argument_count);
        for (var i = 0; i < argument_count; i++) {
            _sane_argument_array[i] = argument[i];
        }
        return private.add_matcher(new GUnitCallMatcher(_sane_argument_array))
    }
    
    static find_return_value = function(_arguments) {
        var _matcher = private.find_matcher_for_arguments(_arguments);
        if (_matcher == noone) {
            throw new GUnitControllerException($"The function was never mocked for arguments {_arguments}! Use \"<MOCK>.when(<FUNCTION_NAME>).is_called_with(<ARGUMENTS_ARRAY>).then_return(<VALUE>);\""
                + " to define what the mock should do. [No .is_called_with... function was used!]");
        }
        _matcher.record_call();
        return _matcher.get_return_value();
    }
    
    static was_called_with = function() {
        var _sane_argument_array = array_create(argument_count);
        for (var i = 0; i < argument_count; i++) {
            _sane_argument_array[i] = argument[i];
        }
        var _matcher = private.find_matcher_for_arguments(_sane_argument_array);
        if (_matcher == noone) {
            throw new GUnitControllerException($"The function was never mocked for arguments {_sane_argument_array}! Use \"<MOCK>.when(<FUNCTION_NAME>).is_called_with(<ARGUMENTS_ARRAY>).then_return(<VALUE>);\""
                + " to define what the mock should do. If it shouldn't do anything, use .then_do_nothing() instead of .then_return().  [No .is_called_with... function was used!]");
        }
        return _matcher;
    }
        
    static was_never_called = function(_message = $"Expected no calls with any arguments but the function was called {private.determine_total_number_of_calls()} times!") {
        times(0, _message);
    }
    
    static was_called_once_with_any_arguments = function(_message = $"Expected the function to be called once with any arguments but it was called {private.determine_total_number_of_calls()} times!") {
        times(1, _message);
    }
    
    static times = function(_number_of_total_times_called, _message = $"Expected {_number_of_total_times_called} calls with any arguments but the function was called {private.determine_total_number_of_calls()} times!") {
        gunit().assert_equals(private.determine_total_number_of_calls(), _number_of_total_times_called, _message);
    }
    #endregion
    
    #region Private data
    private = {
        matchers: [],
        
        add_matcher: function(_matcher) {
            array_insert(matchers, 0, _matcher);
            return _matcher;
        },
        
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