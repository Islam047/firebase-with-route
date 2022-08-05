import 'dart:math';

import 'package:firebase_note_one/models/post_model.dart';
import 'package:firebase_note_one/pages/services/database_service/shared_preferances.dart';
import 'package:firebase_note_one/pages/services/rtdb_service.dart';
import 'package:firebase_note_one/pages/services/utils_service.dart';

import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  static const id = "/detail_page";
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool isLoading = false;

  void _addPost() async{
    String title = titleController.text.trim();
    String content = contentController.text.trim();

    if(title.isEmpty || content.isEmpty) {
      Utils.fireSnackBar("Please fill all fields", context);
      return;
    }
    isLoading = true;
    setState(() {});

    String userId = await DBService.loadUserId() ?? "null";
    Post post = Post(id: Random().nextInt(10000), userId: userId, title: title, content: content);
    await RTDBService.storePost(post).then((value) {
      Navigator.of(context).pop();
    });

    isLoading = false;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // #title
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: "title",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20,),

                  // #content
                  TextField(
                    controller: contentController,
                    decoration: const InputDecoration(
                      hintText: "Content",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 20,),

                  // #sign_in
                  ElevatedButton(
                    onPressed: _addPost,
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)
                    ),
                    child: const Text("Add", style: TextStyle(fontSize: 16),),
                  ),
                ],
              ),
            ),
          ),

          Visibility(
            visible: isLoading,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }
}