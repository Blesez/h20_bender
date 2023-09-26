// ignore_for_file: non_constant_identifier_names

import 'dart:async';

class MyData {
  int numOfTank = 0;
  List<double> tankValues = [];
  String pumpState = '';

  final StreamController<MyData> _controller =
      StreamController<MyData>.broadcast();
  Stream<MyData> get stream => _controller.stream;
  MyData({
    required this.numOfTank,
    required this.tankValues,
    required this.pumpState,
  });
  MyData updateNumOfTank(int numOfTank) {
    this.numOfTank = numOfTank;
    _controller.add(this); //notify listners
    return this;
  }

  MyData updateTankValues(List<double> tankValues) {
    this.tankValues = tankValues;
    _controller.add(this); //notify listners
    return this;
  }

  MyData updatePumpState(String pumpState) {
    this.pumpState = pumpState;
    _controller.add(this); //notify listners
    return this;
  }

  void dispose() {
    _controller.close();
  }
}
