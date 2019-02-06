library number_display;

String _commafy(String integerStr) => integerStr.replaceAllMapped(
  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
  (m) => '${m[1]},',
);

// [integer, decimal, unit]

String display(
  Object input,
  int length,
  {
    int maxAccuracy = 2,
    String placeholder = '--',
    bool allowText = true,
    bool comma = true,
    List<String> units = const ['k', 'M', 'G', 'T'],
    int unitsInterval = 3,
    int unitsMaxAccuracy = 4,
  }
) {
  // placeholder must in length
  if (length < placeholder.length) {
    throw Error();
  }
}
