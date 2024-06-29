import 'package:block_logic/components/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Returns the user display name as BLText
class BLDisplayName extends StatelessWidget {
  const BLDisplayName({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<User?>(builder: (context, value, child) => BLText(value?.email ?? ''));
  }
}

/// Returns the user email as BLText
class BLEmail extends StatelessWidget {
  const BLEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<User?>(builder: (context, value, child) => BLText(value?.displayName ?? ''));
  }
}
