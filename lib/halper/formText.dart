import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class lopo extends StatefulWidget {
  lopo({Key? key}) : super(key: key);

  @override
  _lopoState createState() => _lopoState();
}

class _lopoState extends State<lopo> {
  Set<Marker>? _markers;

  @override
  Widget build(BuildContext context) {
    // _buildMarkers();
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(-36.785533, 174.864509), zoom: 12),
          markers: _markers!,
        ),
      ),
    );
  }

  Future<void> _buildMarkers() async {
    //final bitMapDescriptors = await createBitmapDescriptors(stops.length);
    final bitmapDescriptor = await MarkerGenerator(30)
        .createBitmapDescriptorFromIconData(Icons.info, Colors.white, Colors.teal, Colors.transparent);

    final markers = Set<Marker>();

    final marker = Marker(
      markerId: MarkerId('markerA'),
      position: LatLng(-36.7704774, 174.8618268),
      icon: bitmapDescriptor,
    );

    markers.add(marker);

    setState(() => _markers = markers);
  }
}

class MarkerGenerator {
  final double _markerSize;
  double? _circleStrokeWidth;
  double? _circleOffset;
  double? _outlineCircleWidth;
  double? _fillCircleWidth;
  double? _iconSize;
  double? _iconOffset;

  MarkerGenerator(this._markerSize) {
    // calculate marker dimensions
    _circleStrokeWidth = _markerSize / 10.0;
    _circleOffset = _markerSize / 2;
    _outlineCircleWidth = (_circleOffset! - (_circleStrokeWidth! / 2));
    _fillCircleWidth = _markerSize / 2;
    final outlineCircleInnerWidth = _markerSize - (2 * _circleStrokeWidth!);
    _iconSize = sqrt(pow(outlineCircleInnerWidth, 2) / 2);
    final rectDiagonal = sqrt(2 * pow(_markerSize, 2));
    final circleDistanceToCorners = (rectDiagonal - outlineCircleInnerWidth) / 2;
    _iconOffset = sqrt(pow(circleDistanceToCorners, 2) / 2);
  }

  /// Creates a BitmapDescriptor from an IconData
  Future<BitmapDescriptor> createBitmapDescriptorFromIconData(
      IconData iconData, Color iconColor, Color circleColor, Color backgroundColor) async {
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    _paintCircleFill(canvas, backgroundColor);
    _paintCircleStroke(canvas, circleColor);
    _paintIcon(canvas, iconColor, iconData);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(_markerSize.round(), _markerSize.round());
    final bytes = await image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  /// Paints the icon background
  void _paintCircleFill(Canvas canvas, Color color) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.drawCircle(Offset(_circleOffset!, _circleOffset!), _fillCircleWidth!, paint);
  }

  /// Paints a circle around the icon
  void _paintCircleStroke(Canvas canvas, Color color) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = _circleStrokeWidth!;
    canvas.drawCircle(Offset(_circleOffset!, _circleOffset!), _outlineCircleWidth!, paint);
  }

  /// Paints the icon
  void _paintIcon(Canvas canvas, Color color, IconData iconData) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          letterSpacing: 0.0,
          fontSize: _iconSize,
          fontFamily: iconData.fontFamily,
          color: color,
        ));
    textPainter.layout();
    textPainter.paint(canvas, Offset(_iconOffset!, _iconOffset!));
  }
}
