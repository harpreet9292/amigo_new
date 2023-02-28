import 'package:amigotools/entities/workflows/Workflow.dart';
import 'package:amigotools/entities/workflows/WorkflowActivity.dart';
import 'package:amigotools/entities/workflows/WorkflowTimeslot.dart';

class WorkflowCoreModel
{
  const WorkflowCoreModel(this.item);

  final Workflow item;

  Iterable<WorkflowActivity> fetchCheckpoints({bool includeSingles = false, bool includeInformations = false})
  {
    final types = [WorkflowActivityType.Checkpoint];

    if (includeSingles)
      types.add(WorkflowActivityType.SingleCheckpoint);

    if (includeInformations)
      types.add(WorkflowActivityType.Instructions);

    return item.activities.where((x) => types.contains(x.type));
  }

  bool get hasStart
  {
    final types = [WorkflowActivityType.Start, WorkflowActivityType.StartStop, WorkflowActivityType.AutoStartStop];
    return item.activities.any((x) => types.contains(x.type));
  }

  bool get hasAutoStartStop
  {
    return item.activities.any((x) => x.type == WorkflowActivityType.AutoStartStop);
  }

  Iterable<WorkflowActivity> fetchStartsOrStops({required bool starts, bool autoOnly = false})
  {
    if (!autoOnly)
    {
      final type = starts ? WorkflowActivityType.Start : WorkflowActivityType.Stop; 

      return item.activities.where((x) =>
          x.type == type ||
          x.type == WorkflowActivityType.StartStop ||
          x.type == WorkflowActivityType.AutoStartStop);
    }
    else
    {
      return item.activities.where((x) => x.type == WorkflowActivityType.AutoStartStop);
    }
  }

  WorkflowDurationRelationCoreModel howIsDuration(Duration duration)
  {
    if (item.durationMin != null && duration.inMinutes < item.durationMin!)
    {
      return WorkflowDurationRelationCoreModel.Shorter;
    }
    else if (item.durationMax != null && duration.inMinutes > item.durationMax!)
    {
      return WorkflowDurationRelationCoreModel.Longer;
    }

    return WorkflowDurationRelationCoreModel.Normal;
  }

  WorkflowTimeslot? getTimeslotById(int timeslotId)
  {
    if (item.timeslots != null)
    {
      final found = item.timeslots!.where((x) => x.id == timeslotId);
      
      if (found.isNotEmpty)
      {
        return found.first;
      }
    }

    return null;
  }
}

enum WorkflowDurationRelationCoreModel
{
  Shorter,
  Normal,
  Longer,
}