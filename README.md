
# react-native-baidu-trace

## Getting started

`$ npm install react-native-baidu-trace --save`

### Mostly automatic installation

`$ react-native link react-native-baidu-trace`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-baidu-trace` and add `RNBaiduTrace.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNBaiduTrace.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

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
4. 设置AccessKey
   在Mainfest.xml正确设置AccessKey（AK），如果设置错误将会导致鹰眼服务无法正常使用。
   需在Application标签中加入以下代码，并填入开发者自己的 Android 类型 AK。
   <meta-data             
   android:name="com.baidu.lbsapi.API_KEY"             
   android:value="AK" />       //key:开发者申请的Key


## Usage
```javascript
import RNBaiduTrace from 'react-native-baidu-trace';

// TODO: What to do with the module?
RNBaiduTrace;
```
