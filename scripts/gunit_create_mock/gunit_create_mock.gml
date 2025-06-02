/**
* @description Create and return a mock struct. The mock can be used in place of "real" instances and structs, returning fixed values when its methods are called.
*  Use the mock's when method to configure methods with return values.
*  See the "Mocking" section of the readme as well as GUnitInstanceMock and GUnitMockConfiguration for more information.
* @return   {Struct.GUnitInstanceMock}                  The created mock
* */
function gunit_create_mock() {
    return gunit().create_mock();
}