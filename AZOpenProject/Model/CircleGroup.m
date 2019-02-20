//
//  CircleGroup.m
//  AZOpenProject
//  
//  Created by 阿曌 on 2019/2/19.
//  Copyright © 2019 阿曌. All rights reserved.
//

#import "CircleGroup.h"


static const NSArray<NSString*>* TITLE_LIST() {
    return @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
}
#define PLACEHOLDER_STRING @"-1" //表示已被使用，用来占位的字符

@interface CircleGroup()

@property(nonatomic, strong) NSMutableArray<NSString*>* titleList;

@end
@implementation CircleGroup

- (instancetype)init {
    if (self = [super init]) {
        self.circleLists = [NSMutableArray arrayWithCapacity:TITLE_LIST().count];
        self.titleList = [TITLE_LIST() mutableCopy];
    }
    return self;
}

#pragma mark - 判断
- (BOOL)isBothInOneList:(CircleModel*)circle1 and:(CircleModel*)circle2 {
    for (CircleLinkedList* list in self.circleLists) {
        if ([list isCircleIn:circle1] && [list isCircleIn:circle2]) {
            return YES;
        }
    }
    return NO;
}
#pragma mark - 新增
///新增圆链表
- (BOOL)addNewCircleListWith:(CircleModel*)circleModel {
    NSString* title = [self _requireValidTitle];
    if (!title) {
        return NO;
    }
    
    [self.circleLists addObject:[[CircleLinkedList alloc] initWithStartCircle:circleModel]];
    
    circleModel.title = title;
    
    return YES;
}

///新增关联
- (void)addLinkWith:(CircleModel*)preCircle and:(CircleModel*)nextCircle {
    if (!preCircle || !nextCircle) {
        NSAssert(0, @"两个圆没有绑定自己的数据模型？");
        return;
    }
    NSLog(@"圆(%@)和圆(%@)建立关联", preCircle.title, nextCircle.title);
    if (!preCircle.nextCircle && //圆1没有出点
        !nextCircle.preCircle && //圆2没有入点
        preCircle.preCircle != nextCircle) { //圆1的入点不等于圆2（圆2的出点不等于圆1）
        for (CircleLinkedList* list in self.circleLists) {
            if ([list isCircleIn:nextCircle]) {
                [self.circleLists removeObject:list]; //即将被合并到preCircle所在链表中去了
                break;
            }
        }
        preCircle.nextCircle = nextCircle;
        nextCircle.preCircle = preCircle;
        
    } else {
        NSLog(@"圆(%@)和圆(%@)建立关联失败", preCircle.title, nextCircle.title);
    }
}

#pragma mark - 删除
///删除两圆之间的关联
- (void)delLinkWith:(CircleModel*)circle1 and:(CircleModel*)circle2 {
    NSLog(@"删除圆(%@)和圆(%@)的关联", circle1.title, circle2.title);
    
    if (circle1.preCircle == circle2) {
        circle1.preCircle = nil;
        circle2.nextCircle = nil;
        [self.circleLists addObject:[[CircleLinkedList alloc] initWithStartCircle:circle1]];
    } else if (circle2.preCircle == circle1) {
        circle1.nextCircle = nil;
        circle2.preCircle = nil;
        [self.circleLists addObject:[[CircleLinkedList alloc] initWithStartCircle:circle2]];
    } else {
        NSLog(@"圆(%@)和圆(%@)本来就没有关联", circle1.title, circle2.title);
    }
}

//删除圆
- (void)delCircle:(CircleModel*)delCircle {
    CircleLinkedList* newList = nil;
    for (CircleLinkedList* list in self.circleLists) {
        if ([list isCircleIn:delCircle]) {
            newList = [list deleteCircle:delCircle];
            if (list.count == 0) {
                [self.circleLists removeObject:list];
            }
            break;
        }
    }
    if (newList) {
        [self.circleLists addObject:newList];
    }
    
    [self resetTitle:delCircle.title];
}

#pragma mark - private method
///返回一个未被使用的title
- (NSString*)_requireValidTitle {
    NSString* result = nil;
    for(int i = 0; i < self.titleList.count; i++) {
        if (![self.titleList[i] isEqualToString:PLACEHOLDER_STRING]) {
            result = self.titleList[i];
            self.titleList[i] = PLACEHOLDER_STRING;
            break;
        }
    }
    NSLog(@"%s: %@ /n curList:[%@]", __FUNCTION__, result, self.titleList.description);
    return result;
}

- (void)resetTitle:(NSString*)title {
    NSArray<NSString*>* orignalArr = [TITLE_LIST() copy];
    for(int i = 0; i < self.titleList.count; i++) {
        if (i < orignalArr.count && [orignalArr[i] isEqualToString:title]) {
            self.titleList[i] = title;
            break;
        }
    }
}

@end
