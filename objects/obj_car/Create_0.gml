if (!struct_exists(self, "colour")) {
    colour = "red";
}

if (!struct_exists(self, "fuel_tank")) {
    fuel_tank = new FuelTank();
}

make_noise = function() {
    return "Vroom vroom";
}

get_colour = function() {
    return colour;
}

can_drive = function() {
    return !fuel_tank.is_empty();
}

describe_self = function() {
    return global.gunit_example_describe("car");
}