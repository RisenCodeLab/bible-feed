# Agent Instructions

## Critical Rules

### Never Regenerate Injectable Config
- **Do NOT** run `dart run build_runner build` to regenerate injectable configuration files
- **Do NOT** manually update `injectable.config.dart` or `*.mocks.dart` files
- The user will handle injectable config and mock regeneration manually

### Never Create Plan Files
- **Do NOT** create plan markdown files (e.g., `.opencode/plans/*.md`)
- Discuss plans directly in conversation instead

### Preserve Comments During Refactoring
- When refactoring code, always preserve existing comments (including inline and block comments)
- If code is moved, split, or restructured, carry all associated comments along with the logic they describe
- Do not silently drop comments during refactoring — if a comment no longer applies, explicitly flag it for removal rather than discarding it

### Alphabetical Ordering
- Keep imports in alphabetical order within their groups
- Keep class members in alphabetical order within their respective sections
- Keep file names and directory structures alphabetically ordered where applicable

### Class Member Ordering
Members within classes must be ordered as follows:

1. **Injected dependency fields** (final fields from constructor injection)
2. **Constructor**
3. **Private fields** (non-injected, mutable state)
4. **Private getters and setters**
5. **Private methods**
6. **Public getters and setters**
7. **Public methods**

**Exception:** Within a single section, abstract members that define contracts may precede concrete implementations.

## Code Style

### Imports
- Keep imports alphabetically ordered within their groups
- Group imports in this order:
  1. `dart:` imports
  2. `package:` imports
  3. Relative imports (project files)

### General
- Follow existing code conventions in the codebase
- Use Dart best practices and idioms
- Always use super parameters when forwarding constructor parameters to superclass
- Use `@protected` annotation from `package:flutter/foundation.dart` for members intended for subclass use only
- Prefer composition over inheritance where possible
- Always use `dartx` extension methods for Duration literals (e.g., `100.milliseconds`, `5.seconds`) instead of `Duration(milliseconds: 100)`

### Services
- Services wrap external dependencies (platform APIs, third-party libraries)
- Services should be thin wrappers - minimal business logic

### Managers
- Managers coordinate between services and models
- Managers contain business logic and state transitions

### Testing
- When creating stub implementations, ensure they don't trigger platform-specific initialization
- Override platform-dependent getters to throw `UnimplementedError()` in stubs
- Provide sensible default values in stubs to prevent errors during screenshot generation
- Use the Mockito framework for unit testing:
  - Use `@GenerateNiceMocks` with `MockSpec<T>()` to generate mocks
  - Use real model instances, not mocks, for models
  - Mock services and managers that have external dependencies
  - Follow the pattern in `test/unit/manager/bible_reader_launch_manager_test.dart`
  - Use `pumpAsync()` helper to wait for async operations in tests
