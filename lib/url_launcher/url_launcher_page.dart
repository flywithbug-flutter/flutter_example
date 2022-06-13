import 'package:flutter/material.dart';

class URLLauncherPage extends StatelessWidget {
  const URLLauncherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Url Launcher"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: () {}, child: const Text("metaMask")),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
