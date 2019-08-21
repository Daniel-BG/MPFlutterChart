import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mp_flutter_chart/chart/mp/core/data.dart';
import 'package:mp_flutter_chart/chart/mp/core/description.dart';
import 'package:mp_flutter_chart/chart/mp/core/highlight.dart';
import 'package:mp_flutter_chart/chart/mp/core/interfaces.dart';
import 'package:mp_flutter_chart/chart/mp/core/marker.dart';
import 'package:mp_flutter_chart/chart/mp/core/render.dart';
import 'package:mp_flutter_chart/chart/mp/core/view_port.dart';
import 'package:mp_flutter_chart/chart/mp/listener.dart';
import 'package:mp_flutter_chart/chart/mp/painter/bar_chart_painter.dart';
import 'package:mp_flutter_chart/chart/mp/painter/pie_chart_painter.dart';
import 'package:mp_flutter_chart/chart/mp/poolable/point.dart';
import 'package:mp_flutter_chart/chart/mp/util.dart';

import 'chart.dart';

class PieChart extends Chart {
  Rect circleBox = Rect.zero;
  bool drawEntryLabels = true;
  bool drawHole = true;
  bool drawSlicesUnderHole = false;
  bool usePercentValues = false;
  bool drawRoundedSlices = false;
  String centerText = "";
  double holeRadiusPercent = 50;
  double transparentCircleRadiusPercent = 55;
  bool drawCenterText = true;
  double centerTextRadiusPercent = 100.0;
  double maxAngle = 360;
  double minAngleForSlices = 0;
  double rotationAngle = 270;
  double rawRotationAngle = 270;
  bool rotateEnabled = true;

  PieChart(ChartData<IDataSet<Entry>> data,
      InitPieChartPainterCallback initPieChartPainterCallback,
      {Rect circleBox = Rect.zero,
      bool drawEntryLabels = true,
      bool drawHole = true,
      bool drawSlicesUnderHole = false,
      bool usePercentValues = false,
      bool drawRoundedSlices = false,
      String centerText = "",
      double holeRadiusPercent = 50,
      double transparentCircleRadiusPercent = 55,
      bool drawCenterText = true,
      double centerTextRadiusPercent = 100.0,
      double maxAngle = 360,
      double minAngleForSlices = 0,
      double rotationAngle = 270,
      double rawRotationAngle = 270,
      bool rotateEnabled = true,
      double minOffset = 30,
      double maxHighlightDistance = 0.0,
      bool highLightPerTapEnabled = true,
      bool dragDecelerationEnabled = true,
      double dragDecelerationFrictionCoef = 0.9,
      double extraLeftOffset = 0.0,
      double extraTopOffset = 0.0,
      double extraRightOffset = 0.0,
      double extraBottomOffset = 0.0,
      String noDataText = "No chart data available.",
      bool touchEnabled = true,
      IMarker marker = null,
      Description desc = null,
      bool drawMarkers = true,
      TextPainter infoPainter = null,
      TextPainter descPainter = null,
      IHighlighter highlighter = null,
      bool unbind = false})
      : circleBox = circleBox,
        drawEntryLabels = drawEntryLabels,
        drawHole = drawHole,
        drawSlicesUnderHole = drawSlicesUnderHole,
        usePercentValues = usePercentValues,
        drawRoundedSlices = drawRoundedSlices,
        centerText = centerText,
        maxAngle = maxAngle,
        minAngleForSlices = minAngleForSlices,
        super(data, (painter) {
          if (painter is PieChartPainter) {
            initPieChartPainterCallback(painter);
          }
        },
            maxHighlightDistance: maxHighlightDistance,
            highLightPerTapEnabled: highLightPerTapEnabled,
            dragDecelerationEnabled: dragDecelerationEnabled,
            dragDecelerationFrictionCoef: dragDecelerationFrictionCoef,
            extraLeftOffset: extraLeftOffset,
            extraTopOffset: extraTopOffset,
            extraRightOffset: extraRightOffset,
            extraBottomOffset: extraBottomOffset,
            touchEnabled: touchEnabled,
            noDataText: noDataText,
            marker: marker,
            desc: desc,
            drawMarkers: drawMarkers,
            infoPainter: infoPainter,
            descPainter: descPainter,
            highlighter: highlighter,
            unbind: unbind) {
    // this.marker = BarChartMarker(); pie chart don't need mark for now
  }

  @override
  State<StatefulWidget> createState() {
    return PieChartState();
  }
}

class PieChartState extends ChartState<PieChartPainter, PieChart> {
  Highlight _lastHighlighted;

  @override
  void initialPainter() {
    painter = PieChartPainter(widget.data,
        viewPortHandler: widget.viewPortHandler,
        animator: animator,
        circleBox: widget.circleBox,
        drawEntryLabels: widget.drawEntryLabels,
        drawHole: widget.drawHole,
        drawSlicesUnderHole: widget.drawSlicesUnderHole,
        usePercentValues: widget.usePercentValues,
        drawRoundedSlices: widget.drawRoundedSlices,
        centerText: widget.centerText,
        maxAngle: widget.maxAngle,
        minAngleForSlices: widget.minAngleForSlices,
        rotationAngle: widget.rotationAngle,
        rawRotationAngle: widget.rawRotationAngle,
        rotateEnabled: widget.rotateEnabled,
        minOffset: widget.minOffset,
        maxHighlightDistance: widget.maxHighlightDistance,
        highLightPerTapEnabled: widget.highLightPerTapEnabled,
        dragDecelerationEnabled: widget.dragDecelerationEnabled,
        dragDecelerationFrictionCoef: widget.dragDecelerationFrictionCoef,
        extraLeftOffset: widget.extraLeftOffset,
        extraTopOffset: widget.extraTopOffset,
        extraRightOffset: widget.extraRightOffset,
        extraBottomOffset: widget.extraBottomOffset,
        noDataText: widget.noDataText,
        touchEnabled: widget.touchEnabled,
        marker: widget.marker,
        desc: widget.desc,
        drawMarkers: widget.drawMarkers,
        infoPainter: widget.infoPainter,
        descPainter: widget.descPainter,
        highlighter: widget.highlighter,
        unbind: widget.unbind);
    painter.highlightValue6(_lastHighlighted, false);
  }

  @override
  void onDoubleTap() {}

  @override
  void onScaleEnd(ScaleEndDetails detail) {}

  @override
  void onScaleStart(ScaleStartDetails detail) {}

  @override
  void onScaleUpdate(ScaleUpdateDetails detail) {}

  @override
  void onSingleTapUp(TapUpDetails detail) {
    if (painter.mHighLightPerTapEnabled) {
      Highlight h = painter.getHighlightByTouchPoint(
          detail.localPosition.dx, detail.localPosition.dy);
      _lastHighlighted =
          HighlightUtils.performHighlight(painter, h, _lastHighlighted);
      painter.getOnChartGestureListener()?.onChartSingleTapped(
          detail.localPosition.dx, detail.localPosition.dy);
      setState(() {});
    } else {
      _lastHighlighted = null;
    }
  }

  @override
  void onTapDown(TapDownDetails detail) {}
}

typedef InitPieChartPainterCallback = void Function(PieChartPainter painter);