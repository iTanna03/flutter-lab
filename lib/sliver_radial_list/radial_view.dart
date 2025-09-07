import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_lab/sliver_radial_list/radial_menu_anchor.dart';
import 'package:flutter_lab/sliver_radial_list/sliver_radial_list.dart';

class RadialView extends StatelessWidget {
  RadialView(
      {required this.anchor,
      required this.radius,
      required this.delegate,
      required this.visibleItemCount,
      this.angularPadding = 0.0,
      super.key})
      : _radialAngle = RadialMenuAnchorWrapper.getAngle(anchor);

  final RadialMenuAnchor anchor;
  final double radius;
  final SliverChildDelegate delegate;
  final double angularPadding;
  final int visibleItemCount;
  final RadialAngle _radialAngle;

  Size _getBoundingBoxSize() {
    final angle = _radialAngle.visibleArcAngle;
    final angleArcPerChild = angle / visibleItemCount;
    final childSize = _radialToLinear(angleArcPerChild);

    final radius = this.radius + childSize / 2;

    if (angle == pi / 2) {
      return Size(radius, radius);
    } else if (angle == pi * 2) {
      return Size(2 * radius, 2 * radius);
    } else if (angle == pi) {
      assert(_radialAngle.orientation != null,
          'orientation is required when visibleArcAngle is 180 degree');
      if (_radialAngle.orientation! == RadialSweepOrientation.horizontal) {
        return Size(2 * radius, radius);
      } else {
        return Size(radius, 2 * radius);
      }
    } else {
      throw UnsupportedError('Invalid Visible Arc Angle: $angle');
    }
  }

  Axis _getScrollDirection() {
    if (_radialAngle.orientation
        case == null || RadialSweepOrientation.vertical) {
      return Axis.vertical;
    } else {
      return Axis.horizontal;
    }
  }

  double _radialToLinear(double radians) {
    return radius * radians;
  }

  @override
  Widget build(BuildContext context) {
    final size = _getBoundingBoxSize();

    return Stack(
      alignment: RadialMenuAnchorWrapper.getAlignmentFromAnchor(anchor),
      fit: StackFit.expand,
      children: [
        Positioned(
          width: size.width,
          height: size.height,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse
            }),
            child: CustomScrollView(
              scrollDirection: _getScrollDirection(),
              slivers: [
                SliverRadialList(
                  delegate: delegate,
                  radius: radius,
                  anchor: anchor,
                  visibleItemCount: visibleItemCount,
                  angularPadding: angularPadding,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
