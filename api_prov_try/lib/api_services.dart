// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:api_prov_try/comments_data_class.dart';
// import 'package:api_prov_try/comments_model.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';

// Future<DataModel?> getSinglePostData() async {
//   DataModel? result;
//   try {
//     final response = await http.get(
//       Uri.parse("https://jsonplaceholder.typicode.com/posts/2"),
//       headers: {
//         HttpHeaders.contentTypeHeader: "application/json",
//       },);
//     if (response.statusCode == 200) {
//       final item = json.decode(response.body);
//       result = DataModel.fromJson(item);
//     } else {
//       print("error");
//     }
//   } catch (e) {
//     log(e.toString());
//   }
//   return result;
// }

import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:api_prov_try/comments_model.dart';
import 'package:http/http.dart' as http;

Future<List<CommentsModel>> fetchPosts() async {
  List<CommentsModel> result = [];
  try {
    final response = await http.get(
      Uri.parse("https://jsonplaceholder.typicode.com/comments"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> items = json.decode(response.body);
      result = items.map((item) => CommentsModel.fromJson(item)).toList();
    } else {
      print("Error code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error code: $e");
    rethrow;
  }
  return result;
}

Future<List<CommentsModel>> fetchSpecificComment(int commentId) async {
  List<CommentsModel> comment = [];
  try {
    final response = await http.get(
      Uri.parse("https://jsonplaceholder.typicode.com/comments/${commentId+1}"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> items = json.decode(response.body);
      comment = items.map((item) => CommentsModel.fromJson(item)).toList();
    } else {
      print("ERROR @ fetchSpecificComment ***** : ${response.statusCode}");
    }
  } catch (e) {
    print("ERROR @ fetchSpecificComment ***** : $e");
    print("neeyada athu----------------------");
    rethrow;
  }
  return comment;
}

Future<void> dismissComment(int commentId) async {
  try {
    final url = 'https://jsonplaceholder.typicode.com/comments/$commentId';
    final uri = Uri.parse(url);

    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      print('-------------------------------------------------------------');
      print('Post deleted successfully:--- response code = 200');
      print('Deleted Post ID: $commentId');
      print('-------------------------------------------------------------');
    } else {
      print('Failed to delete post');
    }
    if (response.statusCode == 200) {
      print('Comment dismissed successfully');
    } else {
      print('Failed to dismiss comment: ${response.statusCode}');
    }
  } catch (e) {
    print('Error dismissing comment: $e');
  }
}

Future<http.Response> addNewPost(CommentsModel data) async {
  http.Response response;
  try {
    response = await http.post(
      Uri.parse("https://jsonplaceholder.typicode.com/posts"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 201) {
      print(response.body);
      print('New post added successfully');
    } else {
      print('Failed to add new post: ${response.statusCode}');
    }
  } catch (e) {
    print('Error adding new post: $e');
    rethrow; // Rethrow the exception after printing the error
  }
  return response;
}

Future<http.Response> editComment_apiCall(CommentsModel data, String id) async {
  http.Response response;
  try {
    response = await http.put(
      Uri.parse("https://jsonplaceholder.typicode.com/posts/$id"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 200) {
      print(response.body);
      print('successfully put');
    } else {
      print('Failed to put post: ${response.statusCode}');
    }
  } catch (e) {
    print('Error putting post: $e');
    rethrow; // Rethrow the exception after printing the error
  }
  return response;
}
