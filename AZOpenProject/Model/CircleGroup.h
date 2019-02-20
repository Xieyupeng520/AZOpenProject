//
//  CircleGroup.h
//  AZOpenProject
//  圆组，里面可能存在多个链表
//  Created by 阿曌 on 2019/2/19.
//  Copyright © 2019 阿曌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CircleLinkedList.h"

NS_ASSUME_NONNULL_BEGIN

@interface CircleGroup : NSObject

@property(nonatomic, strong) NSMutableArray<CircleLinkedList*>* circleLists;

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
@end

NS_ASSUME_NONNULL_END
