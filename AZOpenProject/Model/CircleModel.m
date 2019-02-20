//
//  Circle.m
//  OpenProject
//
//  Created by 阿曌 on 2019/2/18.
//  Copyright © 2019 阿曌. All rights reserved.
//

#import "CircleModel.h"

@implementation CircleModel

- (void)delete {
    NSLog(@"delete circle:%@", self.title);
    
    self.preCircle.nextCircle = nil;
    self.nextCircle.preCircle = nil;
    self.preCircle = nil;
    self.nextCircle = nil;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"title:%@, preTitle:%@, nextTitle:%@", self.title, self.preCircle.title, self.nextCircle.title];
}
@end
