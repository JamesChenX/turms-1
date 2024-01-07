class TrayMenuItem {
  final String key;
  final String label;
  final void Function() onTap;

  TrayMenuItem({required this.key, required this.label, required this.onTap});
}