//
//  CircleLinkedList.h
//  OpenProject
//  圆链表
//  Created by 阿曌 on 2019/2/18.
//  Copyright © 2019 阿曌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CircleModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CircleLinkedList : NSObject

@property(nonatomic, strong) CircleModel* startCircle;

- (instancetype)initWithStartCircle:(CircleModel*)circle;

/** 某个圆是否在链表内
 */
- (BOOL)isCircleIn:(CircleModel*)circle;

/** 添加一个圆
 *  before和after的圆需要在链表内，若不在则和传nil效果一样
 *  若before和after的圆都为nil，或者相同，则添加失败返回NO
 *  添加成功返回YES
 */
- (BOOL)addCircle:(CircleModel*)circle before:(CircleModel*)nextCircle after:(CircleModel*)preCircle;

/** 删除一个圆
 *  若删除的是中间节点，可能会变为两个链表
 *  返回的是删除节点之后的圆链表，可能为nil
 */
- (CircleLinkedList*)deleteCircle:(CircleModel*)circle;

/** 删除整条链表
 */
- (void)delete;

/** 链表内元素总数
 */
- (int)count;
@end

NS_ASSUME_NONNULL_END
