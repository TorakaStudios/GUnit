# GUnit

## Introductions

GUnit (pronounced Gee-Unit) is a framework for automated testing in GameMaker.
It is designed to be easy to set up for developers with limited experience in automated testing and/or coding in general.

Using GUnit, you can quickly create test suites to be run repeatedly. These test suites not only ensure
that your code is working as you expect while you create it, but will continue to do so as you develop
further. If a seemingly unrelated code change ever affects a test's expected behaviour, you will
be notified immediately, allowing you to fix it then and there.

GUnit is provided in open source form on this repository. Alternatively, two Local Asset Package files
are provided. Both files contain exactly what is in the repository. One additionally contains a small example
showing how to set up, structure, and run a test.

### How may GUnit be used?

Quick and easy: You MAY use GUnit in any projects, including commercial ones, for free, forever.

You MAY NOT sell GUnit or any parts of it, or claim the code as provided here is your own. Using GUnit
to implement testing in your paid project is allowed. Giving credit to GUnit and its creator, Toraka Studios,
is appreciated.

You MAY make modifications or extensions and publish such extended versions, but they MUST be provided
for free in open source form AND include a link back to this repository, with clear indication which
modifications are yours compared to base GUnit. For further clarification, please contact [Toraka Studios](mailto:TorakaStudios@gmail.com).

### Who is Toraka Studios?

Hi! Toraka Studios is me. I'm Toraka. I'm a software engineer by trade with nine years of experience,
some of it as a dedicated testing engineer. I believe everything can be learned and you're worth improving
yourself every day.

I also made a cutesy pixel art idol band club puzzle game all by myself! Check out 
[Hit Idol on Steam](https://store.steampowered.com/app/3580300/Hit_Idol/) if that sounds like your jam!

## Why test?

An unfortunately common sentiment among game developers is that testing only slows down progress.
My experience is quite the opposite: Writing tests helps you develop faster through three factors:

1. Providing a code-by-the-numbers specification of what the function should do for each plausible input.
2. Assuring that the function is working as intended while developing it, with no risk that problems in other functions cause a false positive.
3. Guaranteeing you will know when changing code elsewhere causes the function's behaviour to change.

### Specification

Specification means to define what the function should return for any given set of input arguments,
what - if any - variables should be changed or other functions called, and what input states are even valid.

Writing specification is hard. In my day job, about 20% of the company's engineers are dedicated solely
to communicating with our clients and translating their requests into words we developers can understand.
Even then, foreseeing every possible combination of variables and input arguments on paper is impossible.

Tests help you translate the abstract into the concrete by asking questions. Can a car always accelerate?
What might stop it? Can its fuel tank be filled infinitely? When we tell the car to make noise, does it
always go vroom vroom, or might it be quieter if it's out of fuel?

### Assurance

One technique called Test-Driven Development is to write tests for your function before even implementing
it. These tests will fail, of course. Then you implement the function *to make the tests pass*, fulfilling
all the requirements they specify.

Automated tests are still valuable if you implement the function first and add tests to it later.
Setting up each scenario in the game can be much more cumbersome than writing a test for them.
By testing the function in isolation, you can guarantee that it, by itself, is working correctly and
quickly pinpoint any problems to where they occur.

### Guarantee

Even when you have finished your function, it is valuable to run automated tests on it. All code makes
assumptions. This is not a bad thing! If you use any variables or other instances in your code, you
are assuming that data is defined at that time.

Making assumptions is fine and necessary. If those assumptions are no longer true as a result of a later
code change, however, the function will cease to work correctly. If the problem only manifests in certain
scenarios, or it is in an area of the game you do not often visit while testing, it may be quite a while
before you notice the problem. The longer before it is noticed, the longer will it often take to fix.

Automated tests codify those assumptions, alerting you if they are no longer true. This is where automated
tests shine the most, as it is not reasonable to manually play a four-hour game to 100% completion
every time you make a change!

## Test Setup

### What to test

In general, all functions you have created should be tested for all plausible inputs and scenarios.
Inversely, this gives us a few things that should NOT be tested:

Never test code that you did not create, especially built-in functions. While you should make sure
they do what you need, properly testing them is the responsibility of their respective creators.

Test for plausible inputs only. If a scenario would inherently cause an error, such as passing the 
string "BatmanBatmanBatman" to a function that expects a number, you do not need to test for it.
This rule requires some case-by-case judgement, as you do want to define and test assumptions
as per the section Guarantee above.

Do not test trivial functionality. For instance, if a fuel tank constructor has two methods to set
and get its current fuel amount, and both functions simply write to / read from a variable, they do
not need to be tested. However, if the tank has a maximum amount of fuel it can
hold, it is valuable to test that this maximum is not exceeded.

### How to test

This section will make an attempt to explain how to set up a test. Please understand that this is a very
complex topic. You are highly encouraged to examine the Example folder and read the documentation on each
individual function GUnit offers. Many details are intentionally left out for (hopefully) an easier start.

A good test is independent of everything around it. It doesn't matter whether any tests are run before or
after it and in which order. **You cannot control the order in which GUnit executes your test methods!**

**You cannot control the order in which GUnit executes your test methods!** This point is so important I
wrote it twice. Tests must not depend on their order of execution.

Further, a test will pass if, and only if, the behaviour being tested is as expected. This means it should
not fail when the behaviour is as expected, but also that it should not pass when the behaviour is different.
One way to prevent false results is mocking, explained further down. Another is setting a random seed:

To ensure consistent behaviour when randomness is involved, GUnit will set the random seed **before each
test method**. When the final test completes, GUnit will reset the random seed back to what it was before
test execution started.

#### Accessing GUnit

The accessor function `gunit()` can be used to retrieve the global GUnit controller object. You may call this
function any number of times and/or store the controller in a variable.

Do NOT call any of GUnit's constructor functions directly. The framework will create instances of these
constructor functions for you when you call methods on the controller and other instances.

#### Defining tests

The easiest way to define a test suite in GUnit is using a test object. In the provided example, this is
`test_obj_car`. The test object may be named anything you like, but it should be clearly associated to the
object or struct it is testing.

The test object should contain only a Create event that sets up its **hook methods** and **test methods** (see below).
The test object may have any amount of other variables and methods, but all setup should be completed when
the Create event finishes.

#### Hook methods

GUnit allows four different hook methods as described in the following list. You may omit any that you don't
need.

* **before_all** is called **once**, before any test methods or the before_each method are called.
* **before_each** is called **for each test method**, just before the test method is called.
* **after_each** is called **for each test method**, just after the test method is called.
* **after_all** is called **once**, after all test methods in the suite and the after_each method are called.

To define a hook method, create a function field with the exact name specified in the list, like this:

```
before_each = function() {
     testee = gunit().create_instance(obj_car);
}
```

#### The test method

A test suite may contain any number of test methods. These method's names MUST start with "test_" to be
automatically detected, but the rest of their name may be anything you like. It is recommended to summarise
what is being tested and in what scenario.

Usually, a test has three phases:

* Arrange: Setting up instances and configuring needed variables
* Act: Usually a single call to the method under test, but may be more. Run the behaviour being tested.
* Assert: Compare the return values obtained during Act and/or instance variables to their expected values.
            If they are as expected, the test passes; If one assertion fails, the test fails.

For example, take this test method:

```
test_goes_vroom_vroom = function() {
    // Arrange
    var _testee = gunit().create_instance(obj_car);
    
    // Act
    var _result = _testee.make_noise();
    
    // Assert
    var _expected = "Vroom vroom";
    gunit().assert_equals(_result, _expected, "Did not make the correct noise 3:");
}
```

First, we create an instance of a car with GUnit's create_instance method. This method is equivalent to
using instance_create_depth, but provides default values for most parameters. Whether or not you use gunit().create_instance(),
**GUnit will destroy all created instances after the test passes or fails**, ensuring it will not interfere with your game.

In this case that's all the setup we need. Next, we call the method under test, make_noise. This is a simple
method with no arguments that always returns a string. You may call this the **result** of the method call, or 
the **actual** value it produces.

With the result stored, we compare it to the value we expect the method to return. For this, GUnit provides
the assert_equals method. If the two values are equal, such that _result == _expected is true, the test passes.
Else it fails.

GUnit also provides assert_true and assert_false for values that are specifically true or false.

That's it as far as setting up the test object. Take a breather, we are almost finished.

#### Registering a test suite

Lastly, for the test suite contained in this test object to be executed, it needs to be registered with GUnit.
For this, use the `register_test_suite(<OBJECT_INDEX>)` method:

```
gunit().register_test_suite(test_obj_car)
    .run();
```

`register_test_suite()` accepts the **object index** of your test object. Do not instantiate the test object;
GUnit will do so for you and destroy it after the testing is done.

You may call `register_test_suite()` any number of times in a row if you have multiple test objects. Once
finished, call the `run()` method to have GUnit execute all of your tests.

#### Alternative setup

There are two alternative ways of setting up a test suite:

You may build a struct the same way you build a test object: Containing one or more functions whose name starts with
`test_`, as well as any number of the hook methods. The struct will be introspected the same way, detecting methods
by their names. Then pass this struct to `register_test_suite_struct(<STRUCT>)`

You may also call `register_new_empty_test_suite()`. This method sets up a `GUnitTestSuite` for you, which provides methods
to add test methods or set hook methods: `add_test(<TEST_FUNCTION>)`, `set_before_all(<FUNCTION>)`, `set_before_each(<FUNCTION>)`,
`set_after_each(<FUNCTION>)`, `set_after_all(<FUNCTION>)`

After configuring the test suite manually, do NOT call `run()` on the GUnitTestSuite. It is registered with GUnit and
you should still call `gunit().run()` to run all registered tests in one batch.

These methods are provided in case they are helpful, but you should prefer using `register_test_suite()` with a test
object index.

### Mocking

With what has been covered so far, you are ready to start testing. It is recommended that you create a few tests
to practice the syntax and get a feel for how to test.

The kind of test you create this way is called *Integration Test*. It uses the full implementation of all components
involved in the test, including secondary components such as a car's fuel tank. This test is valuable for making
sure all components work together, but it isn't always what you want.

Setting up every component in full for every test can be a burden on performance. More importantly, it bloats your
test with setup code for components that aren't actually used. Also, you run the risk of a test failing because
another component isn't behaving as intended.

In a *Unit Test*, these problems are mitigated by replacing all components other than the one being tested with
mocks. A mock pretends to be a real component, containing only the functions needed in the current test and nothing more.

#### Creating a mock

Call gunit().create_mock() to receive a new mock. This instance can be used in place of any object instance or struct.
You may set any variables on the mock as you would on a normal struct. Do not define any functions, however! Configuring
a mock's methods is explained in the next section.

`var _fuel_tank_mock = gunit().create_mock()`

#### Method mocking

Instead of executing functions normally, a mock is configured to always return a specific value (or do nothing) when
one of its functions is called with a certain set of arguments.

To begin, call `when(<FUNCTION_NAME>)` on the mock. This sets up a function with that name on the mock, if it does
not yet exist. This is mocking the function named <FUNCTION_NAME>

Off of `when()`, immediately call `is_called_with(<ARGUMENT>, <ARGUMENT>, ...)`. This defines the set of arguments
to expect. Even though `is_called_with()` does not declare any arguments in its JSDoc, you may pass it any number
of arguments as though `is_called_with()` was the method being mocked.

Finally, off of `is_called_with()`, call `then_return(<RETURN_VALUE>)`. The passed return value will be stored and
returned each time the function is called with this argument set. Together, this may look like:

```
var _fuel_tank_mock = gunit().create_mock();
_fuel_tank_mock.when("fill").is_called_with(5, FuelType.UNLEADED).then_return(true);
_fuel_tank_mock.when("fill").is_called_with(3, FuelType.DIESEL).then_return(false);
```

Note that the set of arguments when mocking, and when actually calling the mocked function, must be exactly the same.
If the call leaves out any of the function's arguments, these arguments must be mocked with a value of `undefined`
if they have no default value.

Function calls will only be mocked if `<EXPECTED_ARGUMENT> == <ACTUAL_ARGUMENT>`. For constructors, structs, and
object instances, this means the **same** instance must be used during mocking as will be used in the function call.

Mocking functions like this may require some code changes to use the same instance in both cases. Alternatively,
you may use `is_called_with_any_arguments()` if the exact arguments are not important, such as if the function is
only called once or should always return the same value.

#### Advanced method mocking

If the function's return value isn't used, or it doesn't return anything, you may finish the mocking chain with
`then_do_nothing()`.

You may mock the same function multiple times. If the argument sets are not the same (as in the example above), any call
will be checked against both argument sets, allowing you to set different return values.

If you mock the same function multiple times with the same argument set, the mocking **created last** will be checked
first. This effectively allows you to replace the mocked return value.

It is discouraged to mock the same function using both `is_called_with_any_arguments()` and `is_called_with()`.
If you do so, make sure to mock it using `is_called_with()` **second**. Otherwise, the any-arguments mocking will
apply to all calls. The specific-arguments mocking will never apply.

#### Asserting function calls

In addition to replacing functions, mock instances will keep track of how often each function was called for each
mocking. You can assert the number of calls using a chain of `assert_that()`, `was_called_with()`, and `never() / once()
/ times(<TIMES>)` like so:

`_fuel_tank_mock.assert_that("fill").was_called_with(5, FuelType.UNLEADED).times(2);`

If the exact arguments aren't important, you may instead use `was_called_times_with_any_arguments(<TIMES>)` or similar
functions:

`_fuel_tank_mock.assert_that("fill").was_called_times_with_any_arguments(2);`

Note: While you can assert each function call made on a mock, you should only assert calls that you would consider
an *effect* of the function. In other words, assert *what* the function does, not *how* it does it. Function calls
to retrieve data that wouldn't be part of the function's description should not be asserted.

#### Global script mocking

The above sections describe how to set up an *instance* mock. GUnit also allows you to mock global script functions
if needed. Call `gunit().get_global_script_mock()` to retrieve the global script mock controller. This is a singleton
instance like the GUnit controller itself. You may call `gunit().get_global_script_mock()` any number of times or assign it to a variable.

The global script mock controller may be configured exactly like an instance mock, using the same methods as described
above:

`gunit().get_global_script_mock().when("gunit_example_describe").is_called_with("car").then_return("Car go car");`

However, you **must** change your code to allow mocking global functions! Instead of calling a global script function
by name directly, call it with a prefix of `global.`:

`global.gunit_example_describe("car");`

This does not affect your code's behaviour in any way while the function isn't mocked. It disables a compiler optimisation
that would normally shortcut from the call site straight to the global script function with no way to mock it.

Whenever a test function finishes, the global script mock controller is fully reset. All global script mocks are
removed and the normal function is returned to its place. If you need the same mocking in each test of a suite,
consider setting it up in the `before_each` method.

### A note about testing events

This readme has covered testing code contained in methods, but not what to do if your code is simply written into
a GML event with no wrapping method. The reason is that triggering events during a test is possible, but **highly**
discouraged.

GUnit executes all tests as part of the same event where `gunit().run()` was called. Different events in GameMaker may
not function correctly if performed at the wrong time or performed multiple times in the same game step.

It is encouraged that you divide your code into small methods with one responsibility each, that you then call in the 
corresponding event. This makes your code easier to test, reuse, *and* maintain.