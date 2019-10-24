//
//  BTKTypes.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年02月27日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#ifndef BTKTypes_h
#define BTKTypes_h

#import <Foundation/Foundation.h>

/**
 轨迹服务相关操作执行结果的错误码

 - BTK_START_SERVICE_SUCCESS: 服务开启成功，并与服务端连接成功
 - BTK_START_SERVICE_SUCCESS_BUT_OFFLINE: 服务开启成功，但与服务端连接失败，SDK会尝试重连
 - BTK_START_SERVICE_PARAM_ERROR: 参数错误
 - BTK_START_SERVICE_INTERNAL_ERROR: 内部错误
 - BTK_START_SERVICE_NETWORK_ERROR: 网络异常
 - BTK_START_SERVICE_AUTH_ERROR: 鉴权不通过导致失败(ak mcode等信息错误)
 - BTK_START_SERVICE_IN_PROGRESS: 正在开启服务
 - BTK_SERVICE_ALREADY_STARTED_ERROR: 已经开启服务，请勿重复开启
 - BTK_STOP_SERVICE_NO_ERROR: 停止服务成功
 - BTK_STOP_SERVICE_NOT_YET_STARTED_ERROR: 服务还未开启，无法停止
 - BTK_STOP_SERVICE_IN_PROGRESS: 正在停止服务
 - BTK_START_SERVICE_SUCCESS_BUT_NO_AUTH_TO_KEEP_ALIVE: 服务开启成功，但是由于没有定位权限，所以无法保活
 */
typedef NS_ENUM(NSUInteger, BTKServiceErrorCode) {
    BTK_START_SERVICE_SUCCESS,
    BTK_START_SERVICE_SUCCESS_BUT_OFFLINE,
    BTK_START_SERVICE_PARAM_ERROR,
    BTK_START_SERVICE_INTERNAL_ERROR,
    BTK_START_SERVICE_NETWORK_ERROR,
    BTK_START_SERVICE_AUTH_ERROR,
    BTK_START_SERVICE_IN_PROGRESS,
    BTK_SERVICE_ALREADY_STARTED_ERROR,
    BTK_STOP_SERVICE_NO_ERROR,
    BTK_STOP_SERVICE_NOT_YET_STARTED_ERROR,
    BTK_STOP_SERVICE_IN_PROGRESS,
    BTK_START_SERVICE_SUCCESS_BUT_NO_AUTH_TO_KEEP_ALIVE,
};


/**
 采集相关操作执行结果的错误码

 - BTK_START_GATHER_SUCCESS: 开始采集成功
 - BTK_GATHER_ALREADY_STARTED_ERROR: 已经在采集，请勿重复开始
 - BTK_START_GATHER_BEFORE_START_SERVICE_ERROR: 开始采集必须在开始服务之后调用
 - BTK_START_GATHER_LOCATION_SERVICE_OFF_ERROR: 开始采集由于系统定位服务未开启而失败
 - BTK_START_GATHER_LOCATION_ALWAYS_USAGE_AUTH_ERROR: 开始采集由于没有后台定位权限而失败
 - BTK_START_GATHER_INTERNAL_ERROR: 开始采集由于内部错误而失败
 - BTK_STOP_GATHER_NO_ERROR: 停止采集成功
 - BTK_STOP_GATHER_NOT_YET_STARTED_ERROR: 停止采集必须在开始采集之后调用
 */
typedef NS_ENUM(NSUInteger, BTKGatherErrorCode) {
    BTK_START_GATHER_SUCCESS,
    BTK_GATHER_ALREADY_STARTED_ERROR,
    BTK_START_GATHER_BEFORE_START_SERVICE_ERROR,
    BTK_START_GATHER_LOCATION_SERVICE_OFF_ERROR,
    BTK_START_GATHER_LOCATION_ALWAYS_USAGE_AUTH_ERROR,
    BTK_START_GATHER_INTERNAL_ERROR,
    BTK_STOP_GATHER_NO_ERROR,
    BTK_STOP_GATHER_NOT_YET_STARTED_ERROR,
};


/**
 被监控对象和地理围栏的位置关系

 - BTK_FENCE_MONITORED_OBJECT_STATUS_TYPE_IN: 被监控对象在地理围栏内部
 - BTK_FENCE_MONITORED_OBJECT_STATUS_TYPE_OUT: 被监控对象在地理围栏外部
 - BTK_FENCE_MONITORED_OBJECT_STATUS_TYPE_UNKNOWN: 被监控对象和地理围栏的位置关系未知
 */
typedef NS_ENUM(NSUInteger, BTKFenceMonitoredObjectStatus) {
    BTK_FENCE_MONITORED_OBJECT_STATUS_TYPE_IN,
    BTK_FENCE_MONITORED_OBJECT_STATUS_TYPE_OUT,
    BTK_FENCE_MONITORED_OBJECT_STATUS_TYPE_UNKNOWN,
};

/**
 被监控对象相对于地理围栏的动作
 
 - BTK_FENCE_MONITORED_OBJECT_ACTION_TYPE_ENTER: 被监控对象进入围栏
 - BTK_FENCE_MONITORED_OBJECT_ACTION_TYPE_EXIT: 被监控对象离开围栏
*/
typedef NS_ENUM(NSUInteger, BTKFenceMonitoredObjectActionType) {
    BTK_FENCE_MONITORED_OBJECT_ACTION_TYPE_ENTER = 1,
    BTK_FENCE_MONITORED_OBJECT_ACTION_TYPE_EXIT = 2,
};

/**
 地理围栏相关操作的执行结果错误码

 - BTK_FENCE_ACTION_SUCCESS: 成功
 - BTK_FENCE_ACTION_INTERNAL_ERROR: 内部错误
 - BTK_FENCE_ACTION_PARAM_ERROR: 参数错误
 */
typedef NS_ENUM(NSUInteger, BTKFenceErrorCode) {
    BTK_FENCE_ACTION_SUCCESS,
    BTK_FENCE_ACTION_INTERNAL_ERROR,
    BTK_FENCE_ACTION_PARAM_ERROR,
};

/**
 track相关操作的执行结果错误码

 - BTK_TRACK_ACTION_SUCCESS: 成功
 - BTK_TRACK_ACTION_INTERNAL_ERROR: 内部错误
 - BTK_TRACK_ACTION_PARAM_ERROR: 参数错误
 */
typedef NS_ENUM(NSUInteger, BTKTrackErrorCode) {
    BTK_TRACK_ACTION_SUCCESS,
    BTK_TRACK_ACTION_INTERNAL_ERROR,
    BTK_TRACK_ACTION_PARAM_ERROR,
};

/**
 entity相关操作的执行结果错误码

 - BTK_ENTITY_ACTION_SUCCESS: 成功
 - BTK_ENTITY_ACTION_INTERNAL_ERROR: 内部错误
 - BTK_ENTITY_ACTION_PARAM_ERROR: 参数错误
 */
typedef NS_ENUM(NSUInteger, BTKEntityErrorCode) {
    BTK_ENTITY_ACTION_SUCCESS,
    BTK_ENTITY_ACTION_INTERNAL_ERROR,
    BTK_ENTITY_ACTION_PARAM_ERROR,
};

/**
 analysis相关操作的执行结果错误码
 
 - BTK_ANALYSIS_ACTION_SUCCESS: 成功
 - BTK_ANALYSIS_ACTION_INTERNAL_ERROR: 内部错误
 - BTK_ANALYSIS_ACTION_PARAM_ERROR: 参数错误
 */
typedef NS_ENUM(NSUInteger, BTKAnalysisErrorCode) {
    BTK_ANALYSIS_ACTION_SUCCESS,
    BTK_ANALYSIS_ACTION_INTERNAL_ERROR,
    BTK_ANALYSIS_ACTION_PARAM_ERROR,
};

/**
 地理围栏实体的形状

 - BTK_FENCE_ENTITY_SHAPE_TYPE_CIRCLE: 圆形地理围栏
 - BTK_FENCE_ENTITY_SHAPE_TYPE_POLYGON: 多边形地理围栏
 - BTK_FENCE_ENTITY_SHAPE_TYPE_POLYLINE: 线形地理围栏
 */
typedef NS_ENUM(NSUInteger, BTKFenceEntityShapeType) {
    BTK_FENCE_ENTITY_SHAPE_TYPE_CIRCLE,
    BTK_FENCE_ENTITY_SHAPE_TYPE_POLYGON,
    BTK_FENCE_ENTITY_SHAPE_TYPE_POLYLINE,
};

/**
 查询纠偏后的实时位置时，指定被监控对象的交通方式

 - BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_DRIVING: 自动（由鹰眼自动识别交通方式）
 - BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_DRIVING: 驾车
 - BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_RIDING: 骑行
 - BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_WALKING: 步行
 */
typedef NS_ENUM(NSUInteger, BTKTrackProcessOptionTransportMode) {
    BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_AUTO = 0,
    BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_DRIVING = 1,
    BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_RIDING = 2,
    BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_WALKING = 3,
};

/**
 查询里程时中断轨迹的里程补偿方式
 在里程计算时，两个轨迹点定位时间间隔5分钟以上，被认为是中断。中断轨迹提供以下5种里程补偿方式。

 - BTK_TRACK_PROCESS_OPTION_NO_SUPPLEMENT: 不补充，中断两点间距离不记入里程
 - BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_STRAIGHT: 使用直线距离补充
 - BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_DRIVING: 使用最短驾车路线距离补充
 - BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_RIDING: 使用最短骑行路线距离补充
 - BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_WALKING: 使用最短步行路线距离补充
 */
typedef NS_ENUM(NSUInteger, BTKTrackProcessOptionSupplementMode) {
    BTK_TRACK_PROCESS_OPTION_NO_SUPPLEMENT = 1,
    BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_STRAIGHT = 2,
    BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_DRIVING = 3,
    BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_RIDING = 4,
    BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_WALKING = 5,
};

/**
 查询指定时间段内的轨迹时返回的轨迹点的时间顺序

 - BTK_TRACK_SORT_TYPE_ASC: 按定位时间升序排序（旧->新）
 - BTK_TRACK_SORT_TYPE_DESC: 按定位时间降序排序（新->旧）
 */
typedef NS_ENUM(NSUInteger, BTKTrackSortType) {
    BTK_TRACK_SORT_TYPE_ASC = 1,
    BTK_TRACK_SORT_TYPE_DESC = 2,
};

/**
 检索entity时返回结果中指定字段的排序规则

 - BTK_ENTITY_SORT_TYPE_ASC: 升序
 - BTK_ENTITY_SORT_TYPE_DESC: 降序
 */
typedef NS_ENUM(NSUInteger, BTKEntitySortType) {
    BTK_ENTITY_SORT_TYPE_ASC = 1,
    BTK_ENTITY_SORT_TYPE_DESC = 2,
};

/**
 检索entity时返回结果的内容

 - BTK_ENTITY_SEARCH_RESULT_TYPE_SIMPLE: 只返回符合检索条件的Entity终端数量
 - BTK_ENTITY_SEARCH_RESULT_TYPE_ALL: 返回符合检索条件的Entity终端详细信息
 */
typedef NS_ENUM(NSUInteger, BTKEntitySearchResultType) {
    BTK_ENTITY_SEARCH_RESULT_TYPE_SIMPLE = 1,
    BTK_ENTITY_SEARCH_RESULT_TYPE_ALL,
};

/**
 改变采集和打包间隔的执行结果的错误码

 - BTK_CHANGE_INTERVAL_NO_ERROR: 成功
 - BTK_CHANGE_INTERVAL_PARAM_ERROR: 参数错误
 */
typedef NS_ENUM(NSUInteger, BTKChangeIntervalErrorCode) {
    BTK_CHANGE_INTERVAL_NO_ERROR,
    BTK_CHANGE_INTERVAL_PARAM_ERROR,
};

/**
 开发者给每个轨迹点设置自定义数据的错误码

 - BTK_CUSTOM_DATA_NO_ERROR: 成功
 - BTK_CUSTOM_DATA_KEY_TYPE_ERROR: key类型错误，key必须是NSString类型
 - BTK_CUSTOM_DATA_VALUE_TYPE_ERROR: value类型错误，value必须是NSNumber或NSString
 - BTK_CUSTOM_DATA_TOO_LONG: 自定义数据总的字节数超过限制（1024字节）
 */
typedef NS_ENUM(NSUInteger, BTKGetCustomDataErrorCode) {
    BTK_CUSTOM_DATA_NO_ERROR,
    BTK_CUSTOM_DATA_KEY_TYPE_ERROR,
    BTK_CUSTOM_DATA_VALUE_TYPE_ERROR,
    BTK_CUSTOM_DATA_TOO_LONG,
};

/**
 设置缓存占用的最大磁盘空间的执行结果的错误码

 - BTK_CACHE_MAX_SIZE_NO_ERROR: 成功
 - BTK_SET_CACHE_MAX_SIZE_INTERNAL_ERROR: 服务内部错误
 - BTK_CACHE_MAX_SIZE_PARAM_ERROR: 参数错误
 */
typedef NS_ENUM(NSUInteger, BTKSetCacheMaxSizeErrorCode) {
    BTK_SET_CACHE_MAX_SIZE_NO_ERROR,
    BTK_SET_CACHE_MAX_SIZE_INTERNAL_ERROR,
    BTK_SET_CACHE_MAX_SIZE_PARAM_ERROR,
};

/**
 坐标类型

 - BTK_COORDTYPE_WGS84: WGS84：为一种大地坐标系，也是目前广泛使用的GPS全球卫星定位系统使用的坐标系
 - BTK_COORDTYPE_GCJ02: GCJ02：表示经过国测局加密的坐标
 - BTK_COORDTYPE_BD09LL: 百度经纬度坐标系
 */
typedef NS_ENUM(UInt8, BTKCoordType) {
    BTK_COORDTYPE_WGS84 = 1,
    BTK_COORDTYPE_GCJ02 = 2,
    BTK_COORDTYPE_BD09LL = 3,
};

#endif /* BTKTypes_h */
