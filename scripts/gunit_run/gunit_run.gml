/**
* @description Execute all registered test suites and output results to the console (and file, if configured).
*  During test execution, the random seed will be reset just before each test to ensure consistent randomness.
*  The setup method call order for each test suite is as follows:
*  before_all
*  For each test method:
*       before_each
*       test method
*       after_each
*  after_all
*  
*  Any setup methods that aren't defined in a test suite will be skipped.
* */
function gunit_run() {
    gunit().run();
}