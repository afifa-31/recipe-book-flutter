   import 'dart:io';

   import 'package:flutter/material.dart';
   import 'package:sqflite_common_ffi/sqflite_ffi.dart';

   import 'home_screen.dart';

   void main() {
     WidgetsFlutterBinding.ensureInitialized();

     // Desktop needs the FFI database; Android/iOS use normal sqflite.
     if (Platform.isWindows || Platform.isLinux) {
       sqfliteFfiInit();
       databaseFactory = databaseFactoryFfi;
     }

     runApp(const RecipeBookApp());
   }

   class RecipeBookApp extends StatelessWidget {
     const RecipeBookApp({super.key});

     @override
     Widget build(BuildContext context) {
       return MaterialApp(
         title: 'Recipe Book',
         debugShowCheckedModeBanner: false,
         theme: ThemeData(
           useMaterial3: true,
           colorSchemeSeed: Colors.deepOrange,
         ),
         home: const HomeScreen(),
       );
     }
   }

