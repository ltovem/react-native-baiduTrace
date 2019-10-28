import {
    DeviceEventEmitter,
    NativeModules,
    Platform
} from 'react-native'

const listeners = {}


const onBindService = "onBindService";
const onHistoryTrack = "onHistoryTrack"; //查询历史轨迹回调

const onStartServer = "onStartService"; // 开启轨迹服务的回调方法
const onStopService = "onStopService"; // 停止轨迹服务的回调方法
const onStartGather = "onStartGather";// 开始采集的回调方法
const onStopGather = "onStopGather";// 停止采集的回调方法
const onGetPushMessage = "onGetPushMessage"; //收到推送消息的回调方法
const onGetCustomDataResult = "onGetCustomDataResult"; // 用户自定义信息设置结果的回调方法
const onChangeGatherAndPackIntervals = "onChangeGatherAndPackIntervals"; //更改采集和打包上传周期的结果的回调方法
const onSetCacheMaxSize = "onSetCacheMaxSize";// 设置缓存占用的最大磁盘空间的结果的回调方法
const onRequestAlwaysLocationAuthorization = "onRequestAlwaysLocationAuthorization"; //请求后台定位权限的回调方法

const onQueryTrackDistance = "onQueryTrackDistance"//里程计算
const onAnalyzeDrivingBehaviour = "onAnalyzeDrivingBehaviour";// 驾驶行为分析
const onAnalyzeStayPoint = "onAnalyzeStayPoint" //停留点分析

export const RNBaiduTrace = NativeModules.RNBaiduTrace
/**
 * /**
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
const BTKServiceErrorCode = {
    BTK_START_SERVICE_SUCCESS : 0,
    BTK_START_SERVICE_SUCCESS_BUT_OFFLINE : 1,
    BTK_START_SERVICE_PARAM_ERROR : 2,
    BTK_START_SERVICE_INTERNAL_ERROR : 3,
    BTK_START_SERVICE_NETWORK_ERROR : 4,
    BTK_START_SERVICE_AUTH_ERROR : 5,
    BTK_START_SERVICE_IN_PROGRESS : 6,
    BTK_SERVICE_ALREADY_STARTED_ERROR : 7,
    BTK_STOP_SERVICE_NO_ERROR : 8,
    BTK_STOP_SERVICE_NOT_YET_STARTED_ERROR : 9,
    BTK_STOP_SERVICE_IN_PROGRESS : 10,
    BTK_START_SERVICE_SUCCESS_BUT_NO_AUTH_TO_KEEP_ALIVE : 11,
}
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
const BTKGatherErrorCode = {
    BTK_START_GATHER_SUCCESS : 0,
    BTK_GATHER_ALREADY_STARTED_ERROR : 1,
    BTK_START_GATHER_BEFORE_START_SERVICE_ERROR : 2,
    BTK_START_GATHER_LOCATION_SERVICE_OFF_ERROR : 3,
    BTK_START_GATHER_LOCATION_ALWAYS_USAGE_AUTH_ERROR : 4,
    BTK_START_GATHER_INTERNAL_ERROR : 5,
    BTK_STOP_GATHER_NO_ERROR : 6,
    BTK_STOP_GATHER_NOT_YET_STARTED_ERROR : 7,
};
/**
 开发者给每个轨迹点设置自定义数据的错误码

 - BTK_CUSTOM_DATA_NO_ERROR: 成功
 - BTK_CUSTOM_DATA_KEY_TYPE_ERROR: key类型错误，key必须是NSString类型
 - BTK_CUSTOM_DATA_VALUE_TYPE_ERROR: value类型错误，value必须是NSNumber或NSString
 - BTK_CUSTOM_DATA_TOO_LONG: 自定义数据总的字节数超过限制（1024字节）
 */
const BTKGetCustomDataErrorCode = {
    BTK_CUSTOM_DATA_NO_ERROR : 0,
    BTK_CUSTOM_DATA_KEY_TYPE_ERROR : 1,
    BTK_CUSTOM_DATA_VALUE_TYPE_ERROR : 2,
    BTK_CUSTOM_DATA_TOO_LONG : 3,
};
/**
 改变采集和打包间隔的执行结果的错误码

 - BTK_CHANGE_INTERVAL_NO_ERROR: 成功
 - BTK_CHANGE_INTERVAL_PARAM_ERROR: 参数错误
 */
const BTKChangeIntervalErrorCode = {
    BTK_CHANGE_INTERVAL_NO_ERROR : 0,
    BTK_CHANGE_INTERVAL_PARAM_ERROR : 1,
};
/**
 设置缓存占用的最大磁盘空间的执行结果的错误码

 - BTK_CACHE_MAX_SIZE_NO_ERROR: 成功
 - BTK_SET_CACHE_MAX_SIZE_INTERNAL_ERROR: 服务内部错误
 - BTK_CACHE_MAX_SIZE_PARAM_ERROR: 参数错误
 */
const BTKSetCacheMaxSizeErrorCode = {
    BTK_SET_CACHE_MAX_SIZE_NO_ERROR : 0,
    BTK_SET_CACHE_MAX_SIZE_INTERNAL_ERROR : 1,
    BTK_SET_CACHE_MAX_SIZE_PARAM_ERROR : 2,
};
/**
 查询纠偏后的实时位置时，指定被监控对象的交通方式

 - BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_DRIVING: 自动（由鹰眼自动识别交通方式）
 - BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_DRIVING: 驾车
 - BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_RIDING: 骑行
 - BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_WALKING: 步行
 */
const BTKTrackProcessOptionTransportMode = {
    BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_AUTO : 0,
    BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_DRIVING : 1,
    BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_RIDING : 2,
    BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_WALKING : 3,
};
/**
 坐标类型

 - BTK_COORDTYPE_WGS84: WGS84：为一种大地坐标系，也是目前广泛使用的GPS全球卫星定位系统使用的坐标系
 - BTK_COORDTYPE_GCJ02: GCJ02：表示经过国测局加密的坐标
 - BTK_COORDTYPE_BD09LL: 百度经纬度坐标系
 */
const BTKCoordType = {
    BTK_COORDTYPE_WGS84 : 1,
    BTK_COORDTYPE_GCJ02 : 2,
    BTK_COORDTYPE_BD09LL : 3,
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
const BTKTrackProcessOptionSupplementMode = {
    BTK_TRACK_PROCESS_OPTION_NO_SUPPLEMENT : 1,
    BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_STRAIGHT : 2,
    BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_DRIVING : 3,
    BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_RIDING : 4,
    BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_WALKING : 5,
};
export default class BaiduTrace {

    /**
     * 初始化百度鹰眼轨迹服务
     * @param serviceId  // 轨迹服务ID number
     * @param entityName  // 设备标识 string
     * @param isNeedObjectStorageOrIOSKeepAlive bool   Android:// 是否需要对象存储服务，默认为：false，关闭对象存储服务。
     *                                          注：鹰眼 Android SDK v3.0以上版本支持随轨迹上传图像等对象数据，
     *                                          若需使用此功能，该参数需设为 true，且需导入bos-android-sdk-1.0.2.jar。
     *                                          iOS :同 keepAlive:false  后台保活参数
     * @param bundleId  //iOS only  require string
     * @param ak  //iOS only require string

     */
    static initBaiduTrace(serviceId, entityName, isNeedObjectStorageOrIOSKeepAlive = false, bundleId = "", ak = "") {
        if (Platform.OS === "android") {
            RNBaiduTrace.initBaiduTrace(serviceId, entityName, isNeedObjectStorageOrIOSKeepAlive)
        } else {
            RNBaiduTrace.initBaiduTrace(serviceId,ak,entityName,bundleId, isNeedObjectStorageOrIOSKeepAlive)
        }
    }

    /**
     * 设置定位和打包周期
     * @param gatherInterval // 定位周期(单位:秒)
     * @param packInterval  // 打包回传周期(单位:秒)
     */
    static setBaiduTraceInterval(gatherInterval, packInterval) {
        RNBaiduTrace.setBaiduTraceInterval(gatherInterval, packInterval)
    }

    /**
     * 开启鹰眼服务，启动鹰眼service
     */
    static startBaiduTrace() {
        RNBaiduTrace.startBaiduTrace()
    }

    /**
     * 停止鹰眼服务
     *  停止轨迹服务：此方法将同时停止轨迹服务和轨迹采集，完全结束鹰眼轨迹服务。若需再次启动轨迹追踪，需重新启动服务和轨迹采集
     */
    static stopBaiduTrace() {
        RNBaiduTrace.stopBaiduTrace()
    }

    /**
     * 开启采集
     *  注意：因为startTrace与startGather是异步执行，且startGather依赖startTrace执行开启服务成功，
     *  所以建议startGather在public void onStartTraceCallback(int errorNo, String message)回调返回错误码为0后，
     *  再进行调用执行，否则会出现服务开启失败12002的错误。
     */
    static startBaiduTraceGather() {
        RNBaiduTrace.startBaiduTraceGather()
    }

    /**
     * 停止采集
     *  停止轨迹服务：此方法将同时停止轨迹服务和轨迹采集，完全结束鹰眼轨迹服务。若需再次启动轨迹追踪，需重新启动服务和轨迹采集
     */
    static stopBaiduTraceGather() {
        RNBaiduTrace.stopBaiduTraceGather()
    }



    /**
     * 查询历史轨迹
     *
     * @param tag        //int 请求标识 1    //是否返回精简的结果（0 : 将只返回经纬度，1 : 将返回经纬度及其他属性信息）
     * @param serviceId  //int 轨迹服务ID
     * @param entityName // 设备标识
     * @param startTime  //  设置轨迹查询起止时间--开始时间(单位：秒)
     * @param endTime    // 设置轨迹查询起止时间--结束时间(单位：秒)
     */
    static getHistoryTrack(tag, serviceId, entityName, startTime, endTime) {
        RNBaiduTrace.getHistoryTrack(tag, serviceId, entityName, startTime, endTime)

    }

    /**
     里程计算
     @param entityName entity名称
     @param startTime 开始时间
     @param endTime 结束时间
     @param isProcessed 是否返回纠偏后的里程 default false
     @param processOption 纠偏选项 call getBTKQueryTrackProcessOption() or null
     @param supplementMode 里程补偿方式 BTKTrackProcessOptionSupplementMode require
     @param serviceID 轨迹服务的ID
     @param tag 请求标志
     */
    static queryTrackDistance(entityName,startTime,endTime,isProcessed = false,processOption,supplementMode,serviceID,tag){
        RNBaiduTrace.queryTrackDistance(entityName,startTime,endTime,isProcessed,processOption,supplementMode,serviceID,tag);
    }

    /**
     创建服务端圆形地理围栏
     @param latitude 圆心坐标
     @param longitude 圆心坐标
     @param radius 半径
     @param coordType 圆心的坐标类型 BTKCoordType
     @param denoiseAccuracy 去燥精度 单位：米。每个轨迹点都有一个定位误差半径radius，这个值越大，代表定位越不准确，可能是噪点。围栏计算时，如果噪点也参与计算，会造成误报的情况。设置denoiseAccuray可控制，当轨迹点的定位误差半径大于设置值时，就会把该轨迹点当做噪点，不参与围栏计算。如果不想去噪，设置为0即可。
     @param fenceName 围栏名称
     @param monitoredObject 围栏监控对象的名称
     @param serviceID 轨迹服务的ID
     @param tag 请求标志
     */
    static createServerCircleFence(latitude,longitude,radius,coordType,denoiseAccuracy,fenceName,monitoredObject,serviceID,tag){
        RNBaiduTrace.createServerCircleFence(latitude,longitude,radius,coordType,denoiseAccuracy,fenceName,monitoredObject,serviceID,tag);
    }

    /**
     创建服务端多边形围栏
     @param vertexes 多边形的顶点坐标数组，数组中每一项为 {"latitude":"36.6","longitude":"133.00"}类型
     @param coordType 顶点坐标的坐标类型 BTKCoordType
     @param denoiseAccuracy 去燥精度 单位：米。每个轨迹点都有一个定位误差半径radius，这个值越大，代表定位越不准确，可能是噪点。围栏计算时，如果噪点也参与计算，会造成误报的情况。设置denoiseAccuray可控制，当轨迹点的定位误差半径大于设置值时，就会把该轨迹点当做噪点，不参与围栏计算。如果不想去噪，设置为0即可。
     @param fenceName 地理围栏的名称
     @param monitoredObject 地理围栏监控对象的名称
     @param serviceID 轨迹服务的ID
     @param tag 请求标志
     */

    static createServerPolygonFence(vertexes,coordType,denoiseAccuracy,fenceName,monitoredObject,serviceID,tag){
        RNBaiduTrace.createServerPolygonFence(vertexes,coordType,denoiseAccuracy,fenceName,monitoredObject,serviceID,tag);
    }
    /**
     创建服务端多边形围栏
     @param vertexes 多边形的顶点坐标数组，数组中每一项为 {"latitude":"36.6","longitude":"133.00"}类型
     @param coordType 顶点坐标的坐标类型 BTKCoordType
     @param offset 偏离距离 偏移距离（若偏离折线距离超过该距离即报警），单位：米 示例：200
     @param denoiseAccuracy 去燥精度 单位：米。每个轨迹点都有一个定位误差半径radius，这个值越大，代表定位越不准确，可能是噪点。围栏计算时，如果噪点也参与计算，会造成误报的情况。设置denoiseAccuray可控制，当轨迹点的定位误差半径大于设置值时，就会把该轨迹点当做噪点，不参与围栏计算。如果不想去噪，设置为0即可。
     @param fenceName 地理围栏的名称
     @param monitoredObject 地理围栏监控对象的名称
     @param serviceID 轨迹服务的ID
     @param tag 请求标志
     */
    static createServerPolylineFence(vertexes,coordType,offset,denoiseAccuracy,fenceName,monitoredObject,serviceID,tag){
        RNBaiduTrace.createServerPolylineFence(vertexes,coordType,offset,denoiseAccuracy,fenceName,monitoredObject,serviceID,tag);
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
    static createServerDistrictFence(keyword,denoiseAccuracy,fenceName,monitoredObject,serviceID,tag){
        RNBaiduTrace.createServerDistrictFence(keyword,denoiseAccuracy,fenceName,monitoredObject,serviceID,tag);
    }

    /**
     构造方法，用于构造删除服务端地理围栏的请求对象

     @param monitoredObject 围栏的监控对象
     @param fenceIDs 围栏ID的数组，若为空，则删除监控对象上的所有地理围栏
     @param serviceID 轨迹服务ID
     @param tag 请求标志
     */
    static deleteServerFence(monitoredObject,fenceIDs,serviceID,tag){
        RNBaiduTrace.deleteServerFence(monitoredObject,fenceIDs,serviceID,tag);
    }
    /**
     更新服务端圆形地理围栏
     @param latitude 圆心坐标
     @param longitude 圆心坐标
     @param radius 半径
     @param coordType 圆心的坐标类型 BTKCoordType
     @param denoiseAccuracy 去燥精度 单位：米。每个轨迹点都有一个定位误差半径radius，这个值越大，代表定位越不准确，可能是噪点。围栏计算时，如果噪点也参与计算，会造成误报的情况。设置denoiseAccuray可控制，当轨迹点的定位误差半径大于设置值时，就会把该轨迹点当做噪点，不参与围栏计算。如果不想去噪，设置为0即可。
     @param fenceName 围栏名称
     @param monitoredObject 围栏监控对象的名称
     @param fenceID 要更新的地理围栏ID
     @param serviceID 轨迹服务的ID
     @param tag 请求标志
     */
    static updateServerCircleFence(latitude,longitude,radius,coordType,denoiseAccuracy,fenceName,monitoredObject,fenceID,serviceID,tag){
        RNBaiduTrace.updateServerCircleFence(latitude,longitude,radius,coordType,denoiseAccuracy,fenceName,monitoredObject,fenceID,serviceID,tag);
    }

    /**
     更新服务端多边形围栏
     @param vertexes 多边形的顶点坐标数组，数组中每一项为 {"latitude":"36.6","longitude":"133.00"}类型
     @param coordType 顶点坐标的坐标类型 BTKCoordType
     @param denoiseAccuracy 去燥精度 单位：米。每个轨迹点都有一个定位误差半径radius，这个值越大，代表定位越不准确，可能是噪点。围栏计算时，如果噪点也参与计算，会造成误报的情况。设置denoiseAccuray可控制，当轨迹点的定位误差半径大于设置值时，就会把该轨迹点当做噪点，不参与围栏计算。如果不想去噪，设置为0即可。
     @param fenceName 地理围栏的名称
     @param monitoredObject 地理围栏监控对象的名称
     @param fenceID 要更新的地理围栏ID
     @param serviceID 轨迹服务的ID
     @param tag 请求标志
     */

    static updateServerPolygonFence(vertexes,coordType,denoiseAccuracy,fenceName,monitoredObject,fenceID,serviceID,tag){
        RNBaiduTrace.updateServerPolygonFence(vertexes,coordType,denoiseAccuracy,fenceName,monitoredObject,fenceID,serviceID,tag);
    }
    /**
     更新服务端多边形围栏
     @param vertexes 多边形的顶点坐标数组，数组中每一项为 {"latitude":"36.6","longitude":"133.00"}类型
     @param coordType 顶点坐标的坐标类型 BTKCoordType
     @param offset 偏离距离 偏移距离（若偏离折线距离超过该距离即报警），单位：米 示例：200
     @param denoiseAccuracy 去燥精度 单位：米。每个轨迹点都有一个定位误差半径radius，这个值越大，代表定位越不准确，可能是噪点。围栏计算时，如果噪点也参与计算，会造成误报的情况。设置denoiseAccuray可控制，当轨迹点的定位误差半径大于设置值时，就会把该轨迹点当做噪点，不参与围栏计算。如果不想去噪，设置为0即可。
     @param fenceName 地理围栏的名称
     @param monitoredObject 地理围栏监控对象的名称
     @param fenceID 要更新的地理围栏ID
     @param serviceID 轨迹服务的ID
     @param tag 请求标志
     */
    static updateServerPolylineFence(vertexes,coordType,offset,denoiseAccuracy,fenceName,monitoredObject,fenceID,serviceID,tag){
        RNBaiduTrace.updateServerPolylineFence(vertexes,coordType,offset,denoiseAccuracy,fenceName,monitoredObject,fenceID,serviceID,tag);
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
    static updateServerDistrictFence(keyword,denoiseAccuracy,fenceName,monitoredObject,fenceID,serviceID,tag){
        RNBaiduTrace.updateServerDistrictFence(keyword,denoiseAccuracy,fenceName,monitoredObject,fenceID,serviceID,tag);
    }

    /**
     服务端围栏查询
     @param monitoredObject 围栏监控的对象的entity_name
     @param fenceIDs 要查询的地理围栏ID列表，若为空，则查询监控对象上的所有地理围栏
     @param outputCoordType 输出坐标类型，BTKCoordType 只能选择百度经纬度或者国测局经纬度，在国内（包括港、澳、台）以外区域，无论设置何种坐标系，均返回 wgs84坐标
     @param serviceID 轨迹服务ID
     @param tag 请求标志
     */
    static queryServerFence(monitoredObject,fenceIDs,outputCoordType,serviceID,tag){
        RNBaiduTrace.queryServerFence(monitoredObject,fenceIDs,outputCoordType,serviceID,tag);
    }

    /**
     查询终端实体“entityA” 和所有监控该终端实体的服务端地理围栏的位置关系
     @param monitoredObject 监控对象的名称
     @param fenceIDs 围栏实体的ID列表 null 所有围栏
     @param serviceID 轨迹服务的ID
     @param tag 请求标志
     */
    static queryServerFenceStatus(monitoredObject,fenceIDs = null,serviceID,tag){
        RNBaiduTrace.queryServerFenceStatus(monitoredObject,fenceIDs = null,serviceID,tag);
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
    static queryServerFenceStatusByCustomLocation(monitoredObject,latitude,longitude,coordType,fenceIDs,tag){
        RNBaiduTrace.queryServerFenceStatusByCustomLocation(monitoredObject,latitude,longitude,coordType,fenceIDs,tag);
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
    static queryServerFenceHistoryAlarm(monitoredObject,fenceIDs,startTime,endTime,outputCoordType,serviceID,tag){
        RNBaiduTrace.queryServerFenceHistoryAlarm(monitoredObject,fenceIDs,startTime,endTime,outputCoordType,serviceID,tag);
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
    static batchQueryServerFenceHistoryAlarm(startTime,endTime,outputCoordType,pageIndex,pageSize,serviceID,tag){
        RNBaiduTrace.batchQueryServerFenceHistoryAlarm(startTime,endTime,outputCoordType,pageIndex,pageSize,serviceID,tag);
    }

    /**
     查询“entityA”这个终端实体上的所有客户端地理围栏，。
     @param monitoredObject 被监控对象的名称
     @param fenceIDs 地理围栏实体的ID列表
     @param startTime 时间段起点
     @param endTime 时间段终点
     @param tag 请求标志
     */
    static queryLocalFenceHistoryAlarm(monitoredObject,fenceIDs,startTime,endTime,tag){
        RNBaiduTrace.queryLocalFenceHistoryAlarm(monitoredObject,fenceIDs,startTime,endTime,tag);
    }
    /**
     停留点分析
     @param entityName 要查询的entity终端实体的名称
     @param startTime 开始时间 时间戳
     @param endTime 结束时间 时间戳
     @param stayTime 停留时间 s
     @param stayRadius 停留半径 单位米
     @param processOption 纠偏选项 call getBTKQueryTrackProcessOption() or null
     @param outputCoordType 返回的坐标类型 BTKCoordType
     @param serviceID 轨迹服务的ID
     @param tag 请求标志
     @return 请求对象
     */
    static analyzeStayPoint(entityName,startTime,endTime,stayTime,stayRadius,processOption,outputCoordType,serviceID,tag){
        RNBaiduTrace.analyzeStayPoint(entityName,startTime,endTime,stayTime,stayRadius,processOption,outputCoordType,serviceID,tag);
    }
    /**
     驾驶行为分析
     @param entityName 要查询的entity终端实体的名称
     @param startTime 开始时间 时间戳
     @param endTime 结束时间 时间戳
     @param thresholdOption 阈值选项 call getBTKDrivingBehaviorThresholdOption() or null
     @param processOption 纠偏选项 call getBTKQueryTrackProcessOption() or null
     @param outputCoordType 返回的坐标类型 BTKCoordType
     @param serviceID 轨迹服务的ID
     @param tag 请求标志
     @return 请求对象
     */
    static analyzeDrivingBehaviour(entityName,startTime,endTime,thresholdOption,processOption,outputCoordType,serviceID,tag){
        RNBaiduTrace.analyzeDrivingBehaviour(entityName,startTime,endTime,thresholdOption,processOption,outputCoordType,serviceID,tag);
    }

    //**********************************************delegate call back*********************************************************

    /**
     开启轨迹服务的回调方法
     @param {Function} cb = (Object）=> {"error":BTKServiceErrorCode}
     */
    static onStartService(callback){
        listeners[callback] = DeviceEventEmitter.addListener(
            onStartServer, result => {
                callback(result)
            })
    }
    /**
     停止轨迹服务的回调方法
     @param {Function} cb = (Object）=> {"error":BTKServiceErrorCode}
     */
    static onStopService(callback){
        listeners[callback] = DeviceEventEmitter.addListener(
            onStopService, result => {
                callback(result)
            })
    }
    /**
     开始采集的回调方法
     @param {Function} cb = (Object）=> {"error":BTKGatherErrorCode}
     */
    static onStartGather(callback){
        listeners[callback] = DeviceEventEmitter.addListener(
            onStartGather, result => {
                callback(result)
            })
    }
    /**
     停止采集的回调方法
     @param {Function} cb = (Object）=> {"error":BTKGatherErrorCode}
     */
    static onStopGather(callback){
        listeners[callback] = DeviceEventEmitter.addListener(
            onStopGather, result => {
                callback(result)
            })
    }
    /**
     收到推送消息的回调方法
     @param {Function} cb = (Object）=> {"error":BTKGatherErrorCode}
     */
    static onGetPushMessage(callback){
        listeners[callback] = DeviceEventEmitter.addListener(
            onGetPushMessage, result => {
                callback(result)
            })
    }

    /**
     用户自定义信息设置结果的回调方法
     @param {Function} cb = (Object）=> {"error":BTKGetCustomDataErrorCode}
     */
    static onGetCustomDataResult(callback){
        listeners[callback] = DeviceEventEmitter.addListener(
            onGetCustomDataResult, result => {
                callback(result)
            })
    }
    /**
     更改采集和打包上传周期的结果的回调方法
     @param {Function} cb = (Object）=> {"error":BTKChangeIntervalErrorCode}
     */
    static onChangeGatherAndPackIntervals(callback){
        listeners[callback] = DeviceEventEmitter.addListener(
            onChangeGatherAndPackIntervals, result => {
                callback(result)
            })
    }

    /**
     设置缓存占用的最大磁盘空间的结果的回调方法
     @param {Function} cb = (Object）=> {"error":BTKSetCacheMaxSizeErrorCode}
     */
    static onSetCacheMaxSize(callback){
        listeners[callback] = DeviceEventEmitter.addListener(
            onSetCacheMaxSize, result => {
                callback(result)
            })
    }

    /**
     * 查询历史轨迹回调
     * @param callback
     * android 返回类型： 例如 {message: "鉴权失败", status: 14004}
     */
    static onHistoryTrack(callback){
        listeners[callback] = DeviceEventEmitter.addListener(
            onHistoryTrack, result => {
                callback(result)
            })
    }
    /**
     里程计算
     @param {Function} cb = (Object）=> {"response":data}
     */
    static onQueryTrackDistance(callback){
        listeners[callback] = DeviceEventEmitter.addListener(
            onQueryTrackDistance, result => {
                callback(result)
            })
    }
    /**
     停留点分析结果回调
     @param {Function} cb = (Object）=> {"response":data}
     */
    static onAnalyzeStayPoint(callback){
        listeners[callback] = DeviceEventEmitter.addListener(
            onAnalyzeStayPoint, result => {
                callback(result)
            })
    }
    /**
     驾驶行为分析回调
     @param {Function} cb = (Object）=> {{"response":data}
     */
    static onAnalyzeDrivingBehaviour(callback){
        listeners[callback] = DeviceEventEmitter.addListener(
            onAnalyzeDrivingBehaviour, result => {
                callback(result)
            })
    }

//***************************
    /**
     *
     * @param denoise   纠偏时是否需要去噪，TRUE代表去噪
     * @param vacuate   纠偏时是否需要抽稀，TRUE代表抽稀。
                        该选项只有在查询行程信息的请求BTKQueryHistoryTrackRequest中有效。
                        在BTKQueryTrackLatestPointRequest和BTKQueryTrackDistanceRequest中的processOption选项中设置此属性没有效果。
     * @param mapMatch  纠偏时是否需要绑路，TRUE代表绑路
     * @param radiusThreshold   纠偏时的定位精度过滤阀值，用于过滤掉定位精度较差的轨迹点。
                                0代表不过滤，100代表过滤掉定位精度大于100米的轨迹点。
                                例如：若只需保留 GPS 定位点，则建议设为：20；若需保留 GPS 和 Wi-Fi 定位点，去除基站定位点，则建议设为：100
     * @param transportMode     纠偏时的交通方式，鹰眼将根据不同交通工具选择不同的纠偏策略 BTKTrackProcessOptionTransportMode
     * @returns {{}}
     */
    static getBTKQueryTrackProcessOption(denoise = false,vacuate = false,mapMatch = false,radiusThreshold = 0,transportMode = BTKTrackProcessOptionTransportMode.BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_AUTO){
        return {
            denoise:denoise,
            vacuate:vacuate,
            mapMatch:mapMatch,
            radiusThreshold:radiusThreshold,
            transportMode:transportMode,
        }
    }

    /**
     * 轨迹分析时需要的阈值，各阈值均有默认值。
     * @param speedingThreshold 固定限速值，可选。 若设置为非0值，则以设置的数值为阈值，轨迹点速度超过该值则认为是超速；若不设置，或设置为0，则根据百度地图道路限速数据计算超速点。
     * @param harshAccelerationThreshold 急加速的水平加速度阈值。 单位：m^2/s，默认值：1.67，仅支持正数
     * @param harshBreakingThreshold 急减速的水平加速度阈值。 单位：m^2/s，默认值：-1.67，仅支持负数
     * @param harshSteeringThreshold 急转弯的向心加速度阈值。 单位：m^2/s，默认值：5，仅支持正数
     */
    static getBTKDrivingBehaviorThresholdOption(speedingThreshold = 0.0,harshAccelerationThreshold = 0.0,harshBreakingThreshold = 0.0,harshSteeringThreshold = 0.0){
        return {
            speedingThreshold:speedingThreshold,
            harshAccelerationThreshold:harshAccelerationThreshold,
            harshBreakingThreshold:harshBreakingThreshold,
            harshSteeringThreshold:harshSteeringThreshold,
        }
    }
}

export {BTKTrackProcessOptionTransportMode,BTKCoordType}
