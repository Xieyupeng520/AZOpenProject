//
//  ViewController.m
//  OpenProject
//
//  Created by 阿曌 on 2019/2/18.
//  Copyright © 2019 阿曌. All rights reserved.
//

#import "ViewController.h"
#import "CircleCanvas.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet CircleCanvas *circleCanvas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)onAddButtonClick:(id)sender {
    [self.circleCanvas addNewCircleAt:CGPointMake(CGRectGetMidX(self.circleCanvas.bounds), CGRectGetMidY(self.circleCanvas.bounds))];
}

@end
