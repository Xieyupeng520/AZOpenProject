//
//  CircleView.m
//  AZOpenProject
//
//  Created by cocozzhang on 2019/2/19.
//  Copyright © 2019 阿曌. All rights reserved.
//

#import "CircleView.h"

///默认边框颜色
static const CGColorRef DefaultBorderColor() {
    return UIColor.blackColor.CGColor;
}
///允许增加关联时的选中边框颜色
static const CGColorRef SelectedBorderColor_Add() {
    return UIColor.greenColor.CGColor;
}
///允许删除关联时的选中边框颜色
static const CGColorRef SelectedBorderColor_Del() {
    return UIColor.redColor.CGColor;
}

@interface CircleView()

@property(nonatomic, strong) UILabel* titleLabel;

@end

@implementation CircleView

///默认显示在屏幕中央
- (instancetype)init {
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    CGRect rect = window.bounds;
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    return [self initWithCenter:center];
}

+ (instancetype)newWithModel:(CircleModel*)model {
    CircleView* circle = [[CircleView alloc] initWithCenter:model.centerPoint];
    circle.circleModel = model;
    [circle setTitle:model.title];
    model.radius = CGRectGetWidth(circle.bounds)/2;
    return circle;
}

- (instancetype)initWithCenter:(CGPoint)center {
    CGRect frame = CGRectMake(center.x - CIRCLE_RADIUS, center.y - CIRCLE_RADIUS, CIRCLE_RADIUS*2, CIRCLE_RADIUS*2);
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = CGRectGetWidth(frame)/2;
        [self setBorderDefaultColor];
        self.layer.borderWidth = CIRCLE_BORDER_WIDTH;
        self.layer.backgroundColor = UIColor.whiteColor.CGColor;
        
        self.userInteractionEnabled = YES;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        self.titleLabel.textColor = UIColor.grayColor;
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)dealloc {
    //怕忘记调用delete，在dealloc时再调用一次
    [self delete];
}

#pragma mark - setter & getter

- (void)setCircleModel:(CircleModel *)circleModel {
    _circleModel = circleModel;
    
    //KVO
    [circleModel addObserver:self forKeyPath:@"centerPoint" options:NSKeyValueObservingOptionNew context:nil];
    [circleModel addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setTitle:(NSString*)title {
    self.titleLabel.text = title;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object != self.circleModel) {
        NSAssert(0, @"监听对象错误");
    }
    
    if ([keyPath isEqualToString:@"title"]) {
        [self setTitle:self.circleModel.title];
    } else if ([keyPath isEqualToString:@"centerPoint"]) {
        self.frame = CGRectMake(self.circleModel.centerPoint.x - CGRectGetWidth(self.bounds)/2,
                                self.circleModel.centerPoint.y - CGRectGetHeight(self.bounds)/2,
                                CGRectGetWidth(self.bounds),
                                CGRectGetHeight(self.bounds));
    }
}

#pragma mark - 选中态和边框颜色
- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self changeBorderColorBySelected:_selected];
}

///根据选中态处理边框颜色
- (void)changeBorderColorBySelected:(BOOL)selected {
    if (!selected) { //未选中是黑色的
        [self setBorderDefaultColor];
    } else {
        if (self.circleViewDelegate && [self.circleViewDelegate respondsToSelector:@selector(hasSelectedView)]) {
            CircleView* view = [self.circleViewDelegate hasSelectedView];
            if (!view) { //view为nil，表示当前圆为第一个被选中的
                [self _changeBorderColorBySelected_1];
            } else if (view == self) { //两次选中当前圆，根据逻辑该条件不会走到
                NSAssert(0, @"检查下什么情况下走到这了？");
                [self setBorderDefaultColor];
            } else { //当前圆为第二个被选中的
                [self _changeBorderColorBySelected_2:view];
            }
        } else {
            [self setBorderAddColor];
        }
    }
}
/**当前圆为第一个被选中的
 * a.如果该圆没有“出点”和“入点”，点击选中后边框变为绿色，表示可建立关联；
 * b.如果该圆只有“入点”没有出点，点击选中后果边框变为半绿半红（或者黄色？），表示可建立关联或者删除关联；
 * c.如果该圆有“出点”，点击选中后边框变为红色，表示可删除关联。
 */
- (void)_changeBorderColorBySelected_1 {
    if (!self.circleModel) {
        NSAssert(0, @"没有绑定自己的数据模型？");
        return;
    }
    if (!self.circleModel.preCircle && !self.circleModel.nextCircle) {
        [self setBorderAddColor];
    } else if (self.circleModel.preCircle && !self.circleModel.nextCircle) {
        [self setBorderBothColor];
    } else if (self.circleModel) {
        [self setBorderDelColor];
    } else {
        NSAssert(0, @"检查下什么情况下走到这了？");
    }
}
/**已经选中了一个圆（圆1）时再选中另一个圆（圆2）
 * a.如果圆2和圆1存在关联，圆2变红，并弹框提示是否删除关联，若选择不删除，则圆1、圆2恢复黑色边框未选中状态；若选择删除，见3.2。
 * b.如果圆2和圆1不存在关联，且圆2没有入点，圆1没有出点，则圆2和圆1自动建立关联（无需弹框）
 * c.如果圆2和圆1不构成“新增”或者“删除”关联，则弹框报错，圆1、圆2恢复黑色边框未选中状态。
 */
- (void)_changeBorderColorBySelected_2:(CircleView*)circle1 {
    if (!self.circleModel || !circle1.circleModel) {
        NSAssert(0, @"两个圆没有绑定自己的数据模型？");
        return;
    }
    if (self.circleModel.preCircle == circle1.circleModel || self.circleModel.nextCircle == circle1.circleModel) { //存在关联
        //上层提示弹框可以删除关联，UI变红
        [self setBorderDelColor];
    } else if (self.circleModel.preCircle != circle1.circleModel &&
               self.circleModel.nextCircle != circle1.circleModel &&
               !self.circleModel.preCircle &&
               !circle1.circleModel.nextCircle) {
        [self setBorderBothColor];
        //上层可以给圆1、圆2建立关联了
    } else {
        //上层报错
    }
}

- (void)setBorderDefaultColor {
    self.layer.borderColor = DefaultBorderColor();
}
- (void)setBorderAddColor {
    self.layer.borderColor = SelectedBorderColor_Add();
}
- (void)setBorderDelColor {
    self.layer.borderColor = SelectedBorderColor_Del();
}
- (void)setBorderBothColor {
    self.layer.borderColor = UIColor.yellowColor.CGColor;
}

#pragma mark - 删除
- (void)delete {
    [self.circleModel removeObserver:self forKeyPath:@"title"];
    [self.circleModel removeObserver:self forKeyPath:@"centerPoint"];
    _circleModel = nil;
}
@end
