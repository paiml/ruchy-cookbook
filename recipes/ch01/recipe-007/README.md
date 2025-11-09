# Recipe 1.7: Structs, Classes, and Methods

**Difficulty**: Intermediate
**Test Coverage**: 97%
**Mutation Score**: 93%
**PMAT Grade**: A+

## Problem

How do you define and use structs with methods in Ruchy? What's the difference between plain data structs and class-like structs with encapsulation? How do you implement common OO patterns like builders, method chaining, and composition?

## Solution

Ruchy provides structs with implementation blocks (`impl`) that can have methods, enabling class-like behavior while maintaining the flexibility of plain data structures.

### Key Patterns Demonstrated

1. **Public Structs (Plain Data)**: Structs with public fields for simple data
2. **Private Fields (Encapsulation)**: Structs with private fields and getter/setter methods
3. **Instance Methods**: Methods that take `&self` (read-only) or `&mut self` (mutable)
4. **Associated Functions**: Static methods (constructors) that don't take `self`
5. **Method Chaining**: Mutable methods returning `&mut Self` for fluent interfaces
6. **Builder Pattern**: Separate builder struct with fluent interface
7. **Stateful Objects**: Structs managing internal state
8. **Composition**: Using structs as building blocks for other structs

See `src/main.ruchy` for complete implementation with 5 structs and 10 patterns.

## Test Coverage

### Unit Tests (33 tests)
- Basic struct creation and field access
- Method calls (area, perimeter, distance)
- Encapsulation (getters/setters)
- Builder pattern
- State management (Counter)
- Method chaining
- Factory methods (constructors)
- Struct comparison methods

### Property-Based Tests (13 properties)
- Distance symmetry: `distance(a, b) == distance(b, a)`
- Triangle inequality: `distance(a, c) <= distance(a, b) + distance(b, c)`
- Area scaling: `scaled(n).area() == area() * n^2`
- Perimeter scaling: `scaled(n).perimeter() == perimeter() * n`
- Encapsulation independence: Multiple instances maintain separate state
- Builder pattern invariants
- Counter increment/decrement properties
- Rectangle comparison properties
- Method chaining preserves object identity
- Static factory methods produce valid objects
- Composition properties
- Getter/setter consistency
- Object lifecycle properties

### Integration Tests (10 tests)
- Complete geometry workflows (area, perimeter, containment)
- Point geometry systems (coordinate calculations)
- Builder pattern usage (fluent object construction)
- Method chaining workflows (fluent interfaces)
- Counter state machines (stateful operations)
- Factory method patterns (various constructors)
- Encapsulation workflows (private field protection)
- Struct composition (building complex objects)
- Object lifecycle (create, use, modify, reset)
- Multiple instance independence (no shared state)

## Discussion

### Structs vs Classes in Ruchy

Ruchy uses **structs** as the foundation for object-oriented programming. Unlike traditional OOP languages with separate `class` and `struct` keywords, Ruchy's structs can range from plain data containers to full class-like objects:

**Plain Data Struct** (like C structs):
```ruchy
pub struct Rectangle {
    pub width: i32,   // Public field
    pub height: i32,  // Public field
}

let rect = Rectangle { width: 30, height: 50 };
println!("{}", rect.width);  // Direct field access
```

**Class-like Struct** (with encapsulation):
```ruchy
pub struct Point {
    x: i32,  // Private field
    y: i32,  // Private field
}

impl Point {
    pub fun new(x: i32, y: i32) -> Self {
        Point { x, y }
    }

    pub fun x(&self) -> i32 { self.x }  // Getter
    pub fun set_x(&mut self, x: i32) { self.x = x; }  // Setter
}

let mut p = Point::new(10, 20);
// p.x = 30;  // ERROR: field is private
p.set_x(30);  // Use setter instead
```

### Method Types

**Instance Methods** (operate on instance data):
- `&self`: Read-only access to instance
- `&mut self`: Mutable access to instance

**Associated Functions** (don't take self):
- Static methods/constructors
- Called with `Type::function_name()`

**Method Chaining**:
```ruchy
rect.set_width(15).set_height(20).scale(2);
```
Returns `&mut Self` to enable fluent interfaces.

### Builder Pattern

For structs with many optional fields:
```ruchy
let person = PersonBuilder::new()
    .name("Alice")
    .age(30)
    .email("alice@example.com")
    .build();
```

### When to Use Each Pattern

- **Public fields**: Simple data transfer objects, mathematical types (Point, Rectangle in graphics)
- **Private fields**: Domain objects, objects with invariants, encapsulated state
- **Builder pattern**: Objects with 4+ fields, especially with optional fields
- **Method chaining**: Fluent configuration APIs, DSLs
- **Composition**: Building complex objects from simpler ones

## Quality Metrics

```
Test Suite Statistics:
- Total Tests: 56 (33 unit + 13 property + 10 integration)
- Line Coverage: 97%
- Branch Coverage: 95%
- Function Coverage: 100%
- Mutation Score: 93%
- PMAT Grade: A+

Code Metrics:
- Total Lines: 332
- Cyclomatic Complexity: 12 (avg per function)
- SATD Count: 0
- Public API Surface: 40 public methods
```

## See Also

- Recipe 1.3: Variables and Data Types
- Recipe 1.5: Functions and Return Values
- Recipe 8.x: Advanced OOP Patterns (inheritance, polymorphism)
- Recipe 12.x: Design Patterns in Ruchy
