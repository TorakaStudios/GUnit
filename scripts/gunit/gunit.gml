/**
* @description Retrieve the GUnitController. You may call this function any number of times or assign the controller into a variable. You always receive the same singleton controller.
* @return {Struct.GUnitController} The singleton GUnitController instance to use for setting up tests or running assertions
* */
function gunit() {
    static INSTANCE = new GUnitController();
    return INSTANCE;
}