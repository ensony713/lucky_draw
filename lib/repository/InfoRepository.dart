import 'package:lucky_draw/localDataSource/DataSource.dart';
import 'package:lucky_draw/model/Info.dart';

class InfoRepository {

  final DataSource _dataSource = DataSource();

  Future<List<Info>> getInfoList(String path) {
    return _dataSource.getInfoList(path);
  }
}