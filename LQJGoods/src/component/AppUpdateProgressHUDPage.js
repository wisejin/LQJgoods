/**
 * APP更新进度弹框
 */
'use strict';
import React, {Component} from 'react';
import {Animated, StyleSheet, Text, View, DeviceEventEmitter} from 'react-native';
import {Actions} from "react-native-router-flux";

export default class AppUpdateProgressHUDPage extends Component {

  constructor(props) {
    super(props);
    this.state = {
      opacity: new Animated.Value(0),
      progresstext: '0%',
    }
  }

  componentDidMount() {
    this._showHUD();
    this.listener = DeviceEventEmitter.addListener('appUpdate', (param) => {
      console.log(param);
      if (param.hide) {
        this._hideHUD();
      }
      this.setState({
        progresstext: param.progressText
      });
    });
  }

  componentWillUnmount() {
    this.listener.remove();
  }

  render() {
    return (
    <Animated.View style={[styles.container, {opacity: this.state.opacity}]}>
      <View style={styles.centerViewStyle}>
        <Text numberOfLines={1} style={styles.textStyle}>
          更新中...
        </Text>
        <Text numberOfLines={1} style={[styles.textStyle, {fontSize: 16}]}>
          {this.state.progresstext}
        </Text>
      </View>
    </Animated.View>
    )
  }

  _hideHUD() {
    Animated.timing(this.state.opacity, {
      duration: 100,
      toValue: 0,
    }).start(Actions.pop);
  }

  _showHUD() {
    Animated.timing(this.state.opacity, {
      duration: 100,
      toValue: 1,
    }).start();
  }

}

const styles = StyleSheet.create({
  container: {
    backgroundColor: 'rgba(52,52,52,0.3)',
    position: 'absolute',
    top: 0,
    bottom: 0,
    left: 0,
    right: 0,
    justifyContent: 'center',
    alignItems: 'center',
  },
  centerViewStyle: {
    width: 75,
    height: 75,
    backgroundColor: 'rgba(0,0,0,.8)',
    borderRadius: 10,
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: -64
  },
  textStyle: {
    fontSize: 14,
    textAlign: 'center',
    color: 'white',
    width: 60,
    //backgroundColor:'red'
  }
});
