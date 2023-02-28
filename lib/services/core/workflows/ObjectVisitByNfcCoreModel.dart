import 'package:amigotools/entities/workflows/WorkflowActivity.dart';

import 'ObjectVisitCoreModel.dart';

class ObjectVisitByNfcCoreModel extends ObjectVisitCoreModel
{
  ObjectVisitByNfcCoreModel(int objectId, int? workflowId, int? timeslotId, int? routineTaskId)
    : super(objectId, workflowId, timeslotId, routineTaskId);

  bool acceptTag(String tag)
  {
    for (final act in workflow.item.activities)
    {
      if (act.barcode == tag)
      {
        if (isActivityCompleted(act.id))
        {
          // todo
          return false;
        }

        return _handleActivity(act);
      }
    }

    return false;
  }

  bool _handleActivity(WorkflowActivity act)
  {
    switch (act.type)
    {
      case WorkflowActivityType.SingleCheckpoint:
      case WorkflowActivityType.Checkpoint:
        markActivityCompleted(act.id, manually: false);
        return true;

      case WorkflowActivityType.Start:
        if (canStart)
        {
          start(manually: false, activityId: act.id);
          return true;
        }
        break;

      case WorkflowActivityType.Stop:
        if (canStop)
        {
          stop(manually: false, activityId: act.id);
          return true;
        }
        break;

      case WorkflowActivityType.StartStop:
      case WorkflowActivityType.AutoStartStop:
        if (canStart)
        {
          start(manually: false, activityId: act.id);
        }
        else if (canStop)
        {
          stop(manually: false, activityId: act.id);
        }
        else
        {
          // todo
          return false;
        }
        return true;

      case WorkflowActivityType.Unknown:
      case WorkflowActivityType.Instructions:
        // nothing
        break;
    }

    return false;
  }
}