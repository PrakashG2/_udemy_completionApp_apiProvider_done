import 'package:api_prov_try/comments_data_class.dart';
import 'package:api_prov_try/comments_model.dart';
import 'package:api_prov_try/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CommentsDataClass(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomeScreen()),
    );
  }
}

class ProviderDemoScreen extends StatefulWidget {
  const ProviderDemoScreen({Key? key}) : super(key: key);

  @override
  _ProviderDemoScreenState createState() => _ProviderDemoScreenState();
}

class _ProviderDemoScreenState extends State<ProviderDemoScreen> {
  ///////////////////////////

  Future<void> _registration() async {
    int postId = 100;
    int id = 100;
    String email = "test";
    String name = "test";
    String body = "body test";
    CommentsModel data = CommentsModel(
      postId: postId,
      id: id,
      name: name,
      email: email,
      body: body,
    );

    var provider = Provider.of<CommentsDataClass>(context, listen: false);

    try {
      await provider.postData(data);
      if (provider.isBack) {
        print("jeichitton-----------------------");
      }
    } catch (e) {
      print("jeichitton-----------------------");

      print('Error registering comment: $e');
    }
  }

  ///
  ////////

  ///
  Future<void> _putRequest(String Postid) async {
    int postId = 100;
    int id = 100;
    String email = "test";
    String name = "test";
    String body = "body test";
    CommentsModel data = CommentsModel(
      postId: postId,
      id: id,
      name: name,
      email: email,
      body: body,
    );

    var provider = Provider.of<CommentsDataClass>(context, listen: false);

    try {
      await provider.putData(data, Postid);
      if (provider.isBack) {
        print("jeichitton-----------------------");
      }
    } catch (e) {
      print("jeichitton-----------------------");

      print('Error registering comment: $e');
    }
  }

  ///
  @override
  void initState() {
    super.initState();
    final postModel = Provider.of<CommentsDataClass>(context, listen: false);
    postModel.getPostData();
  }

  @override
  Widget build(BuildContext context) {
    final postModel = Provider.of<CommentsDataClass>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Provider Demo"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: postModel.loading
            ? Center(
                child: Container(
                  child: SpinKitThreeBounce(
                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: index.isEven ? Colors.red : Colors.green,
                        ),
                      );
                    },
                  ),
                ),
              )
            : ListView.builder(
                itemCount: postModel.commentsList?.length,
                itemBuilder: (context, Index) {
                  String? truncatedName;
                  if (postModel.commentsList != null &&
                      Index < postModel.commentsList!.length) {
                    truncatedName = postModel.commentsList![Index].name.length >
                            20
                        ? postModel.commentsList![Index].name.substring(0, 20) +
                            '...'
                        : postModel.commentsList![Index].name;
                  } else {
                    truncatedName = '';
                  }

                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Dismissible(
                      key: ValueKey(postModel.commentsList?[Index].id),
                      onDismissed: (direction) {
                        int postId = postModel.commentsList?[Index].id ??
                            0; // Assuming 'id' is the unique identifier of the comment
                        postModel.customDismissFunction(postId);
                      },
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete, color: Colors.white),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
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
                                      postModel.commentsList?[Index].name[0]
                                              .toUpperCase() ??
                                          "",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(truncatedName),
                                      Text(
                                        postModel.commentsList?[Index].email ??
                                            "",
                                        style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 85, 81, 81),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            _putRequest(Index.toString());
                                          },
                                          icon: Icon(Icons.edit))
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: SingleChildScrollView(
                                  child: Text(
                                    postModel.commentsList?[Index].body ?? "",
                                    style: TextStyle(fontSize: 16),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _registration,
        child: Icon(Icons.add),
      ),
    );
  }
}
