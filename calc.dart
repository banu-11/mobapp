import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _display = '0';
  String _currentOperation = '';
  double _firstNumber = 0;
  double _secondNumber = 0;
  bool _isNewNumber = true;
  bool _isDecimalPressed = false;

  void _buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _clear();
      } else if (value == '⌫') {
        _backspace();
      } else if (value == '+' || value == '-' || value == '×' || value == '÷') {
        _setOperation(value);
      } else if (value == '=') {
        _calculate();
      } else if (value == '.') {
        _addDecimal();
      } else if (value == '+/-') {
        _toggleSign();
      } else {
        _addDigit(value);
      }
    });
  }

  void _clear() {
    _display = '0';
    _currentOperation = '';
    _firstNumber = 0;
    _secondNumber = 0;
    _isNewNumber = true;
    _isDecimalPressed = false;
  }

  void _backspace() {
    if (_display.length == 1 || (_display.startsWith('-') && _display.length == 2)) {
      _display = '0';
      _isNewNumber = true;
      _isDecimalPressed = false;
    } else {
      _display = _display.substring(0, _display.length - 1);
      if (_display.endsWith('.')) {
        _isDecimalPressed = false;
      }
    }
  }

  void _addDigit(String digit) {
    if (_isNewNumber) {
      _display = digit;
      _isNewNumber = false;
      _isDecimalPressed = false;
    } else {
      if (_display.length < 15) {
        _display += digit;
      }
    }
  }

  void _addDecimal() {
    if (_isNewNumber) {
      _display = '0.';
      _isNewNumber = false;
      _isDecimalPressed = true;
    } else if (!_isDecimalPressed) {
      _display += '.';
      _isDecimalPressed = true;
    }
  }

  void _toggleSign() {
    if (_display != '0') {
      if (_display.startsWith('-')) {
        _display = _display.substring(1);
      } else {
        _display = '-$_display';
      }
    }
  }

  void _setOperation(String operation) {
    if (_currentOperation.isNotEmpty && !_isNewNumber) {
      _calculate();
    }
    _firstNumber = double.parse(_display);
    _currentOperation = operation;
    _isNewNumber = true;
    _isDecimalPressed = false;
  }

  void _calculate() {
    if (_currentOperation.isEmpty) return;
    
    _secondNumber = double.parse(_display);
    double result = 0;
    
    switch (_currentOperation) {
      case '+':
        result = _firstNumber + _secondNumber;
        break;
      case '-':
        result = _firstNumber - _secondNumber;
        break;
      case '×':
        result = _firstNumber * _secondNumber;
        break;
      case '÷':
        if (_secondNumber != 0) {
          result = _firstNumber / _secondNumber;
        } else {
          _display = 'Error';
          _currentOperation = '';
          _isNewNumber = true;
          _isDecimalPressed = false;
          return;
        }
        break;
    }
    
    // Format result to avoid long decimals
    if (result == result.toInt()) {
      _display = result.toInt().toString();
    } else {
      _display = result.toString();
      // Limit decimal places
      List<String> parts = _display.split('.');
      if (parts[1].length > 8) {
        _display = result.toStringAsFixed(8);
      }
    }
    
    _currentOperation = '';
    _isNewNumber = true;
    _isDecimalPressed = _display.contains('.');
  }

  Widget _buildButton(String text, Color color, {Color textColor = Colors.white}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(60),
          elevation: 2,
          child: InkWell(
            onTap: () => _buttonPressed(text),
            borderRadius: BorderRadius.circular(60),
            child: Container(
              height: 70,
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Display
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.bottomRight,
                child: SingleChildScrollView(
                  reverse: true,
                  child: Text(
                    _display,
                    style: TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.w300,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            
            // Buttons
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  // Row 1: AC, +/-, %, ÷
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('C', Colors.grey.shade700),
                        _buildButton('⌫', Colors.grey.shade700),
                        _buildButton('+/-', Colors.grey.shade700),
                        _buildButton('÷', Colors.orange.shade700),
                      ],
                    ),
                  ),
                  
                  // Row 2: 7, 8, 9, ×
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('7', Colors.grey.shade800),
                        _buildButton('8', Colors.grey.shade800),
                        _buildButton('9', Colors.grey.shade800),
                        _buildButton('×', Colors.orange.shade700),
                      ],
                    ),
                  ),
                  
                  // Row 3: 4, 5, 6, -
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('4', Colors.grey.shade800),
                        _buildButton('5', Colors.grey.shade800),
                        _buildButton('6', Colors.grey.shade800),
                        _buildButton('-', Colors.orange.shade700),
                      ],
                    ),
                  ),
                  
                  // Row 4: 1, 2, 3, +
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('1', Colors.grey.shade800),
                        _buildButton('2', Colors.grey.shade800),
                        _buildButton('3', Colors.grey.shade800),
                        _buildButton('+', Colors.orange.shade700),
                      ],
                    ),
                  ),
                  
                  // Row 5: 0, ., =
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Material(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(60),
                              elevation: 2,
                              child: InkWell(
                                onTap: () => _buttonPressed('0'),
                                borderRadius: BorderRadius.circular(60),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '0',
                                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        _buildButton('.', Colors.grey.shade800),
                        _buildButton('=', Colors.orange.shade700),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
