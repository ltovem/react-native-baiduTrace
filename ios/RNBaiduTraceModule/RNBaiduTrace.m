
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


#define _onQueryHistoryTrack @"onQueryHistoryTrack"//轨迹查询的回调方法
#define _onQueryTrackCacheInfo @"onQueryTrackCacheInfo"//缓存查询的回调方法
#define _onClearTrackCache @"onClearTrackCache"//清空缓存的回调方法
#define _onCreateLocalFence @"onCreateLocalFence"//创建客户端地理围栏的回调方法
#define _onDeleteLocalFence @"onDeleteLocalFence"// 删除客户端地理围栏的回调方法
#define _onUpdateLocalFence @"onUpdateLocalFence"//更新客户端地理围栏的回调方法
#define _onQueryLocalFence @"onQueryLocalFence"//查询客户端地理围栏的回调方法
#define _onQueryLocalFenceStatus @"onQueryLocalFenceStatus"//查询监控对象和客户端地理围栏的位置关系的回调方法
#define _onQueryLocalFenceStatusByCustomLocation @"onQueryLocalFenceStatusByCustomLocation"//根据自定义位置，查询监控对象和客户端地理围栏的位置关系的回调方法
#define _onQueryLocalFenceHistoryAlarm @"onQueryLocalFenceHistoryAlarm"//查询客户端地理围栏历史报警信息的回调方法
#define _onCreateServerFence @"onCreateServerFence"//创建服务端地理围栏的回调方法
#define _onDeleteServerFence @"onDeleteServerFence"//删除服务端地理围栏的回调方法
#define _onUpdateServerFence @"onUpdateServerFence"//修改服务端地理围栏的回调方法
#define _onQueryServerFence @"onQueryServerFence"//查询服务端地理围栏的回调方法
#define _onQueryServerFenceStatus @"onQueryServerFenceStatus"//查询监控对象在服务端地理围栏内外的回调方法
#define _onQueryServerFenceStatusByCustomLocation @"onQueryServerFenceStatusByCustomLocation"//根据指定的位置查询被监控对象的状态的回调方法
#define _onQueryServerFenceHistoryAlarm @"onQueryServerFenceHistoryAlarm"//查询监控对象的服务端围栏报警信息的回调方法
#define _onBatchQueryServerFenceHistoryAlarm @"onBatchQueryServerFenceHistoryAlarm"// 批量同步某service的服务端地理围栏报警信息的回调方法
#define _onAddMonitoredObject @"onAddMonitoredObject"//给服务端围栏添加监控对象的回调方法
#define _onDeleteMonitoredObject @"onDeleteMonitoredObject"//删除服务端围栏的监控对象的回调方法
#define _onListMonitoredObject @"onListMonitoredObject"//查询服务端围栏的监控对象的回调方法

#define _onAddEntity @"onAddEntity"//创建Entity终端实体的回调方法
#define _onDeleteEntity @"onDeleteEntity"//删除Entity终端实体的回调方法
#define _onUpdateEntity @"onUpdateEntity"//更新Entity终端实体的回调方法
#define _onQueryEntity @"onQueryEntity"//查询Entity终端实体的回调方法
#define _onEntitySearch @"onEntitySearch"//关键字检索Entity终端实体的回调方法
#define _onEntityBoundSearch @"onEntityBoundSearch"//矩形区域检索Entity终端实体的回调方法
#define _onEntityDistrictSearch @"onEntityDistrictSearch" //行政区域内检索Entity终端实体的回调方法
#define _onEntityPolygonSearch @"onEntityPolygonSearch"//多边形区域检索Entity终端实体的回调方法
#define _onEntityAroundSearch @"onEntityAroundSearch" //圆形区域检索Entity终端实体的回调方法

#define Error @"error"

@interface RNBaiduTrace ()<BTKTraceDelegate,BTKAnalysisDelegate,BTKTrackDelegate,BTKFenceDelegate,BTKEntityDelegate>
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
#pragma mark - 轨迹缓存处理
/**
 查询缓存信息
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(queryTrackCacheInfoAll:(NSUInteger)serviceID tag:(NSUInteger)tag){
    // 构造请求对象
    BTKQueryTrackCacheInfoRequest *request = [[BTKQueryTrackCacheInfoRequest alloc] initWithEntityNames:nil serviceID:serviceID tag:tag];
    // 发起请求
    [[BTKTrackAction sharedInstance] queryTrackCacheInfoWith:request delegate:self];
}
/**
 查询缓存轨迹里程
 @param entityNames entity名称列表
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @param needDistance 是否返回每个entity的缓存轨迹的里程，选填，默认为false。
 @param distanceFilter精度过滤阈值，单位：米
 */
RCT_EXPORT_METHOD(queryTrackCacheInfo:EntityNames:(NSArray *)entityNames serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag needDistance :(BOOL)needDistance distanceFilter:(double)distanceFilter){
    // 构造请求对象
    BTKQueryTrackCacheInfoRequest *request = [[BTKQueryTrackCacheInfoRequest alloc] initWithEntityNames:entityNames serviceID:serviceID tag:tag];
    request.needDistance = needDistance;
    request.distanceFilter = distanceFilter;
    // 发起请求
    [[BTKTrackAction sharedInstance] queryTrackCacheInfoWith:request delegate:self];
}

/**
 清空缓存信息
 @param optionArray item=>{"entityName":"xxx","startTime":1457788888,"endTime":1234555555}
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(clearTrackCache:(NSArray *)optionArray ServiceID:(NSUInteger)serviceID tag:(NSUInteger)tag){
    // 设置清空的条件
    NSMutableArray *options = [NSMutableArray array];
    for (NSDictionary *temp in optionArray) {
        BTKClearTrackCacheOption *op = [[BTKClearTrackCacheOption alloc]initWithEntityName:temp[@"entityName"] startTime:[temp[@"startTime"] integerValue] endTime:[temp[@"endTime"] integerValue]];
        [options addObject:op];
    }
    // 构造请求对象
    BTKClearTrackCacheRequest *request = [[BTKClearTrackCacheRequest alloc] initWithOptions:options serviceID:serviceID tag:tag];
    // 发起请求
    [[BTKTrackAction sharedInstance] clearTrackCacheWith:request delegate:self];
}
#pragma mark - 空间搜索
/**
 关键字检索
 @param query 关键字
 @param activeTime 过滤条件 UNIX时间戳，查询在此时间之后有定位信息上传的entity（loc_time>=activeTime）。
 @param fieldName 排序方法 需要排序的字段
 @param sortby 排序方法 1 asc 2 desc default 1 asc
 @param outputCoordType 返回的坐标类型
 @param pageIndex 分页索引
 @param pageSize 分页大小
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(searchEntity:(NSString *)query activeTime:(NSUInteger )activeTime fieldName:(NSString *)fieldName sortType:(NSUInteger)sortType outputCoordType:(BTKCoordType)outputCoordType pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize ServiceID:(NSUInteger)serviceID tag:(NSUInteger)tag){
    // 设置过滤条件
    BTKQueryEntityFilterOption *filterOption = [[BTKQueryEntityFilterOption alloc] init];
    filterOption.activeTime = activeTime;
    // 设置排序条件，返回的多个entity按照，定位时间'loc_time'的倒序排列
    BTKSearchEntitySortByOption * sortbyOption = [[BTKSearchEntitySortByOption alloc] init];
    sortbyOption.fieldName = fieldName;
    sortbyOption.sortType = sortType;
    // 构造请求对象
    BTKSearchEntityRequest *request = [[BTKSearchEntityRequest alloc] initWithQueryKeyword:query filter:filterOption sortby:sortbyOption outputCoordType:outputCoordType pageIndex:pageIndex pageSize:pageSize ServiceID:serviceID tag:tag];
    // 发起检索请求
    [[BTKEntityAction sharedInstance] searchEntityWith:request delegate:self];
}
/**
 矩形范围搜索
 @param latitude 矩形左下角的顶点坐标点坐标
 @param longitude 矩形左下角的顶点坐标点坐标
 @param latitude2 矩形右上角的顶点坐标点坐标
 @param longitude2 矩形右上角的顶点坐标点坐标
 @param inputCoordType 中心点的坐标类型 BTKCoordType
 @param entityNames entityName列表，精确筛选
 @param activeTime 过滤条件 UNIX时间戳，查询在此时间之后有定位信息上传的entity（loc_time>=activeTime）。
 @param fieldName 排序方法 需要排序的字段 entityName列表，精确筛选
 @param sortby 排序方法 1 asc 2 desc default 1 asc
 @param outputCoordType 返回的坐标类型
 @param pageIndex 分页索引
 @param pageSize 分页大小
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(boundSearchEntity:(double)latitude longitude:(double)longitude  latitude2:(double)latitude2 longitude2:(double)longitude2 inputCoordType:(BTKCoordType)inputCoordType entityNames:(NSArray *)entityNames activeTime:(NSUInteger )activeTime fieldName:(NSString *)fieldName sortType:(NSUInteger)sortType outputCoordType:(BTKCoordType)outputCoordType pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize ServiceID:(NSUInteger)serviceID tag:(NSUInteger)tag){
    // 设置矩形的区域
    NSMutableArray *bounds = [NSMutableArray arrayWithCapacity:2];
    // 矩形左下角的顶点坐标
    CLLocationCoordinate2D point1 = CLLocationCoordinate2DMake(latitude, longitude);
    [bounds addObject:[NSValue valueWithBytes:&point1 objCType:@encode(CLLocationCoordinate2D)]];
    // 矩形右上角的顶点坐标
    CLLocationCoordinate2D point2 = CLLocationCoordinate2DMake(latitude2, longitude);
    [bounds addObject:[NSValue valueWithBytes:&point2 objCType:@encode(CLLocationCoordinate2D)]];
    // 设置检索的过滤选项
    BTKQueryEntityFilterOption *filterOption = [[BTKQueryEntityFilterOption alloc] init];
    filterOption.entityNames = entityNames;
    filterOption.activeTime = activeTime;
    // 设置检索结果的排序选项
    BTKSearchEntitySortByOption * sortbyOption = [[BTKSearchEntitySortByOption alloc] init];
    sortbyOption.fieldName = fieldName;
    sortbyOption.sortType = sortType;
    // 构造检索请求
    BTKBoundSearchEntityRequest *request = [[BTKBoundSearchEntityRequest alloc] initWithBounds:bounds inputCoordType:inputCoordType filter:filterOption sortby:sortbyOption outputCoordType:outputCoordType pageIndex:pageIndex pageSize:pageSize ServiceID:serviceID tag:tag];
    // 发起检索请求
    [[BTKEntityAction sharedInstance] boundSearchEntityWith:request delegate:self];
}
/**
 周边搜索
 @param latitude 圆形检索区域的中心点坐标
 @param longitude 圆形检索区域的中心点坐标
 @param inputCoordType 中心点的坐标类型 BTKCoordType
 @param radius 圆形检索区域的半径
 @param activeTime 过滤条件 UNIX时间戳，查询在此时间之后有定位信息上传的entity（loc_time>=activeTime）。
 @param fieldName 排序方法 需要排序的字段
 @param sortby 排序方法 1 asc 2 desc default 1 asc
 @param outputCoordType 返回的坐标类型
 @param pageIndex 分页索引
 @param pageSize 分页大小
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(aroundSearchEntity:(double)latitude longitude:(double)longitude  inputCoordType:(BTKCoordType)inputCoordType radius:(NSUInteger)radius activeTime:(NSUInteger )activeTime fieldName:(NSString *)fieldName sortType:(NSUInteger)sortType outputCoordType:(BTKCoordType)outputCoordType pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize ServiceID:(NSUInteger)serviceID tag:(NSUInteger)tag){
   // 设置圆形的圆心
   CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
   // 设置检索的过滤条件
   BTKQueryEntityFilterOption *filterOption = [[BTKQueryEntityFilterOption alloc] init];
   filterOption.activeTime = activeTime;
   // 设置检索结果的排序方式
   BTKSearchEntitySortByOption * sortbyOption = [[BTKSearchEntitySortByOption alloc] init];
   sortbyOption.fieldName = fieldName;
   sortbyOption.sortType = sortType;
   // 构造检索请求对象
   BTKAroundSearchEntityRequest *request = [[BTKAroundSearchEntityRequest alloc] initWithCenter:center inputCoordType:inputCoordType radius:radius filter:filterOption sortby:sortbyOption outputCoordType:outputCoordType pageIndex:pageIndex pageSize:pageSize ServiceID:serviceID tag:tag];
   // 发起检索请求
   [[BTKEntityAction sharedInstance] aroundSearchEntityWith:request delegate:self];
}
#pragma mark - 轨迹查询与纠偏
/**
 查询某终端实体的经过轨迹纠偏后的实时位置
 @param entityName entity名称
 @param processOption 纠偏选项
 @param outputCoordType 返回的坐标类型
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(queryTrackLatestPoint:(NSString *)entityName processOption:(NSDictionary *)processOption outputCootdType:(BTKCoordType)outputCoordType serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag){
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
    BTKQueryTrackLatestPointRequest *request = [[BTKQueryTrackLatestPointRequest alloc] initWithEntityName:entityName processOption: process outputCootdType:outputCoordType serviceID:serviceID tag:tag];
    // 发起查询请求
    [[BTKTrackAction sharedInstance] queryTrackLatestPointWith:request delegate:self];
}
/**
 查询历史轨迹
 @param entityName 要查询的entity终端实体的名称
 @param startTime 开始时间
 @param endTime 结束时间
 @param isProcessed 是否返回纠偏后的轨迹
 @param processOption 纠偏选项
 @param supplementMode 里程补偿方式
 @param outputCoordType 返回轨迹点的坐标类型
 @param sortType 返回轨迹点的排序规则
 @param pageIndex 分页索引
 @param pageSize 分页大小
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(getHistoryTrack:(NSUInteger)tag serviceID:(NSUInteger)serviceID entityName:(NSString *)entityName startTime:(NSUInteger)startTime endTime:(NSUInteger)endTime isProcessed:(BOOL)isProcessed processOption:(NSDictionary *)processOption supplementMode:(BTKTrackProcessOptionSupplementMode)supplementMode outputCoordType:(BTKCoordType)outputCoordType sortType:(BTKTrackSortType)sortType pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize  ){
    // 构造请求对象
    BTKQueryTrackProcessOption *process = nil;
    if (processOption != nil) {
        process = [BTKQueryTrackProcessOption new];
        process.denoise = [processOption[@"denoise"] boolValue];
        process.vacuate = [processOption[@"vacuate"] boolValue];
        process.mapMatch = [processOption[@"mapMatch"] boolValue];
        process.radiusThreshold = [processOption[@"radiusThreshold"] integerValue];
        process.transportMode = [processOption[@"transportMode"] integerValue];
    }
    BTKQueryHistoryTrackRequest *request = [[BTKQueryHistoryTrackRequest alloc] initWithEntityName:entityName startTime:startTime endTime:endTime isProcessed:isProcessed processOption:process supplementMode:supplementMode outputCoordType:outputCoordType sortType:sortType pageIndex:pageIndex pageSize:pageSize serviceID:serviceID tag:tag];
    // 发起查询请求
    [[BTKTrackAction sharedInstance] queryHistoryTrackWith:request delegate:self];
}
#pragma mark - 里程计算
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
#pragma mark - 地理围栏
/**
    创建服务端圆形地理围栏
    @param latitude 圆心坐标
    @param longitude 圆心坐标
    @param radius 半径
    @param coordType 圆心的坐标类型
    @param denoiseAccuracy 去燥精度 单位：米。每个轨迹点都有一个定位误差半径radius，这个值越大，代表定位越不准确，可能是噪点。围栏计算时，如果噪点也参与计算，会造成误报的情况。设置denoiseAccuray可控制，当轨迹点的定位误差半径大于设置值时，就会把该轨迹点当做噪点，不参与围栏计算。如果不想去噪，设置为0即可。
    @param fenceName 围栏名称
    @param monitoredObject 围栏监控对象的名称
    @param serviceID 轨迹服务的ID
    @param tag 请求标志
 */
RCT_EXPORT_METHOD(createServerCircleFence:(double)latitude longitude:(double)longitude radius:(double)radius coordType:(BTKCoordType)coordType denoiseAccuracy:(NSUInteger)denoiseAccuracy fenceName:(NSString *)fenceName monitoredObject:(NSString *)monitoredObject serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag){
    // 圆心
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
    // 构造将要创建的新的围栏对象
    BTKServerCircleFence *fence = [[BTKServerCircleFence alloc] initWithCenter:center radius:radius coordType:coordType denoiseAccuracy:50 fenceName:fenceName monitoredObject:monitoredObject];
    // 构造请求对象
    BTKCreateServerFenceRequest *circleRequest = [[BTKCreateServerFenceRequest alloc] initWithServerCircleFence:fence serviceID:serviceID tag:tag];
    // 发起创建请求
    [[BTKFenceAction sharedInstance] createServerFenceWith:circleRequest delegate:self];
}

/**
 创建服务端多边形围栏
 @param vertexes 多边形的顶点坐标数组，数组中每一项为 {"latitude":"36.6","longitude":"133.00"}类型
 @param coordType 顶点坐标的坐标类型
 @param denoiseAccuracy 去燥精度 单位：米。每个轨迹点都有一个定位误差半径radius，这个值越大，代表定位越不准确，可能是噪点。围栏计算时，如果噪点也参与计算，会造成误报的情况。设置denoiseAccuray可控制，当轨迹点的定位误差半径大于设置值时，就会把该轨迹点当做噪点，不参与围栏计算。如果不想去噪，设置为0即可。
 @param fenceName 地理围栏的名称
 @param monitoredObject 地理围栏监控对象的名称
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(createServerPolygonFence:(NSArray *)vertexes coordType:(BTKCoordType)coordType  denoiseAccuracy:(NSUInteger)denoiseAccuracy fenceName:(NSString *)fenceName monitoredObject:(NSString *)monitoredObject serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag){
//    NSMutableArray *verArray = [NSMutableArray array];
//    for (NSDictionary *temp in vertexes) {
//        CLLocationCoordinate2D
//        CLLocationCoordinate2D center = CLLocationCoordinate2DMake([temp[@"latitude"] doubleValue], [temp[@"longitude"] doubleValue]);
//        [verArray addObject:center];
//    }
    BTKServerPolygonFence *fence = [[BTKServerPolygonFence alloc]initWithVertexes:vertexes coordType:coordType denoiseAccuracy:denoiseAccuracy fenceName:fenceName monitoredObject:monitoredObject];
    BTKCreateServerFenceRequest *polygonFenceRequest = [[BTKCreateServerFenceRequest alloc]initWithServerPolygonFence:fence serviceID:serviceID tag:tag];
    [[BTKFenceAction sharedInstance] createServerFenceWith:polygonFenceRequest delegate:self];
    
}
/**
创建服务端线性围栏
@param vertexes 多边形的顶点坐标数组，数组中每一项为 {"latitude":"36.6","longitude":"133.00"}类型
@param coordType 顶点坐标的坐标类型
@param offset 偏离距离 偏移距离（若偏离折线距离超过该距离即报警），单位：米 示例：200
@param denoiseAccuracy 去燥精度 单位：米。每个轨迹点都有一个定位误差半径radius，这个值越大，代表定位越不准确，可能是噪点。围栏计算时，如果噪点也参与计算，会造成误报的情况。设置denoiseAccuray可控制，当轨迹点的定位误差半径大于设置值时，就会把该轨迹点当做噪点，不参与围栏计算。如果不想去噪，设置为0即可。
@param fenceName 地理围栏的名称
@param monitoredObject 地理围栏监控对象的名称
@param serviceID 轨迹服务的ID
@param tag 请求标志
*/
RCT_EXPORT_METHOD(createServerPolylineFence:(NSArray *)vertexes coordType:(BTKCoordType)coordType offset:(NSInteger)offset denoiseAccuracy:(NSUInteger)denoiseAccuracy fenceName:(NSString *)fenceName monitoredObject:(NSString *)monitoredObject serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag){
    
    BTKServerPolylineFence *fence = [[BTKServerPolylineFence alloc]initWithVertexes:vertexes coordType:coordType offset:offset denoiseAccuracy:denoiseAccuracy fenceName:fenceName monitoredObject:monitoredObject];
    BTKCreateServerFenceRequest *polygonLineFenceRequest = [[BTKCreateServerFenceRequest alloc]initWithServerPolylineFence:fence serviceID:serviceID tag:tag];
    [[BTKFenceAction sharedInstance] createServerFenceWith:polygonLineFenceRequest delegate:self];
}

/**
 创建服务端行政区划围栏
 @param keyword 行政区划关键字
 @param denoiseAccuracy 去噪精度
 @param fenceName 围栏名称
 @param monitoredObject 监控对象名称
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(createServerDistrictFence:(NSString *)keyword denoiseAccuracy:(NSUInteger)denoiseAccuracy fenceName:(NSString *)fenceName monitoredObject:(NSString *)monitoredObject serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag){
    
    BTKServerDistrictFence *fence = [[BTKServerDistrictFence alloc]initWithKeyword:keyword denoiseAccuracy:denoiseAccuracy fenceName:fenceName monitoredObject:monitoredObject];
    BTKCreateServerFenceRequest *DistrictFence = [[BTKCreateServerFenceRequest alloc]initWithServerDistrictFence:fence serviceID:serviceID tag:tag];
    [[BTKFenceAction sharedInstance] createServerFenceWith:DistrictFence delegate:self];
}

/**
 构造方法，用于构造删除服务端地理围栏的请求对象

 @param monitoredObject 围栏的监控对象
 @param fenceIDs 围栏ID的数组，若为空，则删除监控对象上的所有地理围栏
 @param serviceID 轨迹服务ID
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(deleteServerFence:(NSString *)monitoredObject fenceIDs:(NSArray *)fenceIDs serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag){
    // 构造请求对象
    BTKDeleteServerFenceRequest *request = [[BTKDeleteServerFenceRequest alloc] initWithMonitoredObject:monitoredObject fenceIDs:fenceIDs serviceID:serviceID tag:tag];
    // 发起删除请求
    [[BTKFenceAction sharedInstance] deleteServerFenceWith:request delegate:self];
}

/**
    更新服务端圆形地理围栏
    @param latitude 圆心坐标
    @param longitude 圆心坐标
    @param radius 半径
    @param coordType 圆心的坐标类型
    @param denoiseAccuracy 去燥精度 单位：米。每个轨迹点都有一个定位误差半径radius，这个值越大，代表定位越不准确，可能是噪点。围栏计算时，如果噪点也参与计算，会造成误报的情况。设置denoiseAccuray可控制，当轨迹点的定位误差半径大于设置值时，就会把该轨迹点当做噪点，不参与围栏计算。如果不想去噪，设置为0即可。
    @param fenceName 围栏名称
    @param monitoredObject 围栏监控对象的名称
    @param fenceID 要更新的地理围栏ID
    @param serviceID 轨迹服务的ID
    @param tag 请求标志
 */
RCT_EXPORT_METHOD(updateServerCircleFence:(double)latitude longitude:(double)longitude radius:(double)radius coordType:(BTKCoordType)coordType denoiseAccuracy:(NSUInteger)denoiseAccuracy fenceName:(NSString *)fenceName monitoredObject:(NSString *)monitoredObject fenceID:(NSUInteger)fenceID serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag){
    // 圆心
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
    // 构造将要更新的新的围栏对象
    BTKServerCircleFence *fence = [[BTKServerCircleFence alloc] initWithCenter:center radius:radius coordType:coordType denoiseAccuracy:denoiseAccuracy fenceName:fenceName monitoredObject:monitoredObject];
    // 构造请求对象
    BTKUpdateServerFenceRequest *circleRequest = [[BTKUpdateServerFenceRequest alloc] initWithServerCircleFence:fence fenceID:fenceID serviceID:serviceID tag:tag];
    // 发起更新请求
    [[BTKFenceAction sharedInstance] updateServerFenceWith:circleRequest delegate:self];
}

/**
 更新服务端多边形围栏
 @param vertexes 多边形的顶点坐标数组，数组中每一项为 {"latitude":"36.6","longitude":"133.00"}类型
 @param coordType 顶点坐标的坐标类型
 @param denoiseAccuracy 去燥精度 单位：米。每个轨迹点都有一个定位误差半径radius，这个值越大，代表定位越不准确，可能是噪点。围栏计算时，如果噪点也参与计算，会造成误报的情况。设置denoiseAccuray可控制，当轨迹点的定位误差半径大于设置值时，就会把该轨迹点当做噪点，不参与围栏计算。如果不想去噪，设置为0即可。
 @param fenceName 地理围栏的名称
 @param monitoredObject 地理围栏监控对象的名称
 @param fenceID 要更新的地理围栏ID
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(updateServerPolygonFence:(NSArray *)vertexes coordType:(BTKCoordType)coordType  denoiseAccuracy:(NSUInteger)denoiseAccuracy fenceName:(NSString *)fenceName monitoredObject:(NSString *)monitoredObject fenceID:(NSUInteger)fenceID serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag){
//    NSMutableArray *verArray = [NSMutableArray array];
//    for (NSDictionary *temp in vertexes) {
//        CLLocationCoordinate2D
//        CLLocationCoordinate2D center = CLLocationCoordinate2DMake([temp[@"latitude"] doubleValue], [temp[@"longitude"] doubleValue]);
//        [verArray addObject:center];
//    }
    BTKServerPolygonFence *fence = [[BTKServerPolygonFence alloc]initWithVertexes:vertexes coordType:coordType denoiseAccuracy:denoiseAccuracy fenceName:fenceName monitoredObject:monitoredObject];
    BTKUpdateServerFenceRequest *polygonFenceRequest = [[BTKUpdateServerFenceRequest alloc]initWithServerPolygonFence:fence fenceID:fenceID serviceID:serviceID tag:tag];
    [[BTKFenceAction sharedInstance] updateServerFenceWith:polygonFenceRequest delegate:self];
    
}
/**
更新服务端线性围栏
@param vertexes 多边形的顶点坐标数组，数组中每一项为 {"latitude":"36.6","longitude":"133.00"}类型
@param coordType 顶点坐标的坐标类型
@param offset 偏离距离 偏移距离（若偏离折线距离超过该距离即报警），单位：米 示例：200
@param denoiseAccuracy 去燥精度 单位：米。每个轨迹点都有一个定位误差半径radius，这个值越大，代表定位越不准确，可能是噪点。围栏计算时，如果噪点也参与计算，会造成误报的情况。设置denoiseAccuray可控制，当轨迹点的定位误差半径大于设置值时，就会把该轨迹点当做噪点，不参与围栏计算。如果不想去噪，设置为0即可。
@param fenceName 地理围栏的名称
@param monitoredObject 地理围栏监控对象的名称
@param fenceID 要更新的地理围栏ID
@param serviceID 轨迹服务的ID
@param tag 请求标志
*/
RCT_EXPORT_METHOD(updateServerPolylineFence:(NSArray *)vertexes coordType:(BTKCoordType)coordType offset:(NSInteger)offset denoiseAccuracy:(NSUInteger)denoiseAccuracy fenceName:(NSString *)fenceName monitoredObject:(NSString *)monitoredObject fenceID:(NSUInteger)fenceID serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag){
    
    BTKServerPolylineFence *fence = [[BTKServerPolylineFence alloc]initWithVertexes:vertexes coordType:coordType offset:offset denoiseAccuracy:denoiseAccuracy fenceName:fenceName monitoredObject:monitoredObject];
    BTKUpdateServerFenceRequest *polygonLineFenceRequest = [[BTKUpdateServerFenceRequest alloc]initWithServerPolylineFence:fence fenceID:fenceID serviceID:serviceID tag:tag];
    [[BTKFenceAction sharedInstance] updateServerFenceWith:polygonLineFenceRequest delegate:self];
}

/**
 更新服务端行政区划围栏
 @param keyword 行政区划关键字
 @param denoiseAccuracy 去噪精度
 @param fenceName 围栏名称
 @param monitoredObject 监控对象名称
 @param fenceID 要更新的地理围栏ID
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(updateServerDistrictFence:(NSString *)keyword denoiseAccuracy:(NSUInteger)denoiseAccuracy fenceName:(NSString *)fenceName monitoredObject:(NSString *)monitoredObject fenceID:(NSUInteger)fenceID serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag){
    
    BTKServerDistrictFence *fence = [[BTKServerDistrictFence alloc]initWithKeyword:keyword denoiseAccuracy:denoiseAccuracy fenceName:fenceName monitoredObject:monitoredObject];
    
    BTKUpdateServerFenceRequest *DistrictFence = [[BTKUpdateServerFenceRequest alloc]initWithServerDistrictFence:fence fenceID:fenceID serviceID:serviceID tag:tag];
    [[BTKFenceAction sharedInstance] updateServerFenceWith:DistrictFence delegate:self];
}
/**
 服务端围栏查询
 @param monitoredObject 围栏监控的对象的entity_name
 @param fenceIDs 要查询的地理围栏ID列表，若为空，则查询监控对象上的所有地理围栏
 @param outputCoordType 输出坐标类型，只能选择百度经纬度或者国测局经纬度，在国内（包括港、澳、台）以外区域，无论设置何种坐标系，均返回 wgs84坐标
 @param serviceID 轨迹服务ID
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(queryServerFence:(NSString *)monitoredObject fenceIDs:(NSArray *)fenceIDs outputCoordType:(BTKCoordType)outputCoordType serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag){
    // 构建请求对象
    BTKQueryServerFenceRequest *request = [[BTKQueryServerFenceRequest alloc] initWithMonitoredObject:monitoredObject fenceIDs:fenceIDs outputCoordType:outputCoordType serviceID:serviceID tag:tag];
    // 发送查询请求
    [[BTKFenceAction sharedInstance] queryServerFenceWith:request delegate:self];
}
/**
 查询终端实体“entityA” 和所有监控该终端实体的服务端地理围栏的位置关系
 @param monitoredObject 监控对象的名称
 @param fenceIDs 围栏实体的ID列表 nil 所有围栏
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(queryServerFenceStatus:(NSString *)monitoredObject fenceIDs:(NSArray *)fenceIDs ServiceID:(NSUInteger)serviceID tag:(NSUInteger)tag){
    // 构建请求对象
    BTKQueryServerFenceStatusRequest *request = [[BTKQueryServerFenceStatusRequest alloc] initWithMonitoredObject:monitoredObject fenceIDs:fenceIDs ServiceID:serviceID tag:tag];
    // 发起查询请求
    [[BTKFenceAction sharedInstance] queryServerFenceStatusWith:request delegate:self];
}
/**
 可以假设被监控对象处于某自定义的位置坐标时，其和地理围栏的位置关系。
 @param monitoredObject 围栏的监控对象名称
 @param latitude 指定的位置坐标
 @param longitude 指定的位置坐标
 @param coordType BTKCoordType
 @param fenceIDs 服务端地理围栏的ID列表
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(queryServerFenceStatusByCustomLocation:(NSString *)monitoredObject latitude:(double)latitude longitude:(double)longitude coordType:(BTKCoordType)coordType fenceIDs:(NSArray *)fenceIDs serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag){
    // 被监控对象的模拟位置
    CLLocationCoordinate2D customLocation = CLLocationCoordinate2DMake(latitude, longitude);
    // 地理围栏ID列表
//    NSArray *fenceIDs = @[@17, @23, @29];
    // 构建请求对象
    BTKQueryServerFenceStatusByCustomLocationRequest *request = [[BTKQueryServerFenceStatusByCustomLocationRequest alloc] initWithmonitoredObject:monitoredObject CustomLocation:customLocation coordType:coordType fenceIDs:fenceIDs serviceID:serviceID tag:tag];
    // 发起查询请求
    [[BTKFenceAction sharedInstance] queryServerFenceStatusByCustomLocationWith:request delegate:self];
}
/**
 查询“entityA”这个终端实体上的所有服务端地理围栏，。
 @param monitoredObject 被监控对象的名称
 @param fenceIDs 地理围栏实体的ID列表
 @param startTime 时间段起点
 @param endTime 时间段终点
 @param outputCoordType 返回坐标类型 BTKCoordType
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(queryServerFenceHistoryAlarm:(NSString *)monitoredObject fenceIDs:(NSArray *)fenceIDs startTime:(NSUInteger)startTime endTime:(NSUInteger)endTime outputCoordType:(BTKCoordType)outputCoordType ServiceID:(NSUInteger)serviceID tag:(NSUInteger)tag){
    
    // 构建请求对象
    BTKQueryServerFenceHistoryAlarmRequest *request = [[BTKQueryServerFenceHistoryAlarmRequest alloc] initWithMonitoredObject:monitoredObject fenceIDs:fenceIDs startTime:startTime endTime:endTime outputCoordType:outputCoordType ServiceID:serviceID tag:tag];
    // 发起查询请求
    [[BTKFenceAction sharedInstance] queryServerFenceHistoryAlarmWith:request delegate:self];
}
/**
 所有的终端实体上的所有服务端地理围栏
 @param startTime 开始时间
 @param endTime 结束时间
 @param outputCoordType 返回坐标类型 BTKCoordType
 @param pageIndex 分页索引
 @param pageSize 分页大小
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(batchQueryServerFenceHistoryAlarm:(NSUInteger)startTime endTime:(NSUInteger)endTime outputCoordType:(BTKCoordType)outputCoordType pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize ServiceID:(NSUInteger)serviceID tag:(NSUInteger)tag){
    
    // 构建请求对象
    BTKBatchQueryServerFenceHistoryAlarmRequest *request = [[BTKBatchQueryServerFenceHistoryAlarmRequest alloc] initWithStartTime:startTime endTime:endTime outputCoordType:outputCoordType pageIndex:pageIndex pageSize:pageSize ServiceID:serviceID tag:tag];
    // 发起查询请求
    [[BTKFenceAction sharedInstance] batchQueryServerFenceHistoryAlarmWith:request delegate:self];
}

#pragma mark -

/**
    创建客户端圆形地理围栏
    @param latitude 圆心坐标
    @param longitude 圆心坐标
    @param radius 半径
    @param coordType 圆心的坐标类型
    @param denoiseAccuracy 去燥精度 单位：米。每个轨迹点都有一个定位误差半径radius，这个值越大，代表定位越不准确，可能是噪点。围栏计算时，如果噪点也参与计算，会造成误报的情况。设置denoiseAccuray可控制，当轨迹点的定位误差半径大于设置值时，就会把该轨迹点当做噪点，不参与围栏计算。如果不想去噪，设置为0即可。
    @param fenceName 围栏名称
    @param monitoredObject 围栏监控对象的名称
    @param tag 请求标志
 */
RCT_EXPORT_METHOD(createLocalFenceCircleFence:(double)latitude longitude:(double)longitude radius:(double)radius coordType:(BTKCoordType)coordType denoiseAccuracy:(NSUInteger)denoiseAccuracy fenceName:(NSString *)fenceName monitoredObject:(NSString *)monitoredObject  tag:(NSUInteger)tag){
    // 圆心
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
    // 构造将要创建的新的围栏对象
    BTKLocalCircleFence *fence = [[BTKLocalCircleFence alloc] initWithCenter:center radius:radius coordType:coordType denoiseAccuracy:denoiseAccuracy fenceName:fenceName monitoredObject:monitoredObject];
    // 构造请求对象
    BTKCreateLocalFenceRequest *circleRequest = [[BTKCreateLocalFenceRequest alloc] initWithLocalCircleFence:fence tag:tag];
    // 发起创建请求
    [[BTKFenceAction sharedInstance] createLocalFenceWith:circleRequest delegate:self];
}



/**
 删除围栏，用于构造删除客户端地理围栏的请求对象

 @param monitoredObject 围栏的监控对象
 @param fenceIDs 围栏ID的数组，若为空，则删除监控对象上的所有地理围栏
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(deleteLocalFence:(NSString *)monitoredObject fenceIDs:(NSArray *)fenceIDs  tag:(NSUInteger)tag){
    // 构造请求对象
    BTKDeleteLocalFenceRequest *request = [[BTKDeleteLocalFenceRequest alloc] initWithMonitoredObject:monitoredObject fenceIDs:fenceIDs  tag:tag];
    // 发起删除请求
    [[BTKFenceAction sharedInstance] deleteLocalFenceWith:request delegate:self];
}

/**
    更新客户端圆形地理围栏 // ios TO DO
    @param latitude 圆心坐标
    @param longitude 圆心坐标
    @param radius 半径
    @param coordType 圆心的坐标类型
    @param denoiseAccuracy 去燥精度 单位：米。每个轨迹点都有一个定位误差半径radius，这个值越大，代表定位越不准确，可能是噪点。围栏计算时，如果噪点也参与计算，会造成误报的情况。设置denoiseAccuray可控制，当轨迹点的定位误差半径大于设置值时，就会把该轨迹点当做噪点，不参与围栏计算。如果不想去噪，设置为0即可。
    @param fenceName 围栏名称
    @param monitoredObject 围栏监控对象的名称
    @param fenceID 要更新的地理围栏ID
    @param serviceID 轨迹服务的ID
    @param tag 请求标志
 */
RCT_EXPORT_METHOD(updateLocalFenceCircleFence:(double)latitude longitude:(double)longitude radius:(double)radius coordType:(BTKCoordType)coordType denoiseAccuracy:(NSUInteger)denoiseAccuracy fenceName:(NSString *)fenceName monitoredObject:(NSString *)monitoredObject fenceID:(NSUInteger)fenceID serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag){
    // 圆心
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
    // 构造将要更新的新的围栏对象
    BTKLocalCircleFence *fence = [[BTKLocalCircleFence alloc] initWithCenter:center radius:radius coordType:coordType denoiseAccuracy:50 fenceName:fenceName monitoredObject:monitoredObject];
    // 构造请求对象
//    BTKUpdateLocalFenceRequest *circleRequest = [[BTKUpdateLocalFenceRequest alloc] initWithLocalFenceID:fenceID localCircleFence:fenceName tag:23];
//    // 发起更新请求
//    [[BTKFenceAction sharedInstance] updateLocalFenceWith:circleRequest delegate:self];
}


/**
 客户端围栏查询
 @param monitoredObject 监控对象的名称
 @param fenceIDs 地理围栏ID数组
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(queryLocalFence:(NSString *)monitoredObject fenceIDs:(NSArray *)fenceIDs tag:(NSUInteger)tag){
    BTKQueryLocalFenceRequest *request = [[BTKQueryLocalFenceRequest alloc] initWithMonitoredObject:monitoredObject fenceIDs:fenceIDs tag:tag];
    // 查询客户端地理围栏
    [[BTKFenceAction sharedInstance] queryLocalFenceWith:request delegate:self];
}
/**
 查询终端实体“entityA” 和所有监控该终端实体的客户端地理围栏的位置关系
 @param monitoredObject 监控对象的名称
 @param fenceIDs 围栏实体的ID列表
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(queryLocalFenceStatus:(NSString *)monitoredObject fenceIDs:(NSArray *)fenceIDs tag:(NSUInteger)tag){
    // 构建请求对象
    BTKQueryLocalFenceStatusRequest *request = [[BTKQueryLocalFenceStatusRequest alloc] initWithMonitoredObject:monitoredObject fenceIDs:fenceIDs tag:tag];
    // 发起查询请求
    [[BTKFenceAction sharedInstance] queryLocalFenceStatusWith:request delegate:self];
}
/**
 可以假设被监控对象处于某自定义的位置坐标时，其和地理围栏的位置关系。
 @param monitoredObject 围栏的监控对象名称
 @param latitude 指定的位置坐标
 @param longitude 指定的位置坐标
 @param coordType BTKCoordType
 @param fenceIDs 客户端地理围栏的ID列表
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(queryLocalFenceStatusByCustomLocation:(NSString *)monitoredObject latitude:(double)latitude longitude:(double)longitude coordType:(BTKCoordType)coordType fenceIDs:(NSArray *)fenceIDs  tag:(NSUInteger)tag){
    // 被监控对象的模拟位置
    CLLocationCoordinate2D customLocation = CLLocationCoordinate2DMake(latitude, longitude);
    // 构建请求对象
    BTKQueryLocalFenceStatusByCustomLocationRequest *request = [[BTKQueryLocalFenceStatusByCustomLocationRequest alloc] initWithmonitoredObject:monitoredObject CustomLocation:customLocation coordType:coordType fenceIDs:fenceIDs tag:tag];
    // 发起查询请求
    [[BTKFenceAction sharedInstance] queryLocalFenceStatusByCustomLocationWith:request delegate:self];
}
/**
 查询“entityA”这个终端实体上的所有客户端地理围栏，。
 @param monitoredObject 被监控对象的名称
 @param fenceIDs 地理围栏实体的ID列表
 @param startTime 时间段起点
 @param endTime 时间段终点
 @param tag 请求标志
 */
RCT_EXPORT_METHOD(queryLocalFenceHistoryAlarm:(NSString *)monitoredObject fenceIDs:(NSArray *)fenceIDs startTime:(NSUInteger)startTime endTime:(NSUInteger)endTime  tag:(NSUInteger)tag){
    
    // 构建请求对象
    BTKQueryLocalFenceHistoryAlarmRequest *request = [[BTKQueryLocalFenceHistoryAlarmRequest alloc] initWithMonitoredObject:monitoredObject fenceIDs:fenceIDs startTime:startTime endTime:endTime tag:tag];
    // 发起查询请求
    [[BTKFenceAction sharedInstance] queryLocalFenceHistoryAlarmWith:request delegate:self];
}

/**
 停留点分析

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
#pragma mark ---
/**
 轨迹查询的回调方法

 @param response 查询结果
 */
-(void)onQueryHistoryTrack:(NSData *)response{
    [self sendEventWithEvent:_onQueryHistoryTrack data:response];
}

/**
 缓存查询的回调方法

 @param response 查询结果
 */
-(void)onQueryTrackCacheInfo:(NSData *)response{
    [self sendEventWithEvent:_onQueryTrackCacheInfo data:response];
}

/**
 清空缓存的回调方法

 @param response 清空操作的结果
 */
-(void)onClearTrackCache:(NSData *)response{
    [self sendEventWithEvent:_onClearTrackCache data:response];
}

#pragma mark - 客户端围栏 实体管理 -delegate
/**
 创建客户端地理围栏的回调方法

 @param response 创建客户端围栏的结果
 */
-(void)onCreateLocalFence:(NSData *)response{
    [self sendEventWithEvent:_onCreateLocalFence data:response];
}

/**
 删除客户端地理围栏的回调方法

 @param response 创建客户端围栏的结果
 */
-(void)onDeleteLocalFence:(NSData *)response{
    [self sendEventWithEvent:_onDeleteLocalFence data:response];
}

/**
 更新客户端地理围栏的回调方法

 @param response 创建客户端围栏的结果
 */
-(void)onUpdateLocalFence:(NSData *)response{
    [self sendEventWithEvent:_onUpdateLocalFence data:response];
}

/**
 查询客户端地理围栏的回调方法

 @param response 创建客户端围栏的结果
 */
-(void)onQueryLocalFence:(NSData *)response{
    [self sendEventWithEvent:_onQueryLocalFence data:response];
}


#pragma mark - 客户端围栏 状态与报警查询

/**
 查询监控对象和客户端地理围栏的位置关系的回调方法

 @param response 查询结果
 */
-(void)onQueryLocalFenceStatus:(NSData *)response{
    [self sendEventWithEvent:_onQueryLocalFenceStatus data:response];
}

/**
 根据自定义位置，查询监控对象和客户端地理围栏的位置关系的回调方法

 @param response 查询结果
 */
-(void)onQueryLocalFenceStatusByCustomLocation:(NSData *)response{
    [self sendEventWithEvent:_onQueryLocalFenceStatusByCustomLocation data:response];
}

/**
 查询客户端地理围栏历史报警信息的回调方法

 @param response 查询结果
 */
-(void)onQueryLocalFenceHistoryAlarm:(NSData *)response{
    [self sendEventWithEvent:_onQueryLocalFenceHistoryAlarm data:response];
}


#pragma mark - 服务端围栏 实体管理
/**
 创建服务端地理围栏的回调方法

 @param response 创建服务端围栏的结果
 */
-(void)onCreateServerFence:(NSData *)response{
    [self sendEventWithEvent:_onCreateServerFence data:response];
}

/**
 删除服务端地理围栏的回调方法

 @param response 删除服务端围栏的结果
 */
-(void)onDeleteServerFence:(NSData *)response{
    [self sendEventWithEvent:_onDeleteServerFence data:response];
}

/**
 修改服务端地理围栏的回调方法

 @param response 修改服务端围栏的结果
 */
-(void)onUpdateServerFence:(NSData *)response{
    [self sendEventWithEvent:_onUpdateServerFence data:response];
}

/**
 查询服务端地理围栏的回调方法

 @param response 查询服务端围栏的结果
 */
-(void)onQueryServerFence:(NSData *)response{
    [self sendEventWithEvent:_onQueryServerFence data:response];
}


#pragma mark - 服务端围栏 状态与报警查询
/**
 查询监控对象在服务端地理围栏内外的回调方法

 @param response 查询结果
 */
-(void)onQueryServerFenceStatus:(NSData *)response{
    [self sendEventWithEvent:_onQueryServerFenceStatus data:response];
}

/**
 根据指定的位置查询被监控对象的状态的回调方法

 @param response 查询结果
 */
-(void)onQueryServerFenceStatusByCustomLocation:(NSData *)response{
    [self sendEventWithEvent:_onQueryServerFenceStatusByCustomLocation data:response];
}

/**
 查询监控对象的服务端围栏报警信息的回调方法

 @param response 查询结果
 */
-(void)onQueryServerFenceHistoryAlarm:(NSData *)response{
    [self sendEventWithEvent:_onQueryServerFenceHistoryAlarm data:response];
}

/**
 批量同步某service的服务端地理围栏报警信息的回调方法

 @param response 查询结果
 */
-(void)onBatchQueryServerFenceHistoryAlarm:(NSData *)response{
    [self sendEventWithEvent:_onBatchQueryServerFenceHistoryAlarm data:response];
}

#pragma mark - 服务端围栏 监控对象管理
/**
 给服务端围栏添加监控对象的回调方法
 
 @param response 查询结果
 */
-(void)onAddMonitoredObject:(NSData *)response{
    [self sendEventWithEvent:_onAddMonitoredObject data:response];
}

/**
 删除服务端围栏的监控对象的回调方法
 
 @param response 查询结果
 */
-(void)onDeleteMonitoredObject:(NSData *)response{
    [self sendEventWithEvent:_onDeleteMonitoredObject data:response];
}

/**
 查询服务端围栏的监控对象的回调方法
 
 @param response 查询结果
 */
-(void)onListMonitoredObject:(NSData *)response{
    [self sendEventWithEvent:_onListMonitoredObject data:response];
}
#pragma mark - - -
#pragma mark - 轨迹分析delegete
/**
停留点分析的回调方法

@param response 停留点分析的结果
*/
- (void)onAnalyzeStayPoint:(NSData *)response{
    [self sendEventWithEvent:_onAnalyzeStayPoint data:response];
}

#pragma mark - entity代理协议，entity相关操作的执行结果，通过本协议中的方法回调
/**
 创建Entity终端实体的回调方法

 @param response 创建结果
 */
-(void)onAddEntity:(NSData *)response{
    [self sendEventWithEvent:_onAddEntity data:response];
}

/**
 删除Entity终端实体的回调方法

 @param response 删除结果
 */
-(void)onDeleteEntity:(NSData *)response{
    [self sendEventWithEvent:_onDeleteEntity data:response];
}

/**
 更新Entity终端实体的回调方法

 @param response 更新结果
 */
-(void)onUpdateEntity:(NSData *)response{
    [self sendEventWithEvent:_onUpdateEntity data:response];
}

/**
 查询Entity终端实体的回调方法

 @param response 查询结果
 */
-(void)onQueryEntity:(NSData *)response{
    [self sendEventWithEvent:_onQueryEntity data:response];
}

#pragma mark - entity终端检索 

/**
 关键字检索Entity终端实体的回调方法

 @param response 检索结果
 */
-(void)onEntitySearch:(NSData *)response{
    [self sendEventWithEvent:_onEntitySearch data:response];
}

/**
 矩形区域检索Entity终端实体的回调方法

 @param response 检索结果
 */
-(void)onEntityBoundSearch:(NSData *)response{
    [self sendEventWithEvent:_onEntityBoundSearch data:response];
}

/**
 圆形区域检索Entity终端实体的回调方法

 @param response 检索结果
 */
-(void)onEntityAroundSearch:(NSData *)response{
    [self sendEventWithEvent:_onEntityAroundSearch data:response];
}

/**
 多边形区域检索Entity终端实体的回调方法

 @param response 检索结果
 */
-(void)onEntityPolygonSearch:(NSData *)response{
    [self sendEventWithEvent:_onEntityPolygonSearch data:response];
}

/**
 行政区域内检索Entity终端实体的回调方法

 @param response 检索结果
 */
-(void)onEntityDistrictSearch:(NSData *)response{
    [self sendEventWithEvent:_onEntityDistrictSearch data:response];
}
#pragma mark - 驾驶行为分析的回调方法
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
    return @[_onStartServer,_onStopService,_onStartGather,_onStopGather,_onGetCustomDataResult,_onChangeGatherAndPackIntervals,_onSetCacheMaxSize,_onGetPushMessage,_onAnalyzeStayPoint,_onAnalyzeStayPoint,_onQueryTrackDistance,_onEntityDistrictSearch,_onEntityPolygonSearch,_onEntityAroundSearch,_onEntityBoundSearch,_onEntitySearch,_onQueryEntity,_onUpdateEntity,_onDeleteEntity,_onAddEntity,_onListMonitoredObject,_onDeleteMonitoredObject,_onAddMonitoredObject,_onBatchQueryServerFenceHistoryAlarm,_onQueryServerFenceHistoryAlarm,_onQueryServerFenceStatusByCustomLocation,_onQueryServerFenceStatus,_onQueryServerFence,_onUpdateServerFence,_onDeleteServerFence,_onCreateServerFence,_onQueryLocalFenceHistoryAlarm,_onQueryLocalFenceStatusByCustomLocation,_onQueryLocalFenceStatus,_onQueryLocalFence,_onUpdateLocalFence,_onDeleteLocalFence,_onCreateLocalFence,_onClearTrackCache,_onQueryTrackCacheInfo,_onQueryHistoryTrack];
}
@end
  
