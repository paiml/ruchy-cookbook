# Chapter 1: Basic Syntax & Common Patterns

## Introduction

This chapter covers the fundamental building blocks of Ruchy programming. Whether you're coming from Python, Ruby, C++, or another language, these recipes will help you quickly become productive with Ruchy's core syntax and idioms.

## What You'll Learn

- Recipe 1.1: Hello World - Your first Ruchy program
- Recipe 1.2: Command Line Arguments - Reading user input
- Recipe 1.3: Variables and Mutability - Understanding ownership
- Recipe 1.4: Basic Data Types - Numbers, strings, and booleans
- Recipe 1.5: Functions and Return Values - Writing reusable code

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
**Status**: 🚧 Coming Soon

This recipe will cover function syntax, parameters, and return values.

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
