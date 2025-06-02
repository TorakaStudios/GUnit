/**
* @description Configure GUnit to output test results to a file as well as the debug console. The file will be deleted and recreated on each run.
* @param    {String}                    _file_name      The file name to output to. Includes file ending.
*  It is recommended to end with ".txt", ".log", or a similar text-based ending to be nice to your operating system.
* @return   {Struct.GUnitController}                    This controller instance for chaining
* */
function gunit_log_to_file(_file_name) {
    return gunit().log_to_file(_file_name);
}