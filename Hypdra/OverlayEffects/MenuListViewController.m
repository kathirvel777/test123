//
//  MenuListViewController.m
//  Montage
//
//  Created by MacBookPro on 11/13/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "MenuListViewController.h"
#import "MenuListView.h"
#import "SwipeBack.h"

@interface MenuListViewController ()
{
    NSArray *listType,*listImage;
}
@end

@implementation MenuListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.swipeBackEnabled=NO;
    listType=[[NSArray alloc]init];
    listImage=[[NSArray alloc]init];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgg-1.png"]];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    listType=@[@"",@"Dispersion",@"Festival",@"Fireworks",@"Flourish",@"Glitch",@"Love",@"Overlay",@"Particles",@"Party",@"Pointers",@"Season",@"Shapes",@"Transitions"];
    
    listImage = @[@"close_optimized",@"75-description", @"75-festival", @"75-Fireworks", @"75-Flourish", @"75-Glitch", @"75-love", @"75-overlay", @"75-Particles", @"75-party", @"75-pointer", @"75-Season", @"75-Shapes", @"75-Transitions"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listType count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MenuListView";
    
    MenuListView *cell = (MenuListView *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuListView" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.nameLabel.text = [listType objectAtIndex:indexPath.row];
    [cell.nameLabel setFont:[UIFont fontWithName:@"FuturaT-Book" size:20.0]];
    
    cell.imgView.image = [UIImage imageNamed:[listImage objectAtIndex:indexPath.row]];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try
    {
        NSString *dismissValue = @"dismissValueList";
        
        [[NSUserDefaults standardUserDefaults] setValue:dismissValue forKey:@"dismissValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if(indexPath.row == 0)
        {
            
            UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
            
            UIViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"menuOverlayController"];
            
            [self presentViewController:vc animated:YES completion:nil];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
            
            
        
           
        }
        else
        {
            
            NSString *valueToSave = [listType objectAtIndex:indexPath.row];
            
            [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"menuType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
            
            UIViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"menuOverlayController"];
            
            
            SWRevealViewController *nav = [mainStoryBoard instantiateViewControllerWithIdentifier:@"menuOverlayController"];
            
            [self.revealViewController setFrontViewController:nav];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            //[self presentViewController:vc animated:YES completion:nil];
            
        }
    }@catch(NSException *exception)
    {
        
    }
}

@end
