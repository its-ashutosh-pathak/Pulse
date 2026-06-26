class DateFormatter {
  /// Returns time in 12-hour format with AM/PM (e.g. 10:30 AM)
  static String formatTime(DateTime time) {
    int hour = time.hour;
    int minute = time.minute;
    String amPm = hour >= 12 ? 'PM' : 'AM';
    
    hour = hour % 12;
    if (hour == 0) hour = 12;
    
    String minStr = minute.toString().padLeft(2, '0');
    return '$hour:$minStr $amPm';
  }

  /// Returns WhatsApp style date for chat lists
  /// Today -> returns time (e.g. 10:30 AM)
  /// Yesterday -> returns 'Yesterday'
  /// Within a week -> returns day name (e.g. 'Monday')
  /// Older -> returns dd/MM/yyyy
  static String formatChatListDate(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final aWeekAgo = today.subtract(const Duration(days: 6));
    
    final dateToCheck = DateTime(time.year, time.month, time.day);
    
    if (dateToCheck == today) {
      return 'Today';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday';
    } else if (dateToCheck.isAfter(aWeekAgo)) {
      switch (dateToCheck.weekday) {
        case 1: return 'Monday';
        case 2: return 'Tuesday';
        case 3: return 'Wednesday';
        case 4: return 'Thursday';
        case 5: return 'Friday';
        case 6: return 'Saturday';
        case 7: return 'Sunday';
      }
    }
    
    String day = time.day.toString().padLeft(2, '0');
    String month = time.month.toString().padLeft(2, '0');
    return '$day/$month/${time.year}';
  }
}
