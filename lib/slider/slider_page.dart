import 'package:flutter/material.dart';
import 'package:flutter_examples_example/slider/FluidSlider.dart';
import 'package:flutter_examples_example/slider/ap_slider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({Key? key}) : super(key: key);

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double _value1 = 0.0;
  double _value2 = 10.0;
  double _value3 = 1.0;
  double _value = 0;
  String? _status;
  Color? _statusColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: ApSlider(
                      dividerCount: 4,
                      initialPercent: 0.8,
                      backgroundColor: Colors.black,
                      valueChanged: (value) {},
                    ),
                  ),
                )
              ],
            ),
            SfSlider(
              min: 0.0,
              max: 100.0,
              value: _value,
              interval: 20,
              showTicks: true,
              showLabels: true,
              enableTooltip: true,
              minorTicksPerInterval: 1,
              onChanged: (dynamic value) {
                setState(() {
                  _value = value;
                });
              },
            ),
            SliderTheme(
              data: const SliderThemeData(),
              child: Slider(
                min: 0.0,
                max: 100.0,
                value: _value,
                divisions: 10,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                    _status = 'active (${_value.round()})';
                    _statusColor = Colors.green;
                  });
                },
                onChangeStart: (value) {
                  setState(() {
                    _status = 'start';
                    _statusColor = Colors.lightGreen;
                  });
                },
                onChangeEnd: (value) {
                  setState(() {
                    _status = 'end';
                    _statusColor = Colors.red;
                  });
                },
              ),
            ),
            Text(
              'Status: $_status',
              style: TextStyle(color: _statusColor),
            ),
            FluidSlider(
              value: _value1,
              onChanged: (double newValue) {
                setState(() {
                  _value1 = newValue;
                });
              },
              min: 0.0,
              max: 100.0,
            ),
            SizedBox(
              height: 100.0,
            ),
            FluidSlider(
                value: _value2,
                onChanged: (double newValue) {
                  setState(() {
                    _value2 = newValue;
                  });
                },
                min: 0.0,
                max: 500.0,
                sliderColor: Colors.redAccent,
                thumbColor: Colors.amber,
                start: Icon(
                  Icons.money_off,
                  color: Colors.white,
                ),
                end: Icon(
                  Icons.attach_money,
                  color: Colors.white,
                )),
            SizedBox(
              height: 100.0,
            ),
            FluidSlider(
                value: _value3,
                sliderColor: Colors.purple,
                onChanged: (double newValue) {
                  setState(() {
                    _value3 = newValue;
                  });
                },
                min: 1.0,
                max: 5.0,
                mapValueToString: (double value) {
                  List<String> romanNumerals = ['I', 'II', 'III', 'IV', 'V'];
                  return romanNumerals[value.toInt() - 1];
                }),
          ],
        ),
      ),
    );
  }
}
