import 'package:flutter/material.dart';
import 'package:h20_bender/progressIndicator.dart';

class TankModel2 extends StatefulWidget {
  final Color? colour;
  final int index;
  final double value;
  const TankModel2({
    super.key,
    this.colour,
    required this.value,
    required this.index,
  });

  @override
  State<TankModel2> createState() => _TankModel2State();
}

class _TankModel2State extends State<TankModel2> {
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
                        onTap: () {},
                      ),
                      const ListTile(
                        title: Text('Tank Status'),
                        trailing: Text("App is offline"),
                      ),
                    ]);
                  });
            }),
      ),
    );
  }
}
