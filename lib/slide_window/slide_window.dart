import 'package:flutter/material.dart';

class SlideWindow extends PopupRoute {
  SlideWindow({required this.child});
  Widget child;

  final Duration _duration = const Duration(milliseconds: 300);
  @override
  Color? get barrierColor => Colors.red;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}

class SlideWindowWidget extends StatefulWidget {
  const SlideWindowWidget({Key? key}) : super(key: key);

  @override
  State<SlideWindowWidget> createState() => _SlideWindowWidgetState();
}

class _SlideWindowWidgetState extends State<SlideWindowWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('data'),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return Scaffold(
                        body: Container(
                          color: const Color.fromARGB(50, 255, 235, 59),
                        ),
                      );
                    },
                    fullscreenDialog: true));
              },
              icon: const Icon(Icons.abc),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                inactiveTickMarkColor: Colors.red,
              ),
              child: Slider(
                value: 0,
                onChanged: (value) {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
