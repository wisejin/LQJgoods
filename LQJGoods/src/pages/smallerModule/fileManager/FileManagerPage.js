/**
 * 文件管理
 */
'use strict';
import React, {Component} from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  InteractionManager,
  ScrollView
} from 'react-native';
import {Actions} from 'react-native-router-flux';
import * as Header from '../../../common/Header';

import {ReactNativeHandlerIos} from '../../../common/NativeIos';

export default class FileManagerPage extends Component {
  constructor(props) {
    super(props);
    this.state = {
      text: 'afff',
    }
  }

  componentDidMount() {
    Actions.refresh({
      rightButtonImage: require('../../../res/images/rn_add.png'),
      onRight: () => {
        // 搜索
        if (Platform.OS === 'ios') {
          let infoDataArray = [];
          var test = [];
          infoDataArray.push('json测试');
          infoDataArray.push('json测试');
          infoDataArray.push('json测试');
          infoDataArray.push('json测试');
          infoDataArray.push('json测试');

          ReactNativeHandlerIos.pushToNextVc('FileManagerController', infoDataArray, (parameter) => {
            console.log(parameter);
            if (parameter && parameter.length > 0) {
              this.setState({
                text: JSON.stringify(parameter)
              });
            }

          });
        }

      }
    });
  }

  render() {
    return (
    <View style={styles.container}>
      <ScrollView>
        <Text style={{
          width: Header.SCREEN_WIDTH - 30,
          // height:Header.SCREEN_HEIGHT,
          margin: 15,
        }}>{this.state.text}</Text>
      </ScrollView>
    </View>
    );
  }
}
const styles = StyleSheet.create(
{
  container: {
    flex: 1,
    backgroundColor: Header.KLightBlueColor
  },
});