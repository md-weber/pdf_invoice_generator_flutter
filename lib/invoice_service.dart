import 'dart:typed_data';

import 'package:pdf_invoice_generator_flutter/model/product.dart';

class CustomRow {
  final String itemName;
  final String itemPrice;
  final String amount;
  final String total;
  final String vat;

  CustomRow(this.itemName, this.itemPrice, this.amount, this.total, this.vat);
}

class PdfInvoiceService {
  Future<Uint8List> createHelloWorld() {
    throw UnimplementedError();
    // TODO 5 - 8 (Optional) only to showcase the pdf generation
    // TODO 5: Create a pdf document
    // TODO 6: Add a page
    // TODO 7: Write Hello World in the Center
    // TODO 8: Save the document and return the Uint8List
  }

  Future<Uint8List> createInvoice(List<Product> soldProducts) async {
    throw UnimplementedError();
    // TODO 13: Create a pdf document
    // TODO 14: Create a list of "CustomRow" which contains each row of the item list
    // TODO 15: Load the image via the rootBundle
    // TODO 16: Add a page to the PDF and add one by one the elements
    // TODO 17: Save the PDF and return the Uint8List
  }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    throw UnimplementedError();
    // TODO 9: Create a filepath where you want to save it (Flutter use getTemporaryDirectory())
    // TODO 10: Create a File instance with the filepath
    // TODO 11: Write into the file the byteArray
    // TODO 12: Open the document with OpenDocument
  }

  String getSubTotal(List<Product> products) {
    return products
        .fold(0.0, (double prev, element) => prev + (element.amount * element.price))
        .toStringAsFixed(2);
  }

  String getVatTotal(List<Product> products) {
    return products
        .fold(
          0.0,
          (double prev, next) => prev + ((next.price / 100 * next.vatInPercent) * next.amount),
        )
        .toStringAsFixed(2);
  }
}
