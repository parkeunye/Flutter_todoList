import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


// 할 일 클래스
class Memo<List> {
  bool isDone;
  String comment;
  Timestamp? date;

  Memo(this.comment, {this.isDone = false,this.date});
}

// TodoListPage 클래스
class MemoList extends StatefulWidget {
  const MemoList({Key? key}) : super(key: key);

  @override
  _MemoListState createState() => _MemoListState();
}

// TodoListPage의 State 클래스
class _MemoListState extends State<MemoList> {
  final _memoController = TextEditingController();

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽으로 세로 정렬
          children: [
            //메모 텍스트
            const Text("메모",style: TextStyle(color: Colors.orangeAccent, fontSize: 20,fontWeight: FontWeight.bold)),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.orangeAccent,
                    width: 5,)
              ), height: 300,
              child: Column(
                children: <Widget>[ // 파이어베이스 연결 후 등록 순으로 메모 작성하는 코드
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('memo').orderBy('date').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      final documents = snapshot.data!.docs;
                      return Expanded(
                        child: ListView(
                          children:
                          documents.map((doc) => _buildItemWidget2(doc)).toList(),
                        ),
                      );
                    },
                  ),
                  Row(
                    children: <Widget>[
                      Expanded( // 메모 작성하는 부분
                        child: TextFormField(
                          controller: _memoController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black26,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2
                                ),
                              ),
                              labelText: '메모할 내용을 입력하세요',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 28),
            Center(// 버튼만 가운데 정렬
              child: ElevatedButton( // 메모 작성 후 등록 버튼
                onPressed: () => _addMemo(Memo(_memoController.text, date: Timestamp.now())),
                style: ElevatedButton.styleFrom(fixedSize: Size(150, 60)),
                child: const Text('메모 추가하기',style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        )
    );
  }

  // 할 일 객체를 ListTile 형태로 변경하는 메서드 documentsnapshot을 사용해 메모 안의 comment와 isDone 나타내기
  Widget _buildItemWidget2(DocumentSnapshot doc) {
    final memo = Memo(doc['comment'], isDone: doc['isDone']);
    return ListTile(
      onTap: () => _toggleMemo(doc),
      title: Text(
        memo.comment,
        style: memo.isDone
            ? const TextStyle(
          decoration: TextDecoration.lineThrough,
          fontStyle: FontStyle.italic,
        )
            : null,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => _deleteMemo(doc),
      ),
    );
  }

  // 할 일 추가 메서드
  void _addMemo(Memo memo) {
    FirebaseFirestore.instance
        .collection('memo')
        .add({'comment': memo.comment, 'isDone': memo.isDone, 'date': memo.date});
    _memoController.text = '';
  }

  // 할 일 삭제 메서드
  void _deleteMemo(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('memo').doc(doc.id).delete();
  }

  // 할 일 완료/미완료 메서드
  void _toggleMemo(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('memo').doc(doc.id).update({
      'isDone': !doc['isDone'],
    });
  }
}