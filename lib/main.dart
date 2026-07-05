
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Calculator",
      debugShowCheckedModeBanner: false,
      home: CalculatorExample(),
    );
  }
}

class CalculatorExample extends StatefulWidget {
  const CalculatorExample({super.key});

  @override
  State<CalculatorExample> createState() => _CalculatorExampleState();
}

class _CalculatorExampleState extends State<CalculatorExample> {
  Size? size;
  String inputval = "";
  String calval = "";
  String op = "";
  String exp = "";
  final ScrollController _scrollController = ScrollController();
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Calculator",style: TextStyle(color: Colors.white, fontWeight:FontWeight.bold),),backgroundColor: Color.fromRGBO(49, 49, 49, 1), centerTitle: true,),
      backgroundColor: Color.fromRGBO(49, 49, 49, 1),
      // appBar: AppBar(title: const Text("Basic Calculator")),
      body: Column(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            width: size?.width,
            height: (size?.height ?? 0) * .4,
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 25),
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
            physics: AlwaysScrollableScrollPhysics(),
              child: Text(
                exp,
                style: TextStyle(color: Colors.white, fontSize: 70),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 15,
                children: [
                  Expanded(
                    child: Row(
                      spacing: 15,
                      children: [
                        button("AC", Color.fromRGBO(255, 191, 0, 1),textcolor: Colors.black),
                        button("%", Color.fromRGBO(75, 75, 75, 1)),
                        button("backspace", Color.fromRGBO(75, 75, 75, 1)),
                        button("/", Color.fromRGBO(75, 75, 75, 1)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      spacing: 15,
                      children: [
                        button("7", Color.fromRGBO(75, 75, 75, 1)),
                        button("8", Color.fromRGBO(75, 75, 75, 1)),
                        button("9", Color.fromRGBO(75, 75, 75, 1)),
                        button("X", Color.fromRGBO(75, 75, 75, 1)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      spacing: 15,
                      children: [
                        button("4", Color.fromRGBO(75, 75, 75, 1)),
                        button("5", Color.fromRGBO(75, 75, 75, 1)),
                        button("6", Color.fromRGBO(75, 75, 75, 1)),
                        button("+", Color.fromRGBO(75, 75, 75, 1)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      spacing: 15,
                      children: [
                        button("1", Color.fromRGBO(75, 75, 75, 1)),
                        button("2", Color.fromRGBO(75, 75, 75, 1)),
                        button("3", Color.fromRGBO(75, 75, 75, 1)),
                        button("-", Color.fromRGBO(75, 75, 75, 1)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      spacing: 15,
                      children: [
                        button("0", Color.fromRGBO(75, 75, 75, 1),width: 175,flex: 2),
                        button(".", Color.fromRGBO(75, 75, 75, 1)),
                        button("=", Color.fromRGBO(75, 75, 75, 1)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget button(String input, Color bgcolor,{double width = 80.0,int flex = 1,Color textcolor = Colors.white}) {
    return Expanded(
      flex: flex,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          setState(() {
            if (input == "AC") {
              inputval = "";
              op = "";
              calval = "";
              exp = "";
            } else if (input == "backspace") {
              if (inputval != "") {
                inputval = inputval.substring(0, inputval.length - 1);
                exp = op.isNotEmpty ? "$calval $op $inputval" : inputval;
              }
              else if (op != ""){
                op = "";
                inputval = calval;
                calval = "";
                exp = inputval;
              }
              else if (calval != ""){
                calval = calval.substring(0,calval.length - 1);
                inputval = calval;
                calval = "";
                exp = inputval;
              }
            } else if (input == "-" && inputval == "") {
              inputval = "-";
              exp = exp + input;
            } else if (input == "+" ||
                input == "-" ||
                input == "X" ||
                input == "/" || input == "%") {
              if (inputval != "" && inputval != "-") {
                calval = inputval;
                inputval = "";
                op = input;
                exp = "$calval $op";
              }
            } else if (input == "=") {
              if (calval != "" && inputval != "" && op != "") {
                exp = "$calval $op $inputval";
                if (op == "+") {
                  inputval = (num.parse(calval) + num.parse(inputval))
                      .toString();
                } else if (op == "-") {
                  inputval = (num.parse(calval) - num.parse(inputval))
                      .toString();
                } else if (op == "X") {
                  inputval = (num.parse(calval) * num.parse(inputval))
                      .toString();
                } else if (op == "/") {
                  inputval = (num.parse(calval) / num.parse(inputval))
                      .toString();
                } else if (op == "%") {
                  inputval = (num.parse(calval) * (num.parse(inputval) / 100)).toString(); 
                      
                }
      
                op = "";
                calval = "";
                exp = inputval;
              }
            } else {
              inputval = inputval + input;
              if (op != "") {
                exp = "$calval $op $inputval";
              } else {
                exp = inputval;
              }
            }
          });
          _scrollToBottom();
        },
        child: Container(
          width: width,
          height: 80.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: bgcolor,
          ),
          child: SizedBox(
            width: 25.48,
            height: 35.47,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: input == "backspace"
                  ? Icon(
                      Icons.backspace_outlined,
                      color: Colors.white,
                      size: 20,
                    )
                  : Text(
                      input,
                      style: TextStyle(color: textcolor, fontSize: 20,fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
