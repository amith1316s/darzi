import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class ReportGenerateService {
  Future<String> generateReportContent(data) async {
    if (data.length > 0) {
      var template = '''
      <!DOCTYPE html>
<html>

<head>
    
</head>

<body>
    <table class="table-main" cellspacing="5" cellpadding="5">
        <tr>
            <td width="55%">
                <h1 style="margin: 0px 0 10px">Darzi Report</h1>
            </td>
        </tr>
        <tr>
            <table>
  <tr>
    <th>Design</th>
    <th>Fabric</th>
    <th>price</th>
	<th>Notes</th>
	<th>Status</th>
	<th>Tracking number</th>
  </tr>
      ''';

      for (var i = 0; i < data.length; i++) {
        template += '''
        <tr>
    <td>${data[i].data['type'] == 'custom' ? "Custom" :data[i].data['design']['title']}</td>
    <td>${data[i].data['fabric']['title']}</td>
    <td>${data[i].data['price'] ?? '0'}</td>
	<td>${data[i].data['note'] ?? ''}</td>
    <td>${data[i].data['status']}</td>
    <td>${data[i].data['trackingNumber']}</td>
  </tr>
        ''';
      }

      template += '''   
  
  
</table>
        </tr>
    </table>
</body>

</html>
    ''';

      return template;
    }

    return '''
    <!DOCTYPE html>
<html>

<head>
    
</head>

<body>
    <table class="table-main" cellspacing="5" cellpadding="5">
        <tr>
            <td width="55%">
                <h1 style="margin: 0px 0 10px">Darzi Report</h1>
            </td>
        </tr>
        <tr>
            <h1 style="margin: 0px 0 10px">No data</h1>
        </tr>
    </table>
</body>

</html>
    ''';
  }
}
