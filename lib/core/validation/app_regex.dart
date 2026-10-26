abstract final class AppRegex {
  AppRegex._();

  static final RegExp email = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$');

  static final RegExp egyptPhone = RegExp(r'^01[0125][0-9]{8}$');

  static final RegExp internationalPhone = RegExp(r'^\+?[1-9]\d{7,14}$');

  static final RegExp hasLetter = RegExp(r'[A-Za-z]');

  static final RegExp hasDigit = RegExp(r'\d');

  static final RegExp hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]');

  static final RegExp hasWhitespace = RegExp(r'\s');

  static final RegExp hasRepeatingChars = RegExp(r'(.)\1\1');

  static final RegExp hasSequentialChars = RegExp(
    r'(abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mno|nop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz|'
    r'ABC|BCD|CDE|DEF|EFG|FGH|GHI|HIJ|IJK|JKL|KLM|LMN|MNO|NOP|OPQ|PQR|QRS|RST|STU|TUV|UVW|VWX|WXY|XYZ|'
    r'012|123|234|345|456|567|678|789|'
    r'cba|dcb|edc|fed|gfe|hgf|ihg|jih|kji|lkj|mlk|nml|onm|pon|qpo|rqp|srq|tsr|uts|vut|wvu|xwv|yxw|zyx)',
  );

  static final RegExp digitsOnly = RegExp(r'^\d+$');

  static final RegExp lettersAndSpaces = RegExp(r'^[A-Za-z\u0600-\u06FF\s]+$');

  static final RegExp alphanumeric = RegExp(r'^[A-Za-z0-9\u0600-\u06FF\s]+$');
}
