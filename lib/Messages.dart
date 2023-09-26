import 'package:h20_bender/tankControl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';

class Messages extends StatefulWidget {
  final IO.Socket channel;
  const Messages({
    required this.channel,
    super.key,
  });

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  late MyData myData;
  late StreamController<MyData> _streamController;

  @override
  void initState() {
    super.initState();
    myData = MyData(numOfTank: 0, tankValues: List.empty(), pumpState: '');
    _streamController = StreamController<MyData>.broadcast();
    widget.channel.on('sendToApp', (data) {
      try {
        final message = jsonDecode(data);
        final List<double> tankValues = List<double>.from(message['val']);
        final pumpState = message['PumpState'];

        // setState(() {
        //  myData = myData.updateTankValues(tankValues).updatePumpState(pumpState);
        // });
        myData = myData.updateTankValues(tankValues).updatePumpState(pumpState);
      } catch (error) {
        debugPrint('ws error $error');
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to connect to the server'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });
    widget.channel.onDisconnect((_) {
      debugPrint('ws channel closed');
    });
  }

  @override
  void dispose() {
    widget.channel.disconnect();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MyData>(
      stream: _streamController.stream,
      builder: (BuildContext context, AsyncSnapshot<MyData> snapshot) {
        if (snapshot.hasData) {
          final myData = snapshot.data!;
          int numOfTank = myData.numOfTank;
          widget.channel.emit('message', numOfTank);
        }
        throw Exception("cant create widget");
      },
    );
  }
}
