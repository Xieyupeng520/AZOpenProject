//
//  CircleCanvas.m
//  AZOpenProject
//
//  Created by cocozzhang on 2019/2/19.
//  Copyright © 2019 阿曌. All rights reserved.
//

#import "CircleCanvas.h"
#import "CircleView.h"
#import "CircleGroup.h"
#import "UIView+UIViewController.h"

@interface CircleCanvas() <CircleViewDelegate>

@property(nonatomic, strong) CircleGroup* circleGroup;

@property(nonatomic, weak) CircleView* selectedView; //当前是否有选中view

@end

@implementation CircleCanvas

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.circleGroup = [CircleGroup new];
}


- (void)drawRect:(CGRect)rect {
    
}

#pragma mark - 新增
#pragma mark 新增圆
- (void)addNewCircleAt:(CGPoint)center {
    CircleModel* model = [CircleModel new];
    model.centerPoint = center;
    
    BOOL addSucc = [self.circleGroup addNewCircleListWith:model];
    
    if (!addSucc) { //添加失败
        [self showTips:@"已达到添加上限"];
        return;
    }
    
    CircleView* newCircle = [CircleView newWithModel:model];
    newCircle.circleViewDelegate = self;
    [self addSubview:newCircle];
    
    //添加手势
    [self _addGesToCircle:newCircle];
}

///给圆添加手势
- (void)_addGesToCircle:(CircleView*)newCircle {
    UITapGestureRecognizer* tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [newCircle addGestureRecognizer:tapG];
    
    UIPanGestureRecognizer* panG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [newCircle addGestureRecognizer:panG];
}

#pragma mark - 选中圆
- (void)dealSelectedCircle:(CircleView*)newCircle {
    CircleView* oldCircle = [self hasSelectedView];
    if (!oldCircle) { //nil表示当前圆为第一个被选中的,ui处理就行
        return;
    } else {
        if (oldCircle.circleModel.preCircle == newCircle.circleModel ||
            oldCircle.circleModel.nextCircle == newCircle.circleModel) {
            //存在关联，则提示弹框可以删除关联
            [self showDelTipsWithDelHandler:^{
                [self.circleGroup delLinkWith:oldCircle.circleModel and:newCircle.circleModel];
                [oldCircle setSelected:NO];
                [newCircle setSelected:NO];
                [self setNeedsLayout];
            }];
        } else if (oldCircle.circleModel.preCircle != newCircle.circleModel &&
                   oldCircle.circleModel.nextCircle != newCircle.circleModel &&
                   !oldCircle.circleModel.preCircle &&
                   !newCircle.circleModel.nextCircle) {
            //可建立关联
            [self.circleGroup addLinkWith:oldCircle.circleModel and:newCircle.circleModel];
            [oldCircle setSelected:NO];
            [newCircle setSelected:NO];
            [self setNeedsLayout];
        } else {
            [self showTips:@"无法给选中的两个圆建议关联"];
            [oldCircle setSelected:NO];
            [newCircle setSelected:NO];
        }
    }
}

#pragma mark - 删除

#pragma mark - 手势处理
///点击手势
- (void)onTap:(UITapGestureRecognizer*)tapRecognizer {
    CircleView *touchView = (CircleView*)tapRecognizer.view;
    NSLog(@"%s : %@", __FUNCTION__, touchView.circleModel.title);
    //UI处理
    [touchView setSelected:!touchView.selected];
    //逻辑处理
    [self dealSelectedCircle:touchView];
    
    if(self.selectedView) { //选中第二个就当没选中
        self.selectedView = nil;
    } else { //选中第一个记录下来
        self.selectedView = touchView;
    }
}

- (void)onPan:(UIPanGestureRecognizer*)panRecognizer {
    CircleView *touchView = (CircleView*)panRecognizer.view;
    CGPoint touchPoint = [panRecognizer locationInView:self];
//    NSLog(@"%s touch Point : %f, %f", __FUNCTION__, touchPoint.x, touchPoint.y);
    touchView.circleModel.centerPoint = touchPoint;
}

#pragma mark - CircleViewDelegate
- (CircleView *)hasSelectedView {
    return self.selectedView;
}

#pragma mark - tips

- (void)showTips:(NSString*)tips {
    NSLog(@"%s:%@", __FUNCTION__, tips);
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:tips message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self.viewController presentViewController:alert animated:NO completion:nil];
}

- (void)showDelTipsWithDelHandler:(void (^ __nullable)(void))delHandler {
    NSLog(@"%s", __FUNCTION__);
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"删除关联" message:@"确认删除选中的两圆之间的关联吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    UIAlertAction* delAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (delHandler) {
            delHandler();
        }
    }];
    [alert addAction:delAction];
    [self.viewController presentViewController:alert animated:NO completion:nil];
}
@end
