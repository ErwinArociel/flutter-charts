part of charts_painter;

/// Paint bar value item. This is painter used for [BarValue] and [CandleValue]
///
/// Bar value:
///    ┌───────────┐ --> Max value in set or from [ChartData.axisMax]
///    │           │
///    │   ┌───┐   │ --> Bar value
///    │   │   │   │
///    │   │   │   │
///    │   │   │   │
///    │   │   │   │
///    └───┴───┴───┘ --> 0 or [ChartData.axisMin]
///
/// Candle value:
///    ┌───────────┐ --> Max value in set or [ChartData.axisMax]
///    │           │
///    │   ┌───┐   │ --> Candle max value
///    │   │   │   │
///    │   │   │   │
///    │   └───┘   │ --> Candle min value
///    │           │
///    └───────────┘ --> 0 or [ChartData.axisMin]
///
class BarGeometryPainter<T> extends GeometryPainter<T> {
  /// Constructor for Bar painter
  BarGeometryPainter(ChartItem<T> item, ChartState state) : super(item, state);

  @override
  void draw(Canvas canvas, Size size, Paint paint) {
    final options = state.itemOptions;

    final _maxValue = state.data.maxValue - state.data.minValue;
    final _verticalMultiplier = size.height / _maxValue;
    final _minValue = state.data.minValue * _verticalMultiplier;

    final _radius = options is BarItemOptions
        ? (options.radius ?? BorderRadius.zero)
        : BorderRadius.zero;

    var _padding = state.itemOptions.padding;

    final _itemWidth = itemWidth(size);

    if (size.width - _itemWidth - _padding.horizontal >= 0) {
      _padding =
          EdgeInsets.symmetric(horizontal: (size.width - _itemWidth) / 2);
    }

    final _itemMaxValue = item.max ?? 0.0;

    // If item is empty, or it's max value is below chart's minValue then don't draw it.
    // minValue can be below 0, this will just ensure that animation is drawn correctly.
    if (item.isEmpty || _itemMaxValue < state.data.minValue) {
      return;
    }

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromPoints(
          Offset(
            _padding.left,
            max(state.data.minValue, item.min ?? 0.0) * _verticalMultiplier -
                _minValue,
          ),
          Offset(
            _itemWidth + _padding.left - min((state.defaultMargin.vertical / (Device.get().isTablet ? 1.5 : 1.0) / state.data.listSize), size.width / 1.8),
            _itemMaxValue * _verticalMultiplier - _minValue,
          ),
        ),
        bottomLeft:
            _itemMaxValue.isNegative ? _radius.topLeft : _radius.bottomLeft,
        bottomRight:
            _itemMaxValue.isNegative ? _radius.topRight : _radius.bottomRight,
        topLeft:
            _itemMaxValue.isNegative ? _radius.bottomLeft : _radius.topLeft,
        topRight:
            _itemMaxValue.isNegative ? _radius.bottomRight : _radius.topRight,
      ),
      paint,
    );

    final _border = options is BarItemOptions ? options.border : null;

    if (_border != null && _border.style == BorderStyle.solid) {
      final _borderPaint = Paint();
      _borderPaint.style = PaintingStyle.stroke;
      _borderPaint.color = _border.color;
      _borderPaint.strokeWidth = _border.width;

      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromPoints(
            Offset(
              _padding.left,
              max(state.data.minValue, item.min ?? 0.0) * _verticalMultiplier -
                  _minValue,
            ),
            Offset(
              _itemWidth + _padding.left,
              _itemMaxValue * _verticalMultiplier - _minValue,
            ),
          ),
          bottomLeft:
              _itemMaxValue.isNegative ? _radius.topLeft : _radius.bottomLeft,
          bottomRight:
              _itemMaxValue.isNegative ? _radius.topRight : _radius.bottomRight,
          topLeft:
              _itemMaxValue.isNegative ? _radius.bottomLeft : _radius.topLeft,
          topRight:
              _itemMaxValue.isNegative ? _radius.bottomRight : _radius.topRight,
        ),
        _borderPaint,
      );
    }
  }
}
