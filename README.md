# openapi_ai_generation

A demonstration project for generating API clients with AI agents from OpenAPI
specifications.

This project showcases how AI agents can automatically generate Dart API clients
and related data classes from OpenAPI JSON specifications, including:

- **API Client Classes**: Automatically generated client classes for each API
  tag
- **Request/Response Models**: Type-safe data models using `@freezed`
  annotations
- **Error Handling**: Proper error response handling with custom exception
  classes
- **Type Mapping**: Automatic mapping from OpenAPI types to Dart types

## Project Structure

```
lib/
├── models/          # Generated data models (requests, responses, errors)
└── clients/         # Generated API client classes
```

## Getting Started

See `instructions/instruction.md` for detailed information on how the generation
process works and the templates used for code generation.
