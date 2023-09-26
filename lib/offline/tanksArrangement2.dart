import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:h20_bender/tankControl.dart';
import 'tankModel2.dart';

class TanksArrangement2 extends StatefulWidget {
  const TanksArrangement2({super.key});

  @override
  State<TanksArrangement2> createState() => _TanksArrangement2State();
}

class _TanksArrangement2State extends State<TanksArrangement2> {
  MyData myData = MyData(numOfTank: 2, tankValues: List.empty(), pumpState: '');
  final StreamController<MyData> _streamController =
      StreamController<MyData>.broadcast();

  @override
  void initState() {
    super.initState();
    updateMyData();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void updateMyData() {
    _streamController.sink.add(myData);
  }

  List<TankModel2> tanks = [];
  late TankModel2 tankModel;
  var itemCount = 0;

  Color getColour(int index) {
    if (index == tanks.length && myData.tankValues.isNotEmpty) {
      if (index < (myData.tankValues.length)) {
        final value = myData.tankValues[index];
        if (value > 0.7) {
          return Colors.green.shade800.withOpacity(0.5);
        } else if (value <= 0.15) {
          return Colors.red.shade800.withOpacity(0.5);
        } else if (value <= 0.3 && value > 0.15) {
          return Colors.yellow.shade800.withOpacity(0.5);
        }
      }
    }
    return Colors.grey.shade600.withOpacity(0.5);
  }

  void addTank(int index, Color colour, double value) {
    setState(() {
      itemCount++;
      tanks.insert(
          index,
          TankModel2(
            index: index,
            colour: colour,
            value: value,
          ));
      myData.updateNumOfTank(tanks.length);
    });
  }

  void removeTank(int index) {
    setState(() {
      tanks.removeAt(index);
      myData.updateNumOfTank(tanks.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MyData>(
        stream: _streamController.stream,
        initialData: myData,
        builder: (context, snapshot) {
          final currentData = snapshot.data ?? myData;
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: tanks.length + 1,
                      itemBuilder: (context, index) {
                        if (index == tanks.length) {
                          return Center(
                            child: IconButton(
                              splashColor: const Color.fromARGB(255, 50, 91, 3),
                              onPressed: () {
                                int newIndex = tanks.length;
                                if (currentData.tankValues.isEmpty) {
                                  final updatedTankValues =
                                      List.filled(newIndex + 1, 0.0);
                                  setState(() {
                                    myData = myData
                                        .updateTankValues(updatedTankValues);
                                  });
                                  if (kDebugMode) {
                                    print(myData.tankValues);
                                  }
                                }
                                if (myData.tankValues != null) {
                                  switch (myData.tankValues.length
                                      .compareTo(newIndex)) {
                                    case -1:
                                      int val =
                                          newIndex - myData.tankValues.length;
                                      final updatedTankValues = [
                                        ...myData.tankValues,
                                        ...List.filled(val, 0.0)
                                      ];
                                      setState(() {
                                        myData = myData.updateTankValues(
                                            updatedTankValues);
                                      });
                                      if (kDebugMode) {
                                        print(myData.tankValues);
                                      }
                                      if (myData.tankValues.length ==
                                          newIndex) {
                                        addTank(
                                          newIndex,
                                          getColour(newIndex),
                                          myData.tankValues[newIndex],
                                        );
                                      }
                                      break;
                                    case 0:
                                      addTank(
                                        newIndex,
                                        getColour(newIndex),
                                        myData.tankValues[newIndex],
                                      );
                                      break;
                                    case 1:
                                      num val =
                                          myData.tankValues.length - newIndex;
                                      for (var i = 0; i < val; i++) {
                                        addTank(
                                          newIndex,
                                          getColour(newIndex),
                                          myData.tankValues[newIndex],
                                        );
                                        newIndex++;
                                      }
                                      break;
                                    default:
                                      break;
                                  }
                                }
                              },
                              iconSize: 200,
                              icon: const Icon(Icons.add_box_rounded,
                                  color: Colors.white),
                              color: Colors.grey.shade600,
                            ),
                          );
                        } else {
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              removeTank(index);
                            },
                            child: tanks[index],
                          );
                        }
                      }),
                ),
              ],
            ),
          );
        });
  }
}
