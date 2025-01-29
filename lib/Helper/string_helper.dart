class StringHelper {
  StringHelper._();
  static final StringHelper stringHelper = StringHelper._();

  factory StringHelper() {
    return stringHelper;
  }

  static const String brand = "Brands";
  static const String crystalline = "Crystalline Ceramics";
  static const String profile = "PROFILE";
  static const String logout = "Logout";
  static const String login = "Login";
  static const String donthaveaccount = "Don't have an account? Sign Up";
  static const String anyProblemContactToAdimn = "Any Problem Contact To Admin";
  static const String anyIssueContactUS = "Any issue contact us";
  static const String showMore = "Show more...";

  // static const String=
  // static const String
  // static const String
  // static const String
  // static const String
  // static const String
  // static const String
  // static const String
  // static const String
  // static const String
  // static const String
  // static const String
  // static const String
  // static const String
  // static const String
  // static const String
  // static const String
}

String limitProductName(String productName, int maxWords) {
  List<String> words = productName.split(' ');
  if (words.length > maxWords) {
    return words.sublist(0, maxWords).join(' ') + '...';
  }
  return productName;
}
