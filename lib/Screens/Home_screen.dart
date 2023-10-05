import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:h20_bender/tankControl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import '../TankArrangement.dart';

//= int.parse(NumInput.text);

class HomeScreen extends StatefulWidget {
  final IO.Socket channel;
  const HomeScreen({required this.channel, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _NumInput = TextEditingController();

  int? _NumOfTank;

  @override
  void initState() {
    super.initState();
    _NumInput.addListener(() {
      setState(() {
        try {
          _NumOfTank = int.parse(_NumInput.text);
        } on FormatException {
          _NumOfTank = null;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'.toUpperCase()),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(0),
              child: Container(
                color: Colors.blue.shade300,
                child: Center(
                  child: Text(
                    "Settings".toUpperCase(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white12,
                    ),
                  ),
                ),
              ),
            ),
            ExpansionTile(title: const Text('Tanks Available'), children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _NumInput,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ]),
              ),
            ]),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("images/waterbg.jpg"),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 3,
                  child: TanksArrangement(
                    channel: widget.channel,
                  )),
              const SizedBox(
                height: 20,
              ),
              MyButton(channel: widget.channel),
            ],
          ),
        ),
      ),
    );
  }

  updateNumOfTank() {
    var myMapNumOfTank = {
      'sender': 'App',
      'NumOfTank': _NumInput,
    };
    widget.channel.emit('message', myMapNumOfTank);
  }
}

class MyButton extends StatefulWidget {
  final IO.Socket channel;
  const MyButton({required this.channel, Key? key}) : super(key: key);

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  late MyData myData;
  @override
  void initState() {
    super.initState();
    myData = MyData(numOfTank: 0, tankValues: List.empty(), pumpState: '');
  }

  bool isButtonClicked = false;
  Color buttoncolor = Colors.grey;
  Text icontext = const Text("Turn pump on");

  void togglebuttoncolor() {
    setState(() {
      myData = myData.updatePumpState(isButtonClicked ? 'off' : 'on');
      isButtonClicked = !isButtonClicked;
      buttoncolor = isButtonClicked ? Colors.green : Colors.grey;
      icontext = isButtonClicked
          ? const Text("Pumping")
          : const Text("Turn \n pump on");
    });
    var messagetoserver = {
      'sender': 'App',
      'PumpState': myData.pumpState,
    };
    widget.channel.emit('message', messagetoserver);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MyData>(
        stream: myData.stream,
        builder: (BuildContext context, AsyncSnapshot<MyData> snapshot) {
          if (snapshot.hasData) {
            final myData = snapshot.data!;
            final pump = myData.pumpState;

            Map<String, Function> actions = {
              'off': () => ElevatedButton(
                    onPressed: togglebuttoncolor,
                    style: ButtonStyle(
                        fixedSize: const MaterialStatePropertyAll(
                            Size.fromRadius(100)),
                        backgroundColor: MaterialStatePropertyAll(buttoncolor),
                        elevation: const MaterialStatePropertyAll(50),
                        shape: const MaterialStatePropertyAll(CircleBorder(
                            side: BorderSide(
                          width: 10.0,
                          color: Colors.white60,
                        )))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.gasPump,
                        ),
                        icontext,
                      ],
                    ),
                  ),
              'on': () {
                return ElevatedButton(
                  onPressed: togglebuttoncolor,
                  style: ButtonStyle(
                      fixedSize:
                          const MaterialStatePropertyAll(Size.fromRadius(100)),
                      backgroundColor: MaterialStatePropertyAll(buttoncolor),
                      elevation: const MaterialStatePropertyAll(50),
                      shape: const MaterialStatePropertyAll(CircleBorder(
                          side: BorderSide(
                        width: 10.0,
                        color: Colors.white60,
                      )))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        FontAwesomeIcons.gasPump,
                        size: BorderSide.strokeAlignInside,
                        color: Colors.white60,
                      ),
                      icontext,
                    ],
                  ),
                );
              },
              'null': () {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: AlertDialog(
                            content: const Text('Connect to an active network'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  style: const ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(Size.fromRadius(100)),
                      backgroundColor: MaterialStatePropertyAll(Colors.grey),
                      elevation: MaterialStatePropertyAll(50),
                      shape: MaterialStatePropertyAll(CircleBorder(
                          side: BorderSide(
                        width: 10.0,
                        color: Colors.white60,
                      )))),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.gasPump,
                        size: BorderSide.strokeAlignInside,
                        color: Colors.white60,
                      ),
                    ],
                  ),
                );
              }
            };

            final buttonDisplayed = actions[pump]?.call() ??
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      fixedSize:
                          const MaterialStatePropertyAll(Size.fromRadius(100)),
                      backgroundColor: MaterialStatePropertyAll(buttoncolor),
                      elevation: const MaterialStatePropertyAll(30),
                      shape: const MaterialStatePropertyAll(CircleBorder(
                          side: BorderSide(
                        width: 10.0,
                        color: Colors.white,
                      )))),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.gasPump,
                        size: 30,
                        color: Colors.white60,
                      ),
                      Text('pump status \n unknown'),
                    ],
                  ),
                );

            return Container(
              child: buttonDisplayed,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
