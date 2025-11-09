# Recipe 1.7: BLOCKED - Ruchy OO Features Not Available

## Status: BLOCKED

This recipe cannot be implemented because **Ruchy does not support defining methods on structs or classes**.

## Issue

Attempting to define methods inside struct or class bodies results in parse errors:

```
Error: Evaluation error: Expected field name
```

## What Was Attempted

1. **Rust-style syntax**: Used `#[derive]`, `pub`, `impl` blocks - ALL rejected by parser
2. **Simplified syntax**: Removed Rust-isms, tried methods directly in struct/class - FAILED with "Expected field name"
3. **Investigation**: Examined Ruchy examples, found only object literals `{key: value}` work

## What Ruchy Actually Supports

Ruchy uses **object literals** like JavaScript/Ruby:

```ruchy
// This works
let person = {
    name: "Alice",
    age: 30
}
println("{}", person.name)
```

## What Ruchy Does NOT Support

```ruchy
// This FAILS - methods in structs
struct Point {
    x: i32,
    y: i32,

    fun distance(&self) -> f64 {  // ERROR: Expected field name
        // ...
    }
}

// This FAILS - methods in classes
class Person {
    name: String,

    init(name: &str) {
        self.name = name.to_string()
    }

    fun get_name(&self) -> String {  // ERROR: Expected field name
        self.name.clone()
    }
}
```

## Documentation

See detailed bug reports:
- `/home/user/ruchy-cookbook/docs/bugs/oo-syntax-bug.md` (Critical OO bug)
- `/home/user/ruchy-cookbook/RUCHY_ISSUE_SYNTAX_ERROR_REPORT.md` (Syntax errors)

## Impact

- **Recipe 1.7**: CANNOT be implemented
- **All OO recipes**: BLOCKED
- **Design patterns**: BLOCKED
- **Real-world apps**: SEVERELY LIMITED

## Resolution Required

Ruchy needs to implement method syntax support before this recipe can proceed.

## Current Files

- `src/main.ruchy`: Contains Rust-style syntax (INVALID - doesn't compile)
- `tests/*.ruchy`: Contains test code (INVALID - doesn't compile)

All code was written without verification (violated EXTREME TDD) and is non-functional.

---

**Status**: BLOCKED
**Date Blocked**: 2025-11-09
**Blocker**: Ruchy parser doesn't support methods on structs/classes
**Severity**: CRITICAL
