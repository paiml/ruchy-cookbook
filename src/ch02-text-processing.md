# Chapter 2: String & Text Processing

## Introduction

This chapter covers string manipulation, text processing, and formatting in Ruchy. Whether you're building user-facing applications, processing log files, or generating reports, these recipes provide practical solutions for common string operations.

## What You'll Learn

- Recipe 2.1: String Formatting - Interpolation and template formatting
- Recipe 2.2: String Slicing and Concatenation
- Recipe 2.3: String Searching and Pattern Matching
- Recipe 2.4: Case Conversion
- Recipe 2.5: Trimming and Padding
- Recipe 2.6: String Splitting and Joining
- Recipe 2.7: Unicode and UTF-8 Handling
- Recipe 2.8: String Validation
- Recipe 2.9: Template String Processing
- Recipe 2.10: Character Operations

## Prerequisites

- Basic understanding of Ruchy syntax (Chapter 1)
- Familiarity with string types and operations
- Understanding of UTF-8 encoding concepts

---

## Recipe 2.1: String Formatting

**Difficulty**: Beginner
**Test Coverage**: 21/21 tests (100%)
**PMAT Grade**: A+

### Problem

You need to format strings by inserting values into templates, combining multiple values with specific separators, or building complex strings from components. String formatting is essential for displaying data to users, generating reports, creating log messages, and building data interchange formats.

### Solution

```ruchy
/// Format a greeting for a single name
pub fun format_greeting(name: &str) -> String {
    format!("Hello, {}!", name)
}

/// Format a full name from first and last names
pub fun format_full_name(first: &str, last: &str) -> String {
    format!("{} {}", first, last)
}

/// Format a message with name and age
pub fun format_message(name: &str, age: i32) -> String {
    format!("{} is {} years old", name, age)
}

/// Build a CSV line from a vector of values
pub fun build_csv(values: Vec<&str>) -> String {
    if values.is_empty() {
        return String::new();
    }
    values.join(",")
}

fun main() {
    // Basic greeting
    println!("{}", format_greeting("Alice"));  // "Hello, Alice!"

    // Multiple values
    println!("{}", format_full_name("Bob", "Smith"));  // "Bob Smith"

    // Mixed types
    println!("{}", format_message("Alice", 30));  // "Alice is 30 years old"

    // Building CSV
    let data = vec!["Alice", "30", "Engineer"];
    println!("{}", build_csv(data));  // "Alice,30,Engineer"
}
```

**Output**:
```
Hello, Alice!
Bob Smith
Alice is 30 years old
Alice,30,Engineer
```

### Discussion

String formatting in Ruchy uses the `format!()` macro, which provides type-safe string interpolation similar to Rust's formatting system.

**How It Works**:

1. **`format!()` Macro**:
   - Takes a format string with `{}` placeholders
   - Accepts any number of arguments to fill placeholders
   - Returns a new `String` (heap-allocated)
   - Type-safe: arguments must implement Display trait

2. **Placeholder Syntax**:
   - `{}` - Display formatting (most common)
   - Placeholders are filled left-to-right with arguments
   - Number of placeholders must match number of arguments

3. **Type Compatibility**:
   - Works with: strings (`&str`, `String`), integers (`i32`, `i64`), floats (`f64`), booleans (`bool`)
   - Automatically handles conversions for display
   - Compile-time type checking prevents runtime errors

**Performance Characteristics**:

- **Time Complexity**: O(n) where n is the total length of formatted string
- **Space Complexity**: O(n) - allocates new String on heap
- **Allocations**: One heap allocation per `format!()` call
- **Alternative for zero-alloc**: Use `write!()` macro with pre-allocated buffer

**Common Pitfalls**:

1. **Placeholder Count Mismatch**:
   ```ruchy
   // ❌ ERROR: Wrong number of arguments
   format!("Hello, {}!", "Alice", "Bob")  // Too many args
   format!("Hello, {} {}!")  // Too few args
   ```

2. **Format String Must Be Literal**:
   ```ruchy
   // ❌ ERROR: format string must be string literal
   let fmt = "Hello, {}!";
   format!(fmt, "Alice")  // Doesn't compile

   // ✅ CORRECT: Use string literal
   format!("Hello, {}!", "Alice")
   ```

3. **Performance**: Don't use `format!()` in tight loops:
   ```ruchy
   // ❌ SLOW: Allocates on every iteration
   for i in 0..10000 {
       let s = format!("Value: {}", i);  // 10,000 allocations
   }

   // ✅ BETTER: Pre-allocate or use write!()
   let mut buf = String::with_capacity(100);
   for i in 0..10000 {
       buf.clear();
       write!(&mut buf, "Value: {}", i);  // Reuses buffer
   }
   ```

**Safety Guarantees**:

- ✅ Type-safe at compile time
- ✅ No buffer overflows (managed String type)
- ✅ UTF-8 guaranteed (Rust/Ruchy strings are always valid UTF-8)
- ✅ No null pointer issues

### Variations

**Variation 1: Number Formatting**

```ruchy
/// Format integers and floats
pub fun format_number(n: i32) -> String {
    format!("The number is {}", n)
}

pub fun format_decimal(n: f64) -> String {
    format!("Pi is approximately {}", n)
}

// Usage
println!("{}", format_number(42));      // "The number is 42"
println!("{}", format_decimal(3.14));   // "Pi is approximately 3.14"
```

**Variation 2: Boolean Formatting**

```ruchy
/// Format boolean status
pub fun format_status(active: bool) -> String {
    format!("Status: {}", active)
}

// Usage
println!("{}", format_status(true));   // "Status: true"
println!("{}", format_status(false));  // "Status: false"
```

**Variation 3: Direct Concatenation (When Format Not Needed)**

```ruchy
/// Simple concatenation without format!()
pub fun concat_strings(a: &str, b: &str) -> String {
    format!("{}{}", a, b)  // Or use: a.to_string() + b
}

pub fun concat_with_separator(a: &str, b: &str, sep: &str) -> String {
    format!("{}{}{}", a, sep, b)
}

// Usage
println!("{}", concat_strings("Hello", "World"));              // "HelloWorld"
println!("{}", concat_with_separator("Hello", "World", " ")); // "Hello World"
```

**Variation 4: Building Complex Strings**

```ruchy
/// Build CSV line from vector
pub fun build_csv(values: Vec<&str>) -> String {
    if values.is_empty() {
        return String::new();
    }
    values.join(",")  // Efficient: single allocation
}

/// Format template with multiple fields
pub fun format_template(name: &str, value: i32) -> String {
    format!("Name: {}, Value: {}", name, value)
}

// Usage
let data = vec!["Alice", "30", "Engineer"];
println!("{}", build_csv(data));  // "Alice,30,Engineer"

println!("{}", format_template("Alice", 42));  // "Name: Alice, Value: 42"
```

**Variation 5: Handling Edge Cases**

```ruchy
/// Format greeting (handles empty strings)
pub fun format_greeting_safe(name: &str) -> String {
    if name.is_empty() {
        format!("Hello!")
    } else {
        format!("Hello, {}!", name)
    }
}

// Usage
println!("{}", format_greeting_safe(""));      // "Hello!"
println!("{}", format_greeting_safe("Alice")); // "Hello, Alice!"
```

### See Also

- Recipe 1.1: Hello World - Basic println!() usage
- Recipe 2.2: String Slicing and Concatenation - More string operations
- Recipe 2.6: String Splitting and Joining - Working with delimiters
- Recipe 2.9: Template String Processing - Advanced templating
- Chapter 7: Command Line Applications - Formatting user output

### Tests

Full test suite: `recipes/ch02/recipe-001/tests/unit_tests.ruchy`

**Test Coverage**:
- ✅ 21/21 unit tests passing
- ✅ Basic single-value formatting
- ✅ Multiple placeholder formatting
- ✅ Integer and float formatting
- ✅ Boolean formatting
- ✅ Empty string handling
- ✅ Special character handling
- ✅ CSV building with edge cases
- ✅ Template formatting

**Key Tests**:

```ruchy
#[test]
fun test_format_single_string() {
    let result = format_greeting("Alice");
    assert_eq!(result, "Hello, Alice!");
}

#[test]
fun test_format_mixed_types() {
    let result = format_message("Alice", 30);
    assert_eq!(result, "Alice is 30 years old");
}

#[test]
fun test_build_csv_line() {
    let values = vec!["Alice", "30", "Engineer"];
    let result = build_csv(values);
    assert_eq!(result, "Alice,30,Engineer");
}

#[test]
fun test_build_csv_empty() {
    let values: Vec<&str> = vec![];
    let result = build_csv(values);
    assert_eq!(result, "");
}
```

---

## Recipe 2.2: String Slicing and Concatenation

**Status**: 🚧 Coming Soon

---

## Recipe 2.3: String Searching and Pattern Matching

**Status**: 🚧 Coming Soon

---

## Recipe 2.4: Case Conversion

**Status**: 🚧 Coming Soon

---

## Recipe 2.5: Trimming and Padding

**Status**: 🚧 Coming Soon

---

## Recipe 2.6: String Splitting and Joining

**Status**: 🚧 Coming Soon

---

## Recipe 2.7: Unicode and UTF-8 Handling

**Status**: 🚧 Coming Soon

---

## Recipe 2.8: String Validation

**Status**: 🚧 Coming Soon

---

## Recipe 2.9: Template String Processing

**Status**: 🚧 Coming Soon

---

## Recipe 2.10: Character Operations

**Status**: 🚧 Coming Soon
