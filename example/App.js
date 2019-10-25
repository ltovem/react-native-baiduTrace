/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Fragment} from 'react';
import {
  SafeAreaView,
  StyleSheet,
  ScrollView,
  View,
  Text,
  StatusBar,
  TouchableOpacity,
} from 'react-native';

import {
  Header,
  LearnMoreLinks,
  Colors,
  DebugInstructions,
  ReloadInstructions,
} from 'react-native/Libraries/NewAppScreen';

import BaiduTrace from './app/index';
class App extends React.Component{

    _renderWith(title,callBack){
        return (
            <TouchableOpacity
                onPress = {()=>callBack()}
                style = {{
                    // backgroundColor:'#f5a',
                    padding: 20,
                }}>
                <Text style = {{fontSize:18,color:'#4e4e4e'}}>{title}</Text>
                <View style = {{height:1,backgroundColor:'lightgray',position: 'absolute',left:0,right: 0,bottom:0}}/>
            </TouchableOpacity>
        )
    }
  render(){
    return (
        <View style = {{flex:1,justifyContent:'center'}}>
          <StatusBar barStyle="dark-content" />
          <SafeAreaView>
              {this._renderWith('初始化服务',()=>this._startServer())}
              {this._renderWith('开启鹰眼服务',()=>this._startTrace())}
              {this._renderWith('停止鹰眼服务',()=>this._stopTrace())}
              {this._renderWith('开启采集服务',()=>this._startTraceGather())}
              {this._renderWith('停止采集服务',()=>this._stopTraceGather())}
          </SafeAreaView>
        </View>
    );
  }


   _startServer(){
    console.log('start server');
     BaiduTrace.initBaiduTrace(131252,'rntest',false,'com.nongguanjia.nsb','DrHMfhPNdHBtdWgW5uW7Ou2P');
  }
  _startTrace(){
      BaiduTrace.startBaiduTrace();
  }
  _stopTrace(){
        BaiduTrace.stopBaiduTrace();
  }
    _startTraceGather(){
        BaiduTrace.startBaiduTraceGather();
    }
    _stopTraceGather(){
        BaiduTrace.stopBaiduTrace();
    }
  componentDidMount() {
      BaiduTrace.onStartService(result=>{

          console.log(result);
          console.log('rn end');
      })
      BaiduTrace.onStopService(result=>{
          console.log(result);
          console.log(' stop rn end');
      })
      BaiduTrace.onStartGather(result=>{

          console.log(result);
          console.log('rn start gather end');
      })
      BaiduTrace.onStopGather(result=>{
          console.log(result);
          console.log(' stop gather rn end');
      })

  }
};

const styles = StyleSheet.create({

});

export default App;
