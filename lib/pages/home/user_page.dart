import 'package:habit_planet/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:habit_planet/pages/home/splash_page.dart';
import 'package:habit_planet/pages/video/loading_page.dart';

import '../../bloc/experience/experience.dart';
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
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          BlocProvider.of<ExperienceBloc>(context).add(FetchExperience());
        }
      },
      builder: (context, state) {
        if (state is UserLoaded) {
          if (state.hasSeenSplashPage) {
            return HomePage(user: state.user);
          } else {
            return SplashPage(user: state.user);
          }
        } else {
          return const LoadingPage(
            resourceName: "Home page",
          );
        }
      },
    );
  }
}
