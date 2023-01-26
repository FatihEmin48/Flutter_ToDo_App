import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../constants/colors.dart';
import '../widgets/todo_item.dart';

class Home extends StatefulWidget{
  Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  _deleteToDoItem(String id){
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
  }
  _handleToDoChange(ToDo todo){
    setState ((){
      todo.isDone = !todo.isDone;
    });
  }
  _addToDoItem(String toDo){
    if(toDo.isEmpty){}
    else{
      setState(() {
        todosList.add(ToDo(id: DateTime.now().millisecondsSinceEpoch.toString(), todoText: toDo));
      });
      _todoController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  _runFilter(String enteredKeyword){
    List<ToDo> result = [];
    if(enteredKeyword.isEmpty){result = todosList;}
    else{
      result = todosList
          .where((item) => item.todoText!
            .toLowerCase()
            .contains(enteredKeyword
            .toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = result;
    });
  }

  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo =[];
  final _todoController = TextEditingController();

  @override
  void initState(){
    _foundToDo = todosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
        Container(
        padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
              ),
              child: TextField(
                onChanged: (value) => _runFilter(value),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  prefixIcon: Icon(
                    Icons.search,
                    color: tdBlack,
                    size: 20,
                  ),
                  prefixIconConstraints: BoxConstraints(
                    maxHeight: 20,
                    minWidth: 25,
                  ),
                  border: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: tdGrey,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50, bottom: 20,),
                  child: Text(
                    'All ToDos',
                    style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                for (ToDo todoo in _foundToDo.reversed)
                  ToDoItem(
                    todo: todoo,
                    onToDoChanged: _handleToDoChange,
                    onDeleteItem: _deleteToDoItem,
                  ),
              ],
            ),
            ),
          ],
        ),
      ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
                Expanded(child: Container(margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5,),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 10.0,
                      spreadRadius: 0.0,
                    ),],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                      hintText: 'Add a new todo item',
                      border: InputBorder.none
                    ),
                  ),
                ),
                ),
              Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                  right: 20,),
                child: ElevatedButton(
                  child: Text('+', style: TextStyle(fontSize: 40,),),
                  onPressed: (){
                    _addToDoItem(_todoController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: tdBlue,
                    minimumSize: Size(60, 60),
                    elevation: 10,
                  ),
                ),
              ),
              ],),
          )
      ],
    ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Icon(
          Icons.menu,
          color: tdBlack,
          size: 30,
        ),
        Container(
          height: 40,
          width: 40,
          child: ClipRect(
            //borderRadius: BorderRadius.circular(20),
            child: Image.asset('images/logo.png'),
          ),
        ),
      ],),
    );
  }
}
