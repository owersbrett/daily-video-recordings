import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
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
        title: Text('SQL Editor'),
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
                TextField(
                  style: TextStyle(color: Colors.black),
                  controller: _queryController,
                  maxLines: 3,
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
          Text("Schema"), // Replace with your actual widget to show schema

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
