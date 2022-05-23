import 'package:flutter/material.dart';
import 'file_select_widget.dart';
import 'reader_widget.dart';

// main function is called to run the app.
void main() {
  runApp(const Application());
}

// A Stateless App to wrap around the MaterialApp class.
class Application extends StatelessWidget {
  final String _title = "Ash RSVP";

  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      // Sets up the material icon configurations.
      home: const Scaffold(
        body: MainWidget(), // Passing in an instance of the class.
      ),
    );
  }
}

class MainWidget extends StatelessWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[TextReader(), FileWidget()],
    );
  }
}
