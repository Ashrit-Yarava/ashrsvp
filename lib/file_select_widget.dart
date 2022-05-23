import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'dart:io';

import 'pdf_reader.dart';

// Define the stateful app.
// A stateful app is an app that can change its appearance based on user input.
class FileWidget extends StatefulWidget {
  const FileWidget({super.key});

  @override
  FileWidgetState createState() =>
      FileWidgetState(); // Creates the app state. The framework then calls build in the app state.
  // Compared to calling build in the class itself for a StatelessWidget.
}

// Underscore indicates a private variable. (Limited to this file only)
class FileWidgetState extends State<FileWidget> {
  // Variables declared under the state can then be changed.
  String _file = "Select File";

  // build is called whenever an event occurs and the framework rebuilds the app from there.
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
      ),
      onPressed: _selectFile,
      child: Text(_file),
    );
  }

  void _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String? filename = result.files.first.name;
      String? path = result.files.first.path;

      if (path != null) {
        setState(() {
          _file = filename;
        });
        extractAllText(File(path));
      }
    } else {
      return;
    }
  }
}
