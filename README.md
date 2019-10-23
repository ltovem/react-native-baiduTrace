
# react-native-baidu-trace

## Getting started

`$ npm install baidu-trace --save`

### Mostly automatic installation

`$ react-native link baidu-trace`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-baidu-trace` and add `RNBaiduTrace.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNBaiduTrace.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

### plist文件设置

APP在声明定位权限时（用作APPStore上架审核），自鹰眼iOS SDK V3.1.1版本开始支持开发者声明“仅需要前台定位”或“同时需要前台和后台定位”，结合最终用户定位权限授予情况，两种声明均可实现鹰眼轨迹的采集，两者不同之处在于：
1. 声明仅需前台定位：若最终用户授权APP定位权限（允许一次/使用APP期间/始终），此时APP在前台时鹰眼可成功采集轨迹，但APP退到后台时APP被杀死可能性较高，易造成轨迹中断。仅声明前台定位权限需在info.plist文件源码中增加以下声明：

`
<key>NSLocationWhenInUseUsageDescription</key>
<string>文字阐述需要前台定位的原因</string>
`

 2.声明同时需要前台和后台定位：若最终用户授权APP定位权限为“始终”时，不论APP在前台还是后台，APP被杀死概率较低，这种方式可尽量保证轨迹采集不中断。若最终用户授权APP定位权限为“允许一次/使用APP期间”时，APP在前台时鹰眼可成功采集轨迹，退到后台时APP被杀死可能性较高，易造成轨迹中断。同时声明前台和后台定位权限需在info.plist文件源码中增加以下声明：

`<key>NSLocationWhenInUseUsageDescription</key>
 <string>文字阐述需要前台定位的原因</string>
 <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
 <string>文字阐述需要后台定位的原因</string>
 <key>NSLocationAlwaysUsageDescription</key>
 <string>文字阐述需要后台定位的原因</string>
 <key>UIBackgroundModes</key>
 <array>
      <string>location</string>
 </array>`
 

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.nong.baidutrace.RNBaiduTracePackage;` to the imports at the top of the file
  - Add `new RNBaiduTracePackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-baidu-trace'
  	project(':react-native-baidu-trace').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-baidu-trace/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-baidu-trace')
  	```


## Usage
```javascript
import RNBaiduTrace from 'react-native-baidu-trace';

// TODO: What to do with the module?
RNBaiduTrace;
```
  
