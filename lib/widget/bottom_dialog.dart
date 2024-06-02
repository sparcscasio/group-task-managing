import 'package:flutter/material.dart';

BottomDialog(BuildContext context, Widget contents) {
  return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width, // 모달 높이 크기
            decoration: const BoxDecoration(
                color: Colors.white, // 모달 배경색
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), // 모달 좌상단 라운딩 처리
                  topRight: Radius.circular(10), // 모달 우상단 라운딩 처리
                )),
            child: contents,
            );
      });
}
