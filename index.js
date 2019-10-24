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

const ON_START_TRACE = "BaiduTrace_onStartTrace"; // 开启服务回调
const ON_STOP_TRACE = "BaiduTrace_onStopTrace"; // 停止服务回调
const ON_START_GATHER = "BaiduTrace_onStartGather";// 开启采集回调
const ON_STOP_GATHER = "BaiduTrace_onStopGather";// 停止采集回调
const ON_BIND_SERVICE = "BaiduTrace_onBindService";
const ON_PUSH = "BaiduTrace_onPush"; // 推送回调
const ON_HISTORY_TRACK = "BaiduTrace_onHistoryTrack"; //查询历史轨迹回调


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


}
