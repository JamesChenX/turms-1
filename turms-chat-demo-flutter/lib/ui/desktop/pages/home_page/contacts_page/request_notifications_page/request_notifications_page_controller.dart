part of 'request_notifications_page.dart';

class _RequestNotificationsPageController
    extends ConsumerState<RequestNotificationsPage>
    with SingleTickerProviderStateMixin<RequestNotificationsPage> {
  String selectedTabId = 'friendRequests';

  late AppLocalizations appLocalizations;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = ref.watch(appLocalizationsViewModel);
    return _RequestNotificationsPageView(this);
  }
}
