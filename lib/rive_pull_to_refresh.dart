import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum RivePullToRefreshState { accept, cancel }

enum RivePullToRefreshStyle { header, floating }

const Duration _kIndicatorScaleDuration = Duration(milliseconds: 200);

class RivePullToRefresh extends StatefulWidget {
  const RivePullToRefresh(
      {required this.child,
      required this.riveWidget,
      required this.onRefresh,
      this.bump,
      this.callBacknumber,
      this.style = RivePullToRefreshStyle.header,
      this.controller,
      this.animTime = const Duration(milliseconds: 2000),
      this.percentActiveBump = 30,
      this.kDragSizeFactorLimit = 1.5,
      this.kDragContainerExtentPercentage = 0.25,
      Key? key})
      : super(key: key);
  final Widget child;

  // [kDragSizeFactorLimit]How much the scroll's drag gesture can overshoot the RefreshIndicator's
  // displacement; max displacement = _kDragSizeFactorLimit * displacement.
  final double kDragSizeFactorLimit;

  ///[kDragContainerExtentPercentage] The over-scroll distance that moves the indicator to its maximum
  /// displacement, as a percentage of the scrollable's container extent.
  final double kDragContainerExtentPercentage;

  ///[controller] to set position to 0.0 when client cancel refresh
  final ScrollController? controller;

  final RivePullToRefreshStyle style;
  final Function(bool)? bump;

  ///[callBacknumber] value return range 0-100 when client scrool
  final Function(double)? callBacknumber;
  final Widget riveWidget;
  final Future<void> Function() onRefresh;
  final Duration animTime;

  ///[percentActiveBump] value range 0 to 100
  final double percentActiveBump;

  @override
  State<RivePullToRefresh> createState() => _RivePullToRefreshState();
}

class _RivePullToRefreshState extends State<RivePullToRefresh> with TickerProviderStateMixin<RivePullToRefresh> {
  RivePullToRefreshState? _rivePullToRefreshState;
  late AnimationController _positionController;
  late Animation<double> _positionFactor;
  late Animatable<double> _kDragSizeFactorLimitTween;
  double _dragOffset = 0.0;
  Completer? completer;
  @override
  void initState() {
    super.initState();
    _kDragSizeFactorLimitTween = Tween<double>(begin: 0.0, end: widget.kDragSizeFactorLimit);
    if (widget.percentActiveBump > 100 || widget.percentActiveBump <= 0) {
      log("[percentActiveBump] not correct. this value range from 0 to 100");
      throw Error();
    }
    _positionController = AnimationController(vsync: this);
    _positionFactor = _positionController.drive(_kDragSizeFactorLimitTween);
  }

  @override
  void dispose() {
    _positionController.dispose();
    super.dispose();
  }

  bool handleOnNotification(ScrollNotification notification) {
    if (completer != null) {
      return false;
    }
    if (notification is ScrollStartNotification && notification.metrics.pixels == 0) {
      _shouldStart = true;
    }
    if (notification.metrics.pixels > 0 && _rivePullToRefreshState == null) {
      _shouldStart = false;
    }

    if (_rivePullToRefreshState != null && _shouldStart == true) {
      // calculator position here
      if (notification is ScrollUpdateNotification) {
        _dragOffset = _dragOffset + notification.scrollDelta!;
        _rivePullToRefreshState = RivePullToRefreshState.cancel;
      }
      if (notification is OverscrollNotification) {
        _dragOffset = _dragOffset + notification.overscroll;
        if (_positionController.value > (widget.percentActiveBump / 100)) {
          _rivePullToRefreshState = RivePullToRefreshState.accept;
        }
      }
      double newValue =
          (_dragOffset) / (notification.metrics.viewportDimension * widget.kDragContainerExtentPercentage);
      if (oldValue != null) {
        var value = _positionController.value + (oldValue! - newValue);
        _positionController.value = clampDouble(value, 0.0, 1.0);
        widget.callBacknumber?.call(_positionController.value * 100);
      }
      oldValue = newValue;
    }
    if (notification is ScrollEndNotification) {
      if (_rivePullToRefreshState == null) {
        return false;
      }
      checkScroolEnd(jumpTo: _positionController.value > 0);
    }
    return true;
  }

  void checkScroolEnd({bool jumpTo = false}) async {
    completer = Completer();
    if (_rivePullToRefreshState == RivePullToRefreshState.accept) {
      await _positionController.animateTo(1 / widget.kDragSizeFactorLimit, duration: _kIndicatorScaleDuration);
      widget.bump?.call(true);
      await Future.delayed(widget.animTime);
      _positionController.animateTo(0.0, duration: _kIndicatorScaleDuration);

      oldValue = null;
      _dragOffset = 0.0;
      _rivePullToRefreshState = null;
      widget.bump?.call(false);
      widget.onRefresh();
    } else {
      _positionController.animateTo(0.0, duration: _kIndicatorScaleDuration);

      oldValue = null;
      _dragOffset = 0.0;
      _rivePullToRefreshState = null;
      if (jumpTo) {
        widget.controller?.jumpTo(0);
      }
    }
    completer!.complete();
    completer = null;
  }

  double? oldValue;
  bool _shouldStart = true;
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final Widget child = NotificationListener<ScrollNotification>(
      onNotification: handleOnNotification,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          if (notification.depth != 0 || !notification.leading) {
            return false;
          }
          if (_rivePullToRefreshState != null && _shouldStart) {
            notification.disallowIndicator();
          } else {
            if (_rivePullToRefreshState == null) {
              // action first pull Overscroll to active refresh
              _rivePullToRefreshState = RivePullToRefreshState.cancel;
              return true;
            }
          }

          return false;
        },
        child: widget.child,
      ),
    );

    if (widget.style == RivePullToRefreshStyle.floating) {
      return Stack(
        children: [
          child,
          Opacity(
            opacity: _rivePullToRefreshState != null ? 0 : 1,
            child: SizeTransition(
              axisAlignment: _rivePullToRefreshState == null ? 1.0 : -1.0,
              sizeFactor: _positionFactor, // this is what brings it down
              child: AnimatedBuilder(
                animation: _positionController,
                builder: (BuildContext context, Widget? _) {
                  return widget.riveWidget;
                },
              ),
            ),
          ),
        ],
      );
    }
    return Column(
      children: [
        Opacity(
          opacity: _rivePullToRefreshState != null ? 0 : 1,
          child: SizeTransition(
            axisAlignment: _rivePullToRefreshState == null ? 1.0 : -1.0,
            sizeFactor: _positionFactor, // this is what brings it down
            child: AnimatedBuilder(
              animation: _positionController,
              builder: (BuildContext context, Widget? _) {
                return widget.riveWidget;
              },
            ),
          ),
        ),
        Expanded(
          child: child,
        )
      ],
    );
  }
}
