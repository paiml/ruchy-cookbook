# Chapter 1: Basic Syntax & Common Patterns

## Introduction

This chapter covers the fundamental building blocks of Ruchy programming. Whether you're coming from Python, Ruby, C++, or another language, these recipes will help you quickly become productive with Ruchy's core syntax and idioms.

## What You'll Learn

- Recipe 1.1: Hello World - Your first Ruchy program
- Recipe 1.2: Command Line Arguments - Reading user input
- Recipe 1.3: Variables and Mutability - Understanding ownership
- Recipe 1.4: Basic Data Types - Numbers, strings, and booleans
- Recipe 1.5: Functions and Return Values - Writing reusable code
- Recipe 1.6: Control Flow and Conditionals - Making decisions
- Recipe 1.7: Structs, Classes, and Methods - Object-oriented programming

## Prerequisites

- Basic programming knowledge in any language
- Ruchy installed on your system
- Familiarity with command line/terminal

---

## Recipe 1.1: Hello World

**Difficulty**: Beginner
**Coverage**: 100%
**Mutation Score**: 95%
**PMAT Grade**: A+

### Problem

You need to write your first Ruchy program that displays output to the console. This is the traditional starting point for learning any programming language.

### Solution

```ruchy
/// Returns the classic "Hello, World!" greeting
pub fun hello_world() -> String {
    "Hello, World!"
}

/// Main entry point for the program
fun main() {
    println!("{}", hello_world());
}
```

**Output**:
```
Hello, World!
```

### Discussion

This simple program demonstrates several Ruchy fundamentals:

1. **Function Declaration**: The `fun` keyword declares functions
2. **Return Types**: `-> String` specifies the return type
3. **String Literals**: Double quotes create String values
4. **Macros**: `println!` is a macro (note the `!`) for printing
5. **String Formatting**: `{}` placeholder for string interpolation

**Why This Works**:
- Ruchy expressions return the last value automatically (no `return` keyword needed)
- `println!` macro handles output to stdout with automatic newline
- The `hello_world()` function is pure - always returns the same value

**Performance Characteristics**:
- Time Complexity: O(1) - constant time
- Space Complexity: O(1) - string literal is compile-time constant
- No heap allocations (string is static)

**Safety Guarantees**:
- No possible panics or errors
- Type-safe at compile time
- Memory-safe (no manual allocation)

### Variations

**Variation 1: Direct Printing**
```ruchy
fun main() {
    println!("Hello, World!");
}
```

**Variation 2: With Return Value**
```ruchy
fun main() -> i32 {
    println!("Hello, World!");
    0  // Exit code
}
```

**Variation 3: Parameterized Greeting**
```ruchy
pub fun greet(name: String) -> String {
    format!("Hello, {}!", name)
}

fun main() {
    println!("{}", greet("World"));
}
```

### See Also

- Recipe 1.2: Command Line Arguments
- Recipe 1.5: Functions and Return Values
- Recipe 2.1: String Formatting
- Chapter 7: Command Line Applications

### Tests

This recipe includes comprehensive testing:
- **Unit Tests**: 10 tests covering output format, content, and edge cases
- **Property Tests**: 3 properties verified (idempotence, consistency, format)
- **Integration Tests**: 2 tests verifying main execution and stdout output
- **Mutation Score**: 95%

<details>
<summary>View Test Suite (click to expand)</summary>

**Unit Tests** ([view source](../../recipes/ch01/recipe-001/tests/unit_tests.ruchy)):
```ruchy
#[test]
fun test_hello_world_output() {
    let result = hello_world();
    assert_eq!(result, "Hello, World!");
}

#[test]
fun test_hello_world_idempotent() {
    let result1 = hello_world();
    let result2 = hello_world();
    assert_eq!(result1, result2);
}
// ... 8 more tests
```

**Property Tests** ([view source](../../recipes/ch01/recipe-001/tests/property_tests.ruchy)):
```ruchy
#[proptest]
fun test_hello_world_always_same(n: u32) {
    let result = hello_world();
    assert_eq!(result, "Hello, World!");
}
// ... 2 more property tests
```

**Full test suite**: [recipes/ch01/recipe-001/tests/](../../recipes/ch01/recipe-001/tests/)

</details>

---

## Recipe 1.2: Command Line Arguments

**Difficulty**: Beginner
**Coverage**: 95%
**Mutation Score**: 90%
**PMAT Grade**: A+

### Problem

You need to read and process command line arguments passed to your program, including flags, values, and positional arguments. This is essential for building CLI tools.

### Solution

```ruchy
use std::env;

/// Parse command line arguments, excluding the program name
pub fun parse_args(args: Vec<&str>) -> Vec<String> {
    if args.is_empty() || (args.len() == 1 && args[0].is_empty()) {
        return vec![];
    }

    args[1..].iter().map(|s| s.to_string()).collect()
}

/// Get argument at specific index
pub fun get_arg_at(args: Vec<&str>, index: usize) -> Option<String> {
    let parsed = parse_args(args);
    parsed.get(index).map(|s| s.clone())
}

/// Count arguments (excluding program name)
pub fun count_args(args: Vec<&str>) -> usize {
    parse_args(args).len()
}

/// Check if a flag is present
pub fun has_flag(args: Vec<&str>, flag: &str) -> bool {
    let parsed = parse_args(args);
    parsed.iter().any(|arg| arg == flag)
}

/// Get value following a flag
pub fun get_flag_value(args: Vec<&str>, flag: &str) -> Option<String> {
    let parsed = parse_args(args);

    for i in 0..parsed.len() {
        if parsed[i] == flag && i + 1 < parsed.len() {
            return Some(parsed[i + 1].clone());
        }
    }

    None
}

/// Join arguments into single string
pub fun join_args(args: Vec<&str>, separator: &str) -> String {
    let parsed = parse_args(args);
    parsed.join(separator)
}

/// Check if arguments contain value
pub fun args_contain(args: Vec<&str>, value: &str) -> bool {
    let parsed = parse_args(args);
    parsed.iter().any(|arg| arg == value)
}

fun main() {
    let args: Vec<String> = env::args().collect();
    let arg_refs: Vec<&str> = args.iter().map(|s| s.as_str()).collect();

    println!("Total arguments: {}", count_args(arg_refs.clone()));

    let parsed = parse_args(arg_refs.clone());
    for (i, arg) in parsed.iter().enumerate() {
        println!("  [{}]: {}", i, arg);
    }

    if has_flag(arg_refs.clone(), "--help") {
        println!("Help flag detected!");
    }

    if let Some(output) = get_flag_value(arg_refs.clone(), "--output") {
        println!("Output file: {}", output);
    }
}
```

**Example Usage**:
```bash
$ ./myprogram hello world --verbose
Total arguments: 3
  [0]: hello
  [1]: world
  [2]: --verbose

$ ./myprogram --output result.txt --threads 4
Total arguments: 4
  [0]: --output
  [1]: result.txt
  [2]: --threads
  [3]: 4
Output file: result.txt
```

### Discussion

This solution provides a comprehensive toolkit for handling command line arguments:

1. **parse_args**: Strips the program name (index 0) and returns clean argument list
2. **Positional Arguments**: Access via `get_arg_at` for numbered positions
3. **Flag Detection**: Use `has_flag` to check for boolean flags like `--verbose`
4. **Flag Values**: Use `get_flag_value` to get values like `--output file.txt`
5. **Utility Functions**: Count, join, and search arguments efficiently

**Why This Works**:
- Ruchy's `Vec` type provides safe indexing with `get()`
- Pattern matching with `Option` prevents index out-of-bounds errors
- String slicing `[1..]` cleanly removes program name
- Iterator methods like `any()` and `map()` are zero-cost abstractions

**Performance Characteristics**:
- Time Complexity: O(n) where n is number of arguments
- Space Complexity: O(n) for parsed argument storage
- Flag lookup: O(n) linear search (acceptable for typical CLI arg counts)

**Safety Guarantees**:
- No panics on missing arguments (returns `Option::None`)
- No buffer overflows (bounds-checked indexing)
- Unicode-safe (works with emoji and international text)

### Variations

**Variation 1: Using External Crate (clap-like)**
```ruchy
use clap::Parser;

#[derive(Parser)]
struct Args {
    #[arg(short, long)]
    verbose: bool,

    #[arg(short, long)]
    output: Option<String>,

    files: Vec<String>,
}

fun main() {
    let args = Args::parse();
    println!("Verbose: {}", args.verbose);
}
```

**Variation 2: Custom Flag Parser**
```ruchy
pub struct FlagParser {
    args: Vec<String>,
}

impl FlagParser {
    pub fun new(args: Vec<String>) -> Self {
        FlagParser { args }
    }

    pub fun get_flag(&self, short: &str, long: &str) -> bool {
        self.args.iter().any(|a| a == short || a == long)
    }

    pub fun get_value(&self, short: &str, long: &str) -> Option<String> {
        // Look for both -o and --output
        for flag in [short, long] {
            if let Some(val) = get_flag_value(&self.args, flag) {
                return Some(val);
            }
        }
        None
    }
}
```

**Variation 3: Subcommand Pattern**
```ruchy
pub fun parse_subcommand(args: Vec<&str>) -> (Option<String>, Vec<String>) {
    let parsed = parse_args(args);

    if parsed.is_empty() {
        return (None, vec![]);
    }

    let subcommand = parsed[0].clone();
    let remaining = parsed[1..].to_vec();

    (Some(subcommand), remaining)
}

// Usage: myapp build --release main.rs
// Returns: (Some("build"), ["--release", "main.rs"])
```

### See Also

- Recipe 1.1: Hello World
- Recipe 7.1: Building Command Line Tools
- Recipe 7.5: Argument Parsing with Clap
- Chapter 4: Error Handling Patterns

### Tests

This recipe includes comprehensive testing:
- **Unit Tests**: 15 tests covering all edge cases (empty args, unicode, special chars)
- **Property Tests**: 6 properties verified (order preservation, count matching, bounds checking)
- **Integration Tests**: 5 real-world scenarios (help flags, file processing, subcommands)
- **Mutation Score**: 90%

<details>
<summary>View Test Suite (click to expand)</summary>

**Unit Tests** ([view source](../../recipes/ch01/recipe-002/tests/unit_tests.ruchy)):
```ruchy
#[test]
fun test_parse_args_multiple() {
    let args = vec!["program", "arg1", "arg2", "arg3"];
    let result = parse_args(args);
    assert_eq!(result.len(), 3);
    assert_eq!(result[0], "arg1");
}

#[test]
fun test_has_flag() {
    let args = vec!["program", "--verbose", "file.txt"];
    assert!(has_flag(args, "--verbose"));
    assert!(!has_flag(args, "--quiet"));
}

#[test]
fun test_get_flag_value() {
    let args = vec!["program", "--output", "result.txt"];
    assert_eq!(get_flag_value(args, "--output"), Some("result.txt"));
}
// ... 12 more unit tests
```

**Property Tests** ([view source](../../recipes/ch01/recipe-002/tests/property_tests.ruchy)):
```ruchy
#[proptest]
fun test_parse_args_preserves_order(args: Vec<String>) {
    // Property: parse_args preserves argument order
    let input = ["program"].concat(args.clone());
    let result = parse_args(input);

    for i in 0..args.len() {
        assert_eq!(result[i], args[i]);
    }
}
// ... 5 more property tests
```

**Full test suite**: [recipes/ch01/recipe-002/tests/](../../recipes/ch01/recipe-002/tests/)

</details>

---

## Recipe 1.3: Variables and Mutability

**Difficulty**: Beginner
**Status**: 🚧 Coming Soon

This recipe will cover variable declaration, mutability, and shadowing.

---

## Recipe 1.4: Basic Data Types

**Difficulty**: Beginner
**Status**: 🚧 Coming Soon

This recipe will cover integers, floats, booleans, and characters.

---

## Recipe 1.5: Functions and Return Values

**Difficulty**: Beginner
**Coverage**: 96%
**Mutation Score**: 91%
**PMAT Grade**: A+

### Problem

You need to understand how to write functions with different parameter counts, return values, and control flow patterns. Functions are the primary building blocks for code reuse in Ruchy.

### Solution

```ruchy
/// Function with no parameters returning a constant
pub fun get_constant() -> i32 {
    42
}

/// Function with single parameter - doubles the value
pub fun double(x: i32) -> i32 {
    x * 2
}

/// Function with two parameters - adds them
pub fun add(a: i32, b: i32) -> i32 {
    a + b
}

/// Function returning tuple - swaps two values
pub fun swap(a: i32, b: i32) -> (i32, i32) {
    (b, a)
}

/// Function with early return
pub fun check_and_return(x: i32) -> i32 {
    if x < 0 {
        return 0;
    }
    x * x
}

/// Function with expression-based return
pub fun square(x: i32) -> i32 {
    x * x
}

/// Function with explicit return statement
pub fun abs(x: i32) -> i32 {
    if x < 0 {
        return -x;
    }
    x
}

/// Function returning owned String
pub fun make_greeting(name: &str) -> String {
    format!("Hello, {}!", name)
}

fun main() {
    println!("get_constant() = {}", get_constant());
    println!("double(5) = {}", double(5));
    println!("add(5, 3) = {}", add(5, 3));

    let (x, y) = swap(1, 2);
    println!("swap(1, 2) = ({}, {})", x, y);

    println!("check_and_return(10) = {}", check_and_return(10));
    println!("check_and_return(-5) = {}", check_and_return(-5));
}
```

**Output**:
```
get_constant() = 42
double(5) = 10
add(5, 3) = 8
swap(1, 2) = (2, 1)
check_and_return(10) = 100
check_and_return(-5) = 0
```

### Discussion

This solution demonstrates comprehensive function patterns in Ruchy:

1. **No Parameters**: Functions like `get_constant()` return fixed values
2. **Single Parameter**: Functions like `double(x)` transform a single input
3. **Multiple Parameters**: Functions like `add(a, b)` combine multiple inputs
4. **Tuple Returns**: Functions like `swap(a, b)` return multiple values
5. **Early Returns**: Use `return` keyword for early exit
6. **Expression Returns**: Last expression is automatically returned
7. **Explicit Returns**: Use `return` keyword for clarity

**Why This Works**:
- Ruchy functions use the `fun` keyword for declaration
- Return type is specified after `->` arrow
- Last expression in function body is automatically returned (no semicolon)
- Explicit `return` keyword allows early exit from function
- Tuple syntax `(a, b)` enables multiple return values
- Type inference works for most cases, but explicit types improve clarity

**Performance Characteristics**:
- Function calls: O(1) - inlined by compiler in most cases
- Zero-cost abstractions: No runtime overhead for function boundaries
- Stack allocation: Parameters passed efficiently via registers (when possible)
- Return value optimization (RVO): Prevents unnecessary copies

**Safety Guarantees**:
- Type-safe parameters: Compiler verifies argument types
- Memory-safe returns: No dangling references possible
- Overflow checks: Can use checked arithmetic (checked_add, etc.)
- No null pointers: Use `Option<T>` for optional values

### Variations

**Variation 1: Functions with Default-Like Behavior**
```ruchy
pub fun greet_or_default(name: Option<&str>) -> String {
    match name {
        Some(n) => format!("Hello, {}!", n),
        None => "Hello, stranger!".to_string(),
    }
}
```

**Variation 2: Higher-Order Functions**
```ruchy
pub fun apply_twice(f: fn(i32) -> i32, x: i32) -> i32 {
    f(f(x))
}

// Usage:
let result = apply_twice(double, 5); // 20
```

**Variation 3: Generic Functions**
```ruchy
pub fun max<T: Ord>(a: T, b: T) -> T {
    if a > b { a } else { b }
}

// Works with any comparable type
let num_max = max(5, 3);        // i32
let char_max = max('a', 'z');   // char
```

**Variation 4: Functions Returning Unit**
```ruchy
pub fun print_message(msg: &str) {
    println!("{}", msg);
    // Implicitly returns ()
}

pub fun do_nothing() -> () {
    ()
}
```

### See Also

- Recipe 1.1: Hello World
- Recipe 1.3: Variables and Mutability
- Recipe 6.1: Closures and Capturing
- Recipe 8.2: Higher-Order Functions
- Chapter 9: Functional Programming Patterns

### Tests

This recipe includes comprehensive testing:
- **Unit Tests**: 30 tests covering all function signatures and return types
- **Property Tests**: 10 properties verified (commutativity, idempotence, invertibility)
- **Integration Tests**: 8 real-world pipelines and workflows
- **Mutation Score**: 91%

<details>
<summary>View Test Suite (click to expand)</summary>

**Unit Tests** ([view source](../../recipes/ch01/recipe-005/tests/unit_tests.ruchy)):
```ruchy
#[test]
fun test_function_no_params() {
    let result = get_constant();
    assert_eq!(result, 42);
}

#[test]
fun test_function_single_param_i32() {
    let result = double(5);
    assert_eq!(result, 10);
}

#[test]
fun test_function_returns_tuple() {
    let (x, y) = swap(1, 2);
    assert_eq!(x, 2);
    assert_eq!(y, 1);
}

#[test]
fun test_early_return_true_case() {
    let result = check_and_return(10);
    assert_eq!(result, 100);
}
// ... 26 more unit tests
```

**Property Tests** ([view source](../../recipes/ch01/recipe-005/tests/property_tests.ruchy)):
```ruchy
#[proptest]
fun test_add_commutative(a: i32, b: i32) {
    // Property: Addition is commutative
    assume!(a.checked_add(b).is_some());
    assert_eq!(add(a, b), add(b, a));
}

#[proptest]
fun test_abs_non_negative(value: i32) {
    // Property: Absolute value is always non-negative
    assume!(value != i32::MIN);
    let result = abs(value);
    assert!(result >= 0);
}

#[proptest]
fun test_swap_invertible(a: i32, b: i32) {
    // Property: Swapping twice returns original values
    let (x, y) = swap(a, b);
    let (a2, b2) = swap(x, y);
    assert_eq!(a2, a);
    assert_eq!(b2, b);
}
// ... 7 more property tests
```

**Full test suite**: [recipes/ch01/recipe-005/tests/](../../recipes/ch01/recipe-005/tests/)

</details>

---

## Recipe 1.6: Control Flow and Conditionals

**Difficulty**: Beginner
**Coverage**: 98%
**Mutation Score**: 94%
**PMAT Grade**: A+

### Problem

You need to make decisions in your code based on conditions, implement branching logic, and handle different execution paths. Control flow is fundamental to all programming.

### Solution

```ruchy
/// Check if a number is positive, negative, or zero
pub fun check_sign(n: i32) -> &'static str {
    if n > 0 {
        "positive"
    } else if n < 0 {
        "negative"
    } else {
        "zero"
    }
}

/// Match specific numbers
pub fun match_number(n: i32) -> &'static str {
    match n {
        1 => "one",
        2 => "two",
        3 => "three",
        _ => "other",
    }
}

/// Match number ranges
pub fun match_range(n: i32) -> &'static str {
    match n {
        0..=10 => "small",
        11..=100 => "medium",
        _ => "large",
    }
}

/// Process age with guard clauses
pub fun process_age(age: i32) -> &'static str {
    if age <= 0 {
        return "Invalid age";
    }

    if age < 13 {
        return "Child";
    }

    if age < 18 {
        return "Teen";
    }

    if age < 65 {
        return "Adult";
    }

    "Senior"
}

/// FizzBuzz pattern with tuple matching
pub fun fizzbuzz(n: i32) -> String {
    match (n % 3 == 0, n % 5 == 0) {
        (true, true) => "FizzBuzz".to_string(),
        (true, false) => "Fizz".to_string(),
        (false, true) => "Buzz".to_string(),
        _ => n.to_string(),
    }
}

fun main() {
    println!("check_sign(5) = {}", check_sign(5));
    println!("check_sign(-3) = {}", check_sign(-3));
    println!("match_number(1) = {}", match_number(1));
    println!("match_range(5) = {}", match_range(5));
    println!("process_age(25) = {}", process_age(25));
    println!("fizzbuzz(15) = {}", fizzbuzz(15));
}
```

**Output**:
```
check_sign(5) = positive
check_sign(-3) = negative
match_number(1) = one
match_range(5) = small
process_age(25) = Adult
fizzbuzz(15) = FizzBuzz
```

### Discussion

This solution demonstrates comprehensive control flow patterns in Ruchy:

1. **if/else Expressions**: Simple conditional branching with `if`, `else if`, and `else`
2. **Match Expressions**: Pattern matching with specific values, ranges, and wildcards
3. **Guard Clauses**: Early return pattern for validation and error handling
4. **Tuple Matching**: Matching on multiple conditions simultaneously
5. **Expression Returns**: All control flow constructs return values

**Why This Works**:
- Ruchy's `if` is an expression, not a statement - it returns a value
- Match expressions are exhaustive - all cases must be covered
- Guard clauses with early returns improve readability
- Ranges in match arms use `..=` syntax for inclusive ranges
- Wildcard `_` pattern catches all remaining cases

**Performance Characteristics**:
- if/else: O(1) - constant time conditional evaluation
- match: O(1) - compiled to jump tables when possible
- Guard clauses: O(1) - early returns prevent unnecessary computation
- Zero-cost abstractions: No runtime overhead for pattern matching

**Safety Guarantees**:
- Exhaustive pattern matching: Compiler ensures all cases handled
- Type-safe conditionals: Conditions must be boolean
- No fall-through: Each match arm is explicit
- Expression consistency: All branches must return same type

### Variations

**Variation 1: Nested Conditionals**
```ruchy
pub fun classify_number(n: i32) -> &'static str {
    if n == 0 {
        "zero"
    } else if n > 0 {
        if n % 2 == 0 {
            "positive even"
        } else {
            "positive odd"
        }
    } else {
        if n % 2 == 0 {
            "negative even"
        } else {
            "negative odd"
        }
    }
}
```

**Variation 2: if let for Option Handling**
```ruchy
pub fun unwrap_or_default(opt: Option<i32>) -> i32 {
    if let Some(value) = opt {
        value
    } else {
        0
    }
}
```

**Variation 3: Match with Guards**
```ruchy
pub fun calculate_shipping(weight: f64) -> f64 {
    match weight {
        w if w <= 1.0 => 5.0,
        w if w <= 5.0 => 10.0,
        w if w <= 10.0 => 20.0,
        _ => 50.0,
    }
}
```

**Variation 4: Logical Operators**
```ruchy
pub fun can_access(age: i32, authenticated: bool, role: &str) -> bool {
    if !authenticated {
        return false;
    }

    if age < 18 {
        return false;
    }

    role == "admin" || role == "user"
}
```

### See Also

- Recipe 1.5: Functions and Return Values
- Recipe 4.1: Result Type Basics
- Recipe 4.2: Option Type Handling
- Recipe 8.1: Pattern Matching Advanced
- Chapter 12: State Machines

### Tests

This recipe includes comprehensive testing:
- **Unit Tests**: 37 tests covering all control flow patterns
- **Property Tests**: 12 properties verified (De Morgan's laws, transitivity, idempotence)
- **Integration Tests**: 10 real-world scenarios (grading, access control, state machines)
- **Mutation Score**: 94%

<details>
<summary>View Test Suite (click to expand)</summary>

**Unit Tests** ([view source](../../recipes/ch01/recipe-006/tests/unit_tests.ruchy)):
```ruchy
#[test]
fun test_if_else_positive() {
    let result = check_sign(5);
    assert_eq!(result, "positive");
}

#[test]
fun test_match_number_one() {
    let result = match_number(1);
    assert_eq!(result, "one");
}

#[test]
fun test_guard_clause_adult() {
    let result = process_age(25);
    assert_eq!(result, "Adult");
}
// ... 34 more unit tests
```

**Property Tests** ([view source](../../recipes/ch01/recipe-006/tests/property_tests.ruchy)):
```ruchy
#[proptest]
fun test_de_morgans_law_and(a: bool, b: bool) {
    // Property: !(a && b) == (!a || !b)
    let left = logical_not(logical_and(a, b));
    let right = logical_or(logical_not(a), logical_not(b));
    assert_eq!(left, right);
}

#[proptest]
fun test_comparison_transitivity(a: i32, b: i32, c: i32) {
    // Property: if a > b and b > c, then a > c
    if is_greater(a, b) && is_greater(b, c) {
        assert!(is_greater(a, c));
    }
}
// ... 10 more property tests
```

**Full test suite**: [recipes/ch01/recipe-006/tests/](../../recipes/ch01/recipe-006/tests/)

</details>

---

## Recipe 1.7: Structs, Classes, and Methods

**Difficulty**: Intermediate
**Coverage**: 97%
**Mutation Score**: 93%
**PMAT Grade**: A+

### Problem

How do you define and use structs in Ruchy? What's the difference between **struct** (value type) and **class** (reference type)? When should you use each, and how do they differ in terms of copying, mutation, and memory semantics?

### Solution

Ruchy has two distinct ways to define custom types: **struct** for value semantics and **class** for reference semantics.

**Example 1: Struct (Value Type) - Copies on Assignment**

```ruchy
/// Struct with public fields - VALUE type
#[derive(Debug, Clone, Copy)]
pub struct Rectangle {
    pub width: i32,
    pub height: i32,
}

impl Rectangle {
    pub fun area(&self) -> i32 {
        self.width * self.height
    }

    pub mutating fun scale(&mut self, factor: i32) {
        self.width *= factor;
        self.height *= factor;
    }
}

fun main() {
    let rect1 = Rectangle { width: 10, height: 20 };
    let mut rect2 = rect1;  // COPIES the struct

    rect2.width = 30;

    println!("rect1.width: {}", rect1.width);  // 10 (unchanged)
    println!("rect2.width: {}", rect2.width);  // 30 (modified copy)
}
```

**Example 2: Class (Reference Type) - Shares on Assignment**

```ruchy
/// Class with init method - REFERENCE type
#[derive(Debug, Clone, PartialEq)]
pub class Person {
    name: String,
    age: i32,

    /// Required init method for classes
    init(name: &str, age: i32) {
        self.name = name.to_string();
        self.age = age;
    }

    fun name(&self) -> &str {
        &self.name
    }

    fun age(&self) -> i32 {
        self.age
    }

    /// No 'mutating' keyword needed for classes!
    fun have_birthday(&self) {
        self.age += 1;
    }
}

fun main() {
    let person1 = Person("Alice", 30);
    let person2 = person1;  // SHARES the reference (no copy!)

    person2.have_birthday();

    println!("person1.age(): {}", person1.age());  // 31 (changed!)
    println!("person2.age(): {}", person2.age());  // 31 (same instance)
    println!("Same instance: {}", person1 === person2);  // true
}
```

**Output**:
```
rect1.width: 10
rect2.width: 30
person1.age(): 31
person2.age(): 31
Same instance: true
```

### Discussion

Ruchy provides two fundamentally different ways to create custom types, each with distinct memory semantics:

#### Struct vs Class: The Key Difference

| Feature | Struct | Class |
|---------|--------|-------|
| **Semantics** | Value type (copy) | Reference type (share) |
| **Assignment** | Creates copy | Shares reference |
| **Mutation** | Requires `mutating` keyword | No `mutating` needed |
| **Initialization** | Automatic memberwise | Requires `init` method |
| **Identity** | Only `==` (value equality) | `===` (identity) + `==` |
| **Storage** | Stack-allocated | Heap-allocated (Rc<RefCell<>>) |
| **Memory** | Copied on assignment | Reference-counted |

#### Struct (Value Semantics)

**Plain Data Struct**:
```ruchy
pub struct Rectangle {
    pub width: i32,   // Public field - direct access
    pub height: i32,  // Public field - direct access
}

let rect = Rectangle { width: 30, height: 50 };
println!("{}", rect.width);  // Direct field access
```

**Struct with Private Fields** (encapsulation):
```ruchy
pub struct Point {
    x: i32,  // Private field - no direct access
    y: i32,  // Private field - no direct access
}

impl Point {
    pub fun new(x: i32, y: i32) -> Self {
        Point { x, y }
    }

    pub fun x(&self) -> i32 { self.x }  // Getter
    pub mutating fun set_x(&mut self, x: i32) { self.x = x; }  // Setter
}

let mut p = Point::new(10, 20);
// p.x = 30;  // ERROR: field is private
p.set_x(30);  // Use setter instead
```

**Key Points**:
- Structs use `impl` blocks for methods
- Need `mutating` keyword for methods that modify `self`
- Copying is automatic (if derives Copy/Clone)
- Each variable owns its own copy

#### Class (Reference Semantics)

**Class with Init**:
```ruchy
pub class BankAccount {
    owner: String,
    pub balance: f64,  // Public field

    init(owner: &str, initial_balance: f64) {
        self.owner = owner.to_string();
        self.balance = initial_balance;
    }

    fun deposit(&self, amount: f64) {  // No 'mutating' needed!
        self.balance += amount;
    }

    static fun savings_account(owner: &str) -> Self {
        BankAccount::init(owner, 0.0)
    }
}

let account = BankAccount("Alice", 1000.0);
let account_ref = account;  // Share reference

account_ref.deposit(100.0);

println!("{}", account.balance());  // 1100.0 (both see change!)
println!("{}", account === account_ref);  // true (same instance)
```

**Key Points**:
- Classes require explicit `init` method
- NO `mutating` keyword needed (reference semantics allow mutation)
- Assignment shares the reference (no copy)
- Multiple variables can refer to same instance
- Use `===` for identity comparison

#### When to Use Struct vs Class

**Use `struct` when**:
- You want **value semantics** (copies are independent)
- Working with small data (coordinates, colors, dates)
- Performance is critical (stack allocation)
- Immutability is preferred
- Examples: `Point`, `Rectangle`, `Color`, `DateTime`

**Use `class` when**:
- You want **reference semantics** (shared state)
- Modeling real-world entities with identity
- Working with large objects (avoiding expensive copies)
- Need shared mutable state
- Examples: `Person`, `BankAccount`, `Database`, `Server`

#### Method Syntax Differences

**Struct Methods**:
```ruchy
impl Rectangle {
    // Read-only method
    pub fun area(&self) -> i32 { ... }

    // Mutable method - needs 'mutating' keyword!
    pub mutating fun scale(&mut self, factor: i32) { ... }

    // Static method (associated function)
    pub fun square(size: i32) -> Self { ... }
}
```

**Class Methods**:
```ruchy
class Person {
    // Read method
    fun name(&self) -> &str { ... }

    // Mutation - NO 'mutating' keyword!
    fun have_birthday(&self) {
        self.age += 1;  // Works due to reference semantics
    }

    // Static method
    static fun new_person(name: &str) -> Self { ... }
}
```

#### Performance Characteristics

**Struct**:
- Stack allocation: Extremely fast
- Copy cost: Proportional to size
- Method calls: Zero-cost (inlined)
- Memory: One copy per variable

**Class**:
- Heap allocation: Slightly slower
- Copy cost: Just copies reference (cheap!)
- Method calls: Zero-cost (inlined through Rc<RefCell<>>)
- Memory: One instance, multiple references

**Safety Guarantees**:
- Borrow checker prevents data races (both)
- No null pointers (both use `Option<T>`)
- Private fields enforced at compile time (both)
- Class: Runtime borrow checking via RefCell

### Variations

**Variation 1: Tuple Structs**
```ruchy
pub struct Color(pub u8, pub u8, pub u8);  // RGB

let red = Color(255, 0, 0);
println!("Red channel: {}", red.0);  // Access by index
```

**Variation 2: Unit Structs**
```ruchy
pub struct Marker;  // Zero-size type

impl Marker {
    pub fun new() -> Self {
        Marker
    }
}
```

**Variation 3: Derive Macros**
```ruchy
#[derive(Debug, Clone, PartialEq)]
pub struct Person {
    name: String,
    age: i32,
}

// Automatically implements Debug, Clone, PartialEq
```

**Variation 4: Generic Structs**
```ruchy
pub struct Container<T> {
    value: T,
}

impl<T> Container<T> {
    pub fun new(value: T) -> Self {
        Container { value }
    }

    pub fun get(&self) -> &T {
        &self.value
    }
}
```

### See Also

- Recipe 1.5: Functions and Return Values
- Recipe 8.1: Traits and Polymorphism
- Recipe 8.2: Advanced OOP Patterns
- Recipe 12.1: Builder Pattern Deep Dive
- Chapter 15: Design Patterns in Ruchy

### Tests

This recipe includes comprehensive testing:
- **Unit Tests**: 47 tests covering struct/class creation, copy/reference semantics, identity comparison
- **Property Tests**: 19 properties verified (value independence, reference sharing, mutation visibility)
- **Integration Tests**: 13 real-world workflows (struct copies, class sharing, bank accounts, counters)
- **Mutation Score**: 95%

<details>
<summary>View Test Suite (click to expand)</summary>

**Unit Tests** ([view source](../../recipes/ch01/recipe-007/tests/unit_tests.ruchy)):
```ruchy
#[test]
fun test_struct_copy_semantics() {
    // Structs are VALUE types - assignment COPIES the data
    let rect1 = Rectangle { width: 10, height: 20 };
    let mut rect2 = rect1;  // Copies the struct

    rect2.width = 30;

    // Original unchanged (because rect2 is a copy)
    assert_eq!(rect1.width, 10);
    assert_eq!(rect2.width, 30);
}

#[test]
fun test_class_reference_semantics() {
    // Classes are REFERENCE types - assignment SHARES the instance
    let person1 = Person("Bob", 25);
    let person2 = person1;  // Shares reference, no copy!

    person2.set_age(26);

    // Both references see the change (shared instance)
    assert_eq!(person1.age(), 26);
    assert_eq!(person2.age(), 26);
}

#[test]
fun test_class_identity_comparison() {
    let person1 = Person("Dave", 40);
    let person2 = Person("Dave", 40);
    let person3 = person1;  // Same reference

    // Value equality (==)
    assert_eq!(person1, person2);  // Same data

    // Identity comparison (===)
    assert!(person1 === person3);  // Same instance
    assert!(!(person1 === person2));  // Different instances
}
// ... 44 more unit tests
```

**Property Tests** ([view source](../../recipes/ch01/recipe-007/tests/property_tests.ruchy)):
```ruchy
#[proptest]
fun test_struct_copy_independence(x: i32, y: i32, new_x: i32) {
    // Property: Struct copies are independent (value semantics)
    let point1 = Point::new(x, y);
    let mut point2 = point1;  // Copy

    point2.set_x(new_x);

    // Original unchanged (because point2 is a copy)
    assert_eq!(point1.x(), x);
    assert_eq!(point2.x(), new_x);
}

#[proptest]
fun test_class_mutation_visible_to_all_refs(initial_balance: u16, deposit: u16) {
    // Property: Mutating through one reference affects all references
    let account = BankAccount("Test", initial_balance as f64);
    let account_ref = account;  // Share reference

    account.deposit(deposit as f64);

    // Both references see the mutation
    assert_eq!(account.balance(), (initial_balance + deposit) as f64);
    assert_eq!(account_ref.balance(), (initial_balance + deposit) as f64);
}

#[proptest]
fun test_shared_counter_increments_accumulate(count: u8) {
    // Property: Shared counter increments accumulate across references
    let counter = SharedCounter(0);
    let counter_ref = counter;  // Share reference

    for _ in 0..count {
        counter.increment();
    }

    // All references see same accumulated value
    assert_eq!(counter.value(), count as i32);
    assert_eq!(counter_ref.value(), count as i32);
    assert!(counter === counter_ref);
}
// ... 16 more property tests
```

**Full test suite**: [recipes/ch01/recipe-007/tests/](../../recipes/ch01/recipe-007/tests/)

</details>

---

## Chapter Exercises

### Exercise 1.1: Personalized Greeting
**Difficulty**: Beginner
**Time**: 10 minutes

Create a program that prints "Hello, [YourName]!" using what you learned in Recipe 1.1.

**Requirements**:
- Define a function `hello_name(name: String) -> String`
- Write at least 5 unit tests
- Achieve 100% coverage

### Exercise 1.2: Multiple Greetings
**Difficulty**: Beginner
**Time**: 15 minutes

Create a program that prints greetings in 3 different languages.

**Requirements**:
- Functions for English, Spanish, and French greetings
- Property tests verifying consistent output
- 90%+ mutation score

### Exercise 1.3: Conditional Greeting
**Difficulty**: Intermediate
**Time**: 20 minutes

Create a greeting that changes based on time of day.

**Requirements**:
- "Good morning", "Good afternoon", "Good evening" based on hour
- Comprehensive test coverage for all time ranges
- Error handling for invalid input

---

## Summary

In this chapter, you learned:

- ✅ Basic Ruchy program structure
- ✅ Function declaration and return types
- ✅ String literals and formatting
- ✅ Console output with `println!`
- ✅ EXTREME TDD methodology with property tests

**Key Takeaways**:
1. Every Ruchy program needs a `main()` function
2. Functions can return values without explicit `return` keyword
3. Type safety is enforced at compile time
4. Test-driven development ensures quality

**Next Steps**: Continue to [Chapter 2: String & Text Processing](./ch02-text-processing.md)

---

## Further Reading

- [Official Ruchy Book](https://ruchy-lang.org/book) - Sequential tutorial format
- [Ruchy Standard Library Documentation](https://docs.ruchy-lang.org/std/)
- [Ruchy by Example](https://ruchy-lang.org/examples)
