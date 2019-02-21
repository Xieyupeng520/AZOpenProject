//
//  CircleManager.m
//  AZOpenProject
//
//  Created by cocozzhang on 2019/2/21.
//  Copyright © 2019 阿曌. All rights reserved.
//

#import "CircleManager.h"
#import "CircleGroup.h"

@interface CircleManager()

@property(nonatomic, strong) CircleGroup* circleGroup;

@end

@implementation CircleManager

+ (instancetype)getInstance {
    static CircleManager *instance = nil;
    static dispatch_once_t OnceToken;
    dispatch_once(&OnceToken, ^{
        instance = [CircleManager new];
    });
    
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.circleGroup = [CircleGroup new];
    }
    return self;
}

@end

@implementation CircleManager (Canvas)
///枚举当前存在的所有关联
- (void)enumAllLink:(void (^)(CircleModel* fromCircle, CircleModel* toCircle))processBlock {
    for (CircleLinkedList* linkList in self.circleGroup.circleLists) {
        CircleModel* circle1 = linkList.startCircle;
        CircleModel* circle2;
        while (circle1.nextCircle) {
            circle2 = circle1.nextCircle;
            if (processBlock) {
                processBlock(circle1, circle2);
            }
            circle1 = circle2;
        }
    }
}

- (BOOL)addNewCircleListWith:(CircleModel *)circleModel {
    return [self.circleGroup addNewCircleListWith:circleModel];
}

- (void)addLinkWith:(CircleModel *)preCircle and:(CircleModel *)nextCircle {
    [self.circleGroup addLinkWith:preCircle and:nextCircle];
}

- (BOOL)delCircle:(CircleModel *)delCircle {
    if ([self.circleGroup isExistOnlyOneCircle]) {
        return NO;
    }
    
    [self.circleGroup delCircle:delCircle];
    return YES;
}

- (void)delLinkWith:(CircleModel *)circle1 and:(CircleModel *)circle2 {
    [self.circleGroup delLinkWith:circle1 and:circle2];
}

- (BOOL)isBothInOneList:(CircleModel *)circle1 and:(CircleModel *)circle2 {
    return [self.circleGroup isBothInOneList:circle1 and:circle2];
}
@end

@implementation CircleManager (DetailViewController)

- (NSString *)titleWithIndex:(int)index {
    CircleLinkedList* list = [self.circleGroup longestLinkList];
    if (list && list.count > index) {
        return [list circleAt:index].title;
    }
    return nil;
}

@end
