import 'package:flutter/foundation.dart';

class OtpController extends ChangeNotifier {
  OtpController({required this.length});

  final int length;

  late final List<String> _digits = List<String>.filled(length, '');

  String get value => _digits.join('');

  String digitAt(int index) {
    if (index < 0 || index >= length) {
      throw RangeError('$index is not in the range of 0..$length');
    }
    return _digits[index];
  }

  void setDigitAt(int index, String value) {
    if (index < 0 || index >= length) {
      throw RangeError('$index is not in the range of 0..$length');
    }
    _digits[index] = value;
    notifyListeners();
  }
}
