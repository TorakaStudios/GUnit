/**
* @description Retrieve the global script mock controller. This special mock allows you to replace a global script asset with a mocked function returning a fixed value.
*  NOTE 1: The object being tested MUST call the script asset with a prefix of "global." instead of just its name. E.g. "global.gunit()" instead of "gunit()"
*  NOTE 2: The original script asset will be put back after every completed test. If you need a script to be mocked for each test in a suite, consider setting it in before_each.
*  NOTE 3: Built-in functions cannot be mocked. Only script assets in your project can be.
* @return   {Struct.GUnitGlobalScriptMock}              This controller instance for chaining
* */
function gunit_get_global_script_mock() {
    return gunit().get_global_script_mock();
}