import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:lucky_draw/model/Info.dart';
import 'package:lucky_draw/repository/InfoRepository.dart';

class InfoViewModel with ChangeNotifier {

  late final InfoRepository _infoRepository;

  List<Info> _infoList = List.empty(growable: true);
  List<Info> get infoList => _infoList;
  String _path = '';
  bool loaded = false;

  /// [path] = 당첨자 정보 엑셀 파일 경로
  set path(String path) {
    _path = path;
    _getInfoList();
  }

  InfoViewModel() {
    _infoRepository = InfoRepository();
    _getInfoList();
  }

  /// repository에서 정보를 읽어오고, notifyListeners로 view에 변화를 알리는 메소드
  Future<void> _getInfoList() async {

    if ('' == _path) {
      return;
    }

    try {
      _infoList = await _infoRepository.getInfoList(_path);
      log('get items: length(${_infoList.length})');
    } catch (e) {
      log('failed loading data');
      loaded = false;
      return;
    }

    loaded = true;
    notifyListeners();
  }
}