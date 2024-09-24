import '../../../infra/built_in_types/built_in_type_helpers.dart';
import '../models/relationship_group.dart';
import 'contacts.dart';

final fixtureRelationshipGroups = fixtureUserContacts
    .groupBy((c) => c.relationshipGroupId)
    .values
    .map((contacts) => RelationshipGroup('test-name', false, contacts))
    .toList();
