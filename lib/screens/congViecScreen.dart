import 'package:flutter/material.dart';

class CongViecScreen extends StatelessWidget {
  const CongViecScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: const Center(
        child: Text('Công việc'),
      ),
    );
  }
}
