import 'package:flutter/material.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class UserTypeLabelRadio extends StatelessWidget {
  const UserTypeLabelRadio({
    this.label,
    this.padding,
    this.groupValue,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final Constants.UserTypeEnum groupValue;
  final Constants.UserTypeEnum value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue)
          onChanged(value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Radio<Constants.UserTypeEnum>(
              groupValue: groupValue,
              value: value,
              onChanged: (Constants.UserTypeEnum newValue) {
                onChanged(newValue);
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              label,
              style: TextStyle(color: Colors.blue[800],fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}