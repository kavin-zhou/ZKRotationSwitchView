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
@property (nonatomic, assign) CGPoint startPoint;  //记录拖动始点
@property (nonatomic, assign) BOOL isMoving;       //正在拖动
@property (nonatomic, strong) UIView *contentView; //被拖动的view
@end

@implementation ZKRotationViewController

static const NSTimeInterval kAnimationDuration = 0.25;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    [self addGesture];
    
    // 设置锚点
    [self setAnchorPoint:CGPointMake(0.5, 1.2) forView:_contentView];
}

- (void)addGesture
{
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                            action:@selector(handlePan:)];
    [_contentView addGestureRecognizer:panGestureRecognizer];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor greenColor];
    
    self.contentView = ({
        _contentView = [[UIView alloc] init];
        _contentView.frame = self.view.bounds;
        _contentView.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:_contentView];
        _contentView;
    });
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
    CGPoint touchPoint = [panGesture locationInView:[UIApplication sharedApplication].keyWindow];
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        [self handlePanBegan:panGesture touchPoint:touchPoint];
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded ||
             panGesture.state == UIGestureRecognizerStateCancelled) {
        [self handlePanEnded:panGesture touchPoint:touchPoint];
        return;
    }
    if (_isMoving) {
        NSLog(@"touchPoint======%f",touchPoint.x);
        NSLog(@"_startPoint=====%f",_startPoint.x);
        [self moveViewWithX:touchPoint.x - _startPoint.x];
    }
}

- (void)handlePanBegan:(UIPanGestureRecognizer *)panGesture
            touchPoint:(CGPoint)touchPoint
{
    _isMoving = YES;
    _startPoint = touchPoint;
}

- (void)handlePanEnded:(UIPanGestureRecognizer *)panGrsture
            touchPoint:(CGPoint)touchPoint
{
    if (touchPoint.x - _startPoint.x > ScreenWidth * 0.5) {
        [self rotationAnimation:^{
            [self moveViewWithX:1910.f];
        }];
    }
    else if (touchPoint.x - _startPoint.x < -ScreenWidth * 0.5) {
        [self rotationAnimation:^{
            [self moveViewWithX:-1910.f];
        }];
    }
    else {
        [self rotationAnimation:^{
            _contentView.transform = CGAffineTransformIdentity;
        }];
    }
}

#pragma mark *** 私有方法 ***
- (void)rotationAnimation:(void(^__nullable)())animations
{
    [UIView animateWithDuration:kAnimationDuration
                     animations:animations
                     completion:^(BOOL finished) {
        _isMoving = NO;
    }];
}

- (void)moveViewWithX:(CGFloat)x
{
    //计算角度
    double angle = M_PI/6 * (x / ScreenWidth);
    //旋转
    _contentView.transform = CGAffineTransformMakeRotation(angle);
}

@end
