import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'globals.dart' as globals;

class TextReader extends StatefulWidget {
  const TextReader({super.key});

  @override
  TextReaderState createState() => TextReaderState();
}

class TextReaderState extends State<TextReader>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration currTime = Duration.zero;

  bool isActive = false;
  bool hasRunBefore = false;

  int index = 0;
  String currentText = " ";
  int maxLength = globals.words.length - 1;

  double wpm = 500;

  String setPositionText = 'Enter index to go to:';

  @override
  void initState() {
    super.initState();

    index = 0;
    currTime = Duration.zero;
    _ticker = createTicker((elapsed) {
      if (isActive) {
        int seconds = (elapsed - currTime).inMilliseconds;
        bool toChange = seconds > wpmToDelay(wpm);
        if (toChange) {
          currTime = elapsed;
          index += 1;
        }

        if (index >= globals.words.length) {
          isActive = false;
        } else {
          setState(() {
            currentText = globals.words[index];
          });
        }
      }
    });

    _ticker.start();
  }

  double wpmToDelay(double wpm) {
    return 1.0 / ((wpm / 60.0) / 1000.0);
  }

  @override
  void dispose() {
    if (_ticker.isActive || _ticker.isTicking) {
      _ticker.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 100, 0, 100),
          child: SizedBox(
            height: 100,
            // width: 300,
            child: Text(
              currentText,
              style:
                  const TextStyle(fontFamily: "JetBrains Mono", fontSize: 48),
            ),
          ),
        ),
        Text(
          "$index",
          style: const TextStyle(
              fontFamily: "Helvatica Neue", fontSize: 18, color: Colors.grey),
        ),
        SizedBox(
            width: 400,
            child: Slider(
              value: wpm,
              onChanged: (value) {
                setState(() {
                  wpm = value;
                });
              },
              min: 100,
              max: 1000,
              divisions: 9,
              label: wpm.round().toString(),
            )),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(onPressed: _startButton, child: const Text("Start")),
              TextButton(onPressed: _stopButton, child: const Text("Stop")),
              TextButton(
                  onPressed: _restartButton, child: const Text("Restart")),
              TextButton(
                  onPressed: _setIndexButton, child: const Text("Set Position"))
            ],
          ),
        ),
      ],
    );
  }

  void _startButton() {
    if (globals.words.isEmpty) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('No book chosen!'),
          content: const Text('Select a book before starting the dialog.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      if (!isActive) {
        setState(() {
          isActive = true;
          currTime = Duration.zero;
        });
      }
    }
  }

  void _stopButton() {
    setState(() {
      isActive = false;
    });
  }

  void _restartButton() {
    setState(() {
      index = 0;
      isActive = false;
      currentText = globals.words[index];
      currTime = Duration.zero;
    });
  }

  final TextEditingController _textFieldController = TextEditingController();

  void _setIndexButton() {
    maxLength = globals.words.length;
    setPositionText = 'Enter index to go to (0-$maxLength):';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(setPositionText),
          content: TextField(
            controller: _textFieldController,
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                String text = _textFieldController.text;
                late int idx;
                try {
                  idx = int.parse(text);
                } on FormatException {
                  return;
                }
                index = idx;
                setState(() {
                  currentText = globals.words[index];
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
