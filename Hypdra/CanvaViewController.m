//
//  CanvaViewController.m
//  Hypdra
//  Created by Mac on 2/8/19.
//  Copyright © 2019 sssn. All rights reserved.

#import "CanvaViewController.h"
#import "DEMORootViewController.h"

@interface CanvaViewController ()

@end

@implementation CanvaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *backgroundImage=[UIImage imageNamed:@"tag-1"];//@"background_about_us_row_item.9"];
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithPatternImage:backgroundImage];
    NSURL *url = [NSURL URLWithString:@"https://www.hypdra.com/canvamate/"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.WebView loadRequest:request];}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back_btn:(id)sender {
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"demo_pageselection" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
    
}
@end
