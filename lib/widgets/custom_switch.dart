import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final Function(bool) onChanged;

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  // storing the value
  late bool value;

  @override
  void initState() {
    super.initState();

    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      onChanged: (val) async {
        // calling the user defined function
        await widget.onChanged(val);

        setState(() {
          value = val;
        });
      },
      value: value,
    );
  }
}

