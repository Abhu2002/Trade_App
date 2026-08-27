import 'package:flutter/material.dart';

String money(double value) => '₹${value.toStringAsFixed(2)}';

String compactMoney(double value) => '₹${value.toStringAsFixed(0)}';

Color movementColor(double value) =>
    value >= 0 ? const Color(0xff16b364) : const Color(0xffef5b67);
