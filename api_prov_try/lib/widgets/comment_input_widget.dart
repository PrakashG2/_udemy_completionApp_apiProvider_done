import 'package:api_prov_try/comments_data_class.dart';
import 'package:api_prov_try/comments_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentInput extends StatefulWidget {
  const CommentInput({super.key, required this.editMode, required this.postId});

  final bool editMode;
  final int postId;

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  //---------------------------------------------------------------------> CONTROLLERS

  TextEditingController postIdController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  //---------------------------------------------------------------------> INIT
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.editMode) {
      final commentsProvider =
          Provider.of<CommentsDataClass>(context, listen: false);
      commentsProvider.getSpecificComment(widget.postId);
      setState(() {
        if (commentsProvider.commentsList != null &&
            commentsProvider.commentsList!.isNotEmpty) {
          final comment = commentsProvider.commentsList![
              widget.postId]; // Assuming you're editing the first comment
          postIdController.text = comment.postId.toString();
          idController.text = comment.id.toString();
          nameController.text = comment.name;
          emailController.text = comment.email;
          bodyController.text = comment.body;
        }
      });
    }
  }

  //-------------------------------------------------------------------------> PUT DATA
  Future<void> _editComment(String commentId) async {
    try {
      CommentsModel data = CommentsModel(
        postId: int.parse(postIdController.text),
        id: int.parse(idController.text),
        name: emailController.text,
        email: nameController.text,
        body: bodyController.text,
      );

      var provider = Provider.of<CommentsDataClass>(context, listen: false);
      await provider.putData(data, commentId);
    } catch (e) {
      print('ERROR EDITING COMMENT *****: $e');
    }
  }

  //----------------------------------------------------------------------> POST DATA
  Future<void> _addComment() async {
    try {
      CommentsModel addCommentData = CommentsModel(
        postId: int.parse(postIdController.text),
        id: int.parse(idController.text),
        name: nameController.text,
        email: emailController.text,
        body: bodyController.text,
      );

      var provider = Provider.of<CommentsDataClass>(context, listen: false);
      await provider.postData(addCommentData);
    } catch (e) {
      print('ERROR ADDING COMMENT *****: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.editMode
          ? const Text("EDIT COMMENT")
          : const Text("ADD NEW COMMENT"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: postIdController,
            decoration: const InputDecoration(
              labelText: 'POST ID',
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: idController,
            decoration: const InputDecoration(
              labelText: 'ID',
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'NAME'),
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'E MAIL',
            ),
          ),
          TextField(
            controller: bodyController,
            decoration: const InputDecoration(labelText: 'BODY'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: () {
            if (widget.editMode) {
              _editComment((widget.postId + 1).toString());
            } else {
              _addComment();
            }
          },
          child: const Text('ADD COMMENT'),
        ),
      ],
    );
  }
}
