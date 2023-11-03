import 'package:api_prov_try/comments_data_class.dart';
import 'package:api_prov_try/widgets/comment_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentsTab extends StatefulWidget {
  const CommentsTab({super.key});

  @override
  State<CommentsTab> createState() => _CommentsTabState();
}

class _CommentsTabState extends State<CommentsTab> {
  //-------------------------------------------------------------------------> INIT

  @override
  void initState() {
    super.initState();
    final postModel = Provider.of<CommentsDataClass>(context, listen: false);
    postModel.getPostData();
  }

  //-----------------------------------------------------------------------> UI PART

  @override
  Widget build(BuildContext context) {
    final commentsProvider = Provider.of<CommentsDataClass>(context);
//-----------------------------------------------------------> LOADER TO COMPENSATE API FETCH DELAY
    if (commentsProvider.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    //----------------------------------------------------> API EMPTY RESPOND HANDLER
    if (commentsProvider.commentsList!.isEmpty) {
      return const Center(child: Text("oops, its empty"));
    }
    return Scaffold(
      body: ListView.builder(
        itemCount: commentsProvider.commentsList?.length,
        itemBuilder: (context, index) {
//-----------------------------------------------> TO PROCESS THE NAME
          String? truncatedName;
          if (commentsProvider.commentsList != null &&
              index < commentsProvider.commentsList!.length) {
            truncatedName = commentsProvider.commentsList![index].name.length >
                    20
                ? '${commentsProvider.commentsList![index].name.substring(0, 20)}...'
                : commentsProvider.commentsList![index].name;
          } else {
            truncatedName = '';
          }

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Dismissible(
              key: ValueKey(commentsProvider.commentsList?[index]),
              onDismissed: (direction) {
                setState(() {
                  commentsProvider.commentsList?.removeAt(index);
                });
                int postId = commentsProvider.commentsList?[index].id ?? 0;
                commentsProvider.customDismissFunction(postId);
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.endToStart,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 212, 208, 208),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(
                              commentsProvider.commentsList?[index].name[0]
                                      .toUpperCase() ??
                                  "",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(truncatedName),
                              Text(
                                commentsProvider.commentsList?[index].email ??
                                    "",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 85, 81, 81),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CommentInput(
                                            editMode: true, postId: index);
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.edit))
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SingleChildScrollView(
                          child: Text(
                            commentsProvider.commentsList?[index].body ?? "",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const CommentInput(editMode: false, postId: 0);
            },
          );
        },
      ),
    );
  }
}
