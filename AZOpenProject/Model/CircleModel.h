//
//  Circle.h
//  OpenProject
//  圆数据模型
//  Created by 阿曌 on 2019/2/18.
//  Copyright © 2019 阿曌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircleModel : NSObject

@property(nonatomic, copy) NSString* title;
@property(nonatomic, assign) CGPoint centerPoint;
@property(nonatomic, assign) float radius;

@property(nonatomic, strong, nullable) CircleModel* preCircle;
@property(nonatomic, strong, nullable) CircleModel* nextCircle;

/** 删除该圆
 *  会把该圆关联的前后圆和该圆的关系断掉
 */
- (void)delete;

@end

NS_ASSUME_NONNULL_END
