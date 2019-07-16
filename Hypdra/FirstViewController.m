//
//  FirstViewController.m
//  EmbeddedSwapping
//
//  Created by Michael Luton on 2/15/13.
//  Copyright (c) 2013 Sandmoose Software. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstMoveViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSLog(@"FirstViewController - viewDidLoad");
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"FirstViewController - viewDidLoad");

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)move:(id)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    FirstMoveViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"FirstMove"];
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
