String shortTextWithAsterisk(String text, {int length = 15}) {
  if (text.length <= length) {
    return text;
  }
  return '${text.substring(0, 5)}****${text.substring(text.length - 5)}';
}
