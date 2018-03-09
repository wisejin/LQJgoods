//
//  BasicsAnimationController.m
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/27.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "BasicsAnimationController.h"

@interface BasicsAnimationController ()
/**
 *  中部
 */
@property (nonatomic, strong) UIImageView *centerImgView;
/**
 *  左部
 */
@property (nonatomic, strong) UIImageView *leftImgView;
/**
 *  右部
 */
@property (nonatomic, strong) UIImageView *rightImgView;
/**
 *  上边卡片
 */
@property (nonatomic, strong) UIImageView *upCardImgView;
/**
 *  下边卡片
 */
@property (nonatomic, strong) UIImageView *downCardImgView;
@end

@implementation BasicsAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
  //中上
  _centerImgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-220)/2.0, KNavHeight+70, 220, 100)];
  _centerImgView.image = [UIImage imageNamed:@"animation_center"];
  [self.view addSubview:_centerImgView];
  
  //左边
  _leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-220)/2.0, _centerImgView.frame.origin.y+_centerImgView.frame.size.height+30, 110, 60)];
  _leftImgView.image = [UIImage imageNamed:@"animation_left"];
  [self.view addSubview:_leftImgView];
  
  //右边
  _rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-220)/2.0+110, _leftImgView.frame.origin.y, 110, 60)];
  _rightImgView.image = [UIImage imageNamed:@"animation_right"];
  [self.view addSubview:_rightImgView];
  
  //上边卡片
  _upCardImgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-30)/2.0, _rightImgView.frame.origin.y+_rightImgView.frame.size.height+30, 30, 30)];
  _upCardImgView.image = [UIImage imageNamed:@"animation_pay"];
  [self.view addSubview:_upCardImgView];
  
  //下边卡片
  _downCardImgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-30)/2.0, _upCardImgView.frame.origin.y+_upCardImgView.frame.size.height+50, 30, 30)];
  _downCardImgView.image = [UIImage imageNamed:@"animation_pay"];
  [self.view addSubview:_downCardImgView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  if(self.info){
    [self performSelector:NSSelectorFromString(self.info) withObject:nil afterDelay:0.f];
  }
  //    [self position1];
  //    [self size1];
  //    [self rotation1];
  //    [self scale1];
  //    [self opacity1];
  //    [self cornerRadius1];
  //    [self backgroundColor1];
  //    [self contents1];
  //    [self valueKeyframeAni1];
  //    [self valueKeyframeAni2];
  //    [self transitionAni1];
  //    [self transitionAni2];
  //    [self transitionAni3];
  //    [self transitionAni4];
  //    [self transitionAniRippleEffect];
  //    [self transitionAniPageCurl];
  //    [self transitionAniSuckEffect];
  //    [self springAni1];
  //    [self groupAni1];
  //    BNNextController *nextVC = [[BNNextController alloc] init];
  //    [self presentViewController:nextVC animated:YES completion:nil];
  //  [self breatheAnimation];
  //  [self rockAnimation];
}

#pragma mark ===================== CABasicAnimation ===================
//position  改变位置
- (void)position1{
  CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"position"];
  ani.toValue = [NSValue valueWithCGPoint:self.centerImgView.center];
  ani.removedOnCompletion = NO;
  ani.fillMode = kCAFillModeForwards;
  ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  [self.leftImgView.layer addAnimation:ani forKey:@"PostionAni"];
}


//size 改变尺寸大小
- (void)size1{
  //要改变当前layer的对应属性（例如：self.centerImgView.layer.bounds.size，如下）
  CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
  
  //从哪里开始改变
  ani.fromValue = [NSValue valueWithCGSize:CGSizeMake(350, 100)];
  
  //要改变到哪里的值
  ani.toValue = [NSValue valueWithCGSize:CGSizeMake(50, 100)];
  
  //removedOnCompletion：动画执行完毕后是否从图层上移除，默认为YES（视图会恢复到动画前的状态），可设置为NO（图层保持动画执行后的状态，前提是fillMode设置为kCAFillModeForwards）
  ani.removedOnCompletion = NO;
  ani.fillMode = kCAFillModeForwards;
  
  //动画的持续时间
  //    ani.duration = 1;
  //动画的重复次数
  ani.repeatCount = 2;
  
  //动画的时间节奏控制
  /*
   timingFunctionName的enum值如下：
   kCAMediaTimingFunctionLinear 匀速
   kCAMediaTimingFunctionEaseIn 慢进
   kCAMediaTimingFunctionEaseOut 慢出
   kCAMediaTimingFunctionEaseInEaseOut 慢进慢出
   kCAMediaTimingFunctionDefault 默认值（慢进慢出）
   */
  ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  [self.centerImgView.layer addAnimation:ani forKey:@"SizeAni"];
}

//rotation 旋转
- (void)rotation1{
  CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"transform"];
  //第一个参数是旋转角度，后面三个参数形成一个围绕其旋转的向量，起点位置由UIView的center属性标识。
  ////用在前面的例子，是由角度值经计算转化为弧度值。要把角度值转化为弧度值，可以使用一个简单的公式Mπ/180 。例如， 45π/180 = 45 （ 3.1415 ） / 180 = 0.7853 。如果你打算在你的程序里面一直都用角度值的话，你可以写一个简单的转化方法，以帮助保持您的代码是可以理解的：
  //这里是围绕X轴旋转180°
  ani.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation((180.0*M_PI)/180.0, 1.0, 0, 0)];
  ani.removedOnCompletion = NO;
  ani.fillMode = kCAFillModeForwards;
  ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  [self.centerImgView.layer addAnimation:ani forKey:@"TransformAni"];
}

//scale1缩放
- (void)scale1{
  CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"transform"];
  ani.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)];
  ani.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
  ani.removedOnCompletion = NO;
  ani.fillMode = kCAFillModeForwards;
  ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  [self.centerImgView.layer addAnimation:ani forKey:@"ScaleAni"];
}

//opacity 透明度
- (void)opacity1{
  CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"opacity"];
  ani.duration = 3;
  //透明度
  ani.toValue = [NSNumber numberWithFloat:0];
  ani.removedOnCompletion = NO;
  ani.fillMode = kCAFillModeForwards;
  ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  [self.centerImgView.layer addAnimation:ani forKey:@"OpacityAni"];
}

//cornerRadius圆角
- (void)cornerRadius1{
  CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
  ani.duration = 2;
  self.centerImgView.layer.masksToBounds = YES;
  //    self.centerImgView.layer.cornerRadius = 50;
  ani.toValue = [NSNumber numberWithFloat:50];
  ani.removedOnCompletion = NO;
  ani.fillMode = kCAFillModeForwards;
  ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  [self.centerImgView.layer addAnimation:ani forKey:@"CornerRadiusAni"];
}

//backgroundColor背景
- (void)backgroundColor1{
  self.centerImgView.image = nil;
  CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
  ani.duration = 5;
  //    self.centerImgView.layer.backgroundColor = [UIColor redColor].CGColor;
  ani.toValue = (__bridge id _Nullable)([UIColor redColor].CGColor);
  ani.removedOnCompletion = NO;
  ani.fillMode = kCAFillModeForwards;
  ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  [self.centerImgView.layer addAnimation:ani forKey:@"BackgroundColorAni"];
}

//contents内容
- (void)contents1{
  CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"contents"];
  ani.duration = 3;
  //CALayer 有一个属性叫做contents，这个属性的类型被定义为id，意味着它可以是任何类型的对象。在这种情况下，你可以给contents属性赋任何值，你的app仍然能够编译通过。但是，在实践中，如果你给contents赋的不是CGImage，那么你得到的图层将是空白的。
  //    self.centerImgView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"right.png"].CGImage);
  ani.toValue = (__bridge id _Nullable)([UIImage imageNamed:@"animation_right.png"].CGImage);
  ani.removedOnCompletion = NO;
  ani.fillMode = kCAFillModeForwards;
  ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  [self.centerImgView.layer addAnimation:ani forKey:@"ContentsAni"];
}

#pragma mark ======================= CAKeyframeAnimation =================
//设置values使其沿正方形运动
- (void)valueKeyframeAni1{
  CAKeyframeAnimation *ani = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  ani.duration = 4.0;
  ani.removedOnCompletion = NO;
  ani.fillMode = kCAFillModeForwards;
  ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(150, 200)];
  NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(250, 200)];
  NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(250, 300)];
  NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(150, 300)];
  NSValue *value5 = [NSValue valueWithCGPoint:CGPointMake(150, 200)];
  ani.values = @[value1,value2,value3,value4,value5];
  [self.centerImgView.layer addAnimation:ani forKey:@"PositionKeyframeValuesAni1"];
}


//设置path使其绕圆圈运动
- (void)valueKeyframeAni2{
  CAKeyframeAnimation *ani = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathAddEllipseInRect(path, NULL, CGRectMake(130, 200, 100, 100));
  ani.path = path;
  CGPathRelease(path);
  ani.duration = 4.0;
  ani.removedOnCompletion = NO;
  ani.fillMode = kCAFillModeForwards;
  [self.centerImgView.layer addAnimation:ani forKey:@"PositionKeyframeValuesAni2"];
}

#pragma mark ======================== CATransition ==============
//转场动画，比UIVIew转场动画具有更多的动画效果，比如Nav的默认Push视图的效果就是通过CATransition的kCATransitionPush类型来实现。
//transitionAni1渐变
- (void)transitionAni1{
  CATransition *ani  = [CATransition animation];
  ani.type = kCATransitionFade;
  ani.subtype = kCATransitionFromLeft;
  ani.duration = 1.5;
  self.centerImgView.image = [UIImage imageNamed:@"right.png"];
  [self.centerImgView.layer addAnimation:ani forKey:@"transitionAni1"];
}

//转场动画2 以下是另外三种转场类型的动画效果（图片名称对应其type类型）：
//transitionAni2
- (void)transitionAni2{
  CATransition *ani = [CATransition animation];
  ani.type = kCATransitionPush;
  ani.subtype = kCATransitionFromLeft;
  ani.duration = 1.5;
  self.centerImgView.image = [UIImage imageNamed:@"right.png"];
  [self.centerImgView.layer addAnimation:ani forKey:@"transitionAni2"];
}

//transitionAni3
- (void)transitionAni3{
  CATransition *ani = [CATransition animation];
  ani.type = kCATransitionMoveIn;
  ani.subtype = kCATransitionFromLeft;
  ani.duration = 1.5;
  self.centerImgView.image = [UIImage imageNamed:@"right.png"];
  [self.centerImgView.layer addAnimation:ani forKey:@"transitionAni3"];
}

//transitionAni4
- (void)transitionAni4{
  CATransition *ani = [CATransition animation];
  ani.type = kCATransitionReveal;
  ani.subtype = kCATransitionFromLeft;
  ani.duration = 1.5;
  self.centerImgView.image = [UIImage imageNamed:@"right.png"];
  [self.centerImgView.layer addAnimation:ani forKey:@"transitionAni3"];
}

//以下是部分私有转场类型的动画效果（图片名称对应其type类型）：
//transitionAniRippleEffect 波纹切换
- (void)transitionAniRippleEffect{
  CATransition *ani = [CATransition animation];
  ani.type = @"rippleEffect";
  ani.subtype = kCATransitionFromLeft;
  ani.duration = 1.5;
  self.centerImgView.image = [UIImage imageNamed:@"right.png"];
  [self.centerImgView.layer addAnimation:ani forKey:@"transitionAniRippleEffect"];
}

//transitionAniCube 立体滚动
- (void)transitionAniCube{
  CATransition *ani = [CATransition animation];
  ani.type = @"cube";
  ani.subtype = kCATransitionFromLeft;
  ani.duration = 1.5;
  self.centerImgView.image = [UIImage imageNamed:@"right.png"];
  [self.centerImgView.layer addAnimation:ani forKey:@"transitionAniCube"];
}

//transitionAniPageCurl 分页
- (void)transitionAniPageCurl{
  CATransition *ani = [CATransition animation];
  ani.type = @"pageCurl";
  ani.subtype = kCATransitionFromLeft;
  ani.duration = 1.5;
  self.centerImgView.image = [UIImage imageNamed:@"right.png"];
  [self.centerImgView.layer addAnimation:ani forKey:@"transitionAniPageCurl"];
}

//transitionAniSuckEffect
- (void)transitionAniSuckEffect{
  CATransition *ani = [CATransition animation];
  ani.type = @"suckEffect";
  ani.subtype = kCATransitionFromBottom;
  ani.duration = 1.5;
  self.centerImgView.image = [UIImage imageNamed:@"right.png"];
  [self.centerImgView.layer addAnimation:ani forKey:@"transitionAniSuckEffect"];
}

//呼吸动画
- (void)breatheAnimation{
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  animation.fromValue = [NSNumber numberWithFloat:1.0f];
  animation.toValue = [NSNumber numberWithFloat:0.0f];
  animation.autoreverses = YES;       //回退动画（动画可逆，即循环）
  animation.duration = 1.0f;
  animation.repeatCount = MAXFLOAT;
  animation.removedOnCompletion = NO;
  animation.fillMode = kCAFillModeForwards;//removedOnCompletion,fillMode配合使用保持动画完成效果
  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
  [self.upCardImgView.layer addAnimation:animation forKey:@"aAlpha"];
}

//摇摆动画
- (void)rockAnimation{
  self.downCardImgView.layer.anchorPoint = CGPointMake(0.5, 0);
  CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  //角度转弧度（这里1，-1简单处理一下）
  rotationAnimation.toValue = [NSNumber numberWithFloat:1];
  rotationAnimation.fromValue = [NSNumber numberWithFloat:-1];
  rotationAnimation.duration = 1.0f;
  rotationAnimation.repeatCount = MAXFLOAT;
  rotationAnimation.removedOnCompletion = NO;
  rotationAnimation.autoreverses = YES;
  rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  rotationAnimation.fillMode = kCAFillModeForwards;
  [self.downCardImgView.layer addAnimation:rotationAnimation forKey:@"revItUpAnimation"];
}


#pragma mark ==================== CASpringAnimation ===============
/*
 CASpringAnimation是iOS9新加入动画类型，是CABasicAnimation的子类，用于实现弹簧动画。
 
 　　CASpringAnimation的重要属性：
 　　mass：质量（影响弹簧的惯性，质量越大，弹簧惯性越大，运动的幅度越大）
 　　stiffness：弹性系数（弹性系数越大，弹簧的运动越快）
 　　damping：阻尼系数（阻尼系数越大，弹簧的停止越快）
 　　initialVelocity：初始速率（弹簧动画的初始速度大小，弹簧运动的初始方向与初始速率的正负一致，若初始速率为0，表示忽略该属性）
 　　settlingDuration：结算时间（根据动画参数估算弹簧开始运动到停止的时间，动画设置的时间最好根据此时间来设置）
 
 　　CASpringAnimation和UIView的SpringAnimation对比：
 　　1.CASpringAnimation 可以设置更多影响弹簧动画效果的属性，可以实现更复杂的弹簧动画效果，且可以和其他动画组合。
 　　2.UIView的SpringAnimation实际上就是通过CASpringAnimation来实现。
 
 文／明仔Su（简书作者）
 原文链接：http://www.jianshu.com/p/d05d19f70bac
 著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。
 */
//以实现视图的bounds变化的弹簧动画效果为例：
- (void)springAni1{
  CASpringAnimation *ani = [CASpringAnimation animationWithKeyPath:@"bounds"];
  //质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大
  ani.mass = 10.0;
  //刚度系数（劲度系数/弹性系数），刚度系数越大，形变产生的力就越大，运动越快
  ani.stiffness = 5000;
  //阻尼系数，组织弹簧拉伸的系数，阻尼系数越大，停止越快
  ani.damping = 100.0;
  //初始速率，动画视图的初始速度大小；速率为正数时，速度方向与运动方向一致，速率为负数时，速度方向与运动方向相反
  ani.initialVelocity = 5.f;
  ani.duration = ani.settlingDuration;
  ani.toValue = [NSValue valueWithCGRect:self.centerImgView.bounds];
  ani.removedOnCompletion = NO;
  ani.fillMode = kCAFillModeForwards;
  ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  [self.leftImgView.layer addAnimation:ani forKey:@"boundsAni"];
}

#pragma mark ====================== CAAnimationGroup ==============
//使用Group可以将多个动画合并一起加入到层中，Group中所有动画并发执行，可以方便地实现需要多种类型动画的场景。
- (void)groupAni1{
  CABasicAnimation *posAni = [CABasicAnimation animationWithKeyPath:@"position"];
  posAni.toValue = [NSValue valueWithCGPoint:self.centerImgView.center];
  
  CABasicAnimation *opcAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
  opcAni.toValue = [NSNumber numberWithFloat:1.0];
  opcAni.toValue = [NSNumber numberWithFloat:0.7];
  
  CABasicAnimation *bodAni = [CABasicAnimation animationWithKeyPath:@"bounds"];
  bodAni.toValue = [NSValue valueWithCGRect:self.centerImgView.bounds];
  
  //动画组
  CAAnimationGroup *groupAni = [CAAnimationGroup animation];
  groupAni.animations = @[posAni,opcAni,bodAni];
  groupAni.duration = 1.0;
  groupAni.fillMode = kCAFillModeForwards;
  groupAni.removedOnCompletion = NO;
  groupAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  [self.leftImgView.layer addAnimation:groupAni forKey:@"groupAni1"];
}

@end


































