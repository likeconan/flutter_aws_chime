import 'dart:math';

import 'package:flutter/material.dart';

import '../models/meeting.model.dart';

class PinchView extends StatefulWidget {
  final bool disable;
  final double contentRatio;
  final Widget child;

  const PinchView({
    super.key,
    required this.contentRatio,
    required this.child,
    this.disable = false,
  });
  @override
  State<PinchView> createState() => _PinchViewState();
}

class _PinchViewState extends State<PinchView> {
  double contentWidth = 1.0;
  double contentHeight = 1.0;
  double _baseScaleFactor = 1.0;
  double _scaleFactor = 1.0;

  late double minWidth;
  late double minHeight;
  double _alignX = 0;
  double _alignY = 0;
  double _baseAlignX = 0;
  double _baseAlignY = 0;
  Offset _baseDragOffset = const Offset(0, 0);
  Orientation? _o;

  @override
  void initState() {
    super.initState();
  }

  void init(
      {required double width, required double height, required Orientation o}) {
    var widgetRatio = width / height;
    minWidth = min(width, height * widget.contentRatio);
    minHeight = min(height, width / widget.contentRatio);
    if (widgetRatio < widget.contentRatio) {
      contentWidth = width;
      contentHeight = contentWidth / widget.contentRatio;
    } else {
      contentHeight = height;
      contentWidth = widget.contentRatio * contentHeight;
    }
    _alignX = 0;
    _alignY = 0;
    _baseAlignX = 0;
    _baseAlignY = 0;
    _baseDragOffset = const Offset(0, 0);
    _baseScaleFactor = 1.0;
    _scaleFactor = 1.0;
    _o = o;
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (_o != orientation) {
              init(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                o: orientation,
              );
            }
            var item = OverflowBox(
              alignment: Alignment(_alignX, _alignY),
              minWidth: minWidth,
              minHeight: minHeight,
              maxWidth: double.infinity,
              maxHeight: double.infinity,
              child: SizedBox(
                width: contentWidth * _scaleFactor,
                height: contentHeight * _scaleFactor,
                child: widget.child,
              ),
            );
            if (widget.disable) {
              return item;
            }
            return GestureDetector(
              onDoubleTap: () {
                hideControl();
                init(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  o: orientation,
                );
                setState(() {});
              },
              onTap: hideControl,
              onLongPress: hideControl,
              onScaleStart: (details) {
                _baseScaleFactor = _scaleFactor;
                if (details.pointerCount == 1) {
                  _baseDragOffset = details.focalPoint;
                  _baseAlignX = _alignX;
                  _baseAlignY = _alignY;
                }
              },
              onScaleUpdate: (details) {
                var val = _baseScaleFactor * details.scale;
                // handle movement
                if (details.pointerCount == 1) {
                  var x = (_baseDragOffset.dx - details.focalPoint.dx) /
                      constraints.maxWidth *
                      (orientation == Orientation.landscape ? -5 : 5);
                  var y = (details.focalPoint.dy - _baseDragOffset.dy) /
                      constraints.maxHeight *
                      (orientation == Orientation.landscape &&
                              widget.contentRatio > 1
                          ? -3
                          : 3);
                  x = x.abs() < 0.03 ? 0 : x;
                  y = y.abs() < 0.03 ? 0 : y;
                  setState(() {
                    _alignX = max(min(1, _baseAlignX + x), -1);
                    _alignY = max(min(1, _baseAlignY + y), -1);
                  });
                }
                // handle scale
                if (details.scale == 1.0 ||
                    details.pointerCount == 1 ||
                    contentWidth * val < minWidth ||
                    contentHeight * val < minHeight) {
                  return;
                }
                setState(() {
                  _scaleFactor = val;
                });
              },
              child: item,
            );
          },
        );
      },
    );
  }
}
