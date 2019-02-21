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
@property (weak, nonatomic) IBOutlet UIButton *previewButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化第一个圆
    [self.circleCanvas addNewCircleAt:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))];
}

- (IBAction)onAddButtonClick:(id)sender {
    static int gap = 12;
    [self.circleCanvas addNewCircleRandomIn:
     CGRectMake(gap,
                CGRectGetMaxY(self.previewButton.frame) + gap,
                CGRectGetWidth(self.view.bounds) - gap*2,
                CGRectGetMinY(self.addButton.frame) - CGRectGetMaxY(self.previewButton.frame) - gap*2)];
}

- (IBAction)onPreviewButtonClick:(id)sender {
    NSLog(@"点击预览");
}

@end
