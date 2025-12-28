import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

class Service {
  Handler getHandler() {
    final router = Router();

    router.get('/v1/users', (Request request) {
      final users = [
        {
          'id': '1',
          'name': 'John Doe',
          'email': 'john.doe@example.com',
          'age': 20,
          'location': {'latitude': 1.0, 'longitude': 1.0},
          'active': true,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        },
      ];
      return Response.ok(
        jsonEncode(users),
        headers: {'Content-Type': 'application/json'},
      );
    });

    router.post('/v1/users', (Request request) async {
      final notFound = {'code': 'NOT_FOUND', 'message': 'User not found'};
      return Response.notFound(
        jsonEncode(notFound),
        headers: {'Content-Type': 'application/json'},
      );
      // final user = jsonDecode(await request.readAsString());
      // return Response.ok(
      //   jsonEncode(user),
      //   headers: {'Content-Type': 'application/json'},
      // );
    });

    router.get('/v1/users/<id>', (Request request, String id) {
      final user = {
        'id': '1',
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'age': 20,
        'location': {'latitude': 1.0, 'longitude': 1.0},
        'active': true,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };
      return Response.ok(
        jsonEncode(user),
        headers: {'Content-Type': 'application/json'},
      );
    });

    router.get('/v1/users/<id>/posts', (Request request, String id) {
      final posts = [
        {
          'id': '1',
          'title': 'Post 1',
          'content': 'Content 1',
          'tags': ['tag1', 'tag2'],
          'category': 'technology',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        },
      ];
      return Response.ok(
        jsonEncode(posts),
        headers: {'Content-Type': 'application/json'},
      );
    });

    router.post('/v1/users/<id>/posts', (Request request, String id) async {
      final post = jsonDecode(await request.readAsString());
      return Response.ok(
        jsonEncode(post),
        headers: {'Content-Type': 'application/json'},
      );
    });

    return Pipeline().addMiddleware(logRequests()).addHandler(router);
  }
}

Future<void> main(List<String> arguments) async {
  final service = Service();
  final server = await serve(service.getHandler(), 'localhost', 8080);
  print('Server is running on http://localhost:${server.port}');
}
