//
//  CircleLinkedList.m
//  OpenProject
//
//  Created by 阿曌 on 2019/2/18.
//  Copyright © 2019 阿曌. All rights reserved.
//

#import "CircleLinkedList.h"

@implementation CircleLinkedList

- (instancetype)initWithStartCircle:(CircleModel*)circle {
    if (self = [super init]) {
        self.startCircle = circle;
    }
    return self;
}

- (BOOL)isCircleIn:(CircleModel*)circle {
    if (!circle || !self.startCircle) {
        return NO;
    }
    
    CircleModel* curCircle = self.startCircle;
    while (curCircle) {
        if (curCircle == circle) {
            return YES;
        }
        curCircle = curCircle.nextCircle;
    }
    return NO;
}
- (BOOL)isCircleEqualHead:(CircleModel*)circle {
    if (!circle || !self.startCircle) {
        return NO;
    }
    return self.startCircle == circle;
}

- (BOOL)isCircleEqualEnd:(CircleModel*)circle {
    if (!circle || !self.startCircle) {
        return NO;
    }
    CircleModel* curCircle = self.startCircle;
    while (curCircle) {
        if (curCircle == circle) {
            return NO;
        }
        curCircle = curCircle.nextCircle;
    }
    return curCircle == circle;
}

- (BOOL)addCircle:(CircleModel *)circle before:(CircleModel *)nextCircle after:(CircleModel *)preCircle {
    if ((!nextCircle && !preCircle) || nextCircle == preCircle) {
        return NO;
    }
    
    BOOL isNextCircleExist = [self isCircleIn:nextCircle];
    BOOL isPreCircleExist = [self isCircleIn:preCircle];
    
    if (!isPreCircleExist && !isNextCircleExist) {
        return NO;
    }
    
    if (isPreCircleExist) {
        preCircle.nextCircle = circle;
        circle.preCircle = preCircle;
    }
    
    if (isNextCircleExist) {
        nextCircle.preCircle = circle;
        circle.nextCircle = nextCircle;
        if (nextCircle == self.startCircle) { //头插
            self.startCircle = circle;
        }
    }
    return YES;
}

- (CircleLinkedList *)deleteCircle:(CircleModel *)circle {
    if (!circle) {
        return nil;
    }
    
    if ([self isCircleEqualHead:circle]) { //头元素
        NSLog(@"delete head circle:%@", circle.title);
        self.startCircle = circle.nextCircle;
        [circle delete];
    } else if ([self isCircleEqualEnd:circle]) { //尾元素
        NSLog(@"delete end circle:%@", circle.title);
        [circle delete];
    } else { //中间元素
        NSLog(@"delete center circle:%@, newListHead:%@", circle.title, circle.nextCircle.title);
        CircleLinkedList* newList = [[CircleLinkedList alloc] initWithStartCircle:circle.nextCircle];
        [circle delete];
        return newList;
    }
    
    return nil;
}

- (void)delete {
    CircleModel* curCircle = self.startCircle;
    CircleModel* delCircle = curCircle;
    while (curCircle) {
        curCircle = curCircle.nextCircle;
        [delCircle delete];
        delCircle = curCircle;
    }
}

- (int)count {
    CircleModel* curCircle = self.startCircle;
    int count = 0;
    while (curCircle) {
        curCircle = curCircle.nextCircle;
        count ++;
    }
    NSLog(@"以(%@)开头的链表元素个数为%d", self.startCircle.title, count);
    return count;
}

- (NSString *)description {
    NSString* result = @"<";
    
    CircleModel* curCircle = self.startCircle;
    while (curCircle) {
        result = [result stringByAppendingString:curCircle.title];
        curCircle = curCircle.nextCircle;
        if (curCircle) {
            result = [result stringByAppendingString:@", "];
        }
    }
    return [result stringByAppendingString:@">"];
}
@end
