import 'package:flutter/material.dart';
import 'package:amigotools/utils/types/UiItem.dart';

class WorkflowsViewConfig {
  static const ItemViewBarItems = const [
    UiItem(WorkflowsViewKeys.Start, "Start", icon: Icons.play_circle_outline, fav: true),
    UiItem(WorkflowsViewKeys.Stop, "Stop", icon: Icons.stop_circle_outlined),
    UiItem(WorkflowsViewKeys.Pause, "Pause", icon: Icons.pause_circle_outline, fav: true),
    UiItem(WorkflowsViewKeys.Resume, "Resume", icon: Icons.replay_circle_filled_outlined, fav: true),
    UiItem(WorkflowsViewKeys.NewOutcome, "New outcome", icon: Icons.add_outlined),
  ];
}

enum WorkflowsViewKeys {
  Start,
  Stop,
  Pause,
  Resume,
  NewOutcome,
}
