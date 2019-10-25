package com.nong.baidutrace;

import android.widget.Toast;
import android.os.Bundle;
import com.baidu.trace.LBSTraceClient;
import com.baidu.trace.Trace;
import com.baidu.trace.api.track.HistoryTrackRequest;
import com.baidu.trace.api.track.HistoryTrackResponse;
import com.baidu.trace.api.track.OnTrackListener;
import com.baidu.trace.model.OnTraceListener;
import com.baidu.trace.model.PushMessage;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.HashMap;
import java.util.Map;

public class RNBaiduTraceModule extends ReactContextBaseJavaModule {
    private static final String DURATION_SHORT_KEY = "SHORT";
    private static final String DURATION_LONG_KEY = "LONG";
    private static ReactApplicationContext reactContext;

    //百度鹰眼
    public static final String ON_START_TRACE = "BaiduTrace_onStartTrace";
    public static final String ON_STOP_TRACE = "BaiduTrace_onStopTrace";
    public static final String ON_START_GATHER = "BaiduTrace_onStartGather";
    public static final String ON_STOP_GATHER = "BaiduTrace_onStopGather";
    public static final String ON_BIND_SERVICE = "BaiduTrace_onBindService";
    public static final String ON_PUSH = "BaiduTrace_onPush";
    public static final String ON_HISTORY_TRACK = "BaiduTrace_onHistoryTrack";
    private LBSTraceClient mTraceClient;
    private Trace mTrace;
    // 定位周期(单位:秒)
    private int gather = 5;
    // 打包回传周期(单位:秒)
    private int pack = 10;

    public RNBaiduTraceModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNBaiduTrace";
    }

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put(DURATION_SHORT_KEY, Toast.LENGTH_SHORT);
        constants.put(DURATION_LONG_KEY, Toast.LENGTH_LONG);
        return constants;
    }

    @ReactMethod
    public void show(String message, int duration) {
        Toast.makeText(getReactApplicationContext(), message, duration).show();
    }

    /**
     * 初始化轨迹服务
     *
     * @param serviceId           // 轨迹服务ID
     * @param entityName          // 设备标识
     * @param isNeedObjectStorage // 是否需要对象存储服务，默认为：false，关闭对象存储服务。
     *                            注：鹰眼 Android SDK v3.0以上版本支持随轨迹上传图像等对象数据，
     *                            若需使用此功能，该参数需设为 true，且需导入bos-android-sdk-1.0.2.jar
     */
    @ReactMethod
    public void initBaiduTrace(int serviceId, String entityName, boolean isNeedObjectStorage) {
        // 初始化轨迹服务
        this.mTrace = new Trace(serviceId, entityName, isNeedObjectStorage);
        // 初始化轨迹服务客户端
        if (getReactApplicationContext() != null) {
            this.mTraceClient = new LBSTraceClient(getReactApplicationContext());
        }
    }

    /**
     * 设置定位和打包周期
     * @param gatherInterval 定位周期(单位:秒)
     * @param packInterval 打包回传周期(单位:秒)
     */
    @ReactMethod
    public void setBaiduTraceInterval(int gatherInterval, int packInterval) {
        gather = gatherInterval;
        pack = packInterval;
        mTraceClient.setInterval(gather, pack);
    }

    public static void sendEvent(String eventName, int status, String message) {
        WritableMap params = Arguments.createMap();
        params.putInt("status", status);
        params.putString("message", message);
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(eventName, params);
    }

    // 初始化轨迹服务监听器
    OnTraceListener mTraceListener = new OnTraceListener() {
        // 开启服务回调
        @Override
        public void onStartTraceCallback(int status, String message) {
            RNBaiduTraceModule.sendEvent(ON_START_TRACE, status, message);
        }

        // 停止服务回调
        @Override
        public void onStopTraceCallback(int status, String message) {
            RNBaiduTraceModule.sendEvent(ON_STOP_TRACE, status, message);
        }

        // 开启采集回调
        @Override
        public void onStartGatherCallback(int status, String message) {
            RNBaiduTraceModule.sendEvent(ON_START_GATHER, status, message);
        }

        // 停止采集回调
        @Override
        public void onStopGatherCallback(int status, String message) {
            RNBaiduTraceModule.sendEvent(ON_STOP_GATHER, status, message);
        }

        // 推送回调
        @Override
        public void onPushCallback(byte messageNo, PushMessage message) {
            int msgNo = Integer.valueOf(messageNo);
            RNBaiduTraceModule.sendEvent(ON_PUSH, msgNo, message.getMessage());
        }

        @Override
        public void onBindServiceCallback(int status, String message) {
            RNBaiduTraceModule.sendEvent(ON_BIND_SERVICE, status, message);
        }

        @Override
        public void onInitBOSCallback(int status, String message) {
        }
    };

    /**
     * 启动鹰眼service
     */
    @ReactMethod
    public void startBaiduTrace() {
        mTraceClient.startTrace(mTrace, mTraceListener);
    }

    /**
     * 停止服务
     * 停止轨迹服务：此方法将同时停止轨迹服务和轨迹采集，完全结束鹰眼轨迹服务。若需再次启动轨迹追踪，需重新启动服务和轨迹采集
     */
    @ReactMethod
    public void stopBaiduTrace() {
        mTraceClient.stopTrace(mTrace, mTraceListener);
    }

    /**
     * 开启采集
     *  注意：因为startTrace与startGather是异步执行，且startGather依赖startTrace执行开启服务成功，
     *  所以建议startGather在public void onStartTraceCallback(int errorNo, String message)回调返回错误码为0后，
     *  再进行调用执行，否则会出现服务开启失败12002的错误。
     */
    @ReactMethod
    public void startBaiduTraceGather() {
        mTraceClient.startGather(mTraceListener);
    }

    /**
     * 停止采集
     *  停止轨迹服务：此方法将同时停止轨迹服务和轨迹采集，完全结束鹰眼轨迹服务。若需再次启动轨迹追踪，需重新启动服务和轨迹采集
     */
    @ReactMethod
    public void stopBaiduTraceGather() {
        mTraceClient.stopGather(mTraceListener);
    }

    /**
     * 查询历史轨迹
     *
     * @param tag        //int 请求标识 1    //待验证：是否返回精简的结果（0 : 将只返回经纬度，1 : 将返回经纬度及其他属性信息）
     * @param serviceId  //int 轨迹服务ID
     * @param entityName // 设备标识
     * @param startTime  //  设置轨迹查询起止时间--开始时间(单位：秒)
     * @param endTime    // 设置轨迹查询起止时间--结束时间(单位：秒)
     */
    @ReactMethod
    public void getHistoryTrack(int tag, int serviceId, String entityName, int startTime, int endTime) {
        // 创建历史轨迹请求实例
        HistoryTrackRequest historyTrackRequest = new HistoryTrackRequest(tag, serviceId, entityName);
        // 设置开始时间
        historyTrackRequest.setStartTime(startTime);
        // 设置结束时间
        historyTrackRequest.setEndTime(endTime);
        // 初始化轨迹监听器
        OnTrackListener mTrackListener = new OnTrackListener() {
            // 历史轨迹回调
            @Override
            public void onHistoryTrackCallback(HistoryTrackResponse response) {
                RNBaiduTraceModule.sendEvent(ON_HISTORY_TRACK, response.getStatus(), response.getMessage());
            }
        };
        // 查询历史轨迹
        mTraceClient.queryHistoryTrack(historyTrackRequest, mTrackListener);
    }


}
