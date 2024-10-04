import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../domain/common/models/new_relationship_request.dart';
import '../../../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../l10n/view_models/app_localizations_view_model.dart';
import 'new_relationship_requests_page.dart';
import 'new_relationship_requests_page_view.dart';

class NewRelationshipRequestsPageController
    extends ConsumerState<NewRelationshipRequestsPage> {
  late AppLocalizations appLocalizations;
  late List<MapEntry<DateTime, List<NewRelationshipRequest>>>
      creationDateAndRequests;
  late Map<Int64, int> groupIdToIndex;

  @override
  Widget build(BuildContext context) {
    appLocalizations = ref.watch(appLocalizationsViewModel);
    final requests = widget.requests
      // Sort it to display the most recent first.
      ..sort((a, b) => b.creationDate.compareTo(a.creationDate));
    final creationDateToRequests = requests.groupByAsLinkedHashMap((request) {
      final creationDate = request.creationDate;
      return DateTime(creationDate.year, creationDate.month, creationDate.day);
    });
    final groupCount = creationDateToRequests.length;
    creationDateAndRequests = creationDateToRequests.entries.toList();
    final requestGroups = creationDateToRequests.values;
    groupIdToIndex = {
      for (var i = 0; i < groupCount; i++)
        requestGroups.elementAt(i).first.id: i
    };
    return NewRelationshipRequestsPageView(this);
  }
}
