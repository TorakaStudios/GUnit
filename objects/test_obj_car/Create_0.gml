before_all = function() {
    // This function is called ONCE, before before_each is called and before any tests are executed
}

before_each = function() {
    // This function is called before each test's execution
}

after_each = function() {
    // This function is called after each test's execution
}

after_all = function() {
    // This function is called ONCE, after ALL tests are executed and after after_each is called for the final time.
}

test_goes_vroom_vroom = function() {
    // Arrange
    var _testee = gunit().create_instance(obj_car);
    
    // Act
    var _result = _testee.make_noise();
    
    // Assert
    var _expected = "Vroom vroom";
    gunit().assert_equals(_result, _expected, "Did not make the correct noise 3:");
}

test_cant_drive_with_empty_tank = function() {
    // Arrange
    var _fuel_tank_mock = gunit().create_mock();
    _fuel_tank_mock.when("is_empty").is_called_with_no_arguments().then_return(true);
    var _testee = gunit().create_instance(obj_car, {
         fuel_tank: _fuel_tank_mock
    });
    
    // Act
    var _result = _testee.can_drive();
    
    // Assert
    gunit().assert_false(_result);
    _fuel_tank_mock.assert_that("is_empty").was_called_once_with_any_arguments();
}

test_can_drive_with_fuel_in_tank = function() {
    // Arrange
    var _fuel_tank_mock = gunit().create_mock();
    _fuel_tank_mock.when("is_empty").is_called_with_no_arguments().then_return(false);
    var _testee = gunit().create_instance(obj_car, {
        fuel_tank: _fuel_tank_mock
    });
        
    // Act
    var _result = _testee.can_drive();
    
    // Assert
    gunit().assert_true(_result);
}

test_fails_gracefully_on_error = function() {
    show_debug_message(non_existent_value);
}

test_failed_assertion = function() {
    gunit().assert_true(false);
}

test_describe_self_says_car_go_car = function() {
    // Arrange
    var _expected = "Car go car";
    var _testee = gunit().create_instance(obj_car);
    gunit().get_global_script_mock().when("gunit_example_describe").is_called_with("car").then_return(_expected);
    
    // Act
    var _result = _testee.describe_self();
    
    // Assert
    gunit().assert_equals(_result, _expected, "Cars don't go like that!");
}