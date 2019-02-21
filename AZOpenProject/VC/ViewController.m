//
//  ViewController.m
//  OpenProject
//
//  Created by 阿曌 on 2019/2/18.
//  Copyright © 2019 阿曌. All rights reserved.
//

#import "ViewController.h"
#import "CircleCanvas.h"
#import "DetailViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet CircleCanvas *circleCanvas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化一个圆
    [self.circleCanvas addNewCircleAt:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))];
}

- (IBAction)onAddButtonClick:(id)sender {
    [self.circleCanvas addNewCircleAt:CGPointMake(CGRectGetMidX(self.circleCanvas.bounds), CGRectGetMidY(self.circleCanvas.bounds))];
}

- (IBAction)onPreviewButtonClick:(id)sender {
    NSLog(@"点击预览");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
//        UINavigationController* nav = segue.destinationViewController;
//        if (nav.viewControllers.count > 0) {
//            UIViewController* vc = nav.viewControllers[0];
//            if ([vc isKindOfClass:[DetailViewController class]]) {
//                ((DetailViewController*)vc).index = 0;
//            }
//        }
//    }
}
@end
