import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({
    super.key,
    required this.min,
    required this.max,
    required this.onChanged,
    this.showInfinity = false,
    this.stepSize,
  });

  final double min;
  final double max;
  final Function(String) onChanged;
  final bool showInfinity;
  final double? stepSize;

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late double _value;

  @override
  void initState() {
    super.initState();

    _value = widget.min;
  }

  @override
  Widget build(BuildContext context) {
    return SfSliderTheme(
      data: SfSliderThemeData(
        activeTrackHeight: 50,
        inactiveTrackHeight: 50,
        thumbRadius: 25,
        thumbColor: Colors.white,
        activeTrackColor: Theme.of(context).primaryColor,
        inactiveTrackColor: Theme.of(context).primaryColor.withOpacity(.2),
        thumbStrokeWidth: 2,
        thumbStrokeColor: Theme.of(context).primaryColor,
      ),
      child: SfSlider(
        value: _value,
        min: widget.min,
        max: widget.max,
        onChanged: (value) {
          widget.onChanged(widget.showInfinity && value == widget.max
              ? '∞'
              : value.toString());

          setState(() {
            _value = value;
          });
        },
        stepSize: widget.stepSize,
        thumbIcon: Center(
          child: widget.showInfinity && _value == widget.max
              ? const Icon(
                  Icons.all_inclusive,
                  size: 20,
                  weight: 600,
                )
              : Text(
                  '${_value.toInt()}s',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
        ),
      ),
    );
  }
}
