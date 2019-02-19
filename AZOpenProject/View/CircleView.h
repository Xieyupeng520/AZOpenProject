//
//  CircleView.h
//  AZOpenProject
//  单个圆UI
//  Created by cocozzhang on 2019/2/19.
//  Copyright © 2019 阿曌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleModel.h"

#define CIRCLE_RADIUS (64)          //默认半径
#define CIRCLE_BORDER_WIDTH (3)     //边框宽度

NS_ASSUME_NONNULL_BEGIN

@protocol CircleViewDelegate;

@interface CircleView : UIView

@property(nonatomic, strong, nonnull) CircleModel* circleModel;
@property(nonatomic, assign, getter=isSelected) BOOL selected;
@property(nonatomic, weak) id<CircleViewDelegate> circleViewDelegate;

- (instancetype)initWithCenter:(CGPoint)center;

+ (instancetype)newWithModel:(CircleModel*)model;

/** 删除该圆
 *  会把该圆关联的model解除监听
 */
- (void)delete;
@end

@protocol CircleViewDelegate <NSObject>

/** 是否已经有被选中的view了
 *  如果返回nil表示当前没有选中的圆；否则表示已有选中的圆。
 *  判断当前是否有选中的圆会影响到圆的边框颜色状态。
 */
- (CircleView*)hasSelectedView;

@end

NS_ASSUME_NONNULL_END
