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

@property(nonatomic, copy) NSMutableArray<CircleLinkedList*>* circleLists;

- (void)addNewCircleListWith:(CircleModel*)circleModel;
@end

NS_ASSUME_NONNULL_END
