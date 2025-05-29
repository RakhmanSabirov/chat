import 'package:flutter/material.dart';

class LongButton extends StatelessWidget {
  final Function() onTap;
  final String text;
  final bool? isLoading;

  const LongButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading == true ? null : onTap,
      child: SizedBox(
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child:
                  isLoading == true
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : Text(
                        text,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
