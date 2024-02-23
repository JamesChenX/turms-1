const affixes = <String>['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
const divider = 1024;

extension FileSizeExtensions on num {
  String toHumanReadableFileSize({int round = 2, bool useBase1024 = true}) {
    final size = this;
    var runningDivider = divider;
    var runningPreviousDivider = 0;
    var affix = 0;

    while (size >= runningDivider && affix < affixes.length - 1) {
      runningPreviousDivider = runningDivider;
      runningDivider *= divider;
      affix++;
    }

    var result =
        (runningPreviousDivider == 0 ? size : size / runningPreviousDivider)
            .toStringAsFixed(round);

    //Check if the result ends with .00000 (depending on how many decimals) and remove it if found.
    if (result.endsWith('0' * round)) {
      result = result.substring(0, result.length - round - 1);
    }

    return '$result ${affixes[affix]}';
  }
}
