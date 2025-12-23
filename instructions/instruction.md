This document describes how to generate a Dart API client and related data
classes from an OpenAPI JSON specification.

<STRUCTURE>

```
lib
├── models
│   └── ${component}
│       ├── ${component}_request.dart
│       └── ${component}_response.dart
└── clients
    └── ${tag}_api_client.dart
```

/STRUCTURE>

<PRIMITIVES>

The following table defines the default mapping from OpenAPI primitive types and
formats to Dart types:

```
OpenAPI type       OpenAPI format      Dart type
-------------------------------------------------------
string             -                   String
string             date                DateTime
string             date-time           DateTime
string             binary              List<int>
integer            int32               int
integer            int64               int
number             float               double
number             double              double
boolean            -                   bool
array              -                   List<T>
object             -                   T
```

</PRIMITIVES>

<DATA>

<CLIENT>

```dart
import 'package:dio/dio.dart';

class ${tag}ApiClient {
  ${tag}ApiClient({required this.dio});

  final Dio dio;

  /// ${summary}
  ///
  /// ${description}
  Future<${component}Response> ${method}${path}() async {
    final response = await dio.get('${path}');
    return ${component}Response.fromJson(response.data);
  }
}
```

</CLIENT>

<RESPONSE>

```dart
@freezed
class ${component}Response with _$${component}Response {
  const factory ${component}Response({
    // Define fields mapped according to the OpenAPI JSON spec for ${component}
  }) = _${component}Response;

factory
${component}Response.fromJson(Map<String, dynamic> json) => _$${component}ResponseFromJson(json);
}
```

</RESPONSE>

<REQUEST>

```dart
@freezed
class ${component}Request with _$${component}Request {
    const factory ${component}Request({
        // Define fields mapped according to the OpenAPI JSON spec for ${component}
    }) = _${component}Request;

    factory ${component}Request.fromJson(Map<String, dynamic> json) => _$${component}RequestFromJson(json);
}
```

</REQUEST>

<ENUM>

```dart
enum ${component}${property} {
    // Define fields mapped according to the OpenAPI json spec for possible values and details.
}
```

}</ENUM>

</DATA>

<INSTRUCTION>

## Instruction

### 1. Select target OpenAPI file

- **Prompt the user for the OpenAPI JSON file**, for example `api.json`.

### 2. Validate the OpenAPI specification

- **Verify that the JSON file is a valid OpenAPI specification.**
- Once validated, use AI to automatically generate:
  - the complete Dart API client, and
  - all required Dart data classes, following the directory layout defined in
    <STRUCTURE>.

### 3. Generate request/response models

- For **each schema** in the OpenAPI spec, generate Dart `@freezed` data classes
  for both **Request** and **Response**, following the templates shown in
  <REQUEST> and <RESPONSE>.
- Map every property to the appropriate Dart type (`String`, `int`, `bool`,
  `double`, `List<T>`, or a custom class for nested objects) according to
  <PRIMITIVES>.
- If a schema is reused across multiple requests or responses, generate it as a
  **standalone model file** under `lib/models`.
- If a schema is only used once and is simple, it may be defined **inline** in
  the corresponding request/response model.
- For properties with enumerated values (`enum`), generate Dart enums as in
  <ENUM>, using the possible values defined in the OpenAPI specification.
- Ensure all classes support JSON serialization with `fromJson`/`toJson` methods
  and are compatible with code generation.
- After generating the model classes, run:
  - `dart run build_runner build`

### 4. Generate API client classes

- Use <CLIENT> as the reference template for client implementation.
- For each OpenAPI tag, create or update a corresponding client file under
  `lib/clients` with the name `${tag}_api_client.dart`.
  - **If the client file does not exist**, create it.
  - **If the client file already exists**, update it and add any missing
    endpoints.
- For each endpoint:
  - Ensure the **request and response types** used in the client method match
    the generated model classes.
  - Choose a **clear and descriptive method name** based on the HTTP method and
    the endpoint semantics. `${method}${path}` (e.g. `getUsers`) is acceptable,
    but should be refined based on the endpoint summary/description when
    necessary.

### 5. Verify generated code

- Run the linter and **fix any lint errors** introduced by the generated code.
- **Run all unit tests** and ensure they pass.

</INSTRUCTION>
