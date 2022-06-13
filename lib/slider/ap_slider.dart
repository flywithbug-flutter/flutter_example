import 'dart:ui' as ui;

import 'package:flutter/material.dart' hide Image;

class ApSlider extends StatefulWidget {
  const ApSlider({
    Key? key,
    required this.backgroundColor,
    this.height,
    this.width,
    this.valueChanged,
    this.valueChangedFinish,
    this.dividerCount = 3,
    this.selectColor,
    this.unSelectColor,
    this.textColor,
    this.slidePadding = 0,
    this.initialPercent = 0,
  }) : super(key: key);

  final double? height;
  final double? width;

  final int dividerCount;
  final ValueChanged<double>? valueChanged;

  /// 拖动结束的回调
  final ValueChanged<double>? valueChangedFinish;
  final Color? selectColor;
  final Color? unSelectColor;
  final Color backgroundColor;
  final Color? textColor;

  /// percent [0 to 1]
  final double initialPercent;

  // 为了点击事件内部的 padding
  final double slidePadding;

  @override
  _DotPercentSliderState createState() => _DotPercentSliderState();
}

class _DotPercentSliderState extends State<ApSlider> {
  double lastPercent = 0;

  double percent = 0;
  late bool showText;

  late Color unSelectColor;
  late Color selectColor;
  late Color textColor;

  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    showText = false;
    percent = widget.initialPercent;
  }

  @override
  Widget build(BuildContext context) {
    selectColor = Colors.red;
    textColor = Colors.black;
    unSelectColor = Colors.grey;

    return Container(
      constraints: const BoxConstraints(minWidth: 100, minHeight: 30),
      width: widget.width,
      height: widget.height,
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails detail) => _onPanUpdate(context, detail),
        onPanDown: (DragDownDetails detail) => _onPanDown(context, detail),
        onPanEnd: (DragEndDetails detail) {
          widget.valueChangedFinish?.call(percent);
          onPanCancel();
        },
        onTapUp: (TapUpDetails details) {
          widget.valueChangedFinish?.call(percent);
        },
        onPanCancel: onPanCancel,
        child: RepaintBoundary(
          child: CustomPaint(
            painter: CustomSliderPainter(
              percent: percent,
              dividerCount: widget.dividerCount,
              showText: showText,
              selectColor: selectColor,
              unSelectColor: unSelectColor,
              backgroundColor: widget.backgroundColor,
              textColor: textColor,
              slidePadding: widget.slidePadding,
            ),
          ),
        ),
      ),
    );
  }

  void _onPanUpdate(BuildContext context, DragUpdateDetails details) {
    final x = details.localPosition.dx;
    _updateTouchX(x, context, false);
  }

  void _onPanDown(BuildContext context, DragDownDetails details) {
    final x = details.localPosition.dx;
    FocusScope.of(context).requestFocus(focusNode);
    _updateTouchX(x, context, true);
  }

  void _updateTouchX(double x_, BuildContext context, bool isDown) {
    var x = x_;
    if (x < 10.0) {
      x = 10.0;
    }
    if (x > context.size!.width - 10.0) {
      x = context.size!.width - 10.0;
    }

    final step = (context.size!.width - 2 * 10.0) / 20;

    var stepCount = ((x - 10.0) / step).round();

    if (isDown) {
      if (stepCount % 5 != 0) {
        stepCount = (stepCount / 5).round() * 5;
      }
    }

    final newPercent = stepCount * 0.05;

    if (widget.valueChanged != null) {
      if (newPercent != lastPercent) {
        setState(() {
          percent = newPercent;
          showText = true;
        });
        lastPercent = newPercent;
        widget.valueChanged!(newPercent);
      }
    }
  }

  void onPanCancel() {
    setState(() {
      showText = false;
    });
  }
}

class CustomSliderPainter extends CustomPainter {
  CustomSliderPainter({
    required this.percent,
    required this.dividerCount,
    required this.showText,
    required this.selectColor,
    required this.unSelectColor,
    required this.backgroundColor,
    required this.textColor,
    required this.slidePadding,
  }) {
    lineHeight = 2.0;
    unSelectPaint = Paint()
      ..color = unSelectColor
      ..strokeWidth = lineHeight;
    selectPaint = Paint()
      ..color = selectColor
      ..strokeWidth = lineHeight;
    dotPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = lineHeight;
    thumbPaint = Paint()
      ..color = unSelectColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineHeight;
  }

  final double percent;
  final int dividerCount;
  final bool showText;

  final Color selectColor;
  final Color unSelectColor;
  final Color backgroundColor;
  final Color textColor;
  final double slidePadding;

  late double lineHeight;

  late Paint unSelectPaint;
  late Paint selectPaint;
  late Paint dotPaint;
  late Paint thumbPaint;

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    const thumbRadius = 9.0;
    const dotRadius = 4.0;
    const triangleMarginBottom = 20.0;
    const rectHeight = 18.0;
    const rectWidth = 36.0;
    const rectRadius = 4.0;
    final lineCenterY = size.height / 2;
    const triangleWidth = 10.0;
    const triangleHeight = 6.0;
    const textSize = 10.0;
    const textMarginBottom = 33.0;
    const pt3 = 3.0;
    const pt2 = 2.5;

    final lineWidth = size.width - thumbRadius * 2 - rectRadius * 2 - slidePadding * 2;
    final lineStart = slidePadding + thumbRadius + rectRadius;

    canvas.drawLine(
      Offset(lineStart, lineCenterY),
      Offset(size.width - thumbRadius - rectRadius - slidePadding, lineCenterY),
      unSelectPaint,
    );

    final dotWidth = lineWidth / dividerCount;

    final selectLineWidth = percent * lineWidth;

    canvas.drawLine(
      Offset(lineStart, lineCenterY),
      Offset(lineStart + selectLineWidth, lineCenterY),
      selectPaint,
    );

    for (var i = 0; i <= dividerCount; i++) {
      final dotX = (0 + i) * dotWidth;
      var tempPaint = unSelectPaint;
      if (dotX <= selectLineWidth) {
        tempPaint = selectPaint;
      }
      canvas.drawCircle(
        Offset(lineStart + (0 + i) * dotWidth, lineCenterY),
        dotRadius + lineHeight / 2,
        dotPaint,
      );

      final rRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(lineStart + (0 + i) * dotWidth, lineCenterY),
          width: 1.2 * dotRadius,
          height: 2 * dotRadius,
        ),
        const Radius.elliptical(
          dotRadius * 0.75,
          dotRadius * 0.75,
        ),
      );
      canvas.drawRRect(rRect, tempPaint);
    }

    /// 绘制thumb
    canvas
      ..drawCircle(
        Offset(lineStart + selectLineWidth, lineCenterY),
        thumbRadius,
        thumbPaint
          ..style = PaintingStyle.fill
          ..color = backgroundColor,
      )
      ..drawCircle(
        Offset(lineStart + selectLineWidth, lineCenterY),
        thumbRadius - 1,
        thumbPaint
          ..style = PaintingStyle.stroke
          ..strokeWidth = lineHeight / 2
          ..color = unSelectColor,
      )
      ..drawLine(
        Offset(lineStart + selectLineWidth - pt3, lineCenterY - pt2),
        Offset(lineStart + selectLineWidth - pt3, lineCenterY + pt2),
        thumbPaint..color = unSelectColor.withOpacity(0.5),
      )
      ..drawLine(
        Offset(lineStart + selectLineWidth, lineCenterY - pt2),
        Offset(lineStart + selectLineWidth, lineCenterY + pt2),
        thumbPaint,
      )
      ..drawLine(
        Offset(lineStart + selectLineWidth + pt3, lineCenterY - pt2),
        Offset(lineStart + selectLineWidth + pt3, lineCenterY + pt2),
        thumbPaint,
      );

    if (showText) {
      /// draw triangle
      final triangleMiddle = lineStart + selectLineWidth;

      final path = Path()
        ..lineTo(triangleMiddle, lineCenterY - triangleMarginBottom)
        ..relativeLineTo(triangleWidth / 2, 0)
        ..relativeLineTo(-triangleWidth / 2, triangleHeight)
        ..relativeLineTo(-triangleWidth / 2, -triangleHeight)
        ..lineTo(triangleMiddle, lineCenterY - triangleMarginBottom);
      canvas.drawPath(path, selectPaint); //thumb

      var rectRight = triangleMiddle + rectWidth / 2;
      if (rectRight > lineWidth + lineStart + 2 * rectRadius) {
        rectRight = lineWidth + lineStart + 2 * rectRadius;
      }
      var rectLeft = rectRight - rectWidth;
      if (rectLeft < 0) {
        rectLeft = 0;
        rectRight = rectWidth;
      }
      final rectTop = lineCenterY - triangleMarginBottom - rectHeight + 1;

      /// draw rect
      final rect = Rect.fromLTRB(rectLeft, rectTop, rectRight, rectTop + rectHeight);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(rectRadius)),
        selectPaint,
      ); //thumb

      /// draw text
      canvas.drawParagraph(
        buildParagraph(
          '${(percent * 100).round()}%',
          textSize,
          rectWidth,
          textColor,
          TextAlign.center,
        ),
        Offset(rectLeft, lineCenterY - textMarginBottom),
      ); //thumb
    }
  }

  static ui.Paragraph buildParagraph(
    String text,
    double textSize,
    double constWidth,
    Color color,
    TextAlign align, {
    Color? backgroundColor,
  }) {
    final builder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: align,
        fontSize: textSize,
        height: 1,
      ),
    );
    Paint? background;
    if (backgroundColor != null) {
      background = Paint()..color = backgroundColor;
    }
    builder
      ..pushStyle(ui.TextStyle(color: color, background: background))
      ..addText(text);
    final constraints = ui.ParagraphConstraints(
      width: constWidth,
    );
    return builder.build()..layout(constraints);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is CustomSliderPainter) {
      return oldDelegate.percent != percent ||
          oldDelegate.showText != showText ||
          oldDelegate.unSelectColor != unSelectColor;
    }
    return false;
  }
}
