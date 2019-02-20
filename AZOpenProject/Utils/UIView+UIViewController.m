//
//  UIView+UIViewController.m
//  AZOpenProject
//
//  Created by cocozzhang on 2019/2/20.
//  Copyright © 2019 阿曌. All rights reserved.
//

#import "UIView+UIViewController.h"

@implementation UIView (UIViewController)

- (UIViewController*)viewController {
    id responder = self;
    
    while (responder && ![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
    }
    
    if ([responder isKindOfClass:[UIViewController class]]) {
        return responder;
    }else{
        return nil;
    }
}

@end
