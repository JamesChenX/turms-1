import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../domain/common/models/new_relationship_request.dart';
import '../../../../../../../domain/common/models/request_status.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../l10n/view_models/date_format_view_models.dart';
import '../../../../../../themes/index.dart';
import '../../../../../components/t_divider/t_horizontal_divider.dart';
import 'new_relationship_request_tile.dart';
import 'new_relationship_requests_page_controller.dart';

class NewRelationshipRequestsPageView extends ConsumerWidget {
  const NewRelationshipRequestsPageView(
      this.newRelationshipRequestsPageController,
      {super.key});

  final NewRelationshipRequestsPageController
      newRelationshipRequestsPageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      _buildFriendRequestGroups(ref);

  Widget _buildFriendRequestGroups(WidgetRef ref) {
    final now = DateTime.now();
    final appLocalizations =
        newRelationshipRequestsPageController.appLocalizations;
    return ListView.separated(
      itemCount:
          newRelationshipRequestsPageController.creationDateAndRequests.length,
      // Prevent the scrollbar from overlapping children.
      padding: const EdgeInsets.only(right: 24),
      findChildIndexCallback: (key) => newRelationshipRequestsPageController
          .groupIdToIndex[(key as ValueKey<Int64>).value],
      separatorBuilder: (context, index) => Sizes.sizedBoxH16,
      itemBuilder: (context, index) {
        final entry = newRelationshipRequestsPageController
            .creationDateAndRequests[index];
        return _buildRequestGroupOfSameDay(
            entry.key, now, appLocalizations, ref, entry.value);
      },
    );
  }

  Widget _buildRequestGroupOfSameDay(
          DateTime creationDate,
          DateTime now,
          AppLocalizations appLocalizations,
          WidgetRef ref,
          List<NewRelationshipRequest> requests) =>
      Column(
        key: ValueKey(requests.first.id),
        children: [
          if (DateUtils.isSameDay(creationDate, now))
            Text(appLocalizations.today)
          else if (creationDate.year == now.year)
            Text(ref.watch(dateFormatViewModel_Md).format(creationDate))
          else
            Text(ref.watch(dateFormatViewModel_yMd).format(creationDate)),
          Sizes.sizedBoxH8,
          const THorizontalDivider(),
          Sizes.sizedBoxH12,
          ...requests.indexed.expand((item) {
            final (requestIndex, request) = item;
            return [
              if (requestIndex > 0) const SizedBox(height: 16),
              NewRelationshipRequestTile(
                key: Key(request.id.toString()),
                request: request,
                onAccept: () async => newRelationshipRequestsPageController
                    .widget
                    .onRequestStatusChange(request, RequestStatus.accepted),
                onStartConversation: () => newRelationshipRequestsPageController
                    .widget
                    .onStartConversationTap(request),
              )
            ];
          })
        ],
      );
}
