import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:h20_bender/tankControl.dart';
import 'package:flutter/material.dart';
import 'TanksArrangement2.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  @override
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
                child: Text("Settings".toUpperCase()),
              ),
            ),
            const ExpansionTile(
              title: Text('Offline Mode'),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("images/waterbg.jpg"),
          fit: BoxFit.cover,
        )),
        child: const Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 3, child: TanksArrangement2()),
              SizedBox(
                height: 20,
              ),
              MyButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class MyButton extends StatefulWidget {
  const MyButton({Key? key}) : super(key: key);

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  late MyData myData;
  late StreamController<MyData> _streamController;
  @override
  void initState() {
    super.initState();
    myData = MyData(numOfTank: 0, tankValues: List.empty(), pumpState: '');
    _streamController = StreamController<MyData>.broadcast();
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
  }

  @override
  Widget build(BuildContext context) {
    final pump = myData.pumpState;

    Map<String, Function> actions = {
      'off': () => ElevatedButton(
            onPressed: togglebuttoncolor,
            style: ButtonStyle(
                fixedSize: const MaterialStatePropertyAll(Size.fromRadius(100)),
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
              fixedSize: const MaterialStatePropertyAll(Size.fromRadius(100)),
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
                        child: const Text('OK'),
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
              fixedSize: const MaterialStatePropertyAll(Size.fromRadius(100)),
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
  }
}
