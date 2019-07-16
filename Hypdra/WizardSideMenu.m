//
//  WizardSideMenu.m
//  Hypdra
//
//  Created by Mac on 7/9/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import "WizardSideMenu.h"
#import "MBProgressHUD.h"
#import "SwipeBack.h"
#import "AFNetworking.h"
#import "CustomPopUp.h"
#import "UIColor+Utils.h"
#import "EffectsTableViewCell.h"
#import "ChooseTemplateCollectionViewController.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface WizardSideMenu ()
{
    NSMutableArray *listType;
    MBProgressHUD *hud;
    NSString *TenStype;

}

@end

@implementation WizardSideMenu

- (void)viewDidLoad {
    [super viewDidLoad];

    listType=[[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"TemplateCategory"]]mutableCopy];
    
    if(listType == nil){
        listType = [[NSMutableArray alloc]init];
    }

    self.navigationController.swipeBackEnabled=NO;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    TenStype = [[NSUserDefaults standardUserDefaults]valueForKey:@"TenStype"];
    
    //self.navigationTitle.text=@"Wizard";
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //[self loadTemplatesCategory];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listType count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"EffectsTableViewCell";
    
    EffectsTableViewCell *cell = (EffectsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EffectsTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    CGRect frame = cell.countLabel.frame;
    frame.origin.x = cell.countLabel.frame.origin.x;
    frame.origin.y = cell.countLabel.frame.origin.y;
    cell.countLabel.frame = frame;
    
    if(indexPath.row % 2 == 0)
    {
        cell.backgroundColor =UIColorFromRGB(0xE4E4E4);
    }
    else
        cell.backgroundColor = [UIColor whiteColor];
    
    cell.imgView.image = [UIImage imageNamed:@"Navigate-Icon-Blue.png"];
    
    cell.nameLabel.text = (NSString *)[[listType objectAtIndex:indexPath.row] objectForKey:@"name"];
    [cell.nameLabel setFont:[UIFont fontWithName:@"FuturaT-Book" size:18.0]];
    cell.nameLabel.textColor=UIColorFromRGB(0x2d2c65);
    cell.countLabel.text = (NSString *)[[listType objectAtIndex:indexPath.row] objectForKey:@"count"];

    cell.bgImage.hidden=NO;
    cell.countLabel.hidden=NO;
    cell.nameLabel.textAlignment=NSTextAlignmentLeft;
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"MenuFrontPage"];
        
        UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];

        ChooseTemplateCollectionViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"wizardSideMenu"];
        NSString *Templateid,*name;
        if([TenStype isEqualToString:@"Template"]){
        Templateid = (NSString *)[[listType objectAtIndex:indexPath.row]valueForKey:@"id"];
        name =(NSString *)[[listType objectAtIndex:indexPath.row]valueForKey:@"name"];
            
        }else{
        Templateid = (NSString *)[[listType objectAtIndex:indexPath.row]valueForKey:@"name"];
            name =(NSString *)[[listType objectAtIndex:indexPath.row]valueForKey:@"name"];
        }
        [[NSUserDefaults standardUserDefaults]setValue:name forKey:@"TemplateTitle"];
        [[NSUserDefaults standardUserDefaults]setValue:Templateid forKey:@"TemplateCatrgory"];
        [self presentViewController:vc animated:YES completion:nil];
        
    }@catch(NSException *exception)
    {
        
    }
}

-(void) okClicked:(CustomPopUp *)alertView
{
    if([alertView.accessibilityHint isEqualToString:@""]){
    }
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView
{
    
    [alertView hide];
    alertView = nil;
    
}

- (void)agreeCLicked:(CustomPopUp *)alertView
{
    [alertView hide];
    alertView = nil;
    
}

- (IBAction)closeTap:(id)sender
{
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"MenuFrontPage"]isEqualToString:@"fromWizard"])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    
    else
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"MenuFrontPage"];
        
        UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
        
        UIViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"wizardSideMenu"];
        
        [self presentViewController:vc animated:YES completion:nil];
    }
}

@end
