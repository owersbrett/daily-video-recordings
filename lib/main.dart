import 'package:mementoh/data/repositories/domain_repository.dart';
import 'package:mementoh/data/repositories/experience_repository.dart';
import 'package:mementoh/data/repositories/habit_entry_note_repository.dart';
import 'package:mementoh/data/repositories/user_repository.dart';
import 'package:mementoh/pages/home/app_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:camera/camera.dart';
import 'package:mementoh/service/file_directories_service.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'data/repositories/habit_entry_repository.dart';
import 'data/repositories/habit_repository.dart';
import 'data/repositories/multimedia_repository.dart';
import 'service/database_service.dart';

List<CameraDescription> cameras = <CameraDescription>[];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FileDirectoriesService().init();

  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  Database database = await DatabaseService.initialize();
  
  await DatabaseService.logTableColumns(database);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : await getTemporaryDirectory(),
  );
  cameras = await availableCameras();
  runApp(MyApp(db: database));
}

String log(String val) {
  Logger.root.info(val);
  return val;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.db});
  final Database db;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    IUserRepository userRepository = UserRepository(db: db);
    IHabitEntryNoteRepository habitEntryNoteRepository = HabitEntryNoteRepository(db: db);
    IHabitEntryRepository habitEntryRepository = HabitEntryRepository(db: db);
    IHabitRepository habitRepository = HabitRepository(db: db);
    IExperienceRepository experienceRepository = ExperienceRepository(db: db);
    IDomainRepository domainRepository = DomainRepository(db: db);

    IMultimediaRepository multimediaRepository = MultimediaRepository(db: db);
    return AppWrapper(
      userRepository: userRepository,
      multimediaRepository: multimediaRepository,
      domainRepository: domainRepository,
      experienceRepository: experienceRepository,
      habitRepository: habitRepository,
      habitEntryRepository: habitEntryRepository,
      habitEntryNoteRepository: habitEntryNoteRepository,
    );
  }
}
