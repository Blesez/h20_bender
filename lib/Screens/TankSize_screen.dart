// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';

var url = 'wss://72daer0qkc.execute-api.us-east-1.amazonaws.com/beta?token:App';

enum TankShape { Cylinderical, Box }

class tankSize extends StatefulWidget {
  final channel;
  final int Tank_index;

  const tankSize({required this.channel, required this.Tank_index, super.key});

  @override
  State<tankSize> createState() => _tankSizeState();
}

class _tankSizeState extends State<tankSize> {
  TankShape? _tankShape;

  final TextEditingController _radius = TextEditingController();
  final TextEditingController _height = TextEditingController();
  final TextEditingController _length = TextEditingController();
  final TextEditingController _width = TextEditingController();

  final double defaultFont = 20.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50))),
      contentPadding: const EdgeInsets.all(10.0),
      title: Text(
        "Change Tank Size".toUpperCase(),
        style: const TextStyle(decoration: TextDecoration.underline),
      ),
      content: SizedBox(
        height: 400,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<TankShape>(
                        value: TankShape.Cylinderical,
                        title: Text(TankShape.Cylinderical.name),
                        groupValue: _tankShape,
                        onChanged: (value) {
                          setState(() {
                            _tankShape = value;
                          });
                        }),
                  ),
                  Expanded(
                    child: RadioListTile<TankShape>(
                        value: TankShape.Box,
                        title: Text(TankShape.Box.name),
                        groupValue: _tankShape,
                        onChanged: (value) {
                          setState(() {
                            _tankShape = value;
                          });
                        }),
                  ),
                ],
              ),
              if (_tankShape == TankShape.Cylinderical)
                Cylinder()
              else if (_tankShape == TankShape.Box)
                Box()
              else
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("OK")),
            ],
          ),
        ),
      ),
    );
  }

  Cylinder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(child: Text("r")),
              const SizedBox(width: 5),
              TextFormField(
                controller: _radius,
                decoration: InputDecoration(
                  constraints: const BoxConstraints(maxWidth: 200),
                  hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: defaultFont,
                      color: Colors.white),
                  labelText: 'Enter Radius',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please enter tank's radius";
                  }
                  return null;
                },
                onSaved: (value) => _radius.text = value!,
              ),
            ],
          ),
          const SizedBox(
            height: 5.0,
          ),
          Row(
            children: [
              const CircleAvatar(child: Text("h")),
              const SizedBox(width: 5),
              TextFormField(
                controller: _height,
                decoration: InputDecoration(
                  constraints: const BoxConstraints(maxWidth: 200),
                  hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: defaultFont,
                      color: Colors.white),
                  labelText: 'Enter Height',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please enter tank's height";
                  }
                  return null;
                },
                onSaved: (value) => _height.text = value!,
              ),
            ],
          ),
          ElevatedButton(
              onPressed: () {
                updateSizeCy();
                Navigator.pop(context);
              },
              child: const Text("OK"))
        ],
      ),
    );
  }

  Box() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(child: Text("l")),
              const SizedBox(width: 5),
              TextFormField(
                controller: _length,
                decoration: InputDecoration(
                  constraints: const BoxConstraints(maxWidth: 200),
                  hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: defaultFont,
                      color: Colors.white),
                  labelText: 'Enter Length',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please enter tank's length";
                  }
                  return null;
                },
                onSaved: (value) => _length.text = value!,
              ),
            ],
          ),
          const SizedBox(
            height: 5.0,
          ),
          Row(
            children: [
              const CircleAvatar(child: Text("h")),
              const SizedBox(width: 5),
              TextFormField(
                controller: _height,
                decoration: InputDecoration(
                  constraints: const BoxConstraints(maxWidth: 200),
                  hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: defaultFont,
                      color: Colors.white),
                  labelText: 'Enter Height',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please enter tank's height";
                  }
                  return null;
                },
                onSaved: (value) => _height.text = value!,
              ),
            ],
          ),
          const SizedBox(
            height: 5.0,
          ),
          Row(
            children: [
              const CircleAvatar(child: Text("w")),
              const SizedBox(width: 5),
              TextFormField(
                controller: _width,
                decoration: InputDecoration(
                  constraints: const BoxConstraints(maxWidth: 200),
                  hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: defaultFont,
                      color: Colors.white),
                  labelText: 'Enter Width',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please enter tank's width";
                  }
                  return null;
                },
                onSaved: (value) => _width.text = value!,
              ),
            ],
          ),
          const SizedBox(
            height: 5.0,
          ),
          ElevatedButton(
              onPressed: () {
                updateSizeBx();
                Navigator.pop(context);
              },
              child: const Text("OK"))
        ],
      ),
    );
  }

  updateSizeCy() {
    var myMapCylinderTS = {
      'sender': 'App',
      'Tank_index': widget.Tank_index,
      'TankSize': [
        {
          'radius': _radius.text,
          'height': _height.text,
          'length': 0,
          'width': 0,
        }
      ],
    };
    widget.channel.emit('message', myMapCylinderTS);
  }

  updateSizeBx() {
    var myMapBoxTS = {
      'sender': 'App',
      'Tank_index': widget.Tank_index,
      'TankSize': [
        {
          'radius': 0,
          'length': _length.text,
          'height': _height.text,
          'width': _width.text
        }
      ],
    };
    widget.channel.emit('message', myMapBoxTS);
  }
}
