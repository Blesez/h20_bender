import 'package:flutter/material.dart';
import 'Screens/Home_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'Messages.dart';
import 'package:h20_bender/offline/home_screen2.dart';

void main() {
  runApp(const MyApp());
}

const url = 'https://blesezwaterproj.onrender.com?token=App';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<IO.Socket?>(
        future: connectToSocketIO(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            if (snapshot.data == null) {
              return const HomeScreen2();
            }
            final socket = snapshot.data!;
            Messages(channel: socket);
            return HomeScreen(channel: socket);
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            return const HomeScreen2();
          }
        },
      ),
    );
  }

  Future<IO.Socket?> connectToSocketIO(BuildContext context) async {
    try {
      final socket = IO.io(url, <String, dynamic>{
        'transports': [
          'websocket',
        ]
      });
      socket.onConnect((_) {
        print('connected to socket.IO server');
      });
      socket.onDisconnect((_) {
        print('disconnected from socket.IO server');
        return null;
      });

      // websocket connection successful, handle further actions here
      return socket;
    } catch (e) {
      if (e is Exception) {
        debugPrint('socket.io connection error: $e');
      }
      return null;
    }
  }
}
