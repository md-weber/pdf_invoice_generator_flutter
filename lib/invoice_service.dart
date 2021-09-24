import 'dart:io';
import 'dart:typed_data';

import 'package:open_document/open_document.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Hello World"),
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> createInvoice(List<Product> soldProducts) {
    final pdf = pw.Document();

    final List<CustomRow> elements = [
      CustomRow("Item Name", "Item Price", "Amount", "Total", "Vat"),
      for (var product in soldProducts)
        CustomRow(
          product.name,
          product.price.toStringAsFixed(2),
          product.amount.toStringAsFixed(2),
          (product.price * product.amount).toStringAsFixed(2),
          (product.vatInPercent * product.price).toStringAsFixed(2),
        )
    ];

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Expanded(
                  child: pw.Column(children: [
                for (var element in elements)
                  pw.Row(
                    children: [
                      pw.Expanded(child: pw.Text(element.itemName, textAlign: pw.TextAlign.left)),
                      pw.Expanded(child: pw.Text(element.itemPrice, textAlign: pw.TextAlign.right)),
                      pw.Expanded(child: pw.Text(element.amount, textAlign: pw.TextAlign.right)),
                      pw.Expanded(child: pw.Text(element.total, textAlign: pw.TextAlign.right)),
                      pw.Expanded(child: pw.Text(element.vat, textAlign: pw.TextAlign.right)),
                    ],
                  )
              ])),
              pw.Row(children: [
                pw.Text("Subtotal"),
                pw.Text("${getSubTotal(soldProducts)} €", textAlign: pw.TextAlign.right)
              ]),
              pw.Row(children: [
                pw.Text("Vat Total"),
                pw.Text("${getVatTotal(soldProducts)} €", textAlign: pw.TextAlign.right),
              ]),
              pw.SizedBox(height: 20),
              pw.Row(children: [
                pw.Text("Total"),
                pw.Text(
                  "${double.parse(getSubTotal(soldProducts)) + double.parse(getVatTotal(soldProducts))} €",
                  textAlign: pw.TextAlign.right,
                ),
              ]),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenDocument.openDocument(filePath: filePath);
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
