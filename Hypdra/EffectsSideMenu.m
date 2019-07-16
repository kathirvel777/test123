//
//  EffectsSideMenu.m
//  Hypdra
//
//  Created by MacBookPro on 5/10/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import "EffectsSideMenu.h"
#import "SwipeBack.h"
#import "AFNetworking.h"
#import "CustomPopUp.h"
#import "UIColor+Utils.h"
#import "MBProgressHUD.h"
#import "EffectsTableViewCell.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface EffectsSideMenu ()
{
    NSMutableArray *listType;
    MBProgressHUD *hud;
}

@end

@implementation EffectsSideMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.swipeBackEnabled=NO;
    listType=[[NSMutableArray alloc]init];
    
    //  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgg-1.png"]];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //self.navigationTitle.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"];
    NSString *title = (NSString *)[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"];
    self.navigationItem.title = [title stringByAppendingString:@"       "];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadEffectsMain];
}

-(void)loadEffectsMain
{
    @try
    {
        NSString *URL;
        
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Effects"])
            
            URL = @"https://www.hypdra.com/api/api.php?rquest=MainCategoryEffects";
        
        else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Titles"])
            
            URL = @"https://www.hypdra.com/api/api.php?rquest=MainCategoryTitles";
        
        else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Transitions"])
           // self.navigationItem.title = @"Transition";

            URL = @"https://www.hypdra.com/api/api.php?rquest=MainCategoryTransition";
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URL parameters:nil error:nil];  // make NSMutableURL req
        
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue]; // add paramerets to NSMutableURLRequest
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              if (!error)
              {
                  NSArray *mainCategoryArray;
                  NSDictionary *mainCategoryEffects=responseObject;
                  
                  if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Effects"])
                      
                      mainCategoryArray=[mainCategoryEffects objectForKey:@"MainCategoryEffects"];
                  
                  else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Titles"])
                      
                      mainCategoryArray=[mainCategoryEffects objectForKey:@"MainCategoryTitle"];
                  
                  else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Transitions"])
                      
                      mainCategoryArray=[mainCategoryEffects objectForKey:@"MainCategoryTransition"];
                  
                  for(int i=0;i<mainCategoryArray.count;i++)
                  {
                      NSDictionary *mainCatEffects=[mainCategoryArray objectAtIndex:i];
                      NSString *mainCat=[mainCatEffects   objectForKey:@"Main_Category"];
                      
                      [listType addObject:mainCat];
                      //                      if(i==0)
                      //                      {
                      //                          [listType insertObject:@"" atIndex:i];
                      //                      }
                      //
                      //                      [listType insertObject:mainCat atIndex:i+1];
                      
                  }
                  [self.tableView reloadData];
                  
                  [hud hideAnimated:YES];
              }
              
              else
              {
                  CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server" withTitle:@"Try again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                  popUp.okay.backgroundColor = [UIColor lightGreen];
                  popUp.agreeBtn.hidden = YES;
                  popUp.cancelBtn.hidden = YES;
                  popUp.inputTextField.hidden = YES;
                  [popUp show];
                  [hud hideAnimated:YES];
              }
          }]resume];
    }@catch(NSException *exception)
    {
        
    }
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
    
    if(indexPath.row % 2 == 0)
    {
        cell.backgroundColor =UIColorFromRGB(0xE4E4E4);
    }
    else
        cell.backgroundColor = [UIColor whiteColor];
    
    //    if(indexPath.row==0)
    //    {
    //        cell.imgView.image = [UIImage imageNamed:@"close_white.png"];
    //
    //        cell.nameLabel.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"];
    //
    //        cell.nameLabel.textAlignment=NSTextAlignmentCenter;
    //        [cell.nameLabel setFont:[UIFont fontWithName:@"FuturaT-Book" size:22.0]];
    //        cell.nameLabel.textColor=[UIColor whiteColor];
    //        cell.bgImage.hidden=YES;
    //        cell.countLabel.hidden=YES;
    //        cell.backgroundColor=UIColorFromRGB(0x2d2c65);
    //    }
    
    //    else
    //    {
    cell.imgView.image = [UIImage imageNamed:@"Navigate-Icon-Blue.png"];
    cell.nameLabel.text = [listType objectAtIndex:indexPath.row];
    [cell.nameLabel setFont:[UIFont fontWithName:@"FuturaT-Book" size:18.0]];
    cell.nameLabel.textColor=UIColorFromRGB(0x2d2c65);
    cell.bgImage.hidden=NO;
    cell.countLabel.hidden=NO;
    cell.nameLabel.textAlignment=NSTextAlignmentLeft;
    //  }
    
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
        
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"MenuFrontPage"];
        
        //set nav title
        [[NSUserDefaults standardUserDefaults]setObject:[listType objectAtIndex:indexPath.row] forKey:@"effectMenuType"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainAdvance" bundle:nil];
        
        UIViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"effectsSideMenu"];
        
        [self presentViewController:vc animated:YES completion:nil];
        //    }
        //  }
        
        /* {
         
         NSString *valueToSave = [listType objectAtIndex:indexPath.row];
         
         [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"effectMenuType"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainAdvance" bundle:nil];
         
         UIViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"effectsSideMenu"];
         
         [self presentViewController:vc animated:YES completion:nil];
         
         }*/
    }@catch(NSException *exception)
    {
        
    }
}

-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@""]){
    }
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    
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
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"MenuFrontPage"]isEqualToString:@"fromAdvance"])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    
    else
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"MenuFrontPage"];
        
        UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainAdvance" bundle:nil];
        
        UIViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"effectsSideMenu"];
        
        [self presentViewController:vc animated:YES completion:nil];
    }
}

@end
