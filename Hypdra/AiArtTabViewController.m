//  AiArtTabViewController.m
//  Hypdra
//  Created by Mac on 12/24/18.
//  Copyright © 2018 sssn. All rights reserved.

#import "AiArtTabViewController.h"
#import "REFrostedViewController.h"
#import "DEMORootViewController.h"

@interface AiArtTabViewController ()<UITabBarControllerDelegate>

@end

@implementation AiArtTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)menu_actn:(id)sender {
    [self.view endEditing:YES];
    
    [self.frostedViewController.view endEditing:YES];
    
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)back_actn:(id)sender {
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"demo_pageselection" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}
@end
