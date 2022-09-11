import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/DataBase/sqlFlite.dart';

class ToDo extends StatefulWidget {
  const ToDo({Key? key}) : super(key: key);

  @override
  State<ToDo> createState() => _NotesState();
}

class _NotesState extends State<ToDo> {
  final title = TextEditingController();
  final subTitle = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Todo',
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
              future: Sql(version: 2, table: 'todo').getRecords(),
              builder: (context, AsyncSnapshot<List<Map>> snapshot) {
                if (snapshot.hasData) {
                  final docs = snapshot.data!;
                  final date = DateFormat('dd/MM/yyyy hh:mm');
                  return Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, i) => Card(
                        color: Colors.blue,
                        child: ListTile(
                          title: Text(
                            docs[i]['title'],
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle: Text(
                            docs[i]['subtitle'],
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white60),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                    child: Text(
                                  date.format(DateTime.parse(docs[i]['clock'])),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                                Expanded(
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    onPressed: () async {
                                      await Sql(version: 2, table: 'todo')
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
                        'There Is No Tasks Found',
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
                      controller: title,
                      decoration: InputDecoration(
                        label: const Text('Add Title'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: subTitle,
                      decoration: InputDecoration(
                        label: const Text('Add Subtitle'),
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
                          await Sql(version: 2, table: 'todo').insertDatabase(
                            title.text,
                            subTitle.text,
                            '${DateTime.now()}',
                          );
                          title.clear();
                          subTitle.clear();
                          setState(() {});
                        },
                        color: Colors.blue,
                        child: const Text(
                          'Add',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add, color: Colors.white)),
    );
  }
}
