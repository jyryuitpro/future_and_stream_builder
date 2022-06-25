import 'dart:math';

import 'package:flutter/material.dart';

class StreamScreen extends StatefulWidget {
  const StreamScreen({Key? key}) : super(key: key);

  @override
  State<StreamScreen> createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen> {
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 16.0,
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // 제네릭을 넣을 수 있습니다. (FutureBuilder와 StreamBuilder 동시에 해당되는 사항)
        // 함수에서 예측을 하기 때문에 넣지 않아도 됩니다.
        // 실제 snapshot.data에 들어가게되는 타입을 넣어줄 수 있다.
        // AsyncSnapshot<int> snapshot
        // stream을 따로 닫는 걸 신경쓸 필요가 없다.
        child: StreamBuilder<int>(
          // 함수가 종료되면 ConnectionState는 done
          stream: streamNumbers(),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'StreamBuilder',
                  style: textStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  // future: 가 없으면 ConnectionState.none이 나옵니다.
                  // ConnectionState가 바뀔 때마다, builder 함수가 새로 호출됩니다.
                  'ConState : ${snapshot.connectionState}',
                  style: textStyle,
                ),
                Row(
                  children: [
                    Text(
                      'Data : ${snapshot.data}',
                      style: textStyle,
                    ),
                    if (snapshot.connectionState == ConnectionState.waiting)
                      CircularProgressIndicator(),
                  ],
                ),
                Text(
                  // 실제로 Data를 받을 경우, Error는 null이 됩니다.
                  'Error : ${snapshot.error}',
                  style: textStyle,
                ),
                ElevatedButton(
                  onPressed: () {
                    // 한번 build함수가 호출 이후 FutureBuilder Data 및 Error Cashing이 이루어집니다.
                    // 즉, 기존 데이터가 유지된채로 builder: 함수가 다시 실행됩니다.
                    setState(() {});
                  },
                  child: Text('setState'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<int> getNumber() async {
    await Future.delayed(Duration(seconds: 3));

    final random = Random();

    // 에러가 발생되더라도 ConnectionState는 done으로 처리됩니다.
    throw Exception('에러가 발생했습니다.');

    // 100보다 작은 random number
    return random.nextInt(100);
  }

  Stream<int> streamNumbers() async* {
    for (int i = 0; i < 10; i++) {

      if (i == 5) {
        throw Exception('i == 5');
      }

      await Future.delayed(
        Duration(seconds: 1),
      );

      // stream에서 값을 계속 받고 있을 때, 즉 stream이 끝나지 않았을 때를 말하며
      // ConnectionState는 active이다.
      yield i;
    }
  }
}
