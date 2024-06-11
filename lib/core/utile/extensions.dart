extension CleanPathExtension on String {
  String cleanPath() {
    List<String> sections = split('/');
    for (int i = 0; i < sections.length; i++) {
      sections[i] = sections[i].split(r'$%')[0];
    }
    return sections.join('/');
  }
}
