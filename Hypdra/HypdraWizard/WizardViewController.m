//
//  WizardViewController.m
//  Montage
//
//  Created by MacBookPro4 on 6/5/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "WizardViewController.h"
#import "DEMOHomeViewController.h"
#import "DEMORootViewController.h"
#import "PageSelectionViewController.h"

@interface WizardViewController ()

@end

@implementation WizardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _createMovie.titleLabel.minimumScaleFactor = 0.5;
    _createMovie.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (IBAction)createMovieAction:(id)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_6" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
}


- (IBAction)backAction:(id)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DEMORootViewController *vc1 = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc1 awakeFromNib:@"demo_pageselection" arg:@"menuController"];
    
    vc1.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc1 animated:YES completion:nil];
    
}


@end

