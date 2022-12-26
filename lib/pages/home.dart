// ignore_for_file: prefer_const_constructors, implementation_imports, unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/pages/add_new_note.dart';
import 'package:notes_app/providers/notes_provider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String searchQuery = ""; 

  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => AddNewNote(
                        isUpdate: false,
                      )));
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all((Radius.circular(15)))),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Notes"),
        centerTitle: true,
      ),
      body: notesProvider.isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: (!notesProvider.notes.isEmpty)
                  ? ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(hintText: "Search"),
                            onChanged: (val) {setState(() {
                              searchQuery = val; 
                            });},
                          ),
                        ),
                        notesProvider.getFilteredNotes(searchQuery).length>0?
                        GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemCount: notesProvider.getFilteredNotes(searchQuery).length,
                            itemBuilder: ((context, index) {
                              Note currentnote = notesProvider.getFilteredNotes(searchQuery)[index];
                              return GestureDetector(
                                onTap: (() {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => AddNewNote(
                                                isUpdate: true,
                                                note: currentnote,
                                              )));
                                }),
                                onLongPress: (() {
                                  notesProvider.deleteNote(currentnote);
                                }),
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 2),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentnote.title!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          currentnote.content!,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 7,
                                        ),
                                      ]),
                                ),
                              );
                            })):Padding(child: Text("No Notes Found!",textAlign: TextAlign.center,),padding: EdgeInsets.all(8),),
                      ],
                    )
                  : Center(
                      child: Text("No Note to show"),
                    )),
    );
  }
}
