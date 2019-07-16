//
//  MuiscTabViewController.m
//  Montage
//
//  Created by MacBookPro on 6/3/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "MuiscTabViewController.h"

@interface MuiscTabViewController ()

@end

@implementation MuiscTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    float x = self.navigationController.navigationBar.frame.size.width;
    // yStatusBar indicates the height of the status bar
    
    float y =  [UIApplication sharedApplication].statusBarFrame.size.height;
    
//    _TabBar.frame = CGRectMake(0, 10+x + _TabBar.frame.size.height, _TabBar.frame.size.width, _TabBar.frame.size.height);
//    [_TabBar setFrame:CGRectMake(0, 10+x + _TabBar.frame.size.height, _TabBar.frame.size.width, _TabBar.frame.size.height)];
    
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    //self.tabBar.frame=CGRectMake(0, self.tabBar.frame.size.height+15, self.tabBar.frame.size.width,statusBarHeight);
    

    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.origin.y = self.view.frame.origin.y+65;
    self.tabBar.frame = tabFrame;
}

-(void)viewDidAppear:(BOOL)animated{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
