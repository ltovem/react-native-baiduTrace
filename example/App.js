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

import BaiduTrace from 'baidu-trace';
class App extends React.Component{

  render(){
    return (
        <View style = {{flex:1,justifyContent:'center'}}>
          <StatusBar barStyle="dark-content" />
          <SafeAreaView>
            <TouchableOpacity
                onPress = {()=>this._startServer()}
                style = {{backgroundColor:'#f5a',padding: 20}}>
              <Text>初始化服务</Text>
              <View style = {{height:1,backgroundColor:'gray',position: 'absolute',left:0,right: 0,bottom:0}}/>
            </TouchableOpacity>

          </SafeAreaView>
        </View>
    );
  }


   _startServer(){
    console.log('start server');
     BaiduTrace.initBaiduTrace(131252,'rntest',false,'com.nongguanjia.nsb','DrHMfhPNdHBtdWgW5uW7Ou2P');
  }
};

const styles = StyleSheet.create({

});

export default App;
