import 'package:api_prov_try/api_services.dart';
import 'package:api_prov_try/comments_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommentsDataClass extends ChangeNotifier {
  List<CommentsModel>? commentsList;
  bool loading = false;
  bool isBack = false;

  Future<void> getPostData() async {
    loading = true;
    commentsList = await fetchPosts();
    loading = false;
    notifyListeners();
  }

  Future<void> getSpecificComment(int commentId) async {
    loading = true;
    commentsList = await fetchSpecificComment(commentId);
    loading = false;
    notifyListeners();
  }

  Future<void> customDismissFunction(int commentId) async {
    await dismissComment(commentId);
  }

  Future<void> postData(CommentsModel body) async {
    loading = true;
    notifyListeners();

    try {
      http.Response response = await addNewPost(body);

      if (response.statusCode == 201) {
        isBack = true;
                print(isBack);

        print(isBack);
      } else {
        print('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error posting data: $e');
    }

    loading = false;
    notifyListeners();
  }



   Future<void> putData(CommentsModel body, String id) async {
    loading = true;
    notifyListeners();

    try {
      http.Response response = await editComment_apiCall(body, id);

      if (response.statusCode == 200) {
        isBack = true;
                print(isBack);

        print("puttttttttttttttttttttttttted");
      } else {
        print('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error posting data: $e');
    }

    loading = false;
    notifyListeners();
  }
}
