import 'package:flutter/material.dart';

typedef BPopSelectChildBuilder = Widget Function(BuildContext context);

class BPopSelect extends StatefulWidget {
  const BPopSelect({
    Key? key,
    required this.child,
    required this.childBuilder,
    this.onSelect,
    this.enable = true,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.onPopMenuShown,
    this.onPopMenuDismissed,
  }) : super(key: key);

  final Widget child;
  final BPopSelectChildBuilder childBuilder;
  final Function(int? index, {bool isSelect})? onSelect;
  final VoidCallback? onPopMenuShown;
  final VoidCallback? onPopMenuDismissed;
  final bool enable;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  @override
  _BPopSelectState createState() => _BPopSelectState();
}

class _BPopSelectState extends State<BPopSelect> {
  bool isSelect = false;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: widget.enable
            ? () async {
                setState(() {
                  isSelect = true;
                  widget.onSelect?.call(null, isSelect: isSelect);
                });

                widget.onPopMenuShown?.call();
                final int? index = await _showChild();
                widget.onPopMenuDismissed?.call();

                setState(() {
                  isSelect = false;
                  widget.onSelect?.call(index, isSelect: isSelect);
                });
              }
            : null,
        child: widget.child,
      );

  Future<int?> _showChild() async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset localToGlobal = button.localToGlobal(Offset.zero);
    final Size size = button.size;
    final Offset offset = Offset(localToGlobal.dx, localToGlobal.dy + size.height);
    final double? left = widget.left == null ? null : offset.dx + widget.left!;
    final double? right = widget.right == null
        ? null
        : MediaQuery.of(context).size.width - offset.dx - size.width + widget.right!;
    final double? top = widget.top == null ? null : offset.dy + widget.top!;
    final double? bottom = widget.bottom == null
        ? null
        : MediaQuery.of(context).size.height - offset.dy + widget.bottom!;
    final Widget child = widget.childBuilder(context);
    final int? result = await Navigator.of(context).push<int>(
        _PopMenuRoute<int>(child: child, left: left, top: top, right: right, bottom: bottom));
    return result;
  }
}

class _PopMenuRoute<T> extends PopupRoute<T> {
  _PopMenuRoute({
    required this.child,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.bgColor,
  });

  final Duration _duration = const Duration(milliseconds: 200);
  final Widget child;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final Color? bgColor;

  @override
  Color get barrierColor => bgColor ?? Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      Material(
        type: MaterialType.transparency,
        color: barrierColor,
        child: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: left,
                top: top,
                right: right,
                bottom: bottom,
                child: child,
              ),
            ],
          ),
        ),
      );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn,
        ),
        child: child,
      );

  @override
  Duration get transitionDuration => _duration;
}

///参照下拉选择的方式实现简易的'新功能引导'
class ShowCasesWidget extends StatefulWidget {
  const ShowCasesWidget({
    Key? key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    required this.child,
    required this.casesWidget,
    this.showCases = true,
    this.delayDuration,
    this.shownCallback,
    this.closeCallback,
  }) : super(key: key);
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  ///正常显示的widget
  final Widget child;

  ///引导的widget
  final Widget casesWidget;

  ///是否显示引导 默认显示
  final bool? showCases;

  ///延时duration展示(如希望界面加载后500ms再显示) 默认不延时
  final Duration? delayDuration;

  ///新手引导操作之后回调(用户点了关闭等)
  final Function(dynamic res)? closeCallback;

  ///显示了回调
  final Function()? shownCallback;

  @override
  _ShowCasesWidgetState createState() => _ShowCasesWidgetState();
}

class _ShowCasesWidgetState extends State<ShowCasesWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.showCases == true) {
        if (widget.delayDuration != null) {
          Future.delayed(widget.delayDuration!, () {
            _showCases();
          });
        } else {
          _showCases();
        }
      }
    });
  }

  void _showCases() async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset localToGlobal = button.localToGlobal(Offset.zero);
    final Size size = button.size;
    final Offset offset = Offset(localToGlobal.dx, localToGlobal.dy + size.height);
    final double? left = widget.left == null ? null : offset.dx + widget.left!;
    final double? right = widget.right == null
        ? null
        : MediaQuery.of(context).size.width - offset.dx - size.width + widget.right!;
    final double? top = widget.top == null ? null : offset.dy + widget.top!;
    final double? bottom = widget.bottom == null
        ? null
        : MediaQuery.of(context).size.height - offset.dy + widget.bottom!;
    widget.shownCallback?.call();
    dynamic res = await Navigator.of(context).push(
      _PopMenuRoute<int>(
        child: widget.casesWidget,
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        bgColor: Colors.transparent,
      ),
    );
    widget.closeCallback?.call(res);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
