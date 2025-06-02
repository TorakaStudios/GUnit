/**
* @description Instantiate the given object as by instance_create_depth and return it. The instance will be destroyed for you after the test completes.
*  If you need an instance to exist for each test in a suite, consider calling this function in before_each or instantiating (and destroying) it manually.
* @param    {Asset.GMObject}            _object_index  The asset index to instantiate as per the fourth argument to instance_create_depth
* @param    {Struct}                    _data          A struct containing any additional variables for the instance as per the fifth argument to instance_create_depth
* @param    {Real}                      _x             The instance's x coordinate as per the first argument to instance_create_depth. Default 0
* @param    {Real}                      _y             The instance's y coordinate as per the second argument to instance_create_depth. Default 0
* @param    {Real}                      _depth         The instance's depth as per the third argument to instance_create_depth. Default 0
* @return   {Id.Instance}                              The created instance
* */
function gunit_create_instance(_object_index, _precreate_variables = undefined, _x = undefined, _y = undefined, _depth = undefined) {
    return gunit().create_instance(_object_index, _precreate_variables, _x, _y, _depth);
}