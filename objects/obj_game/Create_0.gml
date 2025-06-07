#macro DEVELOPMENT_BUILD true
#macro Release:DEVELOPMENT_BUILD false

if (DEVELOPMENT_BUILD) {
    gunit().register_test_suite(test_obj_car)
        .log_to_file("testlog.txt")
        .run();
}