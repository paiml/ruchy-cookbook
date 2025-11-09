# Bug Report: Object-Oriented Syntax Not Working in Ruchy

## Summary

Ruchy claims to support object-oriented programming with structs and classes, but the syntax for defining methods inside struct/class definitions does not work, resulting in `Expected field name` parse errors.

## Environment

- **Ruchy Version**: 3.211.0
- **Installation**: `cargo install ruchy`
- **Platform**: Linux
- **Date**: 2025-11-09

## Problem

The Ruchy language documentation and class-sugar specification suggest that methods can be defined inside struct and class definitions, similar to languages like Ruby, Python, or Swift. However, attempting to use this syntax results in parse errors.

## Reproduction

### Minimal Failing Example

```ruchy
struct Rectangle {
    width: i32,
    height: i32,

    fun area(&self) -> i32 {
        self.width * self.height
    }
}

fun main() {
    let rect = Rectangle { width: 10, height: 20 }
    println("{}", rect.area())
}
```

### Error Message

```
Error: Evaluation error: Expected field name
```

### What We Expected

Based on the class-sugar specification and OO feature claims, we expected:
- Methods defined inside struct/class bodies
- Instance methods with `&self` parameter
- Mutating methods with `&mut self` parameter
- Associated functions (static methods)

### What Actually Works

Only field declarations work inside struct/class:

```ruchy
// This works
struct Rectangle {
    width: i32,
    height: i32
}

// This does NOT work
struct Rectangle {
    width: i32,
    height: i32,

    fun area(&self) -> i32 {  // ERROR: Expected field name
        self.width * self.height
    }
}
```

## Testing Matrix

| Syntax Pattern | Expected | Actual | Status |
|----------------|----------|--------|--------|
| `struct Point { x: i32, y: i32 }` | ✅ Works | ✅ Works | ✅ PASS |
| `class Person { name: String, init(...) {} }` | ✅ Works | ✅ Works | ✅ PASS |
| `struct Point { x: i32, fun get_x() {} }` | ✅ Should work | ❌ Parse error | ❌ FAIL |
| `class Person { name: String, fun get_name() {} }` | ✅ Should work | ❌ Parse error | ❌ FAIL |
| Rust-style `impl` blocks | ❌ Not supported | ❌ Parse error | ✅ Expected |
| Methods outside struct/class | ❓ Unclear | ❓ Unknown | ❓ Untested |

## Impact

**Severity: CRITICAL** - This blocks all object-oriented programming in Ruchy.

### Immediate Impact

1. **Cannot define methods on structs**: No way to associate functions with data structures
2. **Cannot define methods on classes**: Classes are useless without methods
3. **No encapsulation**: Cannot hide implementation details behind methods
4. **Documentation is misleading**: Claims OO support that doesn't work
5. **Cookbook development blocked**: Cannot write OO recipes

### Development Impact

- **Recipe 1.7 (Structs, Classes, and Methods)**: COMPLETELY BLOCKED
- **All OO-style recipes**: BLOCKED
- **Design patterns requiring OO**: BLOCKED
- **Real-world Ruchy applications**: SEVERELY LIMITED

## Investigation Questions

### 1. Is there an alternative syntax?

Maybe methods are defined some other way?

**Possibilities to test**:
```ruchy
// Option 1: Methods defined outside (like Go)?
struct Rectangle {
    width: i32,
    height: i32
}

fun Rectangle::area(self: &Rectangle) -> i32 {
    self.width * self.height
}

// Option 2: Free functions only?
fun area_of_rectangle(rect: &Rectangle) -> i32 {
    rect.width * rect.height
}

// Option 3: Extension syntax?
extend Rectangle {
    fun area(&self) -> i32 {
        self.width * self.height
    }
}
```

### 2. What about class methods?

The class-sugar test showed `class` and `init` work:

```ruchy
class Person {
    name: String,
    age: i32,

    init(name: &str, age: i32) {
        self.name = name.to_string()
        self.age = age
    }
}
```

**But can we add other methods?**

```ruchy
class Person {
    name: String,
    age: i32,

    init(name: &str, age: i32) {
        self.name = name.to_string()
        self.age = age
    }

    fun get_name(&self) -> String {  // Does this work?
        self.name.clone()
    }
}
```

### 3. Is the parser incomplete?

The error `Expected field name` suggests the parser:
- Expects only field declarations inside struct/class bodies
- Doesn't recognize `fun` as a valid keyword in that context
- May have incomplete implementation of OO features

## Workarounds

Until this is fixed, possible workarounds:

### Workaround 1: Free Functions

```ruchy
struct Rectangle {
    width: i32,
    height: i32
}

fun rectangle_area(rect: &Rectangle) -> i32 {
    rect.width * rect.height
}

fun main() {
    let rect = Rectangle { width: 10, height: 20 }
    println("{}", rectangle_area(&rect))
}
```

**Pros**: Works now
**Cons**: Not object-oriented, loses encapsulation

### Workaround 2: Module-based Organization

```ruchy
mod rectangle {
    struct Rectangle {
        width: i32,
        height: i32
    }

    fun new(width: i32, height: i32) -> Rectangle {
        Rectangle { width, height }
    }

    fun area(rect: &Rectangle) -> i32 {
        rect.width * rect.height
    }
}
```

**Pros**: Some organization
**Cons**: Still not OO, verbose

## Recommended Actions

### Immediate (Priority 1)

1. **Update documentation**: Remove claims of OO support until methods work
2. **Add parser support**: Implement method parsing inside struct/class bodies
3. **Write language tests**: Test suite for OO syntax patterns
4. **Fix or document**: Either fix the parser OR clearly document limitations

### Short-term (Priority 2)

1. **Implement method syntax**: Full support for:
   - Instance methods (`fun foo(&self)`)
   - Mutating methods (`fun foo(&mut self)`)
   - Associated functions (`fun new() -> Self`)
   - Static methods

2. **Add examples**: Working examples in documentation

3. **Error messages**: Improve "Expected field name" to suggest alternatives

### Long-term (Priority 3)

1. **OO feature completeness**:
   - Inheritance/traits
   - Interfaces
   - Polymorphism
   - Access control (private/public)

2. **IDE support**: Syntax highlighting, autocomplete for methods

3. **Standard library**: OO-style APIs using the new syntax

## Expected Behavior

### Struct with Methods

```ruchy
struct Rectangle {
    width: i32,
    height: i32,

    // Constructor (associated function)
    fun new(width: i32, height: i32) -> Rectangle {
        Rectangle { width, height }
    }

    // Instance method
    fun area(&self) -> i32 {
        self.width * self.height
    }

    // Mutating method
    fun scale(&mut self, factor: i32) {
        self.width *= factor
        self.height *= factor
    }
}

fun main() {
    let mut rect = Rectangle::new(10, 20)
    println!("Area: {}", rect.area())  // Should print: Area: 200

    rect.scale(2)
    println!("Area: {}", rect.area())  // Should print: Area: 800
}
```

### Class with Methods

```ruchy
class Person {
    name: String,
    age: i32,

    // Constructor (required for classes)
    init(name: &str, age: i32) {
        self.name = name.to_string()
        self.age = age
    }

    // Instance method
    fun get_name(&self) -> String {
        self.name.clone()
    }

    // Mutating method
    fun set_age(&mut self, new_age: i32) {
        self.age = new_age
    }

    // Method with side effects
    fun have_birthday(&mut self) {
        self.age += 1
    }
}

fun main() {
    let mut person = Person("Alice", 30)
    println!("{} is {} years old", person.get_name(), person.age)

    person.have_birthday()
    println!("{} is {} years old", person.get_name(), person.age)
}
```

## Related Issues

- Confusing parse errors for unsupported syntax (see RUCHY_ISSUE_SYNTAX_ERROR_REPORT.md)
- Missing language reference documentation
- Incomplete OO feature implementation

## Testing Checklist

Before closing this bug, verify:

- [ ] Simple struct with one method compiles
- [ ] Struct with multiple methods compiles
- [ ] Struct with constructor function compiles
- [ ] Struct with mutating methods compiles
- [ ] Class with methods besides `init` compiles
- [ ] Class with multiple methods compiles
- [ ] Method calls work correctly
- [ ] Self parameter (`&self`, `&mut self`) works
- [ ] Associated functions work (`Rectangle::new()`)
- [ ] Documentation updated with working examples
- [ ] Error messages improved for common mistakes

## Files Affected

This bug blocks development of:
- `recipes/ch01/recipe-007/` (Structs, Classes, and Methods)
- All OO-focused recipes in the cookbook
- Any real-world Ruchy application using OO patterns

## Conclusion

This is a **CRITICAL BUG** that makes Ruchy's OO claims misleading. The language parser does not support defining methods inside struct or class bodies, despite documentation suggesting otherwise. This needs immediate attention.

---

**Reporter**: Claude Code (AI-assisted development)
**Date**: 2025-11-09
**Ruchy Version**: 3.211.0
**Severity**: CRITICAL (blocks OO development)
**Status**: UNRESOLVED
