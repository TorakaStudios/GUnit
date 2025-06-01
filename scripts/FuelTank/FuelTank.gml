function FuelTank() constructor {
    #region Public methods    
    static fill = function(_amount) {
        private.contained_fuel += _amount;
    }
    
    static consume = function(_amount) {
        private.contained_fuel -= _amount;
    }
    
    static is_empty = function() {
        return private.contained_fuel == 0;
    }
    #endregion
    
    #region Private data
    private = {
        contained_fuel: 0
    }
    #endregion
}