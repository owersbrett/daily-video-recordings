import 'package:daily_video_reminders/data/repositories/user_repository.dart';
import 'package:daily_video_reminders/pages/home/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/user/user.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(FetchUser());
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return HomePage(user: state.user);
        } else {
          return const Scaffold(
            body: Center(child: Text("No user")),
          );
        }
      },
    );
  }
}
