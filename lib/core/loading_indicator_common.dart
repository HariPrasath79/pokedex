import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

const loadingIndicator = LoadingIndicator(
  colors: [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ],
  indicatorType: Indicator.orbit,

  strokeWidth: 1.0,

  /// Required, The loading type of the wi
  /// Optional, The color collections

  /// Optional, the stroke backgroundColor
);

final fetchingLoadingIndicator = Container(
  height: 35,
  color: Colors.transparent,
  child: const LoadingIndicator(
    pathBackgroundColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    colors: [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ],
    indicatorType: Indicator.ballPulse,

    strokeWidth: 1.0,

    /// Required, The loading type of the wi
    /// Optional, The color collections

    /// Optional, the stroke backgroundColor
  ),
);
