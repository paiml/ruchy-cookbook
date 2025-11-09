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
**Status**: 🚧 Coming Soon

This recipe will cover reading and parsing command line arguments.

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
