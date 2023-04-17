import 'package:flutter/material.dart';

class SelectOne extends StatefulWidget {
  const SelectOne(
      {super.key,
      required this.keyValuePairs,
      required this.defaultValue,
      required this.onChange});

  // getting the key values
  final Map<Enum, String> keyValuePairs;
  final Enum defaultValue;
  final Function(Enum value) onChange;

  @override
  State<SelectOne> createState() => _SelectOneState();
}

class _SelectOneState extends State<SelectOne> {
  // selected key equals the default value
  late Enum selectedKey = widget.defaultValue;

  @override
  Widget build(BuildContext context) {
    // if data is empty then throw an error
    if (widget.keyValuePairs.isEmpty) {
      throw 'Empty data found!';
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
      ),
      child: Row(
          children: widget.keyValuePairs.keys.map(
        (key) {
          // whether the item is selected or not
          final bool isSelected = key == selectedKey;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                // updating the selected key
                setState(() {
                  selectedKey = key;
                });

                widget.onChange(selectedKey);
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : null,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  widget.keyValuePairs[key]!,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : null,
                        color: isSelected ? Colors.black : Colors.white,
                      ),
                ),
              ),
            ),
          );
        },
      ).toList()),
    );
  }
}
