//
//  CircleManager.h
//  AZOpenProject
//  单例管理类
//  Created by cocozzhang on 2019/2/21.
//  Copyright © 2019 阿曌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CircleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CircleManager : NSObject

+ (instancetype)getInstance;

@end

@interface CircleManager (Canvas)
/** 枚举当前存在的所有关联
 */
- (void)enumAllLink:(void (^)(CircleModel* fromCircle, CircleModel* toCircle))processBlock;

/** 新增圆到圆链表组
 *  return NO 表示添加失败，原因可能是圆超过当前允许添加的最多个数（10个）
 */
- (BOOL)addNewCircleListWith:(CircleModel*)circleModel;

/** 新增两圆之间的关联
 *  preCircle → nextCircle
 */
- (void)addLinkWith:(CircleModel*)preCircle and:(CircleModel*)nextCircle;

/** 删除两圆之间的关联
 */
- (void)delLinkWith:(CircleModel*)circle1 and:(CircleModel*)circle2;

/** 删除圆
 *  return YES表示删除成功；NO表示只剩一个圆了，删除不成功
 */
- (BOOL)delCircle:(CircleModel*)delCircle;

/** 判断两个圆是否在同一链表内
 */
- (BOOL)isBothInOneList:(CircleModel*)circle1 and:(CircleModel*)circle2;
@end

@interface CircleManager (DetailViewController)
/** 返回最长链表对应下标的title
 */
-(NSString*)titleWithIndex:(int)index;

@end
NS_ASSUME_NONNULL_END
