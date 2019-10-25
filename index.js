import {
    DeviceEventEmitter,
    NativeModules,
    Platform
} from 'react-native'

const RNBaiduTrace = NativeModules.RNBaiduTrace

const listeners = {}
// const ConnectEvent            = 'ConnectEvent'            //连接状态
// const NotificationEvent       = 'NotificationEvent'       //通知事件
// const CustomMessageEvent      = 'CustomMessageEvent'      //自定义消息事件
// const LocalNotificationEvent  = 'LocalNotificationEvent'  //本地通知事件 todo
// const TagAliasEvent           = 'TagAliasEvent'           //TagAlias事件
// const MobileNumberEvent       = 'MobileNumberEvent'       //电话号码事件

const onStartServer = "onStartService"; // 开启轨迹服务的回调方法
const onStopService = "onStopService"; // 停止轨迹服务的回调方法
const onStartGather = "onStartGather";// 开始采集的回调方法
const onStopGather = "onStopGather";// 停止采集的回调方法
const onGetPushMessage = "onGetPushMessage"; //收到推送消息的回调方法
const onGetCustomDataResult = "onGetCustomDataResult"; // 用户自定义信息设置结果的回调方法
const onChangeGatherAndPackIntervals = "onChangeGatherAndPackIntervals"; //更改采集和打包上传周期的结果的回调方法
const onSetCacheMaxSize = "onSetCacheMaxSize";// 设置缓存占用的最大磁盘空间的结果的回调方法
const onRequestAlwaysLocationAuthorization = "onRequestAlwaysLocationAuthorization"; //请求后台定位权限的回调方法

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
     * 停止服务
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

}
