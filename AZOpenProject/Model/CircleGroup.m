//
//  CircleGroup.m
//  AZOpenProject
//  
//  Created by 阿曌 on 2019/2/19.
//  Copyright © 2019 阿曌. All rights reserved.
//

#import "CircleGroup.h"

@implementation CircleGroup

- (instancetype)init {
    if (self = [super init]) {
        self.circleLists = [NSMutableArray array];
    }
    return self;
}

- (void)addNewCircleListWith:(CircleModel*)circleModel {
    [self.circleLists addObject:[[CircleLinkedList alloc] initWithStartCircle:circleModel]];
}

@end
