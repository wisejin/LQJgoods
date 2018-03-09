//
//  BasicsAnimationController.m
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/27.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "BasicsAnimationTableController.h"

@interface BasicsAnimationTableController ()

@end

@implementation BasicsAnimationTableController

- (void)viewDidLoad {
  [super viewDidLoad];
    
  self.dataSoureArray = @[
@{@"iconName":@"list_20",@"title":@"CABasicAnimation改变位置",@"className":@"BasicsAnimationController",@"info":@"position1"},
@{@"iconName":@"list_10",@"title":@"CABasicAnimation改变尺寸大小",@"className":@"BasicsAnimationController",@"info":@"size1"},
@{@"iconName":@"list_12",@"title":@"CABasicAnimation旋转",@"className":@"BasicsAnimationController",@"info":@"rotation1"},
@{@"iconName":@"list_2",@"title":@"CABasicAnimation缩放",@"className":@"BasicsAnimationController",@"info":@"scale1"},
@{@"iconName":@"list_3",@"title":@"CABasicAnimation透明",@"className":@"BasicsAnimationController",@"info":@"opacity1"},
@{@"iconName":@"list_4",@"title":@"CABasicAnimation圆角",@"className":@"BasicsAnimationController",@"info":@"cornerRadius1"},
@{@"iconName":@"list_5",@"title":@"CABasicAnimation背景",@"className":@"BasicsAnimationController",@"info":@"backgroundColor1"},
@{@"iconName":@"list_6",@"title":@"CABasicAnimation内容",@"className":@"BasicsAnimationController",@"info":@"contents1"},
@{@"iconName":@"list_7",@"title":@"CAKeyframeAnimation设置values使其沿正方形运动",@"className":@"BasicsAnimationController",@"info":@"valueKeyframeAni1"},
@{@"iconName":@"list_8",@"title":@"CAKeyframeAnimation设置path使其绕圆圈运动",@"className":@"BasicsAnimationController",@"info":@"valueKeyframeAni2"},
@{@"iconName":@"list_9",@"title":@"CATransition转场动画1.渐变",@"className":@"BasicsAnimationController",@"info":@"transitionAni1"},
@{@"iconName":@"list_14",@"title":@"CATransition转场动画2.以下是另外三种转场类型的动画效果（图片名称对应其type类型）：",@"className":@"BasicsAnimationController",@"info":@"transitionAni2"},
@{@"iconName":@"list_15",@"title":@"CATransition转场动画3",@"className":@"BasicsAnimationController",@"info":@"transitionAni3"},
@{@"iconName":@"list_16",@"title":@"CATransition转场动画4",@"className":@"BasicsAnimationController",@"info":@"transitionAni4"},
@{@"iconName":@"list_17",@"title":@"CATransition波纹切换1",@"className":@"BasicsAnimationController",@"info":@"transitionAniRippleEffect"},
@{@"iconName":@"list_18",@"title":@"CATransition立体滚动",@"className":@"BasicsAnimationController",@"info":@"transitionAniCube"},
@{@"iconName":@"list_19",@"title":@"CATransition分页",@"className":@"BasicsAnimationController",@"info":@"transitionAniPageCurl"},
@{@"iconName":@"list_3",@"title":@"CATransition波纹切换2",@"className":@"BasicsAnimationController",@"info":@"transitionAniSuckEffect"},
@{@"iconName":@"list_0",@"title":@"CATransition呼吸动画",@"className":@"BasicsAnimationController",@"info":@"breatheAnimation"},
@{@"iconName":@"list_5",@"title":@"CATransition摇摆动画",@"className":@"BasicsAnimationController",@"info":@"rockAnimation"},
@{@"iconName":@"list_17",@"title":@"CASpringAnimation以实现视图的bounds变化的弹簧动画效果为例",@"className":@"BasicsAnimationController",@"info":@"springAni1"},
@{@"iconName":@"list_13",@"title":@"CAAnimationGroup动画组合1",@"className":@"BasicsAnimationController",@"info":@"groupAni1"},
];
}

@end
