test_speed = 9;

before_all = function() {
    show_debug_message("Ran before_all!");
}

before_each = function() {
    show_debug_message("Ran before_each!");
}

after_each = function() {
    show_debug_message("Ran after_each!");
}

after_all = function() {
    show_debug_message("Ran after_all!");
}

test_goes_vroom_vroom = function() {
    // Arrange
    var _testee = instance_create_depth(0, 0, 0, obj_car);
    
    // Act
    var _result = _testee.make_noise();
    
    // Assert
    var _expected = "Vroom vrooom";
    gunit().assert_equals(_result, _expected, "Did not make the correct noise 3:");
}

test_is_red = function() {
    show_debug_message(blub);
}