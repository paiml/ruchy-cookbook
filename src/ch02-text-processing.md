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

**Difficulty**: Beginner
**Test Coverage**: 27/27 tests (100%)
**PMAT Grade**: A+

### Problem

You need to extract parts of strings, get substrings, access individual characters, or combine multiple strings together. String slicing and concatenation are fundamental operations for text processing, parsing, and string manipulation.

### Solution

```ruchy
/// Get the first n characters from a string
pub fun get_first_n_chars(s: &str, n: usize) -> String {
    s.chars().take(n).collect()
}

/// Get the last n characters from a string
pub fun get_last_n_chars(s: &str, n: usize) -> String {
    let char_count = s.chars().count();
    if n >= char_count {
        return s.to_string();
    }
    s.chars().skip(char_count - n).collect()
}

/// Get a substring by character positions
pub fun get_substring(s: &str, start: usize, end: usize) -> String {
    s.chars().skip(start).take(end - start).collect()
}

/// Concatenate two strings
pub fun concat_two(a: &str, b: &str) -> String {
    format!("{}{}", a, b)
}

/// Get character at specific index
pub fun get_char_at(s: &str, index: usize) -> Option<char> {
    s.chars().nth(index)
}

/// Check if string starts with a prefix
pub fun check_starts_with(s: &str, prefix: &str) -> bool {
    s.starts_with(prefix)
}

/// Repeat a string n times
pub fun repeat_string(s: &str, count: usize) -> String {
    s.repeat(count)
}

fun main() {
    let text = "Hello, World!";

    println!("{}", get_first_n_chars(text, 5));    // "Hello"
    println!("{}", get_last_n_chars(text, 6));      // "World!"
    println!("{}", get_substring(text, 7, 12));     // "World"
    println!("{:?}", get_char_at(text, 0));         // Some('H')
    println!("{}", check_starts_with(text, "Hello")); // true
    println!("{}", repeat_string("Ha", 3));         // "HaHaHa"
}
```

**Output**:
```
Hello
World!
World
Some('H')
true
HaHaHa
```

### Discussion

String slicing in Ruchy operates on Unicode characters (not bytes), ensuring correct handling of multi-byte UTF-8 sequences.

**How It Works**:

1. **Character-Based Operations**:
   - `.chars()` returns an iterator over Unicode scalar values
   - `.take(n)` takes first n items from iterator
   - `.skip(n)` skips first n items
   - `.collect()` gathers iterator items into a String

2. **Slicing Methods**:
   - **First n chars**: `s.chars().take(n).collect()`
   - **Last n chars**: Count total, then skip(total - n)
   - **Substring**: Combine `skip(start)` and `take(end - start)`
   - **Character at index**: `.nth(index)` returns `Option<char>`

3. **Concatenation Options**:
   - **`format!()` macro**: `format!("{}{}", a, b)` - Type-safe, allocates once
   - **`.join()` method**: `vec.join("")` - Efficient for multiple strings
   - **`.repeat()` method**: Built-in for string repetition

4. **Prefix/Suffix Checks**:
   - `.starts_with(prefix)` - Check if string begins with prefix
   - `.ends_with(suffix)` - Check if string ends with suffix
   - Both are O(m) where m is prefix/suffix length

**Performance Characteristics**:

- **Time Complexity**:
  - `get_first_n_chars`: O(n) - iterates n characters
  - `get_last_n_chars`: O(m + n) - counts all (m) + skips (m-n)
  - `get_substring`: O(start + length) - skips + takes
  - `concat_two`: O(a + b) - allocates and copies both strings
  - `repeat_string`: O(n * len) - n repetitions of string length

- **Space Complexity**: O(result_length) for all operations

- **UTF-8 Safety**: All operations work correctly with multi-byte characters

**Common Pitfalls**:

1. **Byte vs Character Indexing**:
   ```ruchy
   // ❌ WRONG: Byte indexing can panic with UTF-8
   let s = "Hello 世界";
   // Direct byte access is unsafe for multi-byte chars

   // ✅ CORRECT: Use character-based iteration
   let first = s.chars().next();  // Safe for any UTF-8
   ```

2. **Performance with Large Strings**:
   ```ruchy
   // ❌ SLOW: Multiple allocations in loop
   let mut result = String::new();
   for word in words {
       result = concat_two(&result, word);  // O(n²) copies!
   }

   // ✅ BETTER: Use join() or push_str()
   let result = words.join("");  // O(n) single allocation
   ```

3. **Empty String Handling**:
   ```ruchy
   // Always check bounds
   let char_opt = get_char_at("", 0);  // Returns None
   assert_eq!(char_opt, None);  // Safe, no panic
   ```

**Safety Guarantees**:

- ✅ No panics on empty strings (returns empty String or None)
- ✅ No panics on out-of-bounds access (Option<char>)
- ✅ UTF-8 correctness guaranteed
- ✅ No buffer overflows
- ✅ Character boundary safety (no partial UTF-8 sequences)

### Variations

**Variation 1: Skip First N Characters**

```ruchy
pub fun skip_first_n_chars(s: &str, n: usize) -> String {
    s.chars().skip(n).collect()
}

// Usage
println!("{}", skip_first_n_chars("Hello, World!", 7));  // "World!"
```

**Variation 2: Concatenate Multiple Strings**

```ruchy
pub fun concat_all(parts: Vec<&str>) -> String {
    parts.join("")
}

// Usage
let parts = vec!["Hello", " ", "beautiful", " ", "World"];
println!("{}", concat_all(parts));  // "Hello beautiful World"
```

**Variation 3: Concatenate with Space**

```ruchy
pub fun concat_with_space(a: &str, b: &str) -> String {
    format!("{} {}", a, b)
}

// Usage
println!("{}", concat_with_space("Hello", "World"));  // "Hello World"
```

**Variation 4: Check Prefix and Suffix**

```ruchy
pub fun check_ends_with(s: &str, suffix: &str) -> bool {
    s.ends_with(suffix)
}

// Usage
println!("{}", check_ends_with("test.txt", ".txt"));  // true
println!("{}", check_ends_with("test.rs", ".txt"));   // false
```

**Variation 5: Safe Character Extraction with Default**

```ruchy
pub fun get_char_or_default(s: &str, index: usize, default: char) -> char {
    s.chars().nth(index).unwrap_or(default)
}

// Usage
println!("{}", get_char_or_default("Hello", 0, '?'));   // 'H'
println!("{}", get_char_or_default("Hello", 100, '?')); // '?'
```

### See Also

- Recipe 2.1: String Formatting - Combining values into strings
- Recipe 2.6: String Splitting and Joining - Working with delimiters
- Recipe 2.7: Unicode and UTF-8 Handling - Advanced Unicode operations
- Recipe 2.10: Character Operations - Character-level manipulation
- Chapter 1: Basic Syntax - Vectors and iteration basics

### Tests

Full test suite: `recipes/ch02/recipe-002/tests/unit_tests.ruchy`

**Test Coverage**:
- ✅ 27/27 unit tests passing
- ✅ First n characters extraction (3 tests)
- ✅ Last n characters extraction (1 test)
- ✅ Skip first n characters (1 test)
- ✅ Substring extraction (2 tests)
- ✅ Two-string concatenation (2 tests)
- ✅ Multiple string concatenation (2 tests)
- ✅ Character access (4 tests)
- ✅ Prefix checking (2 tests)
- ✅ Suffix checking (2 tests)
- ✅ String repetition (3 tests)

**Key Tests**:

```ruchy
#[test]
fun test_get_first_chars() {
    let result = get_first_n_chars("Hello, World!", 5);
    assert_eq!(result, "Hello");
}

#[test]
fun test_get_last_chars() {
    let result = get_last_n_chars("Hello, World!", 6);
    assert_eq!(result, "World!");
}

#[test]
fun test_get_substring_range() {
    let result = get_substring("Hello, World!", 0, 5);
    assert_eq!(result, "Hello");
}

#[test]
fun test_get_char_at_out_of_bounds() {
    let result = get_char_at("Hello", 10);
    assert_eq!(result, None);
}

#[test]
fun test_repeat_string() {
    let result = repeat_string("Ha", 3);
    assert_eq!(result, "HaHaHa");
}
```

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
