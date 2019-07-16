//
//  SetTitleViewController.m
//  Montage
//
//  Created by MacBookPro on 4/6/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "SetTitleViewController.h"

@interface SetTitleViewController ()
{
    NSString *titleImage,*titleName;
}

@end

@implementation SetTitleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)Done:(id)sender
{
    if (self.setTitle.text.length!=0)
    {
        titleImage = [[NSUserDefaults standardUserDefaults]objectForKey:@"GetTextValue"];
        titleName = self.setTitle.text;
        
        
        NSString *theFileName = [[titleImage lastPathComponent] stringByDeletingPathExtension];

        
        NSDictionary *dict = @{@"titleImage":theFileName , @"titleName": titleName};
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"setTitleText"
         object:dict];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Error"  message:nil  preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
