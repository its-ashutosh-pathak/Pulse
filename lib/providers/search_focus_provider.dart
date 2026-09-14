import 'package:flutter_riverpod/flutter_riverpod.dart';

/// When set to true, SearchScreen should request keyboard focus on its search field.
/// The screen resets this back to false after consuming the signal.
final searchFocusRequestProvider = StateProvider<bool>((ref) => false);
