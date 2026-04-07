import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const ScientificCalculatorApp());
}

class ScientificCalculatorApp extends StatelessWidget {
  const ScientificCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scientific Calculator',
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
      home: const ScientificCalculator(),
    );
  }
}

class ScientificCalculator extends StatefulWidget {
  const ScientificCalculator({super.key});

  @override
  State<ScientificCalculator> createState() => _ScientificCalculatorState();
}

class _ScientificCalculatorState extends State<ScientificCalculator> {
  String _display = '0';
  String _expression = '';
  String _memory = '0';
  bool _isNewNumber = true;
  bool _isDecimalPressed = false;
  bool _isShiftPressed = false;
  bool _isRadians = true; // true for radians, false for degrees
  String _lastResult = '0';

  // Scientific constants
  static const double pi = 3.141592653589793;
  static const double e = 2.718281828459045;

  void _buttonPressed(String value) {
    setState(() {
      switch (value) {
        case 'AC':
          _clear();
          break;
        case 'C':
          _clearEntry();
          break;
        case '⌫':
          _backspace();
          break;
        case '=':
          _calculate();
          break;
        case '+/-':
          _toggleSign();
          break;
        case '.':
          _addDecimal();
          break;
        case 'sin':
        case 'cos':
        case 'tan':
        case 'sin⁻¹':
        case 'cos⁻¹':
        case 'tan⁻¹':
          _calculateTrigonometric(value);
          break;
        case 'log':
        case 'ln':
        case '10ˣ':
        case 'eˣ':
          _calculateLogarithmic(value);
          break;
        case '√':
        case '∛':
        case 'x²':
        case 'x³':
        case 'xʸ':
        case 'e':
        case 'π':
          _calculatePowerRoot(value);
          break;
        case '1/x':
          _calculateReciprocal();
          break;
        case '|x|':
          _calculateAbsolute();
          break;
        case 'n!':
          _calculateFactorial();
          break;
        case 'Rad':
        case 'Deg':
          _toggleAngleMode();
          break;
        case '2nd':
          _toggleShift();
          break;
        case 'MC':
          _memoryClear();
          break;
        case 'MR':
          _memoryRecall();
          break;
        case 'MS':
          _memoryStore();
          break;
        case 'M+':
          _memoryAdd();
          break;
        case 'M-':
          _memorySubtract();
          break;
        case '(':
        case ')':
          _addParenthesis(value);
          break;
        default:
          _addDigit(value);
      }
    });
  }

  void _clear() {
    _display = '0';
    _expression = '';
    _isNewNumber = true;
    _isDecimalPressed = false;
  }

  void _clearEntry() {
    _display = '0';
    _isNewNumber = true;
    _isDecimalPressed = false;
  }

  void _backspace() {
    if (_display.length == 1 ||
        (_display.startsWith('-') && _display.length == 2)) {
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
      if (_display.length < 20) {
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

  void _addParenthesis(String parenthesis) {
    if (_expression.isEmpty || !_isNewNumber) {
      _expression += _display;
      _isNewNumber = true;
    }
    _expression += parenthesis;
    _display = parenthesis;
    _isNewNumber = true;
  }

  void _calculate() {
    try {
      String expressionToEvaluate = _expression + _display;

      // Replace scientific symbols
      expressionToEvaluate = expressionToEvaluate
          .replaceAll('π', pi.toString())
          .replaceAll('e', e.toString())
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('xʸ', '^');

      // Handle power operator
      if (expressionToEvaluate.contains('^')) {
        expressionToEvaluate = _handlePowerOperator(expressionToEvaluate);
      }

      // Evaluate expression
      double result = _evaluateExpression(expressionToEvaluate);

      // Format result
      String formattedResult = _formatResult(result);

      setState(() {
        _display = formattedResult;
        _expression = '';
        _isNewNumber = true;
        _isDecimalPressed = _display.contains('.');
        _lastResult = formattedResult;
      });
    } catch (e) {
      setState(() {
        _display = 'Error';
        _expression = '';
        _isNewNumber = true;
      });
    }
  }

  String _handlePowerOperator(String expression) {
    List<String> parts = expression.split('^');
    if (parts.length == 2) {
      double base = double.parse(parts[0]);
      double exponent = double.parse(parts[1]);
      double result = pow(base, exponent).toDouble();
      return result.toString();
    }
    return expression;
  }

  double _evaluateExpression(String expression) {
    // Simple expression evaluator for basic operations
    // For a production app, consider using a proper expression parser
    if (expression.contains('+')) {
      List<String> parts = expression.split('+');
      return double.parse(parts[0]) + double.parse(parts[1]);
    } else if (expression.contains('-') && !expression.startsWith('-')) {
      List<String> parts = expression.split('-');
      return double.parse(parts[0]) - double.parse(parts[1]);
    } else if (expression.contains('*')) {
      List<String> parts = expression.split('*');
      return double.parse(parts[0]) * double.parse(parts[1]);
    } else if (expression.contains('/')) {
      List<String> parts = expression.split('/');
      double denominator = double.parse(parts[1]);
      if (denominator == 0) throw Exception('Division by zero');
      return double.parse(parts[0]) / denominator;
    }
    return double.parse(expression);
  }

  void _calculateTrigonometric(String func) {
    double value = double.parse(_display);

    // Convert to radians if in degree mode
    if (!_isRadians) {
      value = value * pi / 180;
    }

    double result;
    switch (func) {
      case 'sin':
        result = sin(value);
        break;
      case 'cos':
        result = cos(value);
        break;
      case 'tan':
        result = tan(value);
        break;
      case 'sin⁻¹':
        result = asin(value);
        break;
      case 'cos⁻¹':
        result = acos(value);
        break;
      case 'tan⁻¹':
        result = atan(value);
        break;
      default:
        return;
    }

    // Convert back to degrees if needed
    if (!_isRadians && func.contains('⁻¹')) {
      result = result * 180 / pi;
    }

    setState(() {
      _display = _formatResult(result);
      _isNewNumber = true;
      _isDecimalPressed = _display.contains('.');
    });
  }

  void _calculateLogarithmic(String func) {
    double value = double.parse(_display);
    double result;

    switch (func) {
      case 'log':
        if (value <= 0) {
          _display = 'Error';
          return;
        }
        result = log(value) / ln10;
        break;
      case 'ln':
        if (value <= 0) {
          _display = 'Error';
          return;
        }
        result = log(value);
        break;
      case '10ˣ':
        result = pow(10, value).toDouble();
        break;
      case 'eˣ':
        result = exp(value);
        break;
      default:
        return;
    }

    setState(() {
      _display = _formatResult(result);
      _isNewNumber = true;
      _isDecimalPressed = _display.contains('.');
    });
  }

  void _calculatePowerRoot(String func) {
    double value = double.parse(_display);
    double result;

    switch (func) {
      case '√':
        if (value < 0) {
          _display = 'Error';
          return;
        }
        result = sqrt(value);
        break;
      case '∛':
        result = pow(value, 1 / 3).toDouble();
        break;
      case 'x²':
        result = value * value;
        break;
      case 'x³':
        result = value * value * value;
        break;
      case 'xʸ':
        _expression = _display + '^';
        _isNewNumber = true;
        return;
      case 'e':
        result = e;
        break;
      case 'π':
        result = pi;
        break;
      default:
        return;
    }

    setState(() {
      _display = _formatResult(result);
      _isNewNumber = true;
      _isDecimalPressed = _display.contains('.');
    });
  }

  void _calculateReciprocal() {
    double value = double.parse(_display);
    if (value == 0) {
      _display = 'Error';
      return;
    }
    double result = 1 / value;
    setState(() {
      _display = _formatResult(result);
      _isNewNumber = true;
    });
  }

  void _calculateAbsolute() {
    double value = double.parse(_display);
    double result = value.abs();
    setState(() {
      _display = _formatResult(result);
      _isNewNumber = true;
    });
  }

  void _calculateFactorial() {
    int value = int.tryParse(_display) ?? 0;
    if (value < 0 || value > 170) {
      _display = 'Error';
      return;
    }

    int result = 1;
    for (int i = 2; i <= value; i++) {
      result *= i;
    }

    setState(() {
      _display = result.toString();
      _isNewNumber = true;
    });
  }

  void _toggleAngleMode() {
    setState(() {
      _isRadians = !_isRadians;
    });
  }

  void _toggleShift() {
    setState(() {
      _isShiftPressed = !_isShiftPressed;
    });
  }

  void _memoryClear() {
    _memory = '0';
  }

  void _memoryRecall() {
    setState(() {
      _display = _memory;
      _isNewNumber = true;
    });
  }

  void _memoryStore() {
    _memory = _display;
  }

  void _memoryAdd() {
    double memoryValue = double.parse(_memory);
    double displayValue = double.parse(_display);
    _memory = (memoryValue + displayValue).toString();
  }

  void _memorySubtract() {
    double memoryValue = double.parse(_memory);
    double displayValue = double.parse(_display);
    _memory = (memoryValue - displayValue).toString();
  }

  String _formatResult(double result) {
    if (result.isNaN || result.isInfinite) {
      return 'Error';
    }

    if (result == result.toInt()) {
      return result.toInt().toString();
    }

    String formatted = result.toString();
    List<String> parts = formatted.split('.');
    if (parts[1].length > 10) {
      formatted = result.toStringAsFixed(10);
    }

    return formatted;
  }

  Widget _buildButton(String text, Color color, {double fontSize = 24}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(12),
          elevation: 1,
          child: InkWell(
            onTap: () => _buttonPressed(text),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 60,
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
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
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Column(
          children: [
            // Display
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey.shade900,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: TextStyle(fontSize: 20, color: Colors.grey.shade500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _display,
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Buttons
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Memory and Mode Row
                    Row(
                      children: [
                        _buildButton('MC', Colors.grey.shade800, fontSize: 16),
                        _buildButton('MR', Colors.grey.shade800, fontSize: 16),
                        _buildButton('MS', Colors.grey.shade800, fontSize: 16),
                        _buildButton('M+', Colors.grey.shade800, fontSize: 16),
                        _buildButton('M-', Colors.grey.shade800, fontSize: 16),
                      ],
                    ),

                    // Row 1: Scientific functions
                    Row(
                      children: [
                        _buildButton(
                          _isShiftPressed ? 'sin⁻¹' : 'sin',
                          Colors.grey.shade800,
                        ),
                        _buildButton(
                          _isShiftPressed ? 'cos⁻¹' : 'cos',
                          Colors.grey.shade800,
                        ),
                        _buildButton(
                          _isShiftPressed ? 'tan⁻¹' : 'tan',
                          Colors.grey.shade800,
                        ),
                        _buildButton('log', Colors.grey.shade800),
                        _buildButton('ln', Colors.grey.shade800),
                      ],
                    ),

                    // Row 2: More scientific functions
                    Row(
                      children: [
                        _buildButton('√', Colors.grey.shade800),
                        _buildButton('∛', Colors.grey.shade800),
                        _buildButton('x²', Colors.grey.shade800),
                        _buildButton('x³', Colors.grey.shade800),
                        _buildButton('xʸ', Colors.grey.shade800),
                      ],
                    ),

                    // Row 3: Constants and operations
                    Row(
                      children: [
                        _buildButton('e', Colors.grey.shade800),
                        _buildButton('π', Colors.grey.shade800),
                        _buildButton('1/x', Colors.grey.shade800),
                        _buildButton('|x|', Colors.grey.shade800),
                        _buildButton('n!', Colors.grey.shade800),
                      ],
                    ),

                    // Row 4: Clear and angle mode
                    Row(
                      children: [
                        _buildButton('AC', Colors.red.shade700),
                        _buildButton('C', Colors.orange.shade700),
                        _buildButton(
                          _isRadians ? 'Rad' : 'Deg',
                          Colors.grey.shade800,
                          fontSize: 16,
                        ),
                        _buildButton('2nd', Colors.grey.shade800, fontSize: 18),
                        _buildButton('⌫', Colors.orange.shade700),
                      ],
                    ),

                    // Row 5: 7,8,9 and operators
                    Row(
                      children: [
                        _buildButton('7', Colors.grey.shade800),
                        _buildButton('8', Colors.grey.shade800),
                        _buildButton('9', Colors.grey.shade800),
                        _buildButton('÷', Colors.blue.shade700),
                        _buildButton('(', Colors.grey.shade800),
                      ],
                    ),

                    // Row 6: 4,5,6 and operators
                    Row(
                      children: [
                        _buildButton('4', Colors.grey.shade800),
                        _buildButton('5', Colors.grey.shade800),
                        _buildButton('6', Colors.grey.shade800),
                        _buildButton('×', Colors.blue.shade700),
                        _buildButton(')', Colors.grey.shade800),
                      ],
                    ),

                    // Row 7: 1,2,3 and operators
                    Row(
                      children: [
                        _buildButton('1', Colors.grey.shade800),
                        _buildButton('2', Colors.grey.shade800),
                        _buildButton('3', Colors.grey.shade800),
                        _buildButton('-', Colors.blue.shade700),
                        _buildButton('+/-', Colors.grey.shade800),
                      ],
                    ),

                    // Row 8: 0, ., = and operators
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Material(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(12),
                              elevation: 1,
                              child: InkWell(
                                onTap: () => _buttonPressed('0'),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 60,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '0',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        _buildButton('.', Colors.grey.shade800),
                        _buildButton('=', Colors.green.shade700),
                        _buildButton('+', Colors.blue.shade700),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Mathematical constants
const double ln10 = 2.302585092994046;
