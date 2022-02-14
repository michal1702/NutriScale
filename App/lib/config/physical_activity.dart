enum PhysicalActivity {
  Sedentary_Lifestyle,
  Lightly_Active_Lifestyle,
  Moderately_Active_Lifestyle,
  Very_Active_Lifestyle,
  Extra_Active_Lifestyle
}

extension ParseToString on PhysicalActivity {
  String toShortString() {
    final string = this.toString().split('.').last.split('_');
    if (string.length > 2)
      return "${string[0]} ${string[1]} ${string[2]}";
    else
      return "${string[0]} ${string[1]}";
  }
}

PhysicalActivity stringToActivity(String activity) {
  switch (activity) {
    case 'Sedentary Lifestyle':
      return PhysicalActivity.Sedentary_Lifestyle;
    case 'Lightly Active Lifestyle':
      return PhysicalActivity.Lightly_Active_Lifestyle;
    case 'Moderately Active Lifestyle':
      return PhysicalActivity.Moderately_Active_Lifestyle;
    case 'Very Active Lifestyle':
      return PhysicalActivity.Very_Active_Lifestyle;
    case 'Extra Active Lifestyle':
      return PhysicalActivity.Extra_Active_Lifestyle;
    default:
      return PhysicalActivity.Sedentary_Lifestyle;
  }
}
