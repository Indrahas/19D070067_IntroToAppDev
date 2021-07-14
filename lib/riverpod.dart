import 'package:calculator/model/calculator.dart';
import 'package:calculator/utils.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:math_expressions/math_expressions.dart';

final calculatorProvider =
StateNotifierProvider<CalculatorNotifier>((ref) => CalculatorNotifier());

class CalculatorNotifier extends StateNotifier<Calculator> {
  CalculatorNotifier() : super(Calculator());

  void delete() {
    final equation = state.equation;

    if (equation.isNotEmpty) {
      final newEquation = equation.substring(0, equation.length - 1);

      if (newEquation.isEmpty) {
        reset();
      } else {
        state = state.copy(equation: newEquation, result: '', shouldAppend: false);
        calculate();
      }
    }
  }

  void reset() {
    final equation = '0';
    final result = '0';
    state = state.copy(equation: equation, result: result, shouldAppend: false);
  }

  void resetResult() {
    final equation = state.result;

    state = state.copy(
      equation: equation,
      shouldAppend: false, result: '',
    );
  }

  void append(String buttonText) {
    final equation = () {
      if (Utils.isOperator(buttonText) &&
          Utils.isOperatorAtEnd(state.equation)) {
        final newEquation =
        state.equation.substring(0, state.equation.length - 1);

        return newEquation + buttonText;
      } else if (state.shouldAppend) {
        return state.equation == '0' ? buttonText : state.equation + buttonText;
      } else {
        return Utils.isOperator(buttonText)
            ? state.equation + buttonText
            : buttonText;
      }
    }();

    state = state.copy(equation: equation, shouldAppend: true, result: '');
    calculate();
  }

  void equals() {
    calculate();
    resetResult();
  }

  void calculate() {
    final expression = state.equation.replaceAll('⨯', '*').replaceAll('÷', '/');

    try {
      final exp = Parser().parse(expression);
      final model = ContextModel();

      final result = '${exp.evaluate(EvaluationType.REAL, model)}';
      state = state.copy(result: result, shouldAppend: false, equation: '');
    } catch (e) {}
  }
}