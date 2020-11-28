import 'dart:io';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:share_extend/share_extend.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class FileHandlerService {
  final HttpClient client = new HttpClient();

  shareFile(fileNameToGenerate, sharePanelTitle, shareSubject) async {
    if (await Permission.storage.request().isGranted) {
      var dir = await downloadPath;
      File shareFile = File("$dir/$fileNameToGenerate.pdf");
      ShareExtend.share(shareFile.path, "file",
          sharePanelTitle: sharePanelTitle, subject: shareSubject);
    }
  }

  Future<void> generatePDFDocument(
      fileNameToGenerate, htmlContent, context) async {
    if (await Permission.storage.request().isGranted) {
      var targetPath = await downloadPath;
      var targetFileName = fileNameToGenerate;

      var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
          htmlContent, targetPath, targetFileName);

      File file = new File('$targetPath/$fileNameToGenerate.pdf');
      file.writeAsBytesSync(await generatedPdfFile.readAsBytes());
    }
  }

  Future<String> get downloadPath async {
    // TODO: Handle for ios.
    var path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    return path;
  }

  Future<String> get localPath async {
    Directory dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }
}
