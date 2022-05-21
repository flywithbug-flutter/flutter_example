import 'package:flutter/material.dart';
import 'package:flutter_examples_example/progress/progress_chart.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
      ),
      body: const ProgressChart(
        scores: [],
      ),
    );
  }
}
