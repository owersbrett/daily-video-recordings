import 'package:flutter/material.dart';
import 'package:mementoh/data/habit_entry.dart';
import 'package:sqflite/sqflite.dart';
import '../data/habit.dart';
import '../service/database_service.dart';

class SQLEditor extends StatefulWidget {
  const SQLEditor({super.key, required this.db});
  final Database db;

  @override
  _SQLEditorState createState() => _SQLEditorState();
}

class _SQLEditorState extends State<SQLEditor> with SingleTickerProviderStateMixin {
  final TextEditingController _queryController = TextEditingController();
  String _result = '';

  void _executeQuery() async {
    try {
      if (!isQueryReadOnly(_queryController.text)) {
        throw new Exception('Query is not read-only');
      } else {
        addCommandToHistory(_queryController.text);
      }
      List<Map<String, dynamic>> queryResult = await widget.db.rawQuery(_queryController.text);
      setState(() {
        _result = queryResult.toString();
      });
    } catch (e) {
      setState(() {
        _result = e.toString();
      });
    }
    FocusScope.of(context).unfocus();
  }

  late TabController _tabController;
  List<String> _commandHistory = [];

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
      _commandHistory.add(command);
    });
  }

  bool isQueryReadOnly(String query) {
    String lowerQuery = query.toLowerCase();
    return lowerQuery.startsWith('select') && !lowerQuery.contains('insert') && !lowerQuery.contains('update') && !lowerQuery.contains('delete');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SQL Editor',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              setState(() {
                _queryController.text = '';
                _result = '';
              });
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Query'),
            Tab(text: 'Schema'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: 60,
                  child: Row(
                    children: [
                      ActionChip(label: Text("SELECT"), onPressed: () => _queryController.text = 'SELECT '),
                      ActionChip(label: Text("ALL"), onPressed: () => _queryController.text = _queryController.text + '\t*'),
                      ActionChip(label: Text("FROM"), onPressed: () => _queryController.text = _queryController.text + '\t FROM'),
                      ActionChip(
                          label: const Text(Habit.tableName),
                          onPressed: () => _queryController.text = _queryController.text + '\t ${Habit.tableName}'),
                    ],
                  ),
                ),
                TextField(
                  style: TextStyle(color: Colors.black),
                  controller: _queryController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                ElevatedButton(
                  onPressed: _executeQuery,
                  child: const Text(
                    'Execute',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(_result),
                  ),
                ),
              ],
            ),
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
                            backgroundColor: Colors.amber,
                            title: Text(tables[index]['name'], style: TextStyle(color: Colors.black)),
                            children: [
                              Container(
                                height: 200,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: columns.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                        columns[index]['name'],
                                        style: TextStyle(color: Colors.black, fontSize: 16),
                                      ),
                                      subtitle: Text(columns[index]['type'], style: TextStyle(color: Colors.black, fontSize: 14)),
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
                title: Text(_commandHistory[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}
