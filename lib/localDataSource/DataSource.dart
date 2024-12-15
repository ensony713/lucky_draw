import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:lucky_draw/model/Info.dart';

class DataSource {

  List<String> rowName = ['location', 'team', 'name', 'rank', 'image'];

  /// [path]경로에 있는 엑셀 파일을 읽어서 Info 객체 list로 반환하는 메소드
  Future<List<Info>> getInfoList(path) async {

    if (null == path) {
      return [];
    }

    List<Info> players = [];

    Uint8List bytes;
    try {
      bytes = File(path!).readAsBytesSync();
    } on PathNotFoundException catch (e){
      log('file not found: $e');
      throw '$path is invalid.';
    }

    var excel = Excel.decodeBytes(bytes);
    var sheet1 = excel.tables.keys.last;

    int rowSize = excel.tables[sheet1]?.maxRows ?? 0;

    var data = excel.tables[sheet1];

    if (data == null) {
      throw 'file is invalid';
    }

    var category = data.row(0);
    for (int i = 0; i < category.length; i++) {
      if (category[i]?.value.toString() != rowName[i]) {
        throw 'file data is invalid.';
      }
    }

    for (int i = 1; i < rowSize; i++) {
      Info tmp = Info();
      var row = data.row(i);
      for (var cell in row) {
        switch (cell!.columnIndex) {
          case 0:
            tmp.location = cell.value.toString();
            break;

          case 1:
            tmp.team = cell.value.toString();
            break;

          case 2:
            tmp.name = cell.value.toString();
            break;

          case 3:
            tmp.rank = cell.value.toString();
            break;

          case 4:
            tmp.image = cell.value.toString();
            break;
        }
      }
      players.add(tmp);
    }

    return players;
  }
}