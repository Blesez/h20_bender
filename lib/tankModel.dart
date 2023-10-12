import 'package:flutter/material.dart';
import 'package:h20_bender/progressIndicator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'Screens/TankSize_screen.dart';

class TankModel extends StatefulWidget {
  final IO.Socket channel;
  final Color? colour;
  // final Widget? liquidProgress;
  final int index;
  final double value;
  const TankModel({
    super.key,
    this.colour,
    required this.value,
    required this.channel,
    // @required this.liquidProgress,
    required this.index,
  });

  @override
  State<TankModel> createState() => _TankModelState();
}

class _TankModelState extends State<TankModel> {
  bool isToggled = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 400,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: widget.colour),
        child: InkWell(
            child: LiquidProgress(
                value: widget.value,
                direction: Axis.vertical,
                backgroundColor: const Color.fromARGB(255, 7, 46, 77)),
            onLongPress: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return ListView(children: [
                      ListTile(
                        title: const Text('Tank size'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => tankSize(
                                    channel: widget.channel,
                                    Tank_index: widget.index),
                              ));
                        },
                      ),
                      ListTile(
                        title: const Text('Tank Status'),
                        trailing: Switch(
                            activeColor: Colors.green,
                            value: isToggled,
                            onChanged: (value) {
                              setState(() {
                                isToggled = value;
                              });
                              if (isToggled) {
                                var tankStateByUser = {
                                  'sender': 'App',
                                  'Tank_index': widget.index,
                                  'TankState': 1
                                };
                                widget.channel.emit('message', tankStateByUser);
                              } else {
                                var tankStateByUser = {
                                  'sender': 'App',
                                  'Tank_index': widget.index,
                                  'TankState': 0
                                };
                                widget.channel.emit('message', tankStateByUser);

                                const LiquidProgress(
                                    value: 0.5,
                                    direction: Axis.vertical,
                                    backgroundColor: Colors.grey);
                              }
                            }),
                      )
                    ]);
                  });
            }),
      ),
    );
  }
}
