import 'dart:math';

import 'package:flutter/material.dart';

class FutureScreen extends StatefulWidget {
  const FutureScreen({Key? key}) : super(key: key);

  @override
  State<FutureScreen> createState() => _FutureScreenState();
}

class _FutureScreenState extends State<FutureScreen> {
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 16.0,
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: getNumber(),
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }

            // FutureBuilder Data Cashing을 고려한 작업
            // if (!snapshot.hasData) {
            //   return Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }

            if (snapshot.hasData) {
              // 데이터가 있을 때, 위젯 렌더링
            }

            if (snapshot.hasError) {
              // 에러가 났을 때, 위젯 렌더링
            }

            // 위 둘다 아닌 경우, 즉 로딩중일 때
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'FutureBuilder',
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
}
