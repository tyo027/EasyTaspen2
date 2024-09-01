extension StringExtension on String {
  String capitalize() {
    if (length == 0) return this;
    return split(" ")
        .map((e) => "${e[0].toUpperCase()}${e.substring(1).toLowerCase()}")
        .join(" ");
  }

  String camelToCapitalizedWords() {
    List<String> words = split(RegExp(r'(?=[A-Z])'));

    List<String> capitalizedWords = words.map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    return capitalizedWords.join(' ');
  }
}
