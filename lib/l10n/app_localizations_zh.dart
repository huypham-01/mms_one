// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get home => '主页';

  @override
  String get materialRequest => '物料需求';

  @override
  String get preparer => '准备员';

  @override
  String get warehouse => '仓库';

  @override
  String get materialReceiver => '物料接收';

  @override
  String get lineLeader => '产线长';

  @override
  String get toProduction => '生产发送';

  @override
  String get pdStorageArea => 'PD储存区';

  @override
  String get materialOvertime => '物料库存';

  @override
  String get materialManagement => '物料管理';

  @override
  String get monitoring => '监控';

  @override
  String get storageArea => '存储区域';

  @override
  String get materialOvertimeModule => '物料加班';

  @override
  String get transactionLog => '交易日志';

  @override
  String get logHistory => '日志历史';

  @override
  String get report => '报告';

  @override
  String get language => '语言';

  @override
  String get logout => '登出';

  @override
  String get settings => '设置';

  @override
  String get search => '搜索';

  @override
  String get retry => '重试';

  @override
  String get noData => '无数据';

  @override
  String get loading => '加载中';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get submit => '提交';

  @override
  String get approve => '批准';

  @override
  String get reject => '拒绝';

  @override
  String get pendingConfirm => '待确认';

  @override
  String get inProgress => '进行中';

  @override
  String get completed => '已完成';

  @override
  String get english => 'English';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get chineseSimplified => '简体中文';

  @override
  String get chineseTraditional => '繁體中文';

  @override
  String get version => 'v1.0.0';

  @override
  String get status => '状态';

  @override
  String get processing => '处理中';

  @override
  String get pleaseDoNotCloseScreen => '请勿关闭屏幕';

  @override
  String get prepareDate => '准备日期';

  @override
  String get tapToSelectChoice => '点击选择';

  @override
  String get requestNumber => '请求编号';

  @override
  String get autoFilled => '自动填充';

  @override
  String get workOrder => '工作单';

  @override
  String get demandWk => '需求周';

  @override
  String get pcn => 'PCN';

  @override
  String get finishGoodCtn => '成品/箱';

  @override
  String get materialPn => '物料P/N';

  @override
  String get materialName => '物料名称';

  @override
  String get requestQuantity => '请求数量';

  @override
  String get unit => '单位';

  @override
  String get lotsInformation => '批次信息';

  @override
  String get addLot => '添加批次';

  @override
  String get lot => '批次';

  @override
  String get qty => '数量';

  @override
  String get lotQty => '批次数量';

  @override
  String get enterLotName => '输入批次名称';

  @override
  String get warehouseVerification => '仓库验证';

  @override
  String get verificationInfo => '验证和信息';

  @override
  String get preparedQuantity => '准备数量';

  @override
  String get difference => '差异';

  @override
  String get verifyMethod => '验证方法';

  @override
  String get verifyMethodPr => '验证方法PR';

  @override
  String get barcodeScanPr => '条码扫描PR';

  @override
  String get pcnScan => 'PCN 扫描';

  @override
  String get pcnScanResult => 'PCN 扫描结果';

  @override
  String get pnScan => '物料 P/N 扫描';

  @override
  String get pnScanResult => '物料 P/N 扫描结果';

  @override
  String get tapIconToScan => '点击图标扫描代码';

  @override
  String get verificationCode => '验证码';

  @override
  String get enterAmount => '输入金额';

  @override
  String get scanResult => '扫描结果';

  @override
  String get locker => '储物柜';

  @override
  String get scanLocker => '扫描储物柜';

  @override
  String get scanPreparerName => '扫描备料人员';

  @override
  String get preparerName => '准备员名称';

  @override
  String get specCheck => '规格检查';

  @override
  String get quantityCheck => '数量检查';

  @override
  String get warehouseLocker => '仓库储物柜';

  @override
  String get scanWarehouseLockerQr => '扫描二维码';

  @override
  String get storageLocation => '存储位置';

  @override
  String get productionLocker => '生产储物柜';

  @override
  String get scanProductionLockerQr => '扫描二维码';

  @override
  String get warehouseKeeper => '仓库管理员';

  @override
  String get mrName => 'MR名称';

  @override
  String get receiverFrom => '接收来自';

  @override
  String get leaderName => '领导名称';

  @override
  String get quantityToProduction => '生产数量';

  @override
  String get toWhere => '至何处';

  @override
  String get toWho => '至何人';

  @override
  String get fromLocker => '来自储物柜';

  @override
  String get scanFromLockerQr => '扫描来自储物柜二维码';

  @override
  String get fromLeader => '来自领导';

  @override
  String get fromName => '来自名称';

  @override
  String get specPicture => '规格图片';

  @override
  String get searchByIdName => '按ID、名称、P/N、WO搜索...';

  @override
  String get noResultsFound => '未找到结果';

  @override
  String get anErrorOccurred => '发生错误';

  @override
  String get selectMaterialRequest => '提交前请选择物料请求';

  @override
  String get pictureVerificationRequired => '验证方法是图片——请至少拍摄1张照片';

  @override
  String get scanBarcodeRequired => '提交前请扫描条码';

  @override
  String get barcodeNotMatch => '条码与验证码不匹配';

  @override
  String get enterLotNameRequired => '请输入批次名称';

  @override
  String get enterLotQuantityRequired => '请输入数量';

  @override
  String get scanLockerRequired => '请扫描储物柜';

  @override
  String get scanPnRequired => '请扫描物料 P/N';

  @override
  String get scanPcnRequired => '请扫描 PCN';

  @override
  String get scanWarehouseLockerRequired => '请扫描仓库储物柜';

  @override
  String get scanProductionLockerRequired => '请扫描生产储物柜';

  @override
  String get enterReceivedBy => '请输入接收人';

  @override
  String get enterMrName => '请输入MR名称';

  @override
  String get enterReceiverFrom => '请输入接收来自';

  @override
  String get enterLeaderName => '请输入领导名称';

  @override
  String get enterQuantityToProduction => '请输入生产数量';

  @override
  String get quantityMustBePositive => '生产数量必须为正数';

  @override
  String get enterToWhere => '请输入至何处';

  @override
  String get enterToWho => '请输入至何人';

  @override
  String get enterFromLeader => '请输入来自领导';

  @override
  String get enterFromName => '请输入来自名称';

  @override
  String get rejectSuccess => '拒绝成功';

  @override
  String get rejectFailed => '拒绝失败。请重试';

  @override
  String get submitSuccess => '提交成功';

  @override
  String get submitFailed => '提交失败。请重试';

  @override
  String get networkError => '无网络连接。请检查并重试';

  @override
  String get timeoutError => '连接超时。请重试';

  @override
  String get serverError => '服务器错误。请稍后重试';

  @override
  String get otpInvalid => 'OTP代码无效。请再次检查';

  @override
  String get otpEmptyError => 'OTP不能为空';

  @override
  String get otpLengthError => 'OTP必须正好6位数字';

  @override
  String get verifyOtpTitle => '验证OTP';

  @override
  String get otpCodeLabel => 'OTP代码';

  @override
  String get submitError => '提交时发生错误。请重试';

  @override
  String get scanBarcode => '扫描条码';

  @override
  String get barcodeScan => '条码扫描';

  @override
  String get correct => '正确';

  @override
  String get wrong => '错误';

  @override
  String get receiver => '接收员';

  @override
  String get production => '生产';

  @override
  String get rejectCurrentStep => '拒绝当前步骤';

  @override
  String get rejectCurrentStepDescription => '将此流程退回到上一个验证步骤。';

  @override
  String get rejectReason => '拒绝原因';

  @override
  String get supervisorOtp => '主管 OTP';

  @override
  String get enterRejectReason => '请输入拒绝原因...';

  @override
  String get confirmReject => '确认拒绝';

  @override
  String get enterAllOtpDigits => '请输入完整的 6 位 OTP';

  @override
  String returnToPreviousStep(String step) {
    return '此步骤将退回到 $step 重新检查。';
  }

  @override
  String get firstStepCannotReturnFurther => '这是第一个步骤，无法继续退回。';

  @override
  String get materialOvertimeSubtitle => '管理和监控物料超时';

  @override
  String get refresh => '刷新';

  @override
  String totalOvertimeItems(int total) {
    return '总计：$total 个超时物料';
  }

  @override
  String pageIndicator(int currentPage, int lastPage) {
    return '第 $currentPage/$lastPage 页';
  }

  @override
  String get requestNo => '请求号';

  @override
  String get requestDate => '请求日期';

  @override
  String get days => '天数';

  @override
  String get dayAbbreviation => '天';

  @override
  String get noOvertimeRecordsFound => '未找到超时记录';

  @override
  String get currentStep => '当前步骤';

  @override
  String get overtimeAt => '超时时间';

  @override
  String get storageAreaSubtitle => '监控生产存储区的物料位置和库存';

  @override
  String get searchStorageAreaHint => '搜索请求、物料、PCN、工单...';

  @override
  String get noStorageAreaData => '无存储区数据';

  @override
  String get location => '位置';

  @override
  String get received => '已接收';

  @override
  String get toProduct => '至生产';

  @override
  String get balance => '余额';

  @override
  String get lastConsume => '最后消耗';

  @override
  String get statusInUse => '使用中';

  @override
  String get statusOpen => '打开';

  @override
  String get statusClose => '关闭';

  @override
  String get transactionLogSubtitle => '消耗事件历史';

  @override
  String get noTransactionLogsFound => '未找到交易日志';

  @override
  String get transaction => '交易';

  @override
  String get quantity => '数量';

  @override
  String get materialRequestInformation => '物料需求信息';

  @override
  String get requestStatus => '需求状态';

  @override
  String get workflowInformation => '工作流信息';

  @override
  String get currentStatus => '当前状态';

  @override
  String get actionDate => '操作日期';

  @override
  String get submittedBy => '提交人';

  @override
  String get quantityInformation => '数量信息';

  @override
  String get preparedMaterialReceived => '准备的物料已接收';

  @override
  String get totalToProduction => '生产总数';

  @override
  String get currentMaterialBalance => '当前物料余额';

  @override
  String get lotInformation => '批次信息';

  @override
  String get specPictures => '规格图片';

  @override
  String get verificationMethod => '验证方法';

  @override
  String get logHistoryTitle => '日志历史';

  @override
  String get stepPlanner => '规划者';

  @override
  String get stepPreparer => '准备员';

  @override
  String get stepWarehouse => '仓库';

  @override
  String get stepReceiver => '接收员';

  @override
  String get stepLineLeader => '产线长';

  @override
  String get stepProduction => '生产';

  @override
  String get rolePlanner => '规划者';

  @override
  String get rolePreparer => '准备员';

  @override
  String get roleWarehouse => '仓库';

  @override
  String get roleReceiver => '接收员';

  @override
  String get roleLineLeader => '产线长';

  @override
  String get systemActor => '系统';

  @override
  String get payloadHeader => '载荷数据';

  @override
  String get boolTrue => '真';

  @override
  String get boolFalse => '假';

  @override
  String get errorLoadHistory => '未能加载历史';

  @override
  String get emptyHistoryTitle => '暂无历史';

  @override
  String get emptyHistoryDesc => '此物料请求尚无记录的日志。';

  @override
  String get retryButton => '重试';

  @override
  String get drawerModuleMaterialRequest => '物料请求';

  @override
  String get drawerModulePreparer => '准备员';

  @override
  String get drawerModuleWarehouse => '仓库';

  @override
  String get drawerModuleMaterialReceiver => '物料接收员';

  @override
  String get drawerModuleLineLeader => '产线长';

  @override
  String get reportMaterialRequestTitle => '物料请求报告';

  @override
  String get reportPreparerTitle => '准备员报告';

  @override
  String get reportWarehouseTitle => '仓库报告';

  @override
  String get reportMaterialReceiverTitle => '物料接收员报告';

  @override
  String get reportLineLeaderTitle => '产线长报告';

  @override
  String get workflowReportList => '工作流报告列表';

  @override
  String get noReportData => '没有报告数据';

  @override
  String get noWorkflowReportDataAvailable => '该步骤没有可用的工作流报告数据。';

  @override
  String get drawerReportHeader => '报告';

  @override
  String get drawerLogout => '登出';

  @override
  String get drawerLanguage => '语言';

  @override
  String get drawerMockMode => '🧪 模拟模式';

  @override
  String get drawerLanguageLabel => '语言：';

  @override
  String get loginTitle => 'MMS登录';

  @override
  String get username => '用户名';

  @override
  String get usernameEmpty => '请输入用户名';

  @override
  String get password => '密码';

  @override
  String get passwordEmpty => '请输入密码';

  @override
  String get otpEmpty => '请输入OTP';

  @override
  String get login => '登录';

  @override
  String get materialRequestTitle => '物料需求';

  @override
  String get manageRequisitions => '管理物料需求';

  @override
  String get items => '项目';

  @override
  String get searchByRequestNumber => '按请求编号、物料搜索...';

  @override
  String get noRequestsFound => '没有找到请求';

  @override
  String get all => '全部';

  @override
  String get updateDownloadFailed => '下载失败，请重试。';

  @override
  String get updateDownloadStart => '正在下载更新...';

  @override
  String get updateNewVersionAvailable => '有新版本';

  @override
  String get updateCurrentVersion => '当前版本';

  @override
  String get updateLatestVersion => '最新版本';

  @override
  String get updateLater => '稍后';

  @override
  String get updateUpdate => '更新';

  @override
  String get drawerChangePassword => '更改密码';

  @override
  String get changePasswordTitle => '更改密码';

  @override
  String get currentPassword => '当前密码';

  @override
  String get currentPasswordEmpty => '请输入当前密码';

  @override
  String get newPassword => '新密码';

  @override
  String get newPasswordEmpty => '请输入新密码';

  @override
  String get newPasswordTooShort => '密码必须至少为6个字符';

  @override
  String get confirmPassword => '确认新密码';

  @override
  String get confirmPasswordEmpty => '请确认您的新密码';

  @override
  String get confirmPasswordNotMatch => '密码不匹配';

  @override
  String get changePasswordButton => '确认';

  @override
  String get changePasswordSuccess => '密码更改成功';

  @override
  String get changePasswordFailed => '密码更改失败';

  @override
  String get dialogLogoutTitle => '登出';

  @override
  String get dialogLogoutMessage => '您确定要登出吗？';

  @override
  String get dialogCancel => '取消';

  @override
  String get dialogConfirm => '确认';
}

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn(): super('zh_CN');

  @override
  String get home => '主页';

  @override
  String get materialRequest => '物料需求';

  @override
  String get preparer => '准备员';

  @override
  String get warehouse => '仓库';

  @override
  String get materialReceiver => '物料接收';

  @override
  String get lineLeader => '产线长';

  @override
  String get toProduction => '生产发送';

  @override
  String get pdStorageArea => 'PD储存区';

  @override
  String get materialOvertime => '物料库存';

  @override
  String get materialManagement => '物料管理';

  @override
  String get monitoring => '监控';

  @override
  String get storageArea => '存储区域';

  @override
  String get materialOvertimeModule => '物料加班';

  @override
  String get transactionLog => '交易日志';

  @override
  String get logHistory => '日志历史';

  @override
  String get report => '报告';

  @override
  String get language => '语言';

  @override
  String get logout => '登出';

  @override
  String get settings => '设置';

  @override
  String get search => '搜索';

  @override
  String get retry => '重试';

  @override
  String get noData => '无数据';

  @override
  String get loading => '加载中';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get submit => '提交';

  @override
  String get approve => '批准';

  @override
  String get reject => '拒绝';

  @override
  String get pendingConfirm => '待确认';

  @override
  String get inProgress => '进行中';

  @override
  String get completed => '已完成';

  @override
  String get english => 'English';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get chineseSimplified => '简体中文';

  @override
  String get chineseTraditional => '繁體中文';

  @override
  String get version => 'v1.0.0';

  @override
  String get status => '状态';

  @override
  String get processing => '处理中';

  @override
  String get pleaseDoNotCloseScreen => '请勿关闭屏幕';

  @override
  String get prepareDate => '准备日期';

  @override
  String get tapToSelectChoice => '点击选择';

  @override
  String get requestNumber => '请求编号';

  @override
  String get autoFilled => '自动填充';

  @override
  String get workOrder => '工作单';

  @override
  String get demandWk => '需求周';

  @override
  String get pcn => 'PCN';

  @override
  String get finishGoodCtn => '成品/箱';

  @override
  String get materialPn => '物料P/N';

  @override
  String get materialName => '物料名称';

  @override
  String get requestQuantity => '请求数量';

  @override
  String get unit => '单位';

  @override
  String get lotsInformation => '批次信息';

  @override
  String get addLot => '添加批次';

  @override
  String get lot => '批次';

  @override
  String get qty => '数量';

  @override
  String get lotQty => '批次数量';

  @override
  String get enterLotName => '输入批次名称';

  @override
  String get warehouseVerification => '仓库验证';

  @override
  String get verificationInfo => '验证和信息';

  @override
  String get preparedQuantity => '准备数量';

  @override
  String get difference => '差异';

  @override
  String get verifyMethod => '验证方法';

  @override
  String get verifyMethodPr => '验证方法PR';

  @override
  String get barcodeScanPr => '条码扫描PR';

  @override
  String get pcnScan => 'PCN 扫描';

  @override
  String get pcnScanResult => 'PCN 扫描结果';

  @override
  String get pnScan => '物料 P/N 扫描';

  @override
  String get pnScanResult => '物料 P/N 扫描结果';

  @override
  String get tapIconToScan => '点击图标扫描代码';

  @override
  String get verificationCode => '验证码';

  @override
  String get enterAmount => '输入金额';

  @override
  String get scanResult => '扫描结果';

  @override
  String get locker => '储物柜';

  @override
  String get scanLocker => '扫描储物柜';

  @override
  String get scanPreparerName => '扫描备料人员';

  @override
  String get preparerName => '准备员名称';

  @override
  String get specCheck => '规格检查';

  @override
  String get quantityCheck => '数量检查';

  @override
  String get warehouseLocker => '仓库储物柜';

  @override
  String get scanWarehouseLockerQr => '扫描二维码';

  @override
  String get storageLocation => '存储位置';

  @override
  String get productionLocker => '生产储物柜';

  @override
  String get scanProductionLockerQr => '扫描二维码';

  @override
  String get warehouseKeeper => '仓库管理员';

  @override
  String get mrName => 'MR名称';

  @override
  String get receiverFrom => '接收来自';

  @override
  String get leaderName => '领导名称';

  @override
  String get quantityToProduction => '生产数量';

  @override
  String get toWhere => '至何处';

  @override
  String get toWho => '至何人';

  @override
  String get fromLocker => '来自储物柜';

  @override
  String get scanFromLockerQr => '扫描来自储物柜二维码';

  @override
  String get fromLeader => '来自领导';

  @override
  String get fromName => '来自名称';

  @override
  String get specPicture => '规格图片';

  @override
  String get searchByIdName => '按ID、名称、P/N、WO搜索...';

  @override
  String get noResultsFound => '未找到结果';

  @override
  String get anErrorOccurred => '发生错误';

  @override
  String get selectMaterialRequest => '提交前请选择物料请求';

  @override
  String get pictureVerificationRequired => '验证方法是图片——请至少拍摄1张照片';

  @override
  String get scanBarcodeRequired => '提交前请扫描条码';

  @override
  String get barcodeNotMatch => '条码与验证码不匹配';

  @override
  String get enterLotNameRequired => '请输入批次名称';

  @override
  String get enterLotQuantityRequired => '请输入数量';

  @override
  String get scanLockerRequired => '请扫描储物柜';

  @override
  String get scanPnRequired => '请扫描物料 P/N';

  @override
  String get scanPcnRequired => '请扫描 PCN';

  @override
  String get scanWarehouseLockerRequired => '请扫描仓库储物柜';

  @override
  String get scanProductionLockerRequired => '请扫描生产储物柜';

  @override
  String get enterReceivedBy => '请输入接收人';

  @override
  String get enterMrName => '请输入MR名称';

  @override
  String get enterReceiverFrom => '请输入接收来自';

  @override
  String get enterLeaderName => '请输入领导名称';

  @override
  String get enterQuantityToProduction => '请输入生产数量';

  @override
  String get quantityMustBePositive => '生产数量必须为正数';

  @override
  String get enterToWhere => '请输入至何处';

  @override
  String get enterToWho => '请输入至何人';

  @override
  String get enterFromLeader => '请输入来自领导';

  @override
  String get enterFromName => '请输入来自名称';

  @override
  String get rejectSuccess => '拒绝成功';

  @override
  String get rejectFailed => '拒绝失败。请重试';

  @override
  String get submitSuccess => '提交成功';

  @override
  String get submitFailed => '提交失败。请重试';

  @override
  String get networkError => '无网络连接。请检查并重试';

  @override
  String get timeoutError => '连接超时。请重试';

  @override
  String get serverError => '服务器错误。请稍后重试';

  @override
  String get otpInvalid => 'OTP代码无效。请再次检查';

  @override
  String get submitError => '提交时发生错误。请重试';

  @override
  String get scanBarcode => '扫描条码';

  @override
  String get barcodeScan => '条码扫描';

  @override
  String get correct => '正确';

  @override
  String get wrong => '错误';

  @override
  String get receiver => '接收员';

  @override
  String get production => '生产';

  @override
  String get rejectCurrentStep => '拒绝当前步骤';

  @override
  String get rejectCurrentStepDescription => '将此流程退回到上一个验证步骤。';

  @override
  String get rejectReason => '拒绝原因';

  @override
  String get supervisorOtp => '主管 OTP';

  @override
  String get enterRejectReason => '请输入拒绝原因...';

  @override
  String get confirmReject => '确认拒绝';

  @override
  String get enterAllOtpDigits => '请输入完整的 6 位 OTP';

  @override
  String returnToPreviousStep(String step) {
    return '此步骤将退回到 $step 重新检查。';
  }

  @override
  String get firstStepCannotReturnFurther => '这是第一个步骤，无法继续退回。';

  @override
  String get materialOvertimeSubtitle => '管理和监控物料超时';

  @override
  String get refresh => '刷新';

  @override
  String totalOvertimeItems(int total) {
    return '总计：$total 个超时物料';
  }

  @override
  String pageIndicator(int currentPage, int lastPage) {
    return '第 $currentPage/$lastPage 页';
  }

  @override
  String get requestNo => '请求号';

  @override
  String get requestDate => '请求日期';

  @override
  String get days => '天数';

  @override
  String get dayAbbreviation => '天';

  @override
  String get noOvertimeRecordsFound => '未找到超时记录';

  @override
  String get currentStep => '当前步骤';

  @override
  String get overtimeAt => '超时时间';

  @override
  String get storageAreaSubtitle => '监控生产存储区的物料位置和库存';

  @override
  String get searchStorageAreaHint => '搜索请求、物料、PCN、工单...';

  @override
  String get noStorageAreaData => '无存储区数据';

  @override
  String get location => '位置';

  @override
  String get received => '已接收';

  @override
  String get toProduct => '至生产';

  @override
  String get balance => '余额';

  @override
  String get lastConsume => '最后消耗';

  @override
  String get statusInUse => '使用中';

  @override
  String get statusOpen => '打开';

  @override
  String get statusClose => '关闭';

  @override
  String get transactionLogSubtitle => '消耗事件历史';

  @override
  String get noTransactionLogsFound => '未找到交易日志';

  @override
  String get transaction => '交易';

  @override
  String get quantity => '数量';

  @override
  String get materialRequestInformation => '物料需求信息';

  @override
  String get requestStatus => '需求状态';

  @override
  String get workflowInformation => '工作流信息';

  @override
  String get currentStatus => '当前状态';

  @override
  String get actionDate => '操作日期';

  @override
  String get submittedBy => '提交人';

  @override
  String get quantityInformation => '数量信息';

  @override
  String get preparedMaterialReceived => '准备的物料已接收';

  @override
  String get totalToProduction => '生产总数';

  @override
  String get currentMaterialBalance => '当前物料余额';

  @override
  String get lotInformation => '批次信息';

  @override
  String get specPictures => '规格图片';

  @override
  String get verificationMethod => '验证方法';

  @override
  String get logHistoryTitle => '日志历史';

  @override
  String get stepPlanner => '规划者';

  @override
  String get stepPreparer => '准备员';

  @override
  String get stepWarehouse => '仓库';

  @override
  String get stepReceiver => '接收员';

  @override
  String get stepLineLeader => '产线长';

  @override
  String get stepProduction => '生产';

  @override
  String get rolePlanner => '规划者';

  @override
  String get rolePreparer => '准备员';

  @override
  String get roleWarehouse => '仓库';

  @override
  String get roleReceiver => '接收员';

  @override
  String get roleLineLeader => '产线长';

  @override
  String get systemActor => '系统';

  @override
  String get payloadHeader => '载荷数据';

  @override
  String get boolTrue => '真';

  @override
  String get boolFalse => '假';

  @override
  String get errorLoadHistory => '未能加载历史';

  @override
  String get emptyHistoryTitle => '暂无历史';

  @override
  String get emptyHistoryDesc => '此物料请求尚无记录的日志。';

  @override
  String get retryButton => '重试';

  @override
  String get drawerModuleMaterialRequest => '物料请求';

  @override
  String get drawerModulePreparer => '准备员';

  @override
  String get drawerModuleWarehouse => '仓库';

  @override
  String get drawerModuleMaterialReceiver => '物料接收员';

  @override
  String get drawerModuleLineLeader => '产线长';

  @override
  String get reportMaterialRequestTitle => '物料请求报告';

  @override
  String get reportPreparerTitle => '准备员报告';

  @override
  String get reportWarehouseTitle => '仓库报告';

  @override
  String get reportMaterialReceiverTitle => '物料接收员报告';

  @override
  String get reportLineLeaderTitle => '产线长报告';

  @override
  String get drawerReportHeader => '报告';

  @override
  String get drawerLogout => '登出';

  @override
  String get drawerLanguage => '语言';

  @override
  String get drawerMockMode => '🧪 模拟模式';

  @override
  String get drawerLanguageLabel => '语言：';

  @override
  String get updateDownloadFailed => '下载失败，请重试。';

  @override
  String get updateDownloadStart => '正在下载更新...';

  @override
  String get updateNewVersionAvailable => '有新版本';

  @override
  String get updateCurrentVersion => '当前版本';

  @override
  String get updateLatestVersion => '最新版本';

  @override
  String get updateLater => '稍后';

  @override
  String get updateUpdate => '更新';

  @override
  String get drawerChangePassword => '更改密码';

  @override
  String get changePasswordTitle => '更改密码';

  @override
  String get currentPassword => '当前密码';

  @override
  String get currentPasswordEmpty => '请输入当前密码';

  @override
  String get newPassword => '新密码';

  @override
  String get newPasswordEmpty => '请输入新密码';

  @override
  String get newPasswordTooShort => '密码必须至少为6个字符';

  @override
  String get confirmPassword => '确认新密码';

  @override
  String get confirmPasswordEmpty => '请确认您的新密码';

  @override
  String get confirmPasswordNotMatch => '密码不匹配';

  @override
  String get changePasswordButton => '确认';

  @override
  String get changePasswordSuccess => '密码更改成功';

  @override
  String get changePasswordFailed => '密码更改失败';

  @override
  String get dialogLogoutTitle => '登出';

  @override
  String get dialogLogoutMessage => '您确定要登出吗？';

  @override
  String get dialogCancel => '取消';

  @override
  String get dialogConfirm => '确认';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw(): super('zh_TW');

  @override
  String get home => '主頁';

  @override
  String get materialRequest => '物料需求';

  @override
  String get preparer => '準備員';

  @override
  String get warehouse => '倉庫';

  @override
  String get materialReceiver => '物料接收';

  @override
  String get lineLeader => '產線長';

  @override
  String get toProduction => '生產發送';

  @override
  String get pdStorageArea => 'PD儲存區';

  @override
  String get materialOvertime => '物料庫存';

  @override
  String get materialManagement => '物料管理';

  @override
  String get monitoring => '監控';

  @override
  String get storageArea => '儲存區域';

  @override
  String get materialOvertimeModule => '物料加班';

  @override
  String get transactionLog => '交易日誌';

  @override
  String get logHistory => '日誌歷史';

  @override
  String get report => '報告';

  @override
  String get language => '語言';

  @override
  String get logout => '登出';

  @override
  String get settings => '設置';

  @override
  String get search => '搜尋';

  @override
  String get retry => '重試';

  @override
  String get noData => '無數據';

  @override
  String get loading => '加載中';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '確認';

  @override
  String get submit => '提交';

  @override
  String get approve => '批准';

  @override
  String get reject => '拒絕';

  @override
  String get pendingConfirm => '待確認';

  @override
  String get inProgress => '進行中';

  @override
  String get completed => '已完成';

  @override
  String get english => 'English';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get chineseSimplified => '简体中文';

  @override
  String get chineseTraditional => '繁體中文';

  @override
  String get version => 'v1.0.0';

  @override
  String get status => '狀態';

  @override
  String get processing => '處理中';

  @override
  String get pleaseDoNotCloseScreen => '請勿關閉螢幕';

  @override
  String get prepareDate => '準備日期';

  @override
  String get tapToSelectChoice => '點擊選擇';

  @override
  String get requestNumber => '請求編號';

  @override
  String get autoFilled => '自動填充';

  @override
  String get workOrder => '工作單';

  @override
  String get demandWk => '需求週';

  @override
  String get pcn => 'PCN';

  @override
  String get finishGoodCtn => '成品/箱';

  @override
  String get materialPn => '物料P/N';

  @override
  String get materialName => '物料名稱';

  @override
  String get requestQuantity => '請求數量';

  @override
  String get unit => '單位';

  @override
  String get lotsInformation => '批次資訊';

  @override
  String get addLot => '添加批次';

  @override
  String get lot => '批次';

  @override
  String get qty => '數量';

  @override
  String get lotQty => '批次數量';

  @override
  String get enterLotName => '輸入批次名稱';

  @override
  String get warehouseVerification => '倉庫驗證';

  @override
  String get verificationInfo => '驗證和資訊';

  @override
  String get preparedQuantity => '準備數量';

  @override
  String get difference => '差異';

  @override
  String get verifyMethod => '驗證方法';

  @override
  String get verifyMethodPr => '驗證方法PR';

  @override
  String get barcodeScanPr => '條碼掃描PR';

  @override
  String get pcnScan => 'PCN 掃描';

  @override
  String get pcnScanResult => 'PCN 掃描結果';

  @override
  String get pnScan => '物料 P/N 掃描';

  @override
  String get pnScanResult => '物料 P/N 掃描結果';

  @override
  String get tapIconToScan => '點擊圖標掃描代碼';

  @override
  String get verificationCode => '驗證碼';

  @override
  String get enterAmount => '輸入金額';

  @override
  String get scanResult => '掃描結果';

  @override
  String get locker => '儲物櫃';

  @override
  String get scanLocker => '掃描儲物櫃';

  @override
  String get scanPreparerName => '掃描備料人員';

  @override
  String get preparerName => '準備員名稱';

  @override
  String get specCheck => '規格檢查';

  @override
  String get quantityCheck => '數量檢查';

  @override
  String get warehouseLocker => '倉庫儲物櫃';

  @override
  String get scanWarehouseLockerQr => '掃描二維碼';

  @override
  String get storageLocation => '儲存位置';

  @override
  String get productionLocker => '生產儲物櫃';

  @override
  String get scanProductionLockerQr => '掃描二維碼';

  @override
  String get warehouseKeeper => '倉庫管理員';

  @override
  String get mrName => 'MR名稱';

  @override
  String get receiverFrom => '接收來自';

  @override
  String get leaderName => '領導名稱';

  @override
  String get quantityToProduction => '生產數量';

  @override
  String get toWhere => '至何處';

  @override
  String get toWho => '至何人';

  @override
  String get fromLocker => '來自儲物櫃';

  @override
  String get scanFromLockerQr => '掃描來自儲物櫃二維碼';

  @override
  String get fromLeader => '來自領導';

  @override
  String get fromName => '來自名稱';

  @override
  String get specPicture => '規格圖片';

  @override
  String get searchByIdName => '按ID、名稱、P/N、WO搜尋...';

  @override
  String get noResultsFound => '未找到結果';

  @override
  String get anErrorOccurred => '發生錯誤';

  @override
  String get selectMaterialRequest => '提交前請選擇物料請求';

  @override
  String get pictureVerificationRequired => '驗證方法是圖片——請至少拍攝1張照片';

  @override
  String get scanBarcodeRequired => '提交前請掃描條碼';

  @override
  String get barcodeNotMatch => '條碼與驗證碼不匹配';

  @override
  String get enterLotNameRequired => '請輸入批次名稱';

  @override
  String get enterLotQuantityRequired => '請輸入數量';

  @override
  String get scanLockerRequired => '請掃描儲物櫃';

  @override
  String get scanPnRequired => '請掃描物料 P/N';

  @override
  String get scanPcnRequired => '請掃描 PCN';

  @override
  String get scanWarehouseLockerRequired => '請掃描倉庫儲物櫃';

  @override
  String get scanProductionLockerRequired => '請掃描生產儲物櫃';

  @override
  String get enterReceivedBy => '請輸入接收人';

  @override
  String get enterMrName => '請輸入MR名稱';

  @override
  String get enterReceiverFrom => '請輸入接收來自';

  @override
  String get enterLeaderName => '請輸入領導名稱';

  @override
  String get enterQuantityToProduction => '請輸入生產數量';

  @override
  String get quantityMustBePositive => '生產數量必須為正數';

  @override
  String get enterToWhere => '請輸入至何處';

  @override
  String get enterToWho => '請輸入至何人';

  @override
  String get enterFromLeader => '請輸入來自領導';

  @override
  String get enterFromName => '請輸入來自名稱';

  @override
  String get rejectSuccess => '拒絕成功';

  @override
  String get rejectFailed => '拒絕失敗。請重試';

  @override
  String get submitSuccess => '提交成功';

  @override
  String get submitFailed => '提交失敗。請重試';

  @override
  String get networkError => '無網路連接。請檢查並重試';

  @override
  String get timeoutError => '連接逾時。請重試';

  @override
  String get serverError => '伺服器錯誤。請稍後重試';

  @override
  String get otpInvalid => 'OTP代碼無效。請再次檢查';

  @override
  String get otpEmptyError => 'OTP不能為空';

  @override
  String get otpLengthError => 'OTP必須正好6位數字';

  @override
  String get verifyOtpTitle => '驗證OTP';

  @override
  String get otpCodeLabel => 'OTP代碼';

  @override
  String get submitError => '提交時發生錯誤。請重試';

  @override
  String get scanBarcode => '掃描條碼';

  @override
  String get barcodeScan => '條碼掃描';

  @override
  String get correct => '正確';

  @override
  String get wrong => '錯誤';

  @override
  String get receiver => '接收員';

  @override
  String get production => '生產';

  @override
  String get rejectCurrentStep => '拒絕目前步驟';

  @override
  String get rejectCurrentStepDescription => '將此流程退回到上一個驗證步驟。';

  @override
  String get rejectReason => '拒絕原因';

  @override
  String get supervisorOtp => '主管 OTP';

  @override
  String get enterRejectReason => '請輸入拒絕原因...';

  @override
  String get confirmReject => '確認拒絕';

  @override
  String get enterAllOtpDigits => '請輸入完整的 6 位 OTP';

  @override
  String returnToPreviousStep(String step) {
    return '此步驟將退回到 $step 重新檢查。';
  }

  @override
  String get firstStepCannotReturnFurther => '這是第一個步驟，無法繼續退回。';

  @override
  String get materialOvertimeSubtitle => '管理和監控物料逾時';

  @override
  String get refresh => '重新整理';

  @override
  String totalOvertimeItems(int total) {
    return '總計：$total 個逾時物料';
  }

  @override
  String pageIndicator(int currentPage, int lastPage) {
    return '第 $currentPage/$lastPage 頁';
  }

  @override
  String get requestNo => '請求號';

  @override
  String get requestDate => '請求日期';

  @override
  String get days => '天數';

  @override
  String get dayAbbreviation => '天';

  @override
  String get noOvertimeRecordsFound => '找不到逾時記錄';

  @override
  String get currentStep => '目前步驟';

  @override
  String get overtimeAt => '逾時時間';

  @override
  String get storageAreaSubtitle => '監控生產儲存區的物料位置和庫存';

  @override
  String get searchStorageAreaHint => '搜尋請求、物料、PCN、工單...';

  @override
  String get noStorageAreaData => '無儲存區資料';

  @override
  String get location => '位置';

  @override
  String get received => '已接收';

  @override
  String get toProduct => '至生產';

  @override
  String get balance => '餘額';

  @override
  String get lastConsume => '最後消耗';

  @override
  String get statusInUse => '使用中';

  @override
  String get statusOpen => '開啟';

  @override
  String get statusClose => '關閉';

  @override
  String get transactionLogSubtitle => '消耗事件歷史';

  @override
  String get noTransactionLogsFound => '找不到交易日誌';

  @override
  String get transaction => '交易';

  @override
  String get quantity => '數量';

  @override
  String get materialRequestInformation => '物料需求資訊';

  @override
  String get requestStatus => '需求狀態';

  @override
  String get workflowInformation => '工作流程資訊';

  @override
  String get currentStatus => '目前狀態';

  @override
  String get actionDate => '操作日期';

  @override
  String get submittedBy => '提交人';

  @override
  String get quantityInformation => '數量資訊';

  @override
  String get preparedMaterialReceived => '準備的物料已接收';

  @override
  String get totalToProduction => '生產總數';

  @override
  String get currentMaterialBalance => '目前物料餘額';

  @override
  String get lotInformation => '批次資訊';

  @override
  String get specPictures => '規格圖片';

  @override
  String get verificationMethod => '驗證方法';

  @override
  String get logHistoryTitle => '日誌歷史';

  @override
  String get stepPlanner => '規劃者';

  @override
  String get stepPreparer => '準備員';

  @override
  String get stepWarehouse => '倉庫';

  @override
  String get stepReceiver => '接收員';

  @override
  String get stepLineLeader => '產線長';

  @override
  String get stepProduction => '生產';

  @override
  String get rolePlanner => '規劃者';

  @override
  String get rolePreparer => '準備員';

  @override
  String get roleWarehouse => '倉庫';

  @override
  String get roleReceiver => '接收員';

  @override
  String get roleLineLeader => '產線長';

  @override
  String get systemActor => '系統';

  @override
  String get payloadHeader => '載荷數據';

  @override
  String get boolTrue => '真';

  @override
  String get boolFalse => '假';

  @override
  String get errorLoadHistory => '未能加載歷史';

  @override
  String get emptyHistoryTitle => '暫無歷史';

  @override
  String get emptyHistoryDesc => '此物料請求尚無記錄的日誌。';

  @override
  String get retryButton => '重試';

  @override
  String get drawerModuleMaterialRequest => '物料請求';

  @override
  String get drawerModulePreparer => '準備員';

  @override
  String get drawerModuleWarehouse => '倉庫';

  @override
  String get drawerModuleMaterialReceiver => '物料接收員';

  @override
  String get drawerModuleLineLeader => '產線長';

  @override
  String get reportMaterialRequestTitle => '物料請求報告';

  @override
  String get reportPreparerTitle => '準備員報告';

  @override
  String get reportWarehouseTitle => '倉庫報告';

  @override
  String get reportMaterialReceiverTitle => '物料接收員報告';

  @override
  String get reportLineLeaderTitle => '產線長報告';

  @override
  String get workflowReportList => '工作流報告清單';

  @override
  String get noReportData => '沒有報告數據';

  @override
  String get noWorkflowReportDataAvailable => '此步驟不可用工作流報告數據。';

  @override
  String get drawerReportHeader => '報告';

  @override
  String get drawerLogout => '登出';

  @override
  String get drawerLanguage => '語言';

  @override
  String get drawerMockMode => '🧪 模擬模式';

  @override
  String get drawerLanguageLabel => '語言：';

  @override
  String get loginTitle => 'MMS登入';

  @override
  String get username => '用戶名';

  @override
  String get usernameEmpty => '請輸入用戶名';

  @override
  String get password => '密碼';

  @override
  String get passwordEmpty => '請輸入密碼';

  @override
  String get otpEmpty => '請輸入OTP';

  @override
  String get login => '登入';

  @override
  String get materialRequestTitle => '物料需求';

  @override
  String get manageRequisitions => '管理物料需求';

  @override
  String get items => '項目';

  @override
  String get searchByRequestNumber => '按請求編號、物料搜索...';

  @override
  String get noRequestsFound => '沒有找到請求';

  @override
  String get all => '全部';

  @override
  String get updateDownloadFailed => '下載失敗，請重試。';

  @override
  String get updateDownloadStart => '正在下載更新...';

  @override
  String get updateNewVersionAvailable => '有新版本';

  @override
  String get updateCurrentVersion => '當前版本';

  @override
  String get updateLatestVersion => '最新版本';

  @override
  String get updateLater => '稍後';

  @override
  String get updateUpdate => '更新';

  @override
  String get drawerChangePassword => '更改密碼';

  @override
  String get changePasswordTitle => '更改密碼';

  @override
  String get currentPassword => '目前密碼';

  @override
  String get currentPasswordEmpty => '請輸入目前密碼';

  @override
  String get newPassword => '新密碼';

  @override
  String get newPasswordEmpty => '請輸入新密碼';

  @override
  String get newPasswordTooShort => '密碼必須至少為6個字元';

  @override
  String get confirmPassword => '確認新密碼';

  @override
  String get confirmPasswordEmpty => '請確認您的新密碼';

  @override
  String get confirmPasswordNotMatch => '密碼不匹配';

  @override
  String get changePasswordButton => '確認';

  @override
  String get changePasswordSuccess => '密碼更改成功';

  @override
  String get changePasswordFailed => '密碼更改失敗';

  @override
  String get dialogLogoutTitle => '登出';

  @override
  String get dialogLogoutMessage => '您確定要登出嗎？';

  @override
  String get dialogCancel => '取消';

  @override
  String get dialogConfirm => '確認';
}
