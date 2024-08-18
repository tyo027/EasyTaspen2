extension StringExtensions on String {
  String capitalizeEachWord() {
    return split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  String toUpperCaseFirstOfEachSentence() {
    return split('. ').map((sentence) {
      return sentence.trim().isNotEmpty
          ? sentence.trimLeft()[0].toUpperCase() +
              sentence.trimLeft().substring(1).toLowerCase()
          : sentence;
    }).join('. ');
  }
}
