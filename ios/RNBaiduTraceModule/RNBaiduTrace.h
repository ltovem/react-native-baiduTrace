#import <Foundation/Foundation.h>

#if __has_include(<React/RCTBridge.h>)
#import <React/RCTEventEmitter.h>
#import <React/RCTRootView.h>
#import <React/RCTBridge.h>
#elif __has_include("RCTBridge.h")
#import "RCTEventEmitter.h"
#import "RCTRootView.h"
#import "RCTBridge.h"
#endif
#import "RCTJPushEventQueue.h"
@interface RNBaiduTrace : RCTEventEmitter <RCTBridgeModule>

@end
  
