class Calculator {
  final bool shouldAppend;
  final String equation;
  final String result;

  const Calculator({
    this.shouldAppend = true,
    this.equation = '0',
    this.result = '0',
  });

  Calculator copy({
    required bool shouldAppend,
    required String equation,
    required String result,
  }) =>
      Calculator(
        shouldAppend: shouldAppend ?? this.shouldAppend,
        equation: equation ?? this.equation,
        result: result ?? this.result,
      );
}