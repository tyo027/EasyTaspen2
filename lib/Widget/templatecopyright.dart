import 'package:flutter/material.dart';

class Templatecopyright extends StatelessWidget {
  const Templatecopyright({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (child != null)
                Flexible(fit: FlexFit.tight, child: Container(child: child!)),
              const Text('Powered by:PT TASPEN(Persero) - V.4.0.0')
            ]));
  }
}
