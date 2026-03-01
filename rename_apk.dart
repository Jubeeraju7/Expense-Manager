import 'dart:io';

void main() async {
  // Get the project name from pubspec.yaml
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    print('pubspec.yaml not found');
    return;
  }
  final lines = pubspec.readAsLinesSync();
  final projectNameLine = lines.firstWhere((line) => line.startsWith('name:'), orElse: () =>'' );
  if (projectNameLine == '') {
    print('Project name not found in pubspec.yaml');
    return;
  }
  //final projectName = projectNameLine.split(':')[1].trim();

  // Get the current date and time
  final now = DateTime.now();
  // final formattedDate = '${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}';
  final formattedDate = '${_twoDigits(now.day)}-${_twoDigits(now.month)}-${now.year}';
  final hour12 = now.hour == 0 ? 12 : (now.hour > 12 ? now.hour - 12 : now.hour);
  final period = now.hour >= 12 ? "PM" : "AM";
  final formattedTime = '${_twoDigits(hour12)}-${_twoDigits(now.minute)}-${_twoDigits(now.second)} $period';

  // Define the original and new APK paths
  final originalApkPath = 'build/app/outputs/flutter-apk/app-release.apk';
  final newApkPath = 'build/app/outputs/flutter-apk/Proactive-expense-manager $formattedDate $formattedTime.apk';

  // Rename the APK file
  final originalFile = File(originalApkPath); 
  if (!originalFile.existsSync()) {
    print('APK file not found at $originalApkPath');
    return;
  }
  await originalFile.rename(newApkPath);
  print('APK has been renamed to $newApkPath');
}

// Helper function to format numbers with two digits
String _twoDigits(int n) => n.toString().padLeft(2, '0');
