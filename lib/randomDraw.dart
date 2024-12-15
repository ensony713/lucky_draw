import 'dart:io';
import 'dart:math';
import 'dart:developer' as dp;

import 'package:flutter/material.dart';
import 'package:lucky_draw/model/Info.dart';
import 'package:lucky_draw/viewModel/infoViewModel.dart';
import 'package:provider/provider.dart';

class RandomDraw extends StatefulWidget {
  const RandomDraw({super.key});

  @override
  State<StatefulWidget> createState() => _RandomDraw();
}

class _RandomDraw extends State<RandomDraw>
    with SingleTickerProviderStateMixin {
  String title = '';
  final themeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
    useMaterial3: true,
  );

  late InfoViewModel _infoViewModel;

  Widget _viewer = const SizedBox();

  bool _viewing = false;
  bool _drawing = false;
  int len = 0;
  int winIdx = -1;
  final int _time = 5;
  final double boxWidth = 0.7;
  final double imageSize = 0.8;

  final TextStyle _textStyle = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 60, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    _infoViewModel = Provider.of<InfoViewModel>(context, listen: false);
    len = _infoViewModel.infoList.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: drawView(context), // const Text('Random draw view'),
    );
  }

  // 뽑기 버튼
  Widget drawView(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const Spacer(),
              _drawing ? resultView(context) : Text('$len명 중에 한 명을 뽑습니다.'),
              const Spacer(),
              ElevatedButton(
                  onPressed: _viewing
                      ? null
                      : () async {
                          if (!_drawing) {
                            setState(() {
                              _viewing = true;
                            });
                            winIdx = Random.secure().nextInt(len);
                            dp.log(
                                '당첨자: ${_infoViewModel.infoList[winIdx].name}');

                            await _onAnimated(_infoViewModel.infoList[winIdx]);
                          }

                          setState(() {
                            _drawing = !_drawing;
                          });
                        },
                  child: const Text('추첨!')),
              const SizedBox(
                height: 10,
              )
            ]));
  }

  // 뽑기 결과 뷰
  Widget resultView(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        alignment: Alignment.center,
        child: _viewer,
      ),
    );
  }

  Future<void> _onAnimated(Info winner) async {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    List<Widget> tmp = [
      Container(
          width: width * boxWidth,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.amber.shade800,
              Colors.amber.shade400,
              Colors.amber.shade800
            ]),
          ),
          child: Text(
            winner.location,
            style: _textStyle,
          )),
      Container(
        width: width * boxWidth,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.amber.shade800,
          Colors.amber.shade400,
          Colors.amber.shade800
        ])),
        child: Text(
          winner.team,
          style: _textStyle,
        ),
      ),
      SizedBox(
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${winner.name} ${winner.rank}님',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Image.file(
                width: width * imageSize,
                height: height * imageSize,
                File(winner.image)),
          ],
        ),
      ),
    ];

    for (int i = 0; i < tmp.length; i++) {
      Future.delayed(Duration(seconds: i * _time), () {
        setState(() {
          _viewer = tmp[i];
        });
      });
    }

    Future.delayed(Duration(seconds: _time * tmp.length), () {
      setState(() {
        _viewing = false;
      });
    });
  }
}
