import 'package:flutter/material.dart';
import 'package:habit_planet/main.dart';
import 'package:sqflite/sqflite.dart';
import '../bloc/habits/habits.dart';
import '../bloc/user/user.dart';
import '../service/database_service.dart';
import '../theme/theme.dart';

class SQLEditor extends StatefulWidget {
  const SQLEditor({super.key, required this.db});
  final Database db;

  @override
  _SQLEditorState createState() => _SQLEditorState();
}

class _SQLEditorState extends State<SQLEditor> with SingleTickerProviderStateMixin {
  final TextEditingController _queryController = TextEditingController();

  List<Map<String, dynamic>> _queryResult = [];

  Future _executeQuery(BuildContext ctx) async {
    try {
      _queryController.text = _queryController.text.trim();
      if (!isQueryReadOnly(_queryController.text)) {
        throw Exception('Query is not read-only');
      } else {
        addCommandToHistory(_queryController.text);
      }
      String query = _queryController.text;
      log(query);
      List<Map<String, dynamic>> queryResult = await widget.db.rawQuery(query);
      setState(() {
        _queryResult = queryResult;
      });
      log(queryResult.toString());
    } catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
    FocusScope.of(ctx).unfocus();
  }

  late TabController _tabController;
  final List<String> _commandHistory = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void addCommandToHistory(String command) {
    setState(() {
      if (_commandHistory.isNotEmpty) {
        if (_commandHistory.last != command) {
          _commandHistory.add(command);
        }
      } else {
        _commandHistory.add(command);
      }
    });
  }

  bool isQueryReadOnly(String query) {
    String lowerQuery = query.toLowerCase().trim();
    return lowerQuery.startsWith('select') && !lowerQuery.contains('insert') && !lowerQuery.contains('update') && !lowerQuery.contains('delete');
  }

  Widget chip(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(8),
        child: TextButton(
          child: Text(
            text,
            style: const TextStyle(color: Colors.black),
          ),
          onPressed: () => _queryController.text = '${_queryController.text} $text',
        ),
      ),
    );
  }

  List<Widget> get _commandChips {
    List<Widget> chips = [];
    chips.add(chip("SELECT"));
    chips.add(chip("*"));
    chips.add(chip("FROM"));
    chips.add(chip("WHERE"));
    chips.add(chip("ORDER BY"));
    chips.add(chip("LIMIT"));
    chips.add(chip("ASC"));
    chips.add(chip("DESC"));
    chips.add(chip("AND"));
    chips.add(chip("UPDATE"));
    chips.add(chip("OR"));
    chips.add(chip("NOT"));
    chips.add(chip("IN"));
    chips.add(chip("LIKE"));
    chips.add(chip("IS NULL"));
    chips.add(chip("IS NOT NULL"));
    chips.add(chip("BETWEEN"));
    chips.add(chip("GROUP BY"));
    chips.add(chip("HAVING"));
    chips.add(chip("INNER JOIN"));
    chips.add(chip("LEFT JOIN"));
    chips.add(chip("RIGHT JOIN"));
    chips.add(chip("FULL JOIN"));
    chips.add(chip("UNION"));
    chips.add(chip("UNION ALL"));
    chips.add(chip("EXCEPT"));
    chips.add(chip("INTERSECT"));
    chips.add(chip("COUNT"));

    return chips;
  }

  List<Widget> get _tableChips {
    List<Widget> chips = [];
    chips.addAll(DatabaseService.getTableNames().map((e) => chip(e)));
    return chips;
  }

  List<Widget> get _propertyChips {
    List<Widget> chips = [];
    chips.add(chip("ID"));
    chips.add(chip("NAME"));
    chips.add(chip("DESCRIPTION"));
    chips.add(chip("CREATEDATE"));
    chips.add(chip("UPDATEDATE"));
    chips.add(chip("USERID"));
    chips.add(chip("STRINGVALUE"));
    chips.add(chip("VALUE"));
    chips.add(chip("UNITINCREMENT"));
    chips.add(chip("VALUEGOAL"));
    chips.add(chip("SUFFIX"));
    chips.add(chip("UNITTYPE"));
    chips.add(chip("FREQUENCYTYPE"));
    chips.add(chip("EMOJI"));
    chips.add(chip("STREAKEMOJI"));
    chips.add(chip("HEXCOLOR"));
    chips.add(chip("HABITID"));
    chips.add(chip("BOOLEANVALUE"));
    chips.add(chip("INTEGERVALUE"));
    chips.add(chip("DECIMALVALUE"));
    chips.add(chip("STRINGVALUE"));
    chips.add(chip("UNITTYPE"));
    chips.add(chip("CREATEDATE"));
    chips.add(chip("UPDATEDATE"));
    chips.add(chip("HABITID"));
    chips.add(chip("BOOLEANVALUE"));

    return chips;
  }

  List<Widget> _queryRows() {
    if (_queryResult.isEmpty) {
      return [const Text("Queries appear here")];
    }

    // Create a list of widgets for each row in the query result
    List<Widget> rowWidgets = _queryResult.map((Map<String, dynamic> row) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: row.entries.map((entry) {
              return Text("${entry.key}: ${entry.value}");
            }).toList(),
          ),
        ),
      );
    }).toList();

    // Wrap the rowWidgets in a horizontally scrolling ListView
    return [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: rowWidgets),
      ),
    ];
  }

  Widget responseWidget(Map<String, dynamic> response) {
    return SizedBox(height: 250, child: Text(response.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'sqlflite 2.3.0',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              borderRadius: BorderRadius.circular(8),
              elevation: 5,
              child: TextButton(
                onPressed: () {
                  BlocProvider.of<UserBloc>(context).add(SplashPageRequested());
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Habits',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              borderRadius: BorderRadius.circular(8),
              elevation: 5,
              child: TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _queryController.text = '';
                  });
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Query'),
            Tab(text: 'Schema'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: [
                          TextField(
                            style: const TextStyle(color: Colors.black),
                            controller: _queryController,
                            keyboardType: TextInputType.text,
                            onSubmitted: (value) {
                              _executeQuery(context);
                            },
                            maxLines: 2,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _executeQuery(context),
                            child: const Text(
                              'Execute',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 8, bottom: 8),
                            child: SizedBox(
                              height: 50,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: _commandChips,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                              height: 50,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: _tableChips,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 8, bottom: 8),
                            child: SizedBox(
                              height: 50,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: _propertyChips,
                              ),
                            ),
                          ),
                          ..._queryRows()
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 8.0, left: 8, bottom: 8),
                          //   child: Container(
                          //     height: 250,
                          //     child: ListView(
                          //       scrollDirection: Axis.horizontal,
                          //       children: _queryRows(),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Tab 1: Schema
          FutureBuilder(
            future: widget.db.rawQuery('SELECT name FROM sqlite_master WHERE type=\'table\''),
            builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                List<Map<String, dynamic>> tables = snapshot.data!;
                return ListView.builder(
                  itemCount: tables.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                      future: widget.db.rawQuery('PRAGMA table_info(${tables[index]['name']})'),
                      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        if (snapshot.hasData) {
                          List<Map<String, dynamic>> columns = snapshot.data!;
                          return ExpansionTile(
                            collapsedIconColor: Colors.black,
                            iconColor: Colors.black,
                            backgroundColor: emerald,
                            title: Text(tables[index]['name'], style: const TextStyle(color: Colors.black)),
                            children: [
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: columns.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                        columns[index]['name'],
                                        style: const TextStyle(color: Colors.black, fontSize: 16),
                                      ),
                                      subtitle: Text(columns[index]['type'], style: const TextStyle(color: Colors.black, fontSize: 14)),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),

          // Tab 2: History
          ListView.builder(
            itemCount: _commandHistory.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  setState(() {
                    _queryController.text = _commandHistory[index];
                    _executeQuery(context);
                    _tabController.index = 0;
                  });
                },
                title: Text(_commandHistory.reversed.toList()[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}
