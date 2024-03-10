import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../domain/common/models/new_relationship_request.dart';
import '../../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../l10n/view_models/app_localizations_view_model.dart';
import 'new_relationship_requests_page.dart';
import 'new_relationship_requests_page_view.dart';

class NewRelationshipRequestsPageController
    extends ConsumerState<NewRelationshipRequestsPage> {
  late AppLocalizations appLocalizations;
  late Map<DateTime, List<NewRelationshipRequest>> creationDateToRequests;

  @override
  Widget build(BuildContext context) {
    appLocalizations = ref.watch(appLocalizationsViewModel);
    creationDateToRequests = widget.requests.groupBy((request) {
      final createdAt = request.creationDate;
      return DateTime(createdAt.year, createdAt.month, createdAt.day);
    });
    return NewRelationshipRequestsPageView(this);
  }
}
