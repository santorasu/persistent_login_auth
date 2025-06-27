import 'package:flutter/material.dart';
import 'package:task_management/ui/widgets/tm_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: Column(
        children: [
          Text("data"),
          Text("data"),
          Text("data"),
        ],
      ),
    );
  }
}
