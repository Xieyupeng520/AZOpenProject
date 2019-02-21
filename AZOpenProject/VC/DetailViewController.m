//
//  DetailViewController.m
//  AZOpenProject
//
//  Created by cocozzhang on 2019/2/21.
//  Copyright © 2019 阿曌. All rights reserved.
//

#import "DetailViewController.h"
#import "CircleManager.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation DetailViewController

- (instancetype)initWithIndex:(int)index {
    if (self = [super init]) {
        _index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"第%d页", self.index+1];
    
    NSString* title = [[CircleManager getInstance] titleWithIndex:self.index];
    self.showLabel.text = title;
    
    //如果下一页没有title就不展示a下一页按钮
    if (![[CircleManager getInstance] titleWithIndex:self.index+1]) {
        self.nextButton.hidden = YES;
    }
}

- (IBAction)onNextButtonClick:(id)sender {
    DetailViewController* nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    nextVC.index = self.index+1;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (IBAction)onHomeButtonClick:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
