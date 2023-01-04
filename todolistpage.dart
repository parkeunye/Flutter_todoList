import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


// 할 일 클래스
class Todo<List> {
  bool isDone;
  String title;
  Timestamp? date;
  Todo(this.title, {this.isDone = false,this.date});

}

// TodoListPage 클래스
class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

// TodoListPage의 State 클래스
class _TodoListPageState extends State<TodoListPage> {
  final _todoController = TextEditingController();
  final CollectionReference _todos =
  FirebaseFirestore.instance.collection('todo');
  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("일정",style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.orangeAccent,
                    width: 5,)
              ), height: 300,
              child: Column(
                children: <Widget>[
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('todo').orderBy('date').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      final documents = snapshot.data!.docs;
                      return Expanded(
                        child: ListView(
                            children:
                            documents.map((doc) => _buildItemWidget1(doc)).toList()
                        ),
                      );
                    },
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child:TextFormField(
                          controller: _todoController,
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
                            labelText: '날짜 일정을 입력하세요',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () => _addTodo(Todo(_todoController.text, date: Timestamp.now())),
                style: ElevatedButton.styleFrom(fixedSize: const Size(150, 60)),
                child: const Text('일정 추가하기',style:TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        )
    );
  }

  // 할 일 객체를 ListTile 형태로 변경하는 메서드
  Widget _buildItemWidget1(DocumentSnapshot doc) {
    final todo = Todo(doc['title'], isDone: doc['isDone']);
    return ListTile(
      onTap: () => _toggleTodo(doc),
      title: Text(
        todo.title,
        style: todo.isDone
            ? const TextStyle(
          decoration: TextDecoration.lineThrough,
          fontStyle: FontStyle.italic,
        )
            : null,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => _deleteTodo(doc),
      ),
    );
  }

  // 할 일 추가 메서드
  void _addTodo(Todo todo) {
    FirebaseFirestore.instance
        .collection('todo')
        .add({'title': todo.title, 'isDone': todo.isDone, 'date': todo.date});
    _todoController.text = '';
  }

  // 할 일 삭제 메서드
  void _deleteTodo(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('todo').doc(doc.id).delete();
  }

  // 할 일 완료/미완료 메서드
  void _toggleTodo(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('todo').doc(doc.id).update({
      'isDone': !doc['isDone'],
    });
  }
}