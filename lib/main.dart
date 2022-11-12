import 'package:eatarian_assignment/services/auth/auth_service.dart';
import 'package:eatarian_assignment/services/auth/auth_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final AuthService authInstance = AuthService(auth: FirebaseAuth.instance);
    return MultiProvider(
      providers: [
        StreamProvider<User?>(
            create: ((context) => authInstance.user), initialData: null),
        Provider<AuthService>(
          create: (context) => authInstance,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Eatarian',
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}
