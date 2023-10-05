import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:h20_bender/tankControl.dart';
import 'package:h20_bender/tankModel.dart';

class TanksArrangement extends StatefulWidget {
  final IO.Socket channel;
  const TanksArrangement({required this.channel, Key? key}) : super(key: key);

  @override
  State<TanksArrangement> createState() => _TanksArrangementState();
}

class _TanksArrangementState extends State<TanksArrangement> {
  MyData myData =
      MyData(numOfTank: 2, tankValues: List.empty(), pumpState: 'off');

  List<TankModel> tanks = [];
  var itemCount = 0;

  Color getColour(int index) {
    if (index < myData.tankValues.length) {
      final value = myData.tankValues[index];
      if (value > 0.7) {
        return Colors.green.shade800.withOpacity(0.5);
      } else if (value <= 0.15) {
        return Colors.red.shade800.withOpacity(0.5);
      } else if (value <= 0.3 && value > 0.15) {
        return Colors.yellow.shade800.withOpacity(0.5);
      }
    }
    return Colors.grey.shade600.withOpacity(0.5);
  }

  void addTank(int index, Color colour, double value) {
    setState(() {
      itemCount++;
      tanks.insert(
        index,
        TankModel(
          index: index,
          colour: colour,
          value: value,
          channel: widget.channel,
        ),
      );
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
      stream: myData.stream,
      initialData: myData,
      builder: (context, snapshot) {
        final currentData = snapshot.data ?? myData;
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  List.filled(newIndex, 0.0);
                              setState(() {
                                myData.updateTankValues(updatedTankValues);
                              });
                            }
                            if (myData.tankValues.length <= newIndex) {
                              int val = newIndex - myData.tankValues.length;
                              final updatedTankValues = [
                                ...myData.tankValues,
                                ...List.filled(val + 1, 0.0)
                              ];
                              setState(() {
                                myData =
                                    myData.updateTankValues(updatedTankValues);
                              });
                              if (myData.tankValues.length == newIndex) {
                                addTank(newIndex, getColour(newIndex),
                                    myData.tankValues[newIndex]);
                              }
                            }
                            if (myData.tankValues.length == newIndex) {
                              addTank(newIndex, getColour(newIndex),
                                  myData.tankValues[newIndex]);
                            }
                            if (myData.tankValues.length > newIndex) {
                              int val = myData.tankValues.length - newIndex;
                              for (var i = 0; i < val; i++) {
                                addTank(newIndex, getColour(newIndex),
                                    myData.tankValues[newIndex]);
                                newIndex++;
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
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
