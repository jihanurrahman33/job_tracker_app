extension StringExtensions on String {
  String toTitleCaseFromSnake() {
    if (isEmpty) return this;
    return split('_')
        .map((word) => word.isEmpty
            ? ''
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }

  String toInitials() {
    if (trim().isEmpty) return '?';
    final parts = trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
