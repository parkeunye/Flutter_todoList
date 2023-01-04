import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'memolist.dart';
import 'todolistpage.dart';
import 'timenow.dart';
import 'ex.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

// 시작 클래스
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const TodoBody(),
    );
  }
}

// TodoListPage 클래스
class TodoBody extends StatefulWidget {
  const TodoBody({Key? key}) : super(key: key);

  @override
  _TodoBodyState createState() => _TodoBodyState();
}


// TodoListPage의 State 클래스
class _TodoBodyState extends State<TodoBody> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(decoration: BoxDecoration(
            border: Border.all(
              color: Colors.orangeAccent,
              width: 7,)//테두리 굵기와 선 색
        ),
            child: Column(
              children: [
                const Timenow(),//현재 날짜,시간 표시
                Expanded(child: SingleChildScrollView(
                 //singleChildScrollView로 오버되는 리스트를 스크롤뷰로 볼 수 있게 표시
                    child: Expanded ( child: Column(
                      children: const [
                        TodoListPage(),//할 일 작성 페이지
                        Divider( // 할 일 페이지와 메모 페이지 구분 선
                          color: Colors.orange,
                          thickness: 3,
                          indent: 30,
                          endIndent: 30,
                        ), // Todolist
                        MemoList()// 메모 작성 페이지
                      ],
                    ),
                    )
                )
                ),
              ],
            )
        )
    );
  }

}