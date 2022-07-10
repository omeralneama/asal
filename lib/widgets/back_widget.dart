import 'package:flutter/material.dart';

import '../services/utils.dart';
class BackWidget extends StatelessWidget {
  const BackWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    final color = Utils(context).color;
    return InkWell(borderRadius: BorderRadius.circular(12),
      onTap: ()
      {
        Navigator.pop(context);
      },
      child: Icon(Icons.arrow_back_ios,
        color: color,
      ),
    );
  }
}
