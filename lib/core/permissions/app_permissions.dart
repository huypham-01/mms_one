// class AppPermissions {
//   static const mmsView = 'mms.view';
//   static const mrPlanner = 'mms.mr.planner';
//   static const mrImport = 'mms.mr.import';
//   static const mrActions = 'mms.mr.actions';
//   static const mrStepPreparer = 'mms.mr.step.preparer';
//   static const mrStepWarehouse = 'mms.mr.step.warehouse';
//   static const mrStepLeader = 'mms.mr.step.leader';
//   static const mrStepProduction = 'mms.mr.step.production';
// }

class AppPermissions {
  // General
  static const mmsView = 'mms.view';

  // Material Request
  static const mrPlanner = 'mms.mr.planner';
  static const mrImport = 'mms.mr.import';
  static const mrActions = 'mms.mr.actions';

  // Workflow Steps
  static const mrStepPreparer = 'mms.mr.step.preparer';
  static const mrStepWarehouse = 'mms.mr.step.warehouse';
  static const mrStepReceiver = 'mms.mr.step.receiver';
  static const mrStepLineLeader = 'mms.mr.step.line_leader';
  static const mrStepProduction = 'mms.mr.step.production';

  // Management
  static const materialManage = 'mms.material.manage';
  static const lockManage = 'mms.lock.manage';
  static const workflowStepManage = 'mms.workflowstep.manage';

  static List<String> get allPermissions => [
        mmsView,
        mrPlanner,
        mrImport,
        mrActions,
        mrStepPreparer,
        mrStepWarehouse,
        mrStepReceiver,
        mrStepLineLeader,
        mrStepProduction,
        materialManage,
        lockManage,
        workflowStepManage,
      ];
}
