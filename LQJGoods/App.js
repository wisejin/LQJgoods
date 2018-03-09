'use strict';
import React, {Component} from 'react';
import {
  BackHandler,
  Image,
  InteractionManager,
  Platform,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
  DeviceEventEmitter
} from 'react-native';
/*第三方库*/
import {Actions, Lightbox, Modal, Overlay, Router, Scene, Stack,} from 'react-native-router-flux';
import CodePush from "react-native-code-push";
import {Provider} from 'react-redux';
import store from './src/store/store';
/*自定义Component*/
import * as Header from './src/common/Header';
/*RN 与原生交互*/
import {SplashScreen} from './src/common/NativeAndroid';
import {ReactNativeHandlerIos} from './src/common/NativeIos'

import LQJGoodsIndexPage from './src/pages/index/LQJGoodsIndexPage'; //首页
import SmallerModuleIndexPage from './src/pages/smallerModule/SmallerModuleIndexPage';//项目小模块
import FileManagerPage from './src/pages/smallerModule/fileManager/FileManagerPage';
import AppUpdateProgressHUDPage from './src/component/AppUpdateProgressHUDPage';

export default class App extends Component<> {
  constructor(props) {
    super(props);
    this.state = {
      progressText: '0%'
    }
  }

  componentDidMount() {
    if (Platform.OS === 'android') {
      SplashScreen.hide();
    }
    this.syncImmediate()
  }

  render() {
    return (
    <Provider store={store}>
      <Router
      // wrapBy={(e)=>{
      //   console.log(e);
      // }}
      backAndroidHandler={this._onBackAndroid}
      >
        <Overlay key="overlay">
          <Modal key="modal" hideNavBar>
            <Lightbox key="lightbox">
              <Stack
              key="root"
              navigationBarStyle={styles.navigationBarStyle}
              titleStyle={styles.titleStyle}
              renderLeftButton={this._navBackButton()}>
                <Scene
                key="index"
                component={LQJGoodsIndexPage}
                initial={true}
                title='RN模块'
                onExit={(e) => {
                  if (Platform.OS === 'ios') {
                    ReactNativeHandlerIos.rnGotoRootView("2");
                  }
                }}
                onEnter={(e) => {
                  if (Platform.OS === 'ios') {
                    ReactNativeHandlerIos.rnGotoRootView("1");
                  }
                }}
                />

                <Scene
                key="SmallerModuleIndexPage"
                component={SmallerModuleIndexPage}
                title="项目小模块"
                />

                <Scene
                key="FileManagerPage"
                component={FileManagerPage}
                title="文件管理"
                />

              </Stack>

              {/*弹窗*/}
              <Scene key="AppUpdateProgressHUDPage" component={AppUpdateProgressHUDPage}/>
            </Lightbox>
          </Modal>
        </Overlay>
      </Router>
    </Provider>
    );
  }

//返回按钮View
  _navBackButton() {
    if (Platform.OS === 'ios') {
      return (
      <TouchableOpacity activeOpacity={0.7} onPress={() => this._rootNavBackClick()}>
        <View style={{flexDirection: 'row', width: 60, height: 30}}>
          <Image source={require('./src/res/images/nav_back.png')}
                 style={{marginLeft: 10, width: 13, height: 20, marginTop: 5}}
          />
          <Text style={{color: 'white', fontSize: 17, marginTop: 6, marginLeft: 5}}>返回</Text>
        </View>
      </TouchableOpacity>
      )
    } else {
      return (
      <View style={styles.head}>
        <TouchableOpacity onPress={() => this._rootNavBackClick()}>
          <Image source={require("./src/res/images/nav_back_white.png")}
                 style={{height: 25, width: 25}}/>
        </TouchableOpacity>
        <Text style={{height: 20, width: 0.5, backgroundColor: 'white', marginLeft: 15}}/>
      </View>
      )
    }
  }

  //根视图返回按钮事件
  _rootNavBackClick() {
    let currentScene = Actions.currentScene;
    console.log(currentScene);
    if (currentScene === 'index') {
      if (Platform.OS === 'ios') {
        ReactNativeHandlerIos.popBack();
      } else {
        BackHandler.exitApp();
      }
    } else {
      InteractionManager.runAfterInteractions(() => {
        Actions.pop()
      })
    }
  }

  /**
   * 处理Android返回按键
   */
  _onBackAndroid() {
    let currentScene = Actions.currentScene;
    if (currentScene === 'index') {
      BackHandler.exitApp();
    } else {
      InteractionManager.runAfterInteractions(() => {
        Actions.pop()
      });
    }
    return true;
  }

  /*============ code-push ===============*/
  codePushStatusDidChange(syncStatus) {
    const {dispatch} = this.props;
    switch (syncStatus) {
      case CodePush.SyncStatus.CHECKING_FOR_UPDATE:
        // this.setState({syncMessage: "Checking for update."});
        break;
      case CodePush.SyncStatus.DOWNLOADING_PACKAGE:
        Actions.AppUpdateProgressHUDPage();
        // this.setState({syncMessage: "Downl oading package."});
        break;
      case CodePush.SyncStatus.AWAITING_USER_ACTION:
        // this.setState({syncMessage: "Awaiting user action."});
        break;
      case CodePush.SyncStatus.INSTALLING_UPDATE:
        // this.setState({syncMessage: "Installing update."});
        break;
      case CodePush.SyncStatus.UP_TO_DATE:
        // this.setState({syncMessage: "App up to date.", progress: false});
        break;
      case CodePush.SyncStatus.UPDATE_IGNORED:
        // this.setState({syncMessage: "Update cancelled by user.", progress: false});
        break;
      case CodePush.SyncStatus.UPDATE_INSTALLED:
        // this.setState({syncMessage: "Update installed and will be applied on restart.", progress: false});
        DeviceEventEmitter.emit('appUpdate', {progressText: "更新完成", hide: true});
        break;
      case CodePush.SyncStatus.UNKNOWN_ERROR:
        DeviceEventEmitter.emit('appUpdate', {progressText: "错误", hide: true});
        // this.setState({syncMessage: "An unknown error occurred.", progress: false});
        break;
    }
  }

  // 更新进度
  codePushDownloadDidProgress(progress) {
    let progresstext = parseInt(parseFloat(progress.receivedBytes) / parseFloat(progress.totalBytes) * 100);
    // this.setState({
    //     progressText: progresstext.toString() + '%'
    // });

    //发送通知 告知APP更新进度
    DeviceEventEmitter.emit('appUpdate', {progressText: progresstext.toString() + '%', hide: false});
  }

  // 更新数据(updateDialog:true 有提示框)
  syncImmediate() {
    CodePush.sync(
    {installMode: CodePush.InstallMode.IMMEDIATE, updateDialog: true},
    this.codePushStatusDidChange.bind(this),
    this.codePushDownloadDidProgress.bind(this)
    );
  }

}

let codePushOptions = {checkFrequency: CodePush.CheckFrequency.MANUAL};
let CodePushDemoApp = CodePush(codePushOptions)(App);

const styles = StyleSheet.create({
  navigationBarStyle: {
    height: Platform.OS === 'ios' ? 44 : 68,
    backgroundColor: Header.KMainColor
  },
  titleStyle: {
    color: 'white',
    alignSelf: Platform.OS === 'ios' ? 'center' : 'flex-start',
    paddingTop: Platform.OS === 'ios' ? 0 : 24,
    // fontWeight: '100',
    fontSize: 20
  },
  head: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingTop: 24,
    paddingLeft: 15
  },
});