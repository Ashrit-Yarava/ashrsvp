import 'dart:io';

import 'globals.dart' as globals;

import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<List<int>> readDocumentData(File file) async {
  return await file.readAsBytes();
}

void extractAllText(File file) async {
  //Load the existing PDF document.
  PdfDocument document = PdfDocument(inputBytes: await readDocumentData(file));

  //Create the new instance of the PdfTextExtractor.
  PdfTextExtractor extractor = PdfTextExtractor(document);

  //Extract all the text from the document.
  String text = extractor.extractText();

  //Display the text.
  globals.words = text.split(' ');
}
