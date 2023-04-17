import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

// enums
import '../utils/enums/enums.dart';

class CustomTimeSlider extends StatefulWidget {
  const CustomTimeSlider({
    super.key,
    required this.onChanged,
    required this.defaultValue,
  });

  final Function(Seconds) onChanged;
  final Seconds defaultValue;

  @override
  State<CustomTimeSlider> createState() => _CustomTimeSliderState();
}

class _CustomTimeSliderState extends State<CustomTimeSlider> {
  late double _value;

  final double min = 30;
  final double max = 75;
  final double stepSize = 15;
  final showInfinity = true;

  @override
  void initState() {
    super.initState();

    // setting the value to the default value
    _value = getSecondsFromEnum(widget.defaultValue);
  }

  // method to get the enum for the seconds
  Seconds getEnumValueForSeconds(double value) {
    if (value == 30) {
      return Seconds.thirty;
    } else if (value == 45) {
      return Seconds.fortyFive;
    } else if (value == 60) {
      return Seconds.sixty;
    } else {
      // for any other value (possibly 75)
      return Seconds.infinity;
    }
  }

  // method to get the seconds value from the enum
  double getSecondsFromEnum(Seconds seconds) {
    if (seconds == Seconds.thirty) {
      return 30;
    } else if (seconds == Seconds.fortyFive) {
      return 45;
    } else if (seconds == Seconds.sixty) {
      return 60;
    } else {
      // returning 75 to represent infinity at the step of 15
      return 75;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SfSliderTheme(
      data: SfSliderThemeData(
        activeTrackHeight: 37,
        inactiveTrackHeight: 37,
        thumbRadius: 18.5,
        thumbColor: Colors.white,
        activeTrackColor: Theme.of(context).primaryColor,
        inactiveTrackColor: Theme.of(context).primaryColor,
        thumbStrokeWidth: 2,
        thumbStrokeColor: Theme.of(context).primaryColor,
        overlayRadius: 0,
      ),
      child: SfSlider(
        value: _value,
        min: min,
        max: max,
        onChanged: (value) {
          widget.onChanged(getEnumValueForSeconds(value));

          setState(() {
            _value = value;
          });
        },
        stepSize: stepSize,
        thumbIcon: Center(
          child: showInfinity && _value == max
              ? const Icon(
                  Icons.all_inclusive,
                  size: 20,
                  weight: 600,
                )
              : Text(
                  '${_value.toInt()}s',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
        ),
      ),
    );
  }
}
