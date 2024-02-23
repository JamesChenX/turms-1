class TrayMenuItem {
  const TrayMenuItem(
      {required this.key, required this.label, required this.onTap});
  final String key;
  final String label;
  final void Function() onTap;
}
