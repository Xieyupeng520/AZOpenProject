//
//  ViewController.m
//  OpenProject
//
//  Created by 阿曌 on 2019/2/18.
//  Copyright © 2019 阿曌. All rights reserved.
//

#import "ViewController.h"
#import "CircleView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)onAddButtonClick:(id)sender {
    CircleView* circle = [CircleView new];
    [self.view addSubview:circle];
}

@end
