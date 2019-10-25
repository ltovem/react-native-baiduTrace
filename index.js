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



     @param {Function} cb = (Object）=> {}
     */
    static onStartService(callback){
        listeners[callback] = DeviceEventEmitter.addListener(
            onStartServer, result => {
                callback(result)
            })
    }

}
