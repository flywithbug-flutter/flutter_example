import 'package:flutter/material.dart';
import 'package:flutter_examples_example/toast/toast.dart';

class ToastPage extends StatefulWidget {
  const ToastPage({Key? key}) : super(key: key);

  @override
  State<ToastPage> createState() => _ToastPageState();
}

class _ToastPageState extends State<ToastPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Toast"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Toast.info(context, 'info');
                },
                child: const Text("info")),
            const SizedBox(
              height: 60,
            ),
            ElevatedButton(
                onPressed: () {
                  Toast.error(context, 'error');
                },
                child: const Text("error")),
            const SizedBox(
              height: 60,
            ),
            ElevatedButton(
                onPressed: () {
                  Toast.warning(context, 'warning');
                },
                child: const Text("warning")),
            const SizedBox(
              height: 60,
            ),
            ElevatedButton(
                onPressed: () {
                  Toast.success(context, 'success');
                },
                child: const Text("success")),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
