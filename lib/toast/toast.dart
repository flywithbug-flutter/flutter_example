import 'dart:async';

import 'package:flutter/material.dart' hide Action;
import 'package:flutter/scheduler.dart';

enum ToastType { warning, info, success, error, submit }

mixin Toast {
  static _ToastView? preToast;
  static List<_ToastView> toastList = <_ToastView>[];

  /// 最大弹出数量
  static int kMaxCount = 3;

  static void info(BuildContext context, String message, {String? title, bool onlyOne = true}) {
    show(context, message: message, type: ToastType.info, title: title, onlyOne: onlyOne);
  }

  static void error(BuildContext context, String message, {String? title, bool onlyOne = true}) {
    show(
      context,
      message: message,
      type: ToastType.error,
      title: title,
      onlyOne: onlyOne,
    );
  }

  static void warning(BuildContext context, String message, {String? title, bool onlyOne = true}) {
    show(context, message: message, type: ToastType.warning, title: title, onlyOne: onlyOne);
  }

  static void success(BuildContext context, String message, {String? title, bool onlyOne = true}) {
    show(context, message: message, type: ToastType.success, title: title, onlyOne: onlyOne);
  }

  static void show(
    BuildContext? context, {
    String? title,
    String message = '',
    ToastType? type,
    int dismissDuration = 2,
    bool onlyOne = true,
  }) {
    if (context == null) {
      return;
    }
    // 最大显示数限制
    if (!onlyOne && toastList.length >= kMaxCount) {
      return;
    }

    if (onlyOne) {
      preToast?.dismiss();
      preToast = null;
    }

    OverlayState? overlayState;
    if (context is StatefulElement && context.state is NavigatorState) {
      // 从 NavigatorState 中获取 overlay
      overlayState = (context.state as NavigatorState).overlay;
    } else {
      // 走原先的逻辑
      overlayState = Overlay.of(context);
    }

    final controllerShow =
        AnimationController(vsync: overlayState!, duration: const Duration(milliseconds: 250));
    final opacityShow = Tween<double>(begin: 0, end: 1).animate(controllerShow);

    final controllerHide =
        AnimationController(vsync: overlayState, duration: const Duration(milliseconds: 250));
    final opacityHide = Tween<double>(begin: 1, end: 0).animate(controllerHide);

    final controllerShowOffset =
        AnimationController(vsync: overlayState, duration: const Duration(milliseconds: 350));
    final controllerCurvedShowOffset =
        CurvedAnimation(parent: controllerShowOffset, curve: const _BounceOutCurve._());
    final offsetAnim = Tween<double>(begin: -30, end: 0).animate(controllerCurvedShowOffset);

    final toastView = _ToastView();
    // 取出依赖的上一个 view
    final lastView = !onlyOne && (toastList.isNotEmpty) ? toastList.last : null;
    final globalKey = GlobalKey<__ToastWidgetState>();
    final overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        toastView.toastKey = globalKey;
        return _ToastWidget(
          key: globalKey,
          opacityShow: opacityShow,
          opacityHide: opacityHide,
          offsetAnim: offsetAnim,
          manager: toastView,
          // 如果是 onlyOne 或者 第一次toast 或者 当前 toastView 位于数组第一个的话，则 top 为0；否则取上一个 view 的 nextTop
          top: (onlyOne || lastView == null || toastView == toastList.first) ? 0 : lastView.nextTop,
          child: toastWidget(context, message, type, title: title),
        );
      },
    );

    toastView.overlayState = overlayState;
    toastView.overlayEntry = overlayEntry;
    toastView.controllerShowAnim = controllerShow;
    toastView.controllerShowOffset = controllerShowOffset;
    toastView.controllerHide = controllerHide;

    if (!onlyOne) {
      toastView.index = toastList.length;
      toastList.add(toastView);
      toastView.containerList = toastList;
    } else {
      preToast = toastView;
    }
    toastView._show();
  }

  static Widget toastWidget(
    BuildContext context,
    String message,
    ToastType? type, {
    String? title,
  }) {
    switch (type) {
      case ToastType.warning:
        return _buildToastLayout(
          context,
          _textContentWithIcon(
            context,
            message,
            const Icon(
              Icons.warning_rounded,
              size: 24,
              color: Colors.yellow,
            ),
            title: title,
          ),
        );
      case ToastType.info:
        return _buildToastLayout(
          context,
          _textContentWithIcon(
            context,
            message,
            const Icon(Icons.info, size: 24, color: Colors.red),
            title: title,
          ),
        );
      case ToastType.error:
        return _buildToastLayout(
          context,
          _textContentWithIcon(
            context,
            message,
            const Icon(Icons.info, size: 24, color: Colors.red),
            title: title,
          ),
        );
      case ToastType.success:
        return _buildToastLayout(
          context,
          _textContentWithIcon(
            context,
            message,
            const Icon(Icons.info, size: 24, color: Colors.red),
            title: title,
          ),
        );

      case ToastType.submit:
        return _buildToastLayout(
          context,
          Container(
            constraints: const BoxConstraints(minWidth: 120),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  child: const Icon(Icons.info, size: 28, color: Colors.red),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Text(
                    '提交成功',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        );
      default:
        return _buildToastLayout(context, _textContent(message));
    }
  }

  static LayoutBuilder _buildToastLayout(BuildContext context, Widget child) {
    final queryData = MediaQuery.of(context);
    final topPadding = queryData.padding.top;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return IgnorePointer(
          child: Container(
            alignment: Alignment.topCenter,
            child: Material(
              color: const Color(0x00000000),
              child: Container(
                margin: EdgeInsets.only(top: topPadding + 27.5, left: 10, right: 10),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xff222222),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _textContent(String message) {
    return Container(
      constraints: const BoxConstraints(minWidth: 100),
      child: Text(
        message,
        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        textAlign: TextAlign.left,
        softWrap: true,
      ),
    );
  }

  static Widget _textContentWithIcon(
    BuildContext context,
    String message,
    Icon icon, {
    String? title,
  }) {
    if (title != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 12),
            child: icon,
          ),
          Flexible(
            child: Container(
              constraints: const BoxConstraints(minWidth: 60),
              child: RichText(
                text: TextSpan(
                  text: '$title\n',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: message,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
                maxLines: 3,
              ),
            ),
          )
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(right: 12),
          child: icon,
        ),
        Flexible(
          child: Container(
            constraints: const BoxConstraints(minWidth: 60),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
              textAlign: TextAlign.left,
              maxLines: 2,
              softWrap: true,
            ),
          ),
        )
      ],
    );
  }
}

void safeRun(void Function() callback) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    callback();
  });
  SchedulerBinding.instance.ensureVisualUpdate();
}

class _ToastView {
  late OverlayEntry overlayEntry;
  late OverlayState overlayState;
  late AnimationController controllerShowAnim;
  late AnimationController controllerShowOffset;
  late AnimationController controllerHide;
  GlobalKey<__ToastWidgetState>? toastKey;

  bool show = false;

  /// 当前所有 [_notOnlyOne] 为 true 的 toast 集合
  List<_ToastView>? containerList;

  /// [_notOnlyOne] 为 true 的时候，下一个 view 的 top
  double nextTop = 0;

  /// 当前弹出层的高度
  double _height = 0;

  /// 索引
  int index = 0;

  /// 如果 [containerList] 非空，包含自身的话（这个说明是onlyOne为false的情况）
  bool get _notOnlyOne =>
      (containerList?.isNotEmpty ?? false) && (containerList?.contains(this) ?? false);

  void _show() {
    safeRun(() {
      show = true;
      overlayState.insert(overlayEntry);
    });
  }

  Future<void> display(BuildContext context) async {
    controllerShowAnim.forward();
    controllerShowOffset.forward();
    final queryData = MediaQuery.of(context);

    if (_notOnlyOne) {
      _height = toastKey!.currentContext!.size!.height - (queryData.padding.top + 20);
      var lastTop = 0.0;
      if (index > 0) {
        lastTop = containerList![index - 1].nextTop;
      }
      nextTop = lastTop + _height;
      // 如果几个 [_ToastWidget] 几乎同时 build 的话，lastTop 均为0（详见上面的show方法），那么需要更新 lastTop
      toastKey!.currentState!.updateTop(lastTop);
    }
    await Future<dynamic>.delayed(const Duration(milliseconds: 3000));
    safeRun(dismiss);
  }

  Future<dynamic> dismiss() async {
    if (show) {
      show = false;
      controllerHide.forward();
      await Future<Object>.delayed(const Duration(milliseconds: 250), () => Completer);
      overlayEntry.remove();
      if (_notOnlyOne) {
        containerList!.remove(this);
        for (var i = 0; i < containerList!.length; i++) {
          final view = containerList![i];
          view.index = i;

          // 如果没有toastKey，证明是刚插入containerList， 但是还没display;
          // 没有display的view是不应该纳入遍历的, 因为还没有高度和位置，还没显示
          if (view.toastKey == null) {
            // 更新index
            view.index = i;
            debugPrint('continue');
            continue;
          }

          view.nextTop -= _height;

          // dismiss一个的话，所有的top都要变更
          final widgetTop = (view.toastKey?.currentState?.top ?? 0) - _height;
          view.toastKey?.currentState?.updateTop(widgetTop <= 0 ? 0 : widgetTop);

          // 更新index
          view.index = i;
        }
      }
    }
  }
}

class _ToastWidget extends StatefulWidget {
  const _ToastWidget({
    Key? key,
    required this.child,
    required this.manager,
    required this.offsetAnim,
    required this.opacityShow,
    required this.opacityHide,
    required this.top,
  }) : super(key: key);

  final _ToastView manager;
  final Widget child;
  final Animation<double> opacityShow;
  final Animation<double> opacityHide;
  final Animation<double> offsetAnim;
  final double top;

  @override
  __ToastWidgetState createState() => __ToastWidgetState();
}

class __ToastWidgetState extends State<_ToastWidget> {
  double top = 0;

  bool managerDisplay = false;

  @override
  void initState() {
    super.initState();
    top = widget.top;
  }

  void updateTop(double newTop) {
    setState(() {
      top = newTop;
    });
  }

  @override
  void didChangeDependencies() {
    safeRun(() {
      widget.manager.display(context);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      top: top,
      left: 15,
      right: 15,
      child: AnimatedBuilder(
        animation: widget.opacityShow,
        child: widget.child,
        builder: (BuildContext context, Widget? _child) {
          return Opacity(
            opacity: widget.opacityShow.value,
            child: AnimatedBuilder(
              animation: widget.offsetAnim,
              builder: (BuildContext context, _) {
                return Transform.translate(
                  offset: Offset(0, widget.offsetAnim.value),
                  child: AnimatedBuilder(
                    animation: widget.opacityHide,
                    builder: (BuildContext context, _) {
                      return Opacity(
                        opacity: widget.opacityHide.value,
                        child: Container(alignment: Alignment.center, child: _child),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _BounceOutCurve extends Curve {
  const _BounceOutCurve._();

  @override
  double transform(double t) {
    final v = t - 1;
    return v * v * ((2 + 1) * v + 2) + 1;
  }
}
