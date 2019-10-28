
#import "RNBaiduTrace.h"

#import <BaiduTraceSDK/BaiduTraceSDK.h>


#define  _onStartServer @"onStartService" // 开启轨迹服务的回调方法
#define  _onStopService @"onStopService" // 停止轨迹服务的回调方法
#define  _onStartGather @"onStartGather"// 开始采集的回调方法
#define  _onStopGather @"onStopGather"// 停止采集的回调方法
#define  _onGetPushMessage @"onGetPushMessage" //收到推送消息的回调方法
#define  _onGetCustomDataResult @"onGetCustomDataResult" // 用户自定义信息设置结果的回调方法
#define  _onChangeGatherAndPackIntervals @"onChangeGatherAndPackIntervals" //更改采集和打包上传周期的结果的回调方法
#define  _onSetCacheMaxSize @"onSetCacheMaxSize"// 设置缓存占用的最大磁盘空间的结果的回调方法
#define  _onRequestAlwaysLocationAuthorization @"onRequestAlwaysLocationAuthorization" //请求后台定位权限的回调方法

#define _onAnalyzeDrivingBehaviour @"onAnalyzeDrivingBehaviour" //驾驶行为分析
#define _onAnalyzeStayPoint @"onAnalyzeStayPoint" //停留点分析
#define _onQueryTrackDistance @"onQueryTrackDistance"//里程计算
#define Error @"error"

@interface RNBaiduTrace ()<BTKTraceDelegate,BTKAnalysisDelegate,BTKTrackDelegate>
@property (nonatomic,copy)NSString *entryName;
@end

@implementation RNBaiduTrace

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
    
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}
RCT_EXPORT_MODULE()

/**
 初始化百度鹰眼轨迹服务
 @param entityName  // 设备标识 string
 @param ak ak
 @param mcode mcode
 @param serviceID 轨迹服务的ID
 @param keepAlive 是否保活
*/
RCT_EXPORT_METHOD(initBaiduTrace:(NSUInteger )serviceId ak:(NSString *)ak entityName:(NSString *)entityName bundleId:(NSString *)bundleId keepAlive:(BOOL)keepAlive){
    self.entryName = entityName;
    BTKServiceOption *sop = [[BTKServiceOption alloc] initWithAK:ak mcode:bundleId serviceID:serviceId keepAlive:keepAlive];
    [[BTKAction sharedInstance] initInfo:sop];
}
/**
*   开启轨迹服务
*/
RCT_EXPORT_METHOD(startBaiduTrace){
    // 设置开启轨迹服务时的服务选项，指定本次服务以“entityA”的名义开启
    BTKStartServiceOption *op = [[BTKStartServiceOption alloc] initWithEntityName:self.entryName];
    // 开启服务
    [[BTKAction sharedInstance] startService:op delegate:self];
}
/**
停止轨迹服务

@param delegate 操作结果的回调对象
*/
RCT_EXPORT_METHOD(stopBaiduTrace){
    [[BTKAction sharedInstance] stopService:self];
}
/**
开始采集

@param delegate 操作结果的回调对象
*/
RCT_EXPORT_METHOD(startBaiduTraceGather){
    dispatch_async(dispatch_get_main_queue(),^{
        [[BTKAction sharedInstance] startGather:self];
    });
    
}
/**
停止采集

@param delegate 操作结果的回调对象
*/
RCT_EXPORT_METHOD(stopBaiduTraceGather){
    [[BTKAction sharedInstance] stopGather:self];
}

/**
 里程计算
 @param entityName entity名称
 @param startTime 开始时间
 @param endTime 结束时间
 @param isProcessed 是否返回纠偏后的里程
 @param processOption 纠偏选项
 @param supplementMode 里程补偿方式
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(queryTrackDistance:(NSString *)entityName startTime:(NSUInteger)startTime endTime:(NSUInteger)endTime isProcessed:(BOOL)isProcessed processOption:(NSDictionary *)processOption supplementMode:(BTKTrackProcessOptionSupplementMode)supplementMode serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag){
    // 设置纠偏选项
    BTKQueryTrackProcessOption *process = nil;
    if (processOption != nil) {
        process = [BTKQueryTrackProcessOption new];
        process.denoise = [processOption[@"denoise"] boolValue];
        process.vacuate = [processOption[@"vacuate"] boolValue];
        process.mapMatch = [processOption[@"mapMatch"] boolValue];
        process.radiusThreshold = [processOption[@"radiusThreshold"] integerValue];
        process.transportMode = [processOption[@"transportMode"] integerValue];
    }
    // 构造请求对象
    BTKQueryTrackDistanceRequest *request = [[BTKQueryTrackDistanceRequest alloc] initWithEntityName:entityName startTime:startTime endTime:endTime isProcessed:isProcessed processOption:process supplementMode:supplementMode serviceID:100000 tag:12];
    // 发起查询请求
    [[BTKTrackAction sharedInstance] queryTrackDistanceWith:request delegate:self];
}

/**
 构造方法

 @param entityName 要查询的entity终端实体的名称
 @param startTime 开始时间
 @param endTime 结束时间
 @param stayTime 停留时间
 @param stayRadius 停留半径
 @param processOption 纠偏选项
 @param outputCoordType 返回的坐标类型
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 请求对象
 */

/**
停留点分析

@param request 请求对象
@param delegate 操作结果的回调对象
*/
RCT_EXPORT_METHOD(analyzeStayPoint:(NSString *)entityName
                  startTime:(NSUInteger)startTime
                  endTime:(NSUInteger)endTime
                  stayTime:(NSUInteger)stayTime
                  stayRadius:(NSUInteger)stayRadius
                  processOption:(NSDictionary *)processOption
                  outputCoordType:(NSUInteger)outputCoordType
                  serviceID:(NSUInteger)serviceID
                  tag:(NSUInteger)tag
                  ){
    BTKQueryTrackProcessOption *process = nil;
    if (processOption != nil) {
        process = [BTKQueryTrackProcessOption new];
        process.denoise = [processOption[@"denoise"] boolValue];
        process.vacuate = [processOption[@"vacuate"] boolValue];
        process.mapMatch = [processOption[@"mapMatch"] boolValue];
        process.radiusThreshold = [processOption[@"radiusThreshold"] integerValue];
        process.transportMode = [processOption[@"transportMode"] integerValue];
    }
    
    
    // 构造请求对象
    BTKStayPointAnalysisRequest *request = [[BTKStayPointAnalysisRequest alloc] initWithEntityName:entityName startTime:startTime endTime:endTime stayTime:stayTime stayRadius:stayRadius processOption:process outputCoordType:outputCoordType serviceID:serviceID tag:tag];
//    // 发起请求
    [[BTKAnalysisAction sharedInstance] analyzeStayPointWith:request delegate:self];
}
/**
    驾驶行为分析
 @param entityName 要查询的entity终端实体的名称
 @param startTime 开始时间
 @param endTime 结束时间
 @param thresholdOption 阈值选项
 @param processOption 纠偏选项
 @param outputCoordType 返回的坐标类型
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(analyzeDrivingBehaviour:(NSString *)entityName
                    startTime:(NSUInteger)startTime
                    endTime:(NSUInteger)endTime
                    thresholdOption:(NSDictionary *)thresholdOption
                    processOption:(NSDictionary *)processOption
                    outputCoordType:(NSUInteger)outputCoordType
                    serviceID:(NSUInteger)serviceID
                    tag:(NSUInteger)tag){
 
    BTKQueryTrackProcessOption *process = nil;
    if (processOption != nil) {
        process = [BTKQueryTrackProcessOption new];
        process.denoise = [processOption[@"denoise"] boolValue];
        process.vacuate = [processOption[@"vacuate"] boolValue];
        process.mapMatch = [processOption[@"mapMatch"] boolValue];
        process.radiusThreshold = [processOption[@"radiusThreshold"] integerValue];
        process.transportMode = [processOption[@"transportMode"] integerValue];
    }

    BTKDrivingBehaviorThresholdOption *threadoption = nil;
    if (thresholdOption != nil) {
        threadoption = [BTKDrivingBehaviorThresholdOption new];
        threadoption.speedingThreshold = [thresholdOption[@"speedingThreshold"] doubleValue];
        threadoption.harshAccelerationThreshold = [thresholdOption[@"harshAccelerationThreshold"] doubleValue];
        threadoption.harshBreakingThreshold = [thresholdOption[@"harshBreakingThreshold"] doubleValue];
        threadoption.harshSteeringThreshold = [thresholdOption[@"harshSteeringThreshold"] doubleValue];
    }
    BTKDrivingBehaviourAnalysisRequest *request = [[BTKDrivingBehaviourAnalysisRequest alloc]initWithEntityName:entityName startTime:startTime endTime:endTime thresholdOption:threadoption processOption:process outputCoordType:outputCoordType serviceID:serviceID tag:tag];
    // 发起请求
    [[BTKAnalysisAction sharedInstance] analyzeDrivingBehaviourWith:request delegate:self];
}


#pragma mark - BTKTraceDelegate
/**
 开启轨迹服务的回调方法

 @param error 开启轨迹服务的结果
 */
-(void)onStartService:(BTKServiceErrorCode) error{
    NSLog(@"开启服务结果为 %lu",(unsigned long)error);
    [self sendEventWithEvent:_onStartServer data:@{Error:@(error)}];
}
/**
 停止轨迹服务的回调方法

 @param error 停止轨迹服务的结果
 */
-(void)onStopService:(BTKServiceErrorCode) error{
    NSLog(@"stop 服务结果为 %lu",(unsigned long)error);
    [self sendEventWithEvent:_onStopService data:@{Error:@(error)}];
}

/**
 开始采集的回调方法

 @param error 开始采集的操作结果
 */
-(void)onStartGather:(BTKGatherErrorCode) error{
    [self sendEventWithEvent:_onStartGather data:@{Error:@(error)}];
}
/**
 停止采集的回调方法

 @param error 停止采集的操作结果
 */
-(void)onStopGather:(BTKGatherErrorCode) error{
    [self sendEventWithEvent:_onStopGather data:@{Error:@(error)}];
}

/**
 收到推送消息的回调方法

 @param message 推送消息的内容
 */
-(void)onGetPushMessage:(BTKPushMessage *)message{
    NSLog(@"收到推送消息，消息类型: %@", @(message.type));
    BTKPushMessageFenceAlarmContent *content = (BTKPushMessageFenceAlarmContent *)message.content;
    if (message.type == 0x03) {
        BTKPushMessageFenceAlarmContent *content = (BTKPushMessageFenceAlarmContent *)message.content;
        if (content.actionType == BTK_FENCE_MONITORED_OBJECT_ACTION_TYPE_ENTER) {
            NSLog(@"被监控对象 %@ 进入 服务端地理围栏 %@ ", content.monitoredObject, content.fenceName);
        } else if (content.actionType == BTK_FENCE_MONITORED_OBJECT_ACTION_TYPE_EXIT) {
            NSLog(@"被监控对象 %@ 离开 服务端地理围栏 %@ ", content.monitoredObject, content.fenceName);
        }
    } else if (message.type == 0x04) {
        BTKPushMessageFenceAlarmContent *content = (BTKPushMessageFenceAlarmContent *)message.content;
        if (content.actionType == BTK_FENCE_MONITORED_OBJECT_ACTION_TYPE_ENTER) {
            NSLog(@"被监控对象 %@ 进入 客户端地理围栏 %@ ", content.monitoredObject, content.fenceName);
        } else if (content.actionType == BTK_FENCE_MONITORED_OBJECT_ACTION_TYPE_EXIT) {
            NSLog(@"被监控对象 %@ 离开 客户端地理围栏 %@ ", content.monitoredObject, content.fenceName);
        }
    }
    
    NSDictionary *param = @{
        @"type":@(message.type),
        @"actionType":@(content.actionType),
        @"monitoredObject":content.monitoredObject,
        @"fenceName":content.fenceName,
    };
    
    [self sendEventWithEvent:_onGetPushMessage data:param];
}

/**
 用户自定义信息的设置方法，SDK在每个采集周期会回调此方法，将此方法的返回值作为该定位周期内轨迹点的附加数据
 所有附加数据组成的字典，总的字节数不能超过1024字节。

 @return 当前定位周期内轨迹点的附加数据，key代表自定义字段名称，value代表自定义字段的值。用法见DEMO
 */
//-(NSDictionary *)onGetCustomData{
//
//}

/**
 用户自定义信息设置结果的回调方法

 @param error 自定义信息的设置结果
 */
-(void)onGetCustomDataResult:(BTKGetCustomDataErrorCode) error{
    [self sendEventWithEvent:_onGetCustomDataResult data:@{Error:@(error)}];
}

/**
 更改采集和打包上传周期的结果的回调方法

 @param error 更改周期的结果
 */
-(void)onChangeGatherAndPackIntervals:(BTKChangeIntervalErrorCode) error{
    
    [self sendEventWithEvent:_onChangeGatherAndPackIntervals data:@{Error:@(error)}];
}

/**
 设置缓存占用的最大磁盘空间的结果的回调方法

 @param error 设置的结果
 */
-(void)onSetCacheMaxSize:(BTKSetCacheMaxSizeErrorCode) error{
    [self sendEventWithEvent:_onSetCacheMaxSize data:@{Error:@(error)}];
}

/**
请求后台定位权限的回调方法

@param locationManager 定位控制器，开发者需要调用该实例的requestAlwaysAuthorization方法
*/
-(void)onRequestAlwaysLocationAuthorization:(CLLocationManager *) locationManager{
    
}


#pragma mark - 里程计算delegate
/**
 上传开发者自定义轨迹点的回调方法

 @param response 上传结果
 */
-(void)onAddCustomTrackPoint:(NSData *)response{
    
}

/**
 批量上传开发者自定义的轨迹点的回调方法

 @param response 上传结果
 */
-(void)onBatchAddCustomTrackPoint:(NSData *)response{
    
}

/**
 实时位置查询的回调方法

 @param response 查询结果
 */
-(void)onQueryTrackLatestPoint:(NSData *)response{
    
}

/**
 里程查询的回调方法

 @param response 查询结果
 */
-(void)onQueryTrackDistance:(NSData *)response{
    [self sendEventWithEvent:_onQueryTrackDistance data:response];
}

/**
 轨迹查询的回调方法

 @param response 查询结果
 */
-(void)onQueryHistoryTrack:(NSData *)response{
    
}

/**
 缓存查询的回调方法

 @param response 查询结果
 */
-(void)onQueryTrackCacheInfo:(NSData *)response{
    
}

/**
 清空缓存的回调方法

 @param response 清空操作的结果
 */
-(void)onClearTrackCache:(NSData *)response{
    
}

#pragma mark - 轨迹分析delegete
/**
停留点分析的回调方法

@param response 停留点分析的结果
*/
- (void)onAnalyzeStayPoint:(NSData *)response{
    [self sendEventWithEvent:_onAnalyzeStayPoint data:response];
}
/**
驾驶行为分析的回调方法

@param response 驾驶行为分析的结果
*/
- (void)onAnalyzeDrivingBehaviour:(NSData *)response{
    [self sendEventWithEvent:_onAnalyzeDrivingBehaviour data:response];
}

- (void)sendEventWithEvent:(NSString *)event data:(id)responseData{
    [self.bridge enqueueJSCall:@"RCTDeviceEventEmitter"
        method:@"emit"
          args:@[event, responseData]
    completion:NULL];
}

//事件处理
- (NSArray<NSString *> *)supportedEvents
{
    return @[_onStartServer,_onStopService,_onStartGather,_onStopGather,_onGetCustomDataResult,_onChangeGatherAndPackIntervals,_onSetCacheMaxSize,_onGetPushMessage,_onAnalyzeStayPoint,_onAnalyzeStayPoint,_onQueryTrackDistance];
}
@end
  
