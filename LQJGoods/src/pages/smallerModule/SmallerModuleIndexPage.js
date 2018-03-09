/**
 * 项目小模块
 */
'use strict'
import React, {Component} from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  InteractionManager,
  Animated,
  FlatList,
  Image
} from 'react-native';
import {Actions} from 'react-native-router-flux';
import * as Header from '../../common/Header';
const AnimatedFlatList = Animated.createAnimatedComponent(FlatList);

let listData = [
  {icon: require('../../res/images/list_4.png'), title: '文件管理', class: '', info: ''},
];

export default class SmallerModuleIndexPage extends Component {
  constructor(props) {
    super(props);
    this.state = {}
  }

  render() {
    return (
    <View style={styles.container}>
      <AnimatedFlatList
      //ref={(ref) => this.AnimatedFlatList = ref}
      renderItem={this._renderItemComponent.bind(this)}
      horizontal={false}
      data={listData}
      numColumns={1}
      keyExtractor={(item, index)=>index+''}
      />
    </View>
    );
  }

  _renderItemComponent({item, index}) {
    this._KRandomColorFuc(1);
    return (
    <TouchableOpacity activeOpacity={0.5} onPress={()=>this._itemClick(item,index)}>
      <View style={[styles.item,{backgroundColor:Header.KRandomColorFuc(0.3)}]}>
        <Image source={item.icon} style={styles.icon}/>
        <Text style={styles.titleStyle}>{item.title}</Text>
      </View>
    </TouchableOpacity>
    )
  }

  //item点击事件
  _itemClick(item, index) {
    if(index === 0){
      Actions.FileManagerPage();
    }
  }

  //随机颜色
  _KRandomColorFuc(alpha) {

  }

}
const styles = StyleSheet.create(
{
  container: {
    flex: 1,
    backgroundColor: Header.KLightBlueColor
  },
  item:{
    width:Header.SCREEN_WIDTH,
    flexDirection:'row',
    borderBottomWidth:1,
    borderBottomColor:Header.KLightGrayColor,
    alignItems:'center'
  },
  icon:{
    margin:10,
    width:35,
    height:35,
  },
  titleText:{
    fontSize:20,
    color:Header.KBlackColor,
  }
});