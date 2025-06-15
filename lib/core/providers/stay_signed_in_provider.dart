import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to manage the "Stay signed in" state
final staySignedInProvider = StateProvider<bool>((ref) => false);