import '../../utils/dart_utils.dart';

RegExp fieldRegex = new RegExp(r"(:?(?<field>\w{3})\:\S+(:?\ *|\n*))");
const fieldGroupName = "field";
const optionalField = "cid";
RegExp fieldsRuledRegex = new RegExp(
    r"(?:(?:byr:(?<byr>\d{4}))|(?:iyr:(?<iyr>\d{4}))|(?:eyr:(?<eyr>\d{4}))|(?:hgt:(?<hgt_cm>\d{3})cm)|(?:hgt:(?<hgt_in>\d{2})in)|(?:hcl:(?<hcl>#(?:[0-9]|[a-f]){6}))|(?:ecl:(?<ecl>(?:amb|blu|brn|gry|grn|hzl|oth)))|(?:pid:(?<pid>\d{9})))");

void main(List<String> args) async {
  String input = await readInput(2020, 4);
  countPassports(input);
}

void countPassports(String input) {
  int validPassports = 0;
  int passportsFollowingRules = 0;

  for (String passport in input.split("\n\n")) {
    Set<String> fields = retrieveFields(passport);
    if (validPassport(fields)) {
      validPassports++;
    }
    if (passportFollowsRules(passport)) {
      passportsFollowingRules++;
    }
  }

  print("Part 1: Valid passports = " + validPassports.toString());
  print("Part 2: Passports following rules = " +
      passportsFollowingRules.toString());
}

Set<String> retrieveFields(String passport) {
  Set<String> fields = new Set();
  for (RegExpMatch match in fieldRegex.allMatches(passport)) {
    fields.add(match.namedGroup(fieldGroupName));
  }
  return fields;
}

bool validPassport(Set<String> fields) {
  return (fields.length == 7 && !fields.contains(optionalField)) ||
      fields.length == 8;
}

bool passportFollowsRules(String passport) {
  int validFields = 0;
  for (RegExpMatch match in fieldsRuledRegex.allMatches(passport)) {
    String groupName = getPopulatedGroupName(match);
    String value = match.namedGroup(groupName);
    bool isValid = false;
    switch (groupName) {
      case "byr":
        int byr = int.parse(value);
        isValid = byr >= 1920 && byr <= 2002;
        break;
      case "iyr":
        int iyr = int.parse(value);
        isValid = iyr >= 2010 && iyr <= 2020;
        break;
      case "eyr":
        int eyr = int.parse(value);
        isValid = eyr >= 2020 && eyr <= 2030;
        break;
      case "hgt_cm":
        int hgt_cm = int.parse(value);
        isValid = hgt_cm >= 150 && hgt_cm <= 193;
        break;
      case "hgt_in":
        int hgt_in = int.parse(value);
        isValid = hgt_in >= 59 && hgt_in <= 76;
        break;
      case "hcl":
        isValid = true;
        break;
      case "ecl":
        isValid = true;
        break;
      case "pid":
        isValid = true;
        break;
    }
    if (isValid) validFields++;
  }
  return validFields == 7;
}

String getPopulatedGroupName(RegExpMatch match) {
  for (String groupName in match.groupNames) {
    if (match.namedGroup(groupName) != null) {
      return groupName;
    }
  }
  return null;
}
