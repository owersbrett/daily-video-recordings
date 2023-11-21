import 'package:equatable/equatable.dart';

abstract class ReportsState implements Equatable {
  final List<Map<String, String>> reports = [
    {'title': 'Habits', 'description': 'View your habits', 'route': '/habits'},
    {'title': 'Multimedia', 'description': 'View your multimedia', 'route': '/multimedia'},
    {'title': 'Moods', 'description': 'View your moods', 'route': '/moods'},
    {'title': 'Notes', 'description': 'View your notes', 'route': '/notes'},
    {'title': 'Goals', 'description': 'View your goals', 'route': '/goals'},
    {'title': 'Tasks', 'description': 'View your tasks', 'route': '/tasks'},
    {'title': 'Events', 'description': 'View your events', 'route': '/events'},
    {'title': 'Appointments', 'description': 'View your appointments', 'route': '/appointments'},
    {'title': 'Reminders', 'description': 'View your reminders', 'route': '/reminders'},
    {'title': 'Medications', 'description': 'View your medications', 'route': '/medications'},
    {'title': 'Symptoms', 'description': 'View your symptoms', 'route': '/symptoms'},
    {'title': 'Vitals', 'description': 'View your vitals', 'route': '/vitals'},
    {'title': 'Conditions', 'description': 'View your conditions', 'route': '/conditions'},
    {'title': 'Allergies', 'description': 'View your allergies', 'route': '/allergies'},
    {'title': 'Immunizations', 'description': 'View your immunizations', 'route': '/immunizations'},
    {'title': 'Procedures', 'description': 'View your procedures', 'route': '/procedures'},
    {'title': 'Claims', 'description': 'View your claims', 'route': '/claims'},
  ];

  @override
  bool? get stringify => throw UnimplementedError();
}
