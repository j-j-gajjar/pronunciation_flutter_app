import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pronunciation/features/main_screen/main_screen.dart';

import 'package:pronunciation/ui/main_screen/main_screen.dart';

void main() {
  runApp(
    BlocProvider(
      create: (BuildContext context) => MainScreenBloc()
        ..add(
          const MainScreenEvent.initial(),
        ),
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
        home: const MainScreenView(),
      ),
    ),
  );
}
