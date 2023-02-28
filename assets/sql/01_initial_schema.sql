CREATE TABLE `users` (
  `id` INT UNIQUE NOT NULL,
  `name` TEXT NOT NULL,
  `role` TEXT NOT NULL,
  `patrol` INT NOT NULL
);
CREATE INDEX `inx_users_role` ON `users` (`role`);

CREATE TABLE `entities` (
  `id` INT UNIQUE NOT NULL,
  `ident` TEXT UNIQUE NOT NULL,
  `type` TEXT NOT NULL,
  `name` TEXT NOT NULL,
  `plural` TEXT,
  `fields` TEXT NOT NULL,
  `rolesRead` TEXT,
  `rolesCreate` TEXT,
  `headlines` TEXT,
  `isFav` INT NOT NULL,
  `atMenu` INT NOT NULL,
  `atStart` INT NOT NULL,
  `atFinish` INT NOT NULL,
  `required` INT NOT NULL
);
CREATE INDEX `inx_entities_type` ON `entities` (`type`);

CREATE TABLE `groups` (
  `id` INT UNIQUE NOT NULL,
  `entityIdent` TEXT NOT NULL,
  `groupId` INT,
  `values` TEXT NOT NULL,
  `headline` TEXT,
  `name` TEXT NOT NULL
);
CREATE INDEX `inx_groups_entityIdent` ON `groups` (`entityIdent`);
CREATE INDEX `inx_groups_groupId` ON `groups` (`groupId`);
CREATE INDEX `inx_groups_name` ON `groups` (`name`);

CREATE TABLE `objects` (
  `id` INT UNIQUE NOT NULL,
  `entityIdent` TEXT NOT NULL,
  `groupId` INT,
  `values` TEXT NOT NULL,
  `headline` TEXT,
  `name` TEXT NOT NULL,
  `position` TEXT,
  `workflows` TEXT
);
CREATE INDEX `inx_objects_entityIdent` ON `objects` (`entityIdent`);
CREATE INDEX `inx_objects_groupId` ON `objects` (`groupId`);
CREATE INDEX `inx_objects_name` ON `objects` (`name`);

CREATE TABLE `orders` (
  `id` INT UNIQUE NOT NULL,
  `entityIdent` TEXT NOT NULL,
  `groupId` INT,
  `values` TEXT NOT NULL,
  `headline` TEXT,
  `objectId` INT,
  `userId` INT,
  `state` TEXT NOT NULL,
  `time` DATETIME
);
CREATE INDEX `inx_orders_entityIdent` ON `orders` (`entityIdent`);
CREATE INDEX `inx_orders_groupId` ON `orders` (`groupId`);
CREATE INDEX `inx_orders_userId` ON `orders` (`userId`);

CREATE TABLE `outcomes` (
  `id` INT UNIQUE NOT NULL,
  `entityIdent` TEXT NOT NULL,
  `groupId` INT,
  `values` TEXT NOT NULL,
  `headline` TEXT,
  `objectId` INT,
  `orderId` INT,
  `position` TEXT,
  `time` DATETIME NOT NULL,
  `sys_status` TEXT NOT NULL
);
CREATE INDEX `inx_outcomes_entityIdent` ON `outcomes` (`entityIdent`);
CREATE INDEX `inx_outcomes_groupId` ON `outcomes` (`groupId`);
CREATE INDEX `inx_outcomes_sys_status` ON `outcomes` (`sys_status`);

CREATE TABLE `custitems` (
  `id` INT UNIQUE NOT NULL,
  `entityIdent` TEXT NOT NULL,
  `groupId` INT,
  `values` TEXT NOT NULL,
  `headline` TEXT,
  `objectId` INT,
  `outcomeId` INT
);
CREATE INDEX `inx_custitems_entityIdent` ON `custitems` (`entityIdent`);
CREATE INDEX `inx_custitems_groupId` ON `custitems` (`groupId`);
CREATE INDEX `inx_custitems_objectId` ON `custitems` (`objectId`);
CREATE INDEX `inx_custitems_outcomeId` ON `custitems` (`outcomeId`);

CREATE TABLE `materials` (
  `id` INT UNIQUE NOT NULL,
  `name` TEXT NOT NULL,
  `unit` TEXT NOT NULL,
  `rounding` REAL NOT NULL,
  `price` REAL NOT NULL
);

CREATE TABLE `object_events` (
  `id` INTEGER PRIMARY KEY,
  `objectId` INT NOT NULL,
  `workflowId` INT,
  `timeslotId` INT,
  `activityId` INT,
  `routineTaskId` INT,
  `type` TEXT NOT NULL,
  `time` DATETIME NOT NULL,
  `manually` INT NOT NULL,
  `sys_status` TEXT NOT NULL
);
CREATE INDEX `inx_object_events_objectId` ON `object_events` (`objectId`);
CREATE INDEX `inx_object_events_workflowId` ON `object_events` (`workflowId`);
CREATE INDEX `inx_object_events_timeslotId` ON `object_events` (`timeslotId`);
CREATE INDEX `inx_object_events_activityId` ON `object_events` (`activityId`);
CREATE INDEX `inx_object_events_sys_status` ON `object_events` (`sys_status`);

CREATE TABLE `sys_tasks` (
  `id` INTEGER PRIMARY KEY,
  `type` TEXT NOT NULL,
  `body` TEXT NOT NULL,
  `prio` TEXT NOT NULL,
  `attempts` INT NOT NULL
);

CREATE TABLE `routines` (
  `id` INT UNIQUE NOT NULL,
  `name` TEXT NOT NULL,
  `startTime` DATETIME,
  `endTime` DATETIME,
  `groupId` INT,
  `access` TEXT NOT NULL,
  `users` TEXT,
  `notes` TEXT
);
CREATE INDEX `inx_routines_groupId` ON `routines` (`groupId`);

CREATE TABLE `routine_tasks` (
  `id` INT UNIQUE NOT NULL,
  `uid` INT UNIQUE NOT NULL,
  `routineId` INT,
  `objectId` INT NOT NULL,
  `workflowId` INT,
  `timeslotId` INT,
  `startTime` DATETIME,
  `stopTime` DATETIME,
  `index` INT,
  `userId` INT,
  `status` TEXT NOT NULL
);
CREATE INDEX `inx_routine_tasks_routineId` ON `routine_tasks` (`routineId`);
CREATE INDEX `inx_routine_tasks_objectId` ON `routine_tasks` (`objectId`);
CREATE INDEX `inx_routine_tasks_workflowId` ON `routine_tasks` (`workflowId`);
CREATE INDEX `inx_routine_tasks_timeslotId` ON `routine_tasks` (`timeslotId`);
CREATE INDEX `inx_routine_tasks_startTime` ON `routine_tasks` (`startTime`);
CREATE INDEX `inx_routine_tasks_stopTime` ON `routine_tasks` (`stopTime`);
CREATE INDEX `inx_routine_tasks_index` ON `routine_tasks` (`index`);
CREATE INDEX `inx_routine_tasks_status` ON `routine_tasks` (`status`);
