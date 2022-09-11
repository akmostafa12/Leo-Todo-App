import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/Screens/showNote.dart';
import 'package:todo/DataBase/sqlFlite.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final note = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            FutureBuilder(
              future: Sql(version: 1, table: 'notes').getRecords(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
                if (snapshot.hasData) {
                  final docs = snapshot.data!;
                  final date = DateFormat('dd/MM/yyyy hh:mm');
                  return Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, i) => Card(
                        color: Colors.yellow,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ShowNote(
                                  subject: docs[i]['title'],
                                  date: date.format(
                                      DateTime.parse(docs[i]['clock'])));
                            }));
                          },
                          child: ListTile(
                            title: Text(
                              docs[i]['title'],
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              maxLines: 1,
                            ),
                            trailing: Padding(
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                      child: Text(
                                    date.format(
                                        DateTime.parse(docs[i]['clock'])),
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  )),
                                  Expanded(
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      onPressed: () async {
                                        await Sql(version: 1, table: 'notes')
                                            .deleteColumn(
                                                '${snapshot.data![i]['id']}');
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      itemCount: docs.length,
                      shrinkWrap: true,
                    ),
                  );
                }

                return Expanded(
                  child: Column(
                    children: const [
                      Spacer(
                        flex: 1,
                      ),
                      Center(
                          child: Text(
                        'There Is No Notes Found',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                      Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: (context),
              builder: (context) => Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    TextField(
                      controller: note,
                      decoration: InputDecoration(
                        label: const Text('Add Note'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32)),
                      width: 200,
                      child: MaterialButton(
                        onPressed: () async {
                          await Sql(version: 1, table: 'notes').insertDatabase(
                            note.text,
                            '',
                            '${DateTime.now()}',
                          );
                          note.clear();
                          setState(() {});
                        },
                        color: Colors.yellow,
                        child: const Text('Add',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          backgroundColor: Colors.yellow,
          child: const Icon(Icons.add, color: Colors.black)),
    );
  }
}
