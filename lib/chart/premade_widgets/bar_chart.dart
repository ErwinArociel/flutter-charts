import 'package:charts_painter/chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef DataToValue<T> = double Function(T item);
typedef DataToAxis<T> = String Function(int item);

class BarChart<T> extends StatelessWidget {
  BarChart({
    required List<T> data,
    required this.dataToValue,
    this.height = 240.0,
    required this.backgroundDecorations,
    required this.foregroundDecorations,
    this.chartBehaviour = const ChartBehaviour(),
    this.itemOptions = const BarItemOptions(),
    this.stack = false,
    required Key key,
  })  : _mappedValues = [data.map((e) => BarValue<T>(dataToValue!(e))).toList()],
        super(key: key);

   const BarChart.map(
    this._mappedValues, {
    this.height = 240.0,
    required this.backgroundDecorations,
    required this.foregroundDecorations,
    this.chartBehaviour = const ChartBehaviour(),
    this.itemOptions = const BarItemOptions(),
    this.stack = false,
    required Key key,
  })  : dataToValue = null,
        super(key: key);

  final DataToValue<T>? dataToValue;
  final List<List<BarValue<T>>> _mappedValues;
  final double height;

  final bool stack;
  final ItemOptions itemOptions;
  final ChartBehaviour chartBehaviour;
  final List<DecorationPainter> backgroundDecorations;
  final List<DecorationPainter> foregroundDecorations;

  @override
  Widget build(BuildContext context) {
    final _foregroundDecorations = foregroundDecorations;
    final _backgroundDecorations = backgroundDecorations;

    return AnimatedChart<T>(
      height: height,
      width: MediaQuery.of(context).size.width - 24.0,
      duration: const Duration(milliseconds: 450),
      state: ChartState<T>(
        ChartData(_mappedValues,
            valueAxisMaxOver: 1.5,
            strategy: stack ? DataStrategy.stack : DataStrategy.none),
        itemOptions: itemOptions,
        behaviour: chartBehaviour,
        foregroundDecorations: _foregroundDecorations,
        backgroundDecorations: [
          ..._backgroundDecorations,
        ],
      ),
    );
  }
}
