import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

// constants
import '../utils/constants/constants.dart';

// providers
import '../providers/providers.dart';

class CustomTimeSlider extends StatefulWidget {
  const CustomTimeSlider({
    super.key,
    required this.onChanged,
    required this.value,
    required this.min,
    required this.count,
    required this.stepSize,
  });

  final Function(double) onChanged;
  final double min;
  final int count;
  final double value;
  final double stepSize;

  @override
  State<CustomTimeSlider> createState() => _CustomTimeSliderState();
}

class _CustomTimeSliderState extends State<CustomTimeSlider> {
  late double _value;

  // to hold the max value
  late double max;

  // max representing infinity
  late double maxRepresentingInfinity;

  @override
  void initState() {
    super.initState();

    // calculating the value of max
    max = widget.min + (widget.stepSize * (widget.count - 1));

    // getting the max representing infinity
    maxRepresentingInfinity = max + widget.stepSize;

    // assigning the value
    _value = widget.value == -1 ? maxRepresentingInfinity : widget.value;

    // if value is not maxRepresentinginfinity but less than min value or greater than max infinity value then throw an error
    if (_value != maxRepresentingInfinity &&
        (_value < widget.min || _value > max)) {
      throw 'Value can not be smaller than minimum or greater than maximum';
    }

    // if value is not a multiple of step size then throw an error
    if (_value != maxRepresentingInfinity && _value % widget.stepSize != 0) {
      throw 'Value needs to be a multiple of step size';
    }

    // if count is less than 2 then throw an error
    if (widget.count < 2) {
      throw 'Count can not be less than 2';
    }

    // if min is greater than or equals max then throw an error
    if (widget.min >= max) {
      throw 'Min can not be greater than or equals to max';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(100),
              border: themeProvider.isDark()
                  ? Border.all(width: 2, color: kLightColorDarkTheme)
                  : null),
          child: SfSliderTheme(
            data: SfSliderThemeData(
              activeTrackHeight: themeProvider.isDark() ? 33 : 37,
              inactiveTrackHeight: themeProvider.isDark() ? 33 : 37,
              thumbRadius: themeProvider.isDark() ? 16.5 : 18.5,
              thumbColor:
                  themeProvider.isDark() ? kLightColorDarkTheme : kLightColor,
              activeTrackColor: Theme.of(context).primaryColor,
              inactiveTrackColor: Theme.of(context).primaryColor,
              thumbStrokeWidth: 2,
              thumbStrokeColor: Theme.of(context).primaryColor,
              overlayRadius: 0,
            ),
            child: SfSlider(
              value: _value,
              min: widget.min,
              max: maxRepresentingInfinity,
              onChanged: (value) {
                // send -1 if infinity is true and value is max, value otherwise
                widget.onChanged(value == maxRepresentingInfinity ? -1 : value);

                setState(() {
                  _value = value;
                });
              },
              stepSize: widget.stepSize,
              thumbIcon: Center(
                child: _value == maxRepresentingInfinity
                    ? Icon(
                        Icons.all_inclusive,
                        size: 20,
                        weight: 600,
                        color: themeProvider.isDark()
                            ? kDarkColorDarkTheme
                            : kDarkColor,
                      )
                    : Text(
                        '${_value.toInt()}s',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: themeProvider.isDark()
                                  ? kDarkColorDarkTheme
                                  : Theme.of(context).primaryColor,
                            ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
