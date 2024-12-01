import 'package:flutter/material.dart';

double getLinearThreshold(int x, int maxX) {
  double threshold = 50 + (49 / maxX) * x;

  return threshold.clamp(50.0, 95.0);
}