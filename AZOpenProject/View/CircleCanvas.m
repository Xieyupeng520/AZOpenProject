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

@interface CircleCanvas() <CircleViewDelegate>

@property(nonatomic, strong) CircleGroup* circleGroup;

@property(nonatomic, weak) CircleView* selectedView; //当前是否有选中view

@end

@implementation CircleCanvas

- (instancetype)init {
    if (self = [super init]) {
        self.circleGroup = [CircleGroup new];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.circleGroup = [CircleGroup new];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)addNewCircleAt:(CGPoint)center {
    CircleModel* model = [CircleModel new];
    model.centerPoint = center;
    
    [self.circleGroup addNewCircleListWith:model];
    
    CircleView* newCircle = [CircleView newWithModel:model];
    newCircle.circleViewDelegate = self;
    [self addSubview:newCircle];
    
    //添加手势
    UITapGestureRecognizer* tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [newCircle addGestureRecognizer:tapG];
}

#pragma mark - 手势处理
///点击手势
- (void)onTap:(UITapGestureRecognizer*)tapRecognizer {
    CircleView *touchView = (CircleView*)tapRecognizer.view;
    [touchView setSelected:!touchView.selected];
    
    if(self.selectedView) { //选中第二个就当没选中
        self.selectedView = nil;
    } else { //选中第一个记录下来
        self.selectedView = touchView;
    }
}

#pragma mark - CircleViewDelegate
- (CircleView *)hasSelectedView {
    return self.selectedView;
}
@end
