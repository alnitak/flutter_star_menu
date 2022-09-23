import 'package:flutter/material.dart';

/// class to define grid shape params
@immutable
class GridShapeParams {
  /// Number of columns
  final int columns;

  /// Horizontal space between items
  final int columnsSpaceH;

  /// Vertical space between items
  final int columnsSpaceV;

  const GridShapeParams(
      {this.columns = 3, this.columnsSpaceH = 0, this.columnsSpaceV = 0});

  GridShapeParams copyWith({
    int? columns,
    int? columnsSpaceH,
    int? columnsSpaceV,
  }) {
    return GridShapeParams(
      columns: columns ?? this.columns,
      columnsSpaceH: columnsSpaceH ?? this.columnsSpaceH,
      columnsSpaceV: columnsSpaceV ?? this.columnsSpaceV,
    );
  }
}
