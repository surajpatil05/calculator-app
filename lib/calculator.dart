import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  dynamic text = '0';
  double numOne = 0;
  double numTwo = 0;
  String result = '';
  String finalResult = '0';
  String opr = '';
  String preOpr = '';

  Widget calcButton(String btntxt, Color btncolor, Color txtcolor) {
    return Padding(
      padding: EdgeInsets.all(5.w), // Adds spacing between buttons
      child: SizedBox(
        width: 75.w, // Adjusted width for better spacing
        height: 65.h, // Adjusted height for better spacing
        child: ElevatedButton(
          onPressed: () {
            calculation(btntxt);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: btncolor,
              shape: const CircleBorder(),
              padding: EdgeInsets.all(15.r),
              overlayColor: Colors.white,
              shadowColor: Colors.grey[700],
              surfaceTintColor: Colors.grey[400]),
          child: Text(
            btntxt,
            style: TextStyle(
              fontSize: 30.sp,
              color: txtcolor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            const Icon(
              FontAwesomeIcons.list,
            ).icon,
            color: Colors.orangeAccent,
            size: 18.sp,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Padding(
                      padding: EdgeInsets.all(5.r),
                      child: Text(
                        text,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 65.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            for (var row in [
              ['AC', '+/-', '%', '÷'],
              ['7', '8', '9', 'x'],
              ['4', '5', '6', '-'],
              ['1', '2', '3', '+']
            ])
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: row
                    .map((btn) => calcButton(
                          btn,
                          btn == '÷' || btn == 'x' || btn == '-' || btn == '+'
                              ? Colors.orange
                              : (btn == 'AC' || btn == '+/-' || btn == '%')
                                  ? Colors.grey[600]! // Light grey color
                                  : Colors.grey[850]!,
                          Colors.white,
                        ))
                    .toList(),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Blank Circle Button
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(5.r),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[850],
                        shape: const CircleBorder(),
                        padding: EdgeInsets.all(15.r),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: FaIcon(
                          FontAwesomeIcons.calculator,
                          size: 30.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(5.r),
                    child: ElevatedButton(
                      onPressed: () {
                        calculation('0');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[850],
                        shape: const CircleBorder(),
                        padding: EdgeInsets.all(15.r),
                      ),
                      child: Text(
                        "0",
                        style: TextStyle(
                          fontSize: 30.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                calcButton('.', Colors.grey[850]!, Colors.white),
                calcButton('=', Colors.orange, Colors.white),
              ],
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  // Function to perform calculations

  void calculation(String btnText) {
    if (btnText == 'AC') {
      resetCalculator();
    } else if (btnText == '%') {
      percentageCalculation();
    } else if (btnText == '+/-') {
      toggleSign();
    } else if (btnText == '.') {
      addDecimalPoint();
    } else if (btnText == '=' || isOperator(btnText)) {
      processOperator(btnText);
    } else {
      processNumber(btnText);
    }

    setState(() {
      text = finalResult;
    });
  }

  void resetCalculator() {
    text = '0';
    numOne = 0;
    numTwo = 0;
    result = '';
    finalResult = '0';
    opr = '';
    preOpr = '';
  }

  void percentageCalculation() {
    if (result.isNotEmpty) {
      result = (double.parse(result) / 100).toString();
      finalResult = doesContainDecimal(result);
    }
  }

  void toggleSign() {
    if (result.isNotEmpty && result != '0') {
      result = result.startsWith('-') ? result.substring(1) : '-$result';
      finalResult = result;
    }
  }

  void addDecimalPoint() {
    if (!result.contains('.')) {
      result += '.';
      finalResult = result;
    }
  }

  bool isOperator(String value) {
    return value == '+' || value == '-' || value == 'x' || value == '/';
  }

  String formatNumber(double num) {
    return num % 1 == 0 ? num.toInt().toString() : num.toString();
  }

  void processOperator(String btnText) {
    if (result.isNotEmpty) {
      numTwo = double.parse(result); // Capture the second number
    }

    if (btnText == '=') {
      calculateFinalResult(); // Compute result
    } else {
      if (result.isNotEmpty) {
        numOne = double.parse(result);
      }
      opr = btnText;
      finalResult = '${formatNumber(numOne)} $opr'; // Display expression
      result = ''; // Reset result for next input
    }

    setState(() {
      text = finalResult;
    });
  }

  void processNumber(String btnText) {
    // If an operator was selected, append the new number instead of replacing everything
    if (opr.isNotEmpty) {
      result += btnText;
      finalResult = '${formatNumber(numOne)} $opr $btnText';
    } else {
      result += btnText;
      finalResult = result;
    }
  }

  void calculateFinalResult() {
    if (result.isEmpty || opr.isEmpty) return;

    numTwo = double.parse(result);

    switch (opr) {
      case '+':
        finalResult = (numOne + numTwo).toString();
        break;
      case '-':
        finalResult = (numOne - numTwo).toString();
        break;
      case 'x':
        finalResult = (numOne * numTwo).toString();
        break;
      case '/':
        finalResult = numTwo == 0 ? "Error" : (numOne / numTwo).toString();
        break;
    }

    finalResult = doesContainDecimal(finalResult);
    numOne = double.parse(finalResult);
    result = '';
    opr = '';
  }

  String doesContainDecimal(String result) {
    if (result.contains('.')) {
      List<String> splitDecimal = result.split('.');
      if (int.parse(splitDecimal[1]) == 0) {
        return splitDecimal[0];
      }
    }
    return result;
  }
}
