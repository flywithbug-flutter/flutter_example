import 'package:flutter/material.dart';
import 'package:flutter_examples_example/drop_down_button/b_pop_select.dart';

class DropDownButtonPage extends StatefulWidget {
  const DropDownButtonPage({Key? key}) : super(key: key);

  @override
  State<DropDownButtonPage> createState() => _DropDownButtonPageState();
}

class _DropDownButtonPageState extends State<DropDownButtonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DropDownButtonPage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BPopSelect(
              child: Container(height: 40, width: 60, color: Colors.red),
              left: 0,
              top: 0,
              right: 0,
              childBuilder: (context) {
                return Container(
                  height: 100,
                  width: 100,
                  color: Colors.yellow,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
