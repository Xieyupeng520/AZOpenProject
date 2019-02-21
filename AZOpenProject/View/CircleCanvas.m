//
//  CircleCanvas.m
//  AZOpenProject
//
//  Created by cocozzhang on 2019/2/19.
//  Copyright © 2019 阿曌. All rights reserved.
//

#import "CircleCanvas.h"
#import "CircleView.h"
#import "UIView+UIViewController.h"
#import "CircleManager.h"

@interface CircleCanvas() <CircleViewDelegate>

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
}

#pragma mark - 绘图
- (void)drawRect:(CGRect)rect {
    [[CircleManager getInstance] enumAllLink:^(CircleModel * _Nonnull fromCircle, CircleModel * _Nonnull toCircle) {
        [self drawLineFrom:fromCircle To:toCircle];
    }];
}

- (void)drawLineFrom:(CircleModel*)fromCircle To:(CircleModel*)toCircle {
    float from_x = fromCircle.centerPoint.x;
    float from_y = fromCircle.centerPoint.y;
    float to_x = toCircle.centerPoint.x;
    float to_y = toCircle.centerPoint.y;
    float r = fromCircle.radius;
    
    //画线
    float angle1,line_from_x,line_from_y,line_to_x,line_to_y;
    angle1 = atanf((to_x - from_x) / (to_y - from_y));
    
    if (from_y > to_y) { //一二象限
        line_from_x = -sinf(angle1) * r + from_x;
        line_from_y = -cosf(angle1) * r + from_y;
        line_to_x = sinf(angle1) * r + to_x;
        line_to_y = cosf(angle1) * r + to_y;
    } else { //三四象限
        line_from_x = sinf(angle1) * r + from_x;
        line_from_y = cosf(angle1) * r + from_y;
        line_to_x = -sinf(angle1) * r + to_x;
        line_to_y = -cosf(angle1) * r + to_y;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] setStroke];
    CGContextSetLineWidth(ctx, 3);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextMoveToPoint(ctx, line_from_x, line_from_y);
    CGContextAddLineToPoint(ctx, line_to_x, line_to_y);
    CGContextStrokePath(ctx);
    
    //画顶点圆
    CGContextAddArc(ctx, line_to_x, line_to_y, 5, 0, 2 * M_PI, 0);
    CGContextFillPath(ctx);
}

#pragma mark - 新增圆
- (void)addNewCircleRandomIn:(CGRect)area {
    //保证圆能完整显示在区域内
    CGFloat deltaWidth = CGRectGetWidth(area) - CIRCLE_RADIUS*2;
    CGFloat deltaHeight = CGRectGetHeight(area) - CIRCLE_RADIUS*2;
    CGFloat minX = CGRectGetMinX(area) + CIRCLE_RADIUS;
    CGFloat minY = CGRectGetMinY(area) + CIRCLE_RADIUS;
    
    CGFloat randomX = arc4random_uniform(deltaWidth+1);
    CGFloat randomY = arc4random_uniform(deltaHeight+1);
    
    [self addNewCircleAt:CGPointMake(minX + randomX, minY + randomY)];
}

- (void)addNewCircleAt:(CGPoint)center {
    CircleModel* model = [CircleModel new];
    model.centerPoint = center;
    
    BOOL addSucc = [[CircleManager getInstance] addNewCircleListWith:model];
    
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
    //点击
    UITapGestureRecognizer* tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [newCircle addGestureRecognizer:tapG];
    
    //移动
    UIPanGestureRecognizer* panG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [newCircle addGestureRecognizer:panG];
    
    //长按
    UILongPressGestureRecognizer* longPressG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [newCircle addGestureRecognizer:longPressG];
}

#pragma mark - 选中圆
- (void)dealSelectedCircle:(CircleView*)newCircle {
    CircleView* oldCircle = [self hasSelectedView];
    if (!oldCircle || oldCircle == newCircle) { //nil表示当前圆为第一个被选中的,ui处理就行
        //do nothing
    } else {
        if (oldCircle.circleModel.preCircle == newCircle.circleModel ||
            oldCircle.circleModel.nextCircle == newCircle.circleModel) {
            //存在关联，则提示弹框可以删除关联
            [self showDelTipsWithMsg:@"确认删除选中的两圆之间的关联吗？" delHandler:^{
                [[CircleManager getInstance] delLinkWith:oldCircle.circleModel and:newCircle.circleModel];
                [oldCircle setSelected:NO];
                [newCircle setSelected:NO];
                [self setNeedsDisplay];
            } cancelHandler:^{
                [oldCircle setSelected:NO];
                [newCircle setSelected:NO];
            }];
        } else if ([[CircleManager getInstance] isBothInOneList:oldCircle.circleModel and:newCircle.circleModel]) { //俩圆在同一条链表的首尾
            [self showTips:@"无法建立循环关联"];
            [oldCircle setSelected:NO];
            [newCircle setSelected:NO];
        } else if (oldCircle.circleModel.preCircle != newCircle.circleModel &&
                   oldCircle.circleModel.nextCircle != newCircle.circleModel &&
                   !oldCircle.circleModel.nextCircle &&
                   !newCircle.circleModel.preCircle) {
            //可建立关联
            [[CircleManager getInstance] addLinkWith:oldCircle.circleModel and:newCircle.circleModel];
            [oldCircle setSelected:NO];
            if (!newCircle.circleModel.nextCircle) { //没有下一个
                self.selectedView = newCircle; //允许连续建立关联关键代码
                [self setNeedsDisplay];
                return;
            } else {
                [newCircle setSelected:NO];
                [self setNeedsDisplay];
            }
        } else {
            [self showTips:@"无法给选中的两个圆建立关联"];
            [oldCircle setSelected:NO];
            [newCircle setSelected:NO];
        }
    }
    
    if(self.selectedView) { //选中第二个就当没选中
        self.selectedView = nil;
    } else { //选中第一个记录下来
        self.selectedView = newCircle;
    }
}

#pragma mark - 删除圆
- (void)deleteCircle:(CircleView*)delCircle {
    BOOL delSucc = [[CircleManager getInstance] delCircle:delCircle.circleModel];
    if (!delSucc) {
        [self showTips:@"再删就没东西预览了！"];
        [delCircle setSelected:NO];
        return;
    }
    [delCircle delete];
    [delCircle removeFromSuperview];
    
    [self setNeedsDisplay];
}

#pragma mark - 手势处理
///点击手势
- (void)onTap:(UITapGestureRecognizer*)tapRecognizer {
    CircleView *touchView = (CircleView*)tapRecognizer.view;
    NSLog(@"%s : %@", __FUNCTION__, touchView.circleModel.title);
    //UI处理
    [touchView setSelected:!touchView.selected];
    //逻辑处理
    [self dealSelectedCircle:touchView];
}

- (void)onPan:(UIPanGestureRecognizer*)panRecognizer {
    CircleView *touchView = (CircleView*)panRecognizer.view;
    CGPoint touchPoint = [panRecognizer locationInView:self];
//    NSLog(@"%s touch Point : %f, %f", __FUNCTION__, touchPoint.x, touchPoint.y);
    touchView.circleModel.centerPoint = touchPoint;
    
    [self setNeedsDisplay];
}

- (void)onLongPress:(UILongPressGestureRecognizer*)longPressRecognizer {
    CircleView *touchView = (CircleView*)longPressRecognizer.view;
    [touchView setBorderDelColor];
    [self showDelTipsWithMsg:@"确认删除选中的圆吗？" delHandler:^{
        [self deleteCircle:touchView];
    } cancelHandler:^{
        [touchView setSelected:NO];
    }];
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

- (void)showDelTipsWithMsg:(NSString*)msg delHandler:(void (^ __nullable)(void))delHandler cancelHandler:(void (^ __nullable)(void))cancelHandler {
    NSLog(@"%s", __FUNCTION__);
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"删除" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelHandler) {
            cancelHandler();
        }
    }];
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
