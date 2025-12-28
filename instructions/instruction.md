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

</STRUCTURE>

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
  Future<${component}Response> ${method}${path}() async {
    final response = await dio.get('${path}');
    return ${component}Response.fromJson(response.data);
  }
}
```

<ERROR>

```dart
/// ${summary}
Future<${component}Response> ${method}${path}() async {
  try  {
    final response = await dio.get('${path}');
    return ${component}Response.fromJson(response.data);
  } on DioException catch (e) {
    final response = e.response;
    final data = response?.data as Map<String, dynamic>?;
    if (data == null) {
      rethrow;
    }
    switch (response?.statusCode) {
      case ${code}:
        throw ${codeError}.fromJson(data);
      default:
        throw ${defaultError}.fromJson(data);
    }
  }
}
```

</ERROR>

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

<ERRORRESPONSE>

```dart
@freezed
class ${component} with _$${component} {
    const factory ${component}({
        // Define fields mapped according to the OpenAPI JSON spec for ${component}
    }) = _${component};

    factory ${component}.fromJson(Map<String, dynamic> json) => _$${component}FromJson(json);
}
```

</ERRORRESPONSE>

<ENUM>

```dart
enum ${component}${property} {
    // Define fields mapped according to the OpenAPI json spec for possible values and details.
}
```

</ENUM>

</DATA>

<INSTRUCTION>

## Instruction

### 1. Select target OpenAPI file

- **Prompt the user for the location of the OpenAPI JSON file or a diff of the
  API specification.**
- If the user provides a **diff** instead of a raw file:
  - Update the existing specification with the changes from the diff.
  - If the file doesn't exist, treat the diff as a new specification.

### 2. Validate the OpenAPI specification

- **Verify that the JSON file is a valid OpenAPI specification.**
- If a diff was provided, ensure the updated specification is valid after
  applying the changes.
- Once validated, use AI to automatically generate:
  - the complete Dart API client, and
  - all required Dart data classes, following the directory layout defined in
    `STRUCTURE` tag.

### 3. Generate request/response models

- For **each schema** in the OpenAPI spec, generate Dart `@freezed` data classes
  for both **Request** and **Response**, following the templates shown in
  `REQUEST` tag and `RESPONSE` tag.
- **Error responses** (such as 400, 401, 404, 500, or default) should **not** be
  generated as request or response classes. Instead, they should follow the
  `ERRORRESPONSE` tag template and be generated as error model classes.
- If a diff was provided, compare the updated specification with existing model
  files to identify:
  - **New schemas** to generate as new model files.
  - **Modified schemas** to update in existing model files.
  - **Removed schemas** to delete from existing model files.
- Map every property to the appropriate Dart type (`String`, `int`, `bool`,
  `double`, `List<T>`, or a custom class for nested objects) according to
  `PRIMITIVES` tag.
- If a schema is reused across multiple requests or responses, generate it as a
  **standalone model file** under `lib/models`.
- If a schema is only used once and is simple, it may be defined **inline** in
  the corresponding request/response model.
- For properties with enumerated values (`enum`), generate Dart enums as in
  `ENUM` tag, using the possible values defined in the OpenAPI specification.
- Ensure all classes support JSON serialization with `fromJson`/`toJson` methods
  and are compatible with code generation.
- After generating the model classes, run:
  - `dart run build_runner build`

### 4. Generate API client classes

- Use `CLIENT` tag as the reference template for client implementation.
- For each OpenAPI tag, create or update a corresponding client file under
  `lib/clients` with the name `${tag}_api_client.dart`.
  - **If the client file does not exist**, create it.
  - **If the client file already exists**, update it based on the changes:
    - **Add** any new endpoints that were added in the specification.
    - **Update** any existing endpoints that were modified in the specification.
    - **Remove** any endpoints that were removed from the specification.
- If a diff was provided, compare the updated specification with the existing
  client code to identify:
  - New endpoints to add.
  - Modified endpoints to update (including changes to request/response models).
  - Removed endpoints to delete.
- For each endpoint:
  - Ensure the **request and response types** used in the client method match
    the generated model classes.
  - Choose a **clear and descriptive method name** based on the HTTP method and
    the endpoint semantics. `${method}${path}` (e.g. `getUsers`) is acceptable,
    but should be refined based on the endpoint summary/description when
    necessary.
  - **Handle error responses** by following the `ERROR` tag template:
    - If error responses such as 400, 401, 404, 500, or default exist in the
      OpenAPI specification, the API client must handle all available status
      codes.
    - If a default error response exists in the specification, the API client
      must handle the default case.
    - Use try-catch blocks with `DioException` to catch HTTP errors and throw
      the appropriate error response model based on the status code.

### 5. Verify generated code

- Run the linter and **fix any lint errors** introduced by the generated code.
- **Run all unit tests** and ensure they pass.

</INSTRUCTION>
