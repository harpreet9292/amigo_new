import 'package:amigotools/utils/types/BriefDbItem.dart';

class ObjectVisitCoreEntity
{
  final int id;
  final int objectId;
  final int? workflowId;
  final int? timeslotId;
  final int? routineTaskId;

  BriefDbItem? object;
  bool paused = false;

  ObjectVisitCoreEntity(this.id, this.objectId, this.workflowId, this.timeslotId, this.routineTaskId);
}