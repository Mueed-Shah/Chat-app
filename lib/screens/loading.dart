import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('Flutter ChatScreen'),),
      body: const Center(child:CircularProgressIndicator()),
    );
  }
}
