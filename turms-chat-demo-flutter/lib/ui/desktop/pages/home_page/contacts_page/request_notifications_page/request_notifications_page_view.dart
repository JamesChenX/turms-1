part of 'request_notifications_page.dart';

class _RequestNotificationsPageView extends StatelessWidget {
  const _RequestNotificationsPageView(this.requestNotificationsPageController);

  final _RequestNotificationsPageController requestNotificationsPageController;

  @override
  Widget build(BuildContext context) {
    final appLocalizations =
        requestNotificationsPageController.appLocalizations;
    return Column(children: [
      Stack(
        children: [
          const Positioned.fill(
              child: TWindowControlZone(
            toggleMaximizeOnDoubleTap: true,
          )),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                dividerHeight: 0,
                controller: requestNotificationsPageController.tabController,
                tabs: [
                  Tab(
                    text: appLocalizations.friendRequests,
                    height: 40,
                  ),
                  Tab(
                    text: appLocalizations.groupMembershipRequests,
                    height: 40,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(
              bottom: 16,
              left: 16,
              // Used to avoid the scrollbar aligning to the right exactly.
              right: 16),
          child: TabBarView(
              controller: requestNotificationsPageController.tabController,
              children: [
                const FriendRequestsPage(),
                const GroupMembershipRequestsPage(),
              ]),
        ),
      )
    ]);
  }
}
