//
//  CircleCanvas.h
//  AZOpenProject
//  画布
//  Created by cocozzhang on 2019/2/19.
//  Copyright © 2019 阿曌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircleCanvas : UIView

/** 在某个位置新增圆
 */
- (void)addNewCircleAt:(CGPoint)center;

/** 在某个区域内随机位置新增圆
 */
- (void)addNewCircleRandomIn:(CGRect)area;

@end

NS_ASSUME_NONNULL_END
