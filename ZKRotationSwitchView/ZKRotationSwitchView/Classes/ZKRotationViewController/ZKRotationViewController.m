//
//  ZKRotationViewController.m
//  ZKRotationSwitchView
//
//  Created by ZK on 16/5/24.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKRotationViewController.h"

#define ScreenWidth     [UIScreen mainScreen].bounds.size.width

@interface ZKRotationViewController ()
@end

@implementation ZKRotationViewController

static const NSTimeInterval kAnimationDuration = 0.35;
static const NSUInteger kDivideNum = 6;     //M_PI被平分的份数

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    [self addGesture];
    
    // 设置锚点
    [self setAnchorPoint:CGPointMake(0.5, 1.5) forView:self.view];
}

- (void)addGesture
{
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                            action:@selector(handlePan:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor greenColor];
}

/** 给需要旋转的view设置锚点, 否则view的旋转不收控制 */
- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake(view.center.x - transition.x, view.center.y - transition.y);
}

#pragma mark *** 手势拖动 ***
- (void)handlePan:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translation = [panGesture translationInView:panGesture.view];
    
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        
        [self moveViewWithX:translation.x];
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded ||
             panGesture.state == UIGestureRecognizerStateCancelled) {
        
        [self handlePanEnded:panGesture translationX:translation.x];
        return;
    }
}

- (void)handlePanEnded:(UIPanGestureRecognizer *)panGrsture
            translationX:(CGFloat)translationX
{
    if (translationX > ScreenWidth * 0.5) {
        [self rotationAnimation:^{
            [self moveViewWithX:kDivideNum*ScreenWidth];
        }];
    }
    else if (translationX < -ScreenWidth * 0.5) {
        [self rotationAnimation:^{
            [self moveViewWithX:-kDivideNum*ScreenWidth];
        }];
    }
    else {
        [self rotationAnimation:^{
            self.view.transform = CGAffineTransformIdentity;
        }];
    }
}

#pragma mark *** 私有方法 ***
- (void)rotationAnimation:(void(^__nullable)())animations
{
    [UIView animateWithDuration:kAnimationDuration
                     animations:animations
                     completion:nil];
}

- (void)moveViewWithX:(CGFloat)x
{
    NSLog(@"x=====%f",x);
    //计算角度
    double angle = M_PI/kDivideNum * (x / ScreenWidth);
    //旋转
    self.view.transform = CGAffineTransformMakeRotation(angle);
}

#pragma mark *** 公共方法 ***
+ (instancetype)showInController:(UIViewController *)viewController
{
    ZKRotationViewController *rotationVC = [[ZKRotationViewController alloc] init];
    [rotationVC moveViewWithX:2*ScreenWidth];
    [viewController addChildViewController:rotationVC];
    [viewController.view addSubview:rotationVC.view];
    
    [rotationVC rotationAnimation:^{
        rotationVC.view.transform = CGAffineTransformIdentity;
    }];
    
    return rotationVC;
}

@end
