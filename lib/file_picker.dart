import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lucky_draw/model/Info.dart';
import 'package:lucky_draw/randomDraw.dart';
import 'package:lucky_draw/viewModel/infoViewModel.dart';
import 'package:provider/provider.dart';

class DataPicker extends StatefulWidget {

  const DataPicker({super.key});

  @override
  State<StatefulWidget> createState() => _DataPickerState();
}

class _DataPickerState extends State<DataPicker> {

  late InfoViewModel _infoViewModel;
  String _path = '';

  /// 파일을 선택하는 다이얼로그를 띄우는 button click event handler
  void _pickFile() async {
    _infoViewModel.infoList.clear();
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (null == result) {
      return;
    }

    if ('csv' != result.files.single.extension!.toLowerCase()
        && 'xlsx' != result.files.single.extension!.toLowerCase()) {
      return;
    }

    setState(() {
      _path = result.files.single.name;
      _infoViewModel.path = result.files.single.path!;
    });
  }

  /// 반환하는 stateful widget
  @override
  Widget build(BuildContext context) {
    _infoViewModel = Provider.of<InfoViewModel>(context, listen: false);
    Null Function()? test;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          ElevatedButton(
              onPressed: _pickFile,
              child: const Text('추첨 참여자 명단 선택')
          ),
          const SizedBox(height: 16.0,),
          Text(
            '선택된 파일: $_path',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16.0,),
          Selector<InfoViewModel, List<Info>> (
           selector: (context, state) => state.infoList,
            builder: (context, data, child) {
              if (data.isNotEmpty) {
                test = () {
                  log('draw!');
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RandomDraw())
                  );
                };
              } else {
                test = null;
              }
              return ElevatedButton(
                onPressed: test,
                child: const Text('추첨 시작!'),
              );
            },
          ),
        ],
      ),
    );
  }
}