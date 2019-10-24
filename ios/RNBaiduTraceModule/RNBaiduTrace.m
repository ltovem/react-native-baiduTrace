
#import "RNBaiduTrace.h"

#import <BaiduTraceSDK/BaiduTraceSDK.h>

@interface RNBaiduTrace ()

@end

@implementation RNBaiduTrace

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
    
}
RCT_EXPORT_MODULE()

/**
* 初始化百度鹰眼轨迹服务
* @param serviceId  // 轨迹服务ID string
* @param entityName  // 设备标识 string
* @param isNeedObjectStorage   // 是否需要对象存储服务，默认为：false，关闭对象存储服务。
*                              注：鹰眼 Android SDK v3.0以上版本支持随轨迹上传图像等对象数据，
*                              若需使用此功能，该参数需设为 true，且需导入bos-android-sdk-1.0.2.jar。
*/
RCT_EXPORT_METHOD(initBaiduTrace:(NSUInteger )serviceId ak:(NSString *)ak entityName:(NSString *)entityName bundleId:(NSString *)bundleId keepAlive:(BOOL)keepAlive){
    
    BTKServiceOption *sop = [[BTKServiceOption alloc] initWithAK:ak mcode:bundleId serviceID:serviceId keepAlive:keepAlive];
    [[BTKAction sharedInstance] initInfo:sop];
}

@end
  
