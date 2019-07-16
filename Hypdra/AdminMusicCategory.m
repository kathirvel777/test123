//
//  AdminMusicCategory.m
//  Montage
//
//  Created by MacBookPro on 5/3/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "AdminMusicCategory.h"
#import "AFNetworking.h"
#import "CategoryMusicView.h"
#import "MBProgressHUD.h"
#import "DEMORootViewController.h"
#import "AdminMusicViewCell.h"
#import "Reachability.h"
#import <AVKit/AVKit.h>
#import "WizardAddTitileViewController.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface AdminMusicCategory ()<AVAudioPlayerDelegate>
{
    NSMutableArray *MainArray, *arrayForBool,*arrayForBool1,*arrayForBool2,*arrayForBool3,*arrayForBool4,*arrayForBool5,*arrayForBool6,*arrayForBool7,*arrayForBool8,*arrayForBool9,*arrayForBool10,*arrayForBool11,*arrayForBool12,*arrayForBool13,*arrayForBool14,*arrayForBool15,*arrayForBool16,*arrayForBool17,*arrayForBool18;
    
    NSMutableArray *arrayForBool1a,*arrayForBool2a,*arrayForBool3a,*arrayForBool4a,*arrayForBool5a,*arrayForBool6a,*arrayForBool7a,*arrayForBool8a,*arrayForBool9a,*arrayForBool10a,*arrayForBool11a,*arrayForBool12a,*arrayForBool13a,*arrayForBool14a,*arrayForBool15a,*arrayForBool16a,*arrayForBool17a,*arrayForBool18a;
    
    NSString *user_id;
    NSDictionary *musicDetails;
    MBProgressHUD *hud;
    NSArray *music_response;
    NSMutableArray *Array1,*Array2,*Array3,*Array4,*Array5,*Array6,*Array7,
    *Array8,*Array9,*Array10,*Array11,*Array12,*Array13,*Array14,*Array15,
    *Array16,*Array17,*Array18;
    
    NSMutableArray *CArray1,*CArray2,*CArray3,*CArray4,*CArray5,*CArray6,*CArray7,*CArray8,*CArray9,*CArray10,*CArray11,*CArray12,*CArray13,*CArray14,*CArray15,*CArray16,*CArray17,*CArray18;
    
    NSMutableArray *IdArray1,*IdArray2,*IdArray3,*IdArray4,*IdArray5,*IdArray6,*IdArray7,*IdArray8,*IdArray9,*IdArray10,*IdArray11,*IdArray12,*IdArray13,*IdArray14,*IdArray15,
    *IdArray16,*IdArray17,*IdArray18;
    
    NSMutableArray *montage_music,*music_count;
    int rowCheck,sectionCheck;
    int rowPlay,sectionPlay;
    int tappedCheck,tappedMusic,selected_cell_index;
;
    AVPlayer *player;
    NSString *idVal;
    
}
@end

@implementation AdminMusicCategory

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selected_cell_index = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"SelectedIndex"];
    NSLog(@"selected cell index is %d",selected_cell_index);
    
    
    self.doneOutlet.tintColor=[UIColor clearColor];
    self.doneOutlet.enabled=NO;
 
    Array1=[[NSMutableArray alloc]init];
    Array2=[[NSMutableArray alloc]init];
    Array3=[[NSMutableArray alloc]init];
    Array4=[[NSMutableArray alloc]init];
    Array5=[[NSMutableArray alloc]init];
    Array6=[[NSMutableArray alloc]init];
    Array7=[[NSMutableArray alloc]init];
    Array8=[[NSMutableArray alloc]init];
    Array9=[[NSMutableArray alloc]init];
    Array10=[[NSMutableArray alloc]init];
    Array11=[[NSMutableArray alloc]init];
    Array12=[[NSMutableArray alloc]init];
    Array13=[[NSMutableArray alloc]init];
    Array14=[[NSMutableArray alloc]init];
    Array15=[[NSMutableArray alloc]init];
    Array16=[[NSMutableArray alloc]init];
    Array17=[[NSMutableArray alloc]init];
    Array18=[[NSMutableArray alloc]init];
    
    CArray1=[[NSMutableArray alloc]init];
    CArray2=[[NSMutableArray alloc]init];
    CArray3=[[NSMutableArray alloc]init];
    CArray4=[[NSMutableArray alloc]init];
    CArray5=[[NSMutableArray alloc]init];
    CArray6=[[NSMutableArray alloc]init];
    CArray7=[[NSMutableArray alloc]init];
    CArray8=[[NSMutableArray alloc]init];
    CArray9=[[NSMutableArray alloc]init];
    CArray10=[[NSMutableArray alloc]init];
    CArray11=[[NSMutableArray alloc]init];
    CArray12=[[NSMutableArray alloc]init];
    CArray13=[[NSMutableArray alloc]init];
    CArray14=[[NSMutableArray alloc]init];
    CArray15=[[NSMutableArray alloc]init];
    CArray16=[[NSMutableArray alloc]init];
    CArray17=[[NSMutableArray alloc]init];
    CArray18=[[NSMutableArray alloc]init];
    
    IdArray1=[[NSMutableArray alloc]init];
    IdArray2=[[NSMutableArray alloc]init];
    IdArray3=[[NSMutableArray alloc]init];
    IdArray4=[[NSMutableArray alloc]init];
    IdArray5=[[NSMutableArray alloc]init];
    IdArray6=[[NSMutableArray alloc]init];
    IdArray7=[[NSMutableArray alloc]init];
    IdArray8=[[NSMutableArray alloc]init];
    IdArray9=[[NSMutableArray alloc]init];
    IdArray10=[[NSMutableArray alloc]init];
    IdArray11=[[NSMutableArray alloc]init];
    IdArray12=[[NSMutableArray alloc]init];
    IdArray13=[[NSMutableArray alloc]init];
    IdArray14=[[NSMutableArray alloc]init];
    IdArray15=[[NSMutableArray alloc]init];
    IdArray16=[[NSMutableArray alloc]init];
    IdArray17=[[NSMutableArray alloc]init];
    IdArray18=[[NSMutableArray alloc]init];
    
    montage_music=[[NSMutableArray alloc]init];
    music_count=[[NSMutableArray alloc]init];
    
    arrayForBool=[[NSMutableArray alloc]init];
    
    arrayForBool1=[[NSMutableArray alloc]init];
    arrayForBool2=[[NSMutableArray alloc]init];
    arrayForBool3=[[NSMutableArray alloc]init];
    arrayForBool4=[[NSMutableArray alloc]init];
    arrayForBool5=[[NSMutableArray alloc]init];
    arrayForBool6=[[NSMutableArray alloc]init];
    arrayForBool7=[[NSMutableArray alloc]init];
    arrayForBool8=[[NSMutableArray alloc]init];
    arrayForBool9=[[NSMutableArray alloc]init];
    arrayForBool10=[[NSMutableArray alloc]init];
    arrayForBool11=[[NSMutableArray alloc]init];
    arrayForBool12=[[NSMutableArray alloc]init];
    arrayForBool13=[[NSMutableArray alloc]init];
    arrayForBool14=[[NSMutableArray alloc]init];
    arrayForBool15=[[NSMutableArray alloc]init];
    arrayForBool16=[[NSMutableArray alloc]init];
    arrayForBool17=[[NSMutableArray alloc]init];
    arrayForBool18=[[NSMutableArray alloc]init];

    arrayForBool1a=[[NSMutableArray alloc]init];
    arrayForBool2a=[[NSMutableArray alloc]init];
    arrayForBool3a=[[NSMutableArray alloc]init];
    arrayForBool4a=[[NSMutableArray alloc]init];
    arrayForBool5a=[[NSMutableArray alloc]init];
    arrayForBool6a=[[NSMutableArray alloc]init];
    arrayForBool7a=[[NSMutableArray alloc]init];
    arrayForBool8a=[[NSMutableArray alloc]init];
    arrayForBool9a=[[NSMutableArray alloc]init];
    arrayForBool10a=[[NSMutableArray alloc]init];
    arrayForBool11a=[[NSMutableArray alloc]init];
    arrayForBool12a=[[NSMutableArray alloc]init];
    arrayForBool13a=[[NSMutableArray alloc]init];
    arrayForBool14a=[[NSMutableArray alloc]init];
    arrayForBool15a=[[NSMutableArray alloc]init];
    arrayForBool16a=[[NSMutableArray alloc]init];
    arrayForBool17a=[[NSMutableArray alloc]init];
    arrayForBool18a=[[NSMutableArray alloc]init];

    _currentWindow = [UIApplication sharedApplication].keyWindow;
    
    _BlurView = [[UIView alloc]initWithFrame:CGRectMake(_currentWindow.frame.origin.x, _currentWindow.frame.origin.y, _currentWindow.frame.size.width, _currentWindow.frame.size.height)];
    
    _BlurView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    
    self.tableView.bounces = false;
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
 
}

-(void)viewWillDisappear:(BOOL)animated
{
    [montage_music removeAllObjects];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self loadCategory];
    
}

-(void)viewDidLayoutSubviews
{
    self.secondView.frame = CGRectMake(0, self.tabBarController.tabBar.frame.size.height, self.secondView.frame.size.width, self.secondView.frame.size.height - self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
    //
    NSLog(@"Height's = %f", self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [montage_music count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[arrayForBool objectAtIndex:section] boolValue])
    {
        if(section==0)
            return Array1.count;
        else if(section==1)
            return Array2.count;
        else if(section==2)
            return Array3.count;
        else if(section==3)
            return Array4.count;
        else if(section==4)
            return Array5.count;
        else if(section==5)
            return Array6.count;
        else if(section==6)
            return Array7.count;
        else if(section==7)
            return Array8.count;
        else if(section==8)
            return Array9.count;
        else if(section==9)
            return Array10.count;
        else if(section==10)
            return Array11.count;
        else if(section==11)
            return Array12.count;
        else if(section==12)
            return Array13.count;
        else if(section==13)
            return Array14.count;
        else if(section==14)
            return Array15.count;
        else if(section==15)
            return Array16.count;
        else if(section==16)
            return Array17.count;
        else if(section==17)
            return Array18.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdminMusicViewCell *cell;
    
        static NSString *cellIdentifier = @"Cell";
    
        cell = (AdminMusicViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AdminMusicViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    }
    
    else
    {
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AdminMusicViewCellpad" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    }
    
    if(indexPath.section==0)
        cell.nameVal.text=[Array1 objectAtIndex:indexPath.row];
    
    else if(indexPath.section==1)
        cell.nameVal.text=[Array2 objectAtIndex:indexPath.row];
    
    else if(indexPath.section==2)
        cell.nameVal.text=[Array3 objectAtIndex:indexPath.row];
    
    else if(indexPath.section==3)
        cell.nameVal.text=[Array4 objectAtIndex:indexPath.row];
    
    else if(indexPath.section==4)
        cell.nameVal.text=[Array5 objectAtIndex:indexPath.row];
    
    else if(indexPath.section==5)
        cell.nameVal.text=[Array6 objectAtIndex:indexPath.row];
    
    else if(indexPath.section==6)
        cell.nameVal.text=[Array7 objectAtIndex:indexPath.row];
    
    else if(indexPath.section==7)
        cell.nameVal.text=[Array8 objectAtIndex:indexPath.row];
    
    else if(indexPath.section==8)
        cell.nameVal.text=[Array9 objectAtIndex:indexPath.row];
    
    else if(indexPath.section==9)
        cell.nameVal.text=[Array10 objectAtIndex:indexPath.row];
    
    else if(indexPath.section==10)
        cell.nameVal.text=[Array11 objectAtIndex:indexPath.row];
    
    else if(indexPath.section==11)
        cell.nameVal.text=[Array12 objectAtIndex:indexPath.row];
    
    else if(indexPath.section==12)
        cell.nameVal.text=[Array13 objectAtIndex:indexPath.row];
    
    else if(indexPath.section==13)
        cell.nameVal.text=[Array14 objectAtIndex:indexPath.row];
    
    else if(indexPath.section==14)
        cell.nameVal.text=[Array15 objectAtIndex:indexPath.row];
    
    else if(indexPath.section==15)
        cell.nameVal.text=[Array16 objectAtIndex:indexPath.row];
    
    else if(indexPath.section==16)
        cell.nameVal.text=[Array17 objectAtIndex:indexPath.row];
    
    else if(indexPath.section==17)
        cell.nameVal.text=[Array18 objectAtIndex:indexPath.row];
    
    else
        cell.nameVal.text=@"None";
    
    
    cell.nameVal.font=[UIFont systemFontOfSize:15.0f];
    cell.backgroundColor=[UIColor whiteColor];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone ;
    
    cell.imgVal.tag = (indexPath.section * 1000) + indexPath.row;
    cell.countImgVal.tag=(indexPath.section*1000)+indexPath.row;
    
    if(tappedCheck==1)
    {
        if(rowCheck==indexPath.row && sectionCheck==indexPath.section)
        {
            if(indexPath.section==0)
            {
                if([[arrayForBool1 objectAtIndex:rowCheck] isEqual:@"YES"])
                    cell.countImgVal.image=[UIImage imageNamed:@"64-tick-box.png"];
                
                else
                    cell.countImgVal.image=[UIImage imageNamed:@"32-box.png"];
            }
            
            else if(indexPath.section==1)
            {
                if([[arrayForBool2 objectAtIndex:rowCheck]isEqual:@"YES"])
                    cell.countImgVal.image=[UIImage imageNamed:@"64-tick-box.png"];
                
                else
                    cell.countImgVal.image=[UIImage imageNamed:@"32-box.png"];
            }
            
            else if(indexPath.section==2)
            {
                if([[arrayForBool3 objectAtIndex:rowCheck]isEqual:@"YES"])
                    cell.countImgVal.image=[UIImage imageNamed:@"64-tick-box.png"];
                
                else
                    cell.countImgVal.image=[UIImage imageNamed:@"32-box.png"];
            }
            
            else if(indexPath.section==3)
            {
                if([[arrayForBool4 objectAtIndex:rowCheck]isEqual:@"YES"])
                    cell.countImgVal.image=[UIImage imageNamed:@"64-tick-box.png"];
                
                else
                    cell.countImgVal.image=[UIImage imageNamed:@"32-box.png"];
            }
            
            else if(indexPath.section==4)
            {
                if([[arrayForBool5 objectAtIndex:rowCheck]isEqual:@"YES"])
                    cell.countImgVal.image=[UIImage imageNamed:@"64-tick-box.png"];
                
                else
                    cell.countImgVal.image=[UIImage imageNamed:@"32-box.png"];
            }
            
            else if(indexPath.section==5)
            {
                if([[arrayForBool6 objectAtIndex:rowCheck]isEqual:@"YES"])
                    cell.countImgVal.image=[UIImage imageNamed:@"64-tick-box.png"];
                
                else
                    cell.countImgVal.image=[UIImage imageNamed:@"32-box.png"];
            }
            
            else if(indexPath.section==6)
            {
                if([[arrayForBool7 objectAtIndex:rowCheck]isEqual:@"YES"])
                    cell.countImgVal.image=[UIImage imageNamed:@"64-tick-box.png"];
                
                else
                    cell.countImgVal.image=[UIImage imageNamed:@"32-box.png"];
            }
            
            else if(indexPath.section==7)
            {
                if([[arrayForBool8 objectAtIndex:rowCheck]isEqual:@"YES"])
                    cell.countImgVal.image=[UIImage imageNamed:@"64-tick-box.png"];
                
                else
                    cell.countImgVal.image=[UIImage imageNamed:@"32-box.png"];
            }
            else if(indexPath.section==8)
            {
                if([[arrayForBool9 objectAtIndex:rowCheck]isEqual:@"YES"])
                    cell.countImgVal.image=[UIImage imageNamed:@"64-tick-box.png"];
                
                else
                    cell.countImgVal.image=[UIImage imageNamed:@"32-box.png"];
            }
            else if(indexPath.section==9)
            {
                if([[arrayForBool10 objectAtIndex:rowCheck]isEqual:@"YES"])
                    cell.countImgVal.image=[UIImage imageNamed:@"64-tick-box.png"];
                
                else
                    cell.countImgVal.image=[UIImage imageNamed:@"32-box.png"];
            }
            else if(indexPath.section==10)
            {
                if([[arrayForBool11 objectAtIndex:rowCheck]isEqual:@"YES"])
                    cell.countImgVal.image=[UIImage imageNamed:@"64-tick-box.png"];
                
                else
                    cell.countImgVal.image=[UIImage imageNamed:@"32-box.png"];
            }
            else if(indexPath.section==11)
            {
                if([[arrayForBool12 objectAtIndex:rowCheck]isEqual:@"YES"])
                    cell.countImgVal.image=[UIImage imageNamed:@"64-tick-box.png"];
                
                else
                    cell.countImgVal.image=[UIImage imageNamed:@"32-box.png"];
            }
            else if(indexPath.section==12)
            {
                if([[arrayForBool13 objectAtIndex:rowCheck]isEqual:@"YES"])
                    cell.countImgVal.image=[UIImage imageNamed:@"64-tick-box.png"];
                
                else
                    cell.countImgVal.image=[UIImage imageNamed:@"32-box.png"];
            }
            
            else if(indexPath.section==13)
            {
                if([[arrayForBool14 objectAtIndex:rowCheck]isEqual:@"YES"])
                    cell.countImgVal.image=[UIImage imageNamed:@"64-tick-box.png"];
                
                else
                    cell.countImgVal.image=[UIImage imageNamed:@"32-box.png"];
            }
            else if(indexPath.section==14)
            {
                if([[arrayForBool15 objectAtIndex:rowCheck]isEqual:@"YES"])
                    cell.countImgVal.image=[UIImage imageNamed:@"64-tick-box.png"];
                
                else
                    cell.countImgVal.image=[UIImage imageNamed:@"32-box.png"];
            }
            
            else if(indexPath.section==15)
            {
                if([[arrayForBool16 objectAtIndex:rowCheck]isEqual:@"YES"])
                    cell.countImgVal.image=[UIImage imageNamed:@"64-tick-box.png"];
                
                else
                    cell.countImgVal.image=[UIImage imageNamed:@"32-box.png"];
            }
            
            else if(indexPath.section==16)
            {
                if([[arrayForBool17 objectAtIndex:rowCheck]isEqual:@"YES"])
                    cell.countImgVal.image=[UIImage imageNamed:@"64-tick-box.png"];
                
                else
                    cell.countImgVal.image=[UIImage imageNamed:@"32-box.png"];
            }
            else if(indexPath.section==17)
            {
                if([[arrayForBool18 objectAtIndex:rowCheck]isEqual:@"YES"])
                    cell.countImgVal.image=[UIImage imageNamed:@"64-tick-box.png"];
                
                else
                    cell.countImgVal.image=[UIImage imageNamed:@"32-box.png"];
            }
        }
        
        else
        {
            cell.countImgVal.image=[UIImage imageNamed:@"32-box.png"];
        }
    }
    
    
    //Tapped play music
    
    if(tappedMusic==1)
    {
        if(rowPlay==indexPath.row && sectionPlay==indexPath.section)
        {
            if(indexPath.section==0)
            {
                
                if([[arrayForBool1a objectAtIndex:rowPlay] isEqual:@"YES"])
                    cell.imgVal.image=[UIImage imageNamed:@"play_150"];
                
                else
                    cell.imgVal.image=[UIImage imageNamed:@"pause_150"];
            }
            
            else if(indexPath.section==1)
            {
                if([[arrayForBool2a objectAtIndex:rowPlay]isEqual:@"YES"])
                    cell.imgVal.image=[UIImage imageNamed:@"play_150"];
                
                else
                    cell.imgVal.image=[UIImage imageNamed:@"pause_150"];
            }
            
            else if(indexPath.section==2)
            {
                if([[arrayForBool3a objectAtIndex:rowPlay]isEqual:@"YES"])
                    cell.imgVal.image=[UIImage imageNamed:@"play_150"];
                
                else
                    cell.imgVal.image=[UIImage imageNamed:@"pause_150"];
            }
            else if(indexPath.section==3)
            {
                if([[arrayForBool4a objectAtIndex:rowPlay]isEqual:@"YES"])
                    cell.imgVal.image=[UIImage imageNamed:@"play_150"];
                
                else
                    cell.imgVal.image=[UIImage imageNamed:@"pause_150"];
            }
            else if(indexPath.section==4)
            {
                if([[arrayForBool5a objectAtIndex:rowPlay]isEqual:@"YES"])
                    cell.imgVal.image=[UIImage imageNamed:@"play_150"];
                
                else
                    cell.imgVal.image=[UIImage imageNamed:@"pause_150"];
            }
            else if(indexPath.section==5)
            {
                if([[arrayForBool6a objectAtIndex:rowPlay]isEqual:@"YES"])
                    cell.imgVal.image=[UIImage imageNamed:@"play_150"];
                
                else
                    cell.imgVal.image=[UIImage imageNamed:@"pause_150"];
            }
            else if(indexPath.section==6)
            {
                if([[arrayForBool7a objectAtIndex:rowPlay]isEqual:@"YES"])
                    cell.imgVal.image=[UIImage imageNamed:@"play_150"];
                
                else
                    cell.imgVal.image=[UIImage imageNamed:@"pause_150"];
            }
            else if(indexPath.section==7)
            {
                if([[arrayForBool8a objectAtIndex:rowPlay]isEqual:@"YES"])
                    cell.imgVal.image=[UIImage imageNamed:@"play_150"];
                
                else
                    cell.imgVal.image=[UIImage imageNamed:@"pause_150"];
            }
            else if(indexPath.section==8)
            {
                if([[arrayForBool9a objectAtIndex:rowPlay]isEqual:@"YES"])
                    cell.imgVal.image=[UIImage imageNamed:@"play_150"];
                
                else
                    cell.imgVal.image=[UIImage imageNamed:@"pause_150"];
            }
            else if(indexPath.section==9)
            {
                if([[arrayForBool10a objectAtIndex:rowPlay]isEqual:@"YES"])
                    cell.imgVal.image=[UIImage imageNamed:@"play_150"];
                
                else
                    cell.imgVal.image=[UIImage imageNamed:@"pause_150"];
            }
            else if(indexPath.section==10)
            {
                if([[arrayForBool11a objectAtIndex:rowPlay]isEqual:@"YES"])
                    cell.imgVal.image=[UIImage imageNamed:@"play_150"];
                
                else
                    cell.imgVal.image=[UIImage imageNamed:@"pause_150"];
            }
            else if(indexPath.section==11)
            {
                if([[arrayForBool12a objectAtIndex:rowPlay]isEqual:@"YES"])
                    cell.imgVal.image=[UIImage imageNamed:@"play_150"];
                
                else
                    cell.imgVal.image=[UIImage imageNamed:@"pause_150"];
            }
            else if(indexPath.section==12)
            {
                if([[arrayForBool13a objectAtIndex:rowPlay]isEqual:@"YES"])
                    cell.imgVal.image=[UIImage imageNamed:@"play_150"];
                
                else
                    cell.imgVal.image=[UIImage imageNamed:@"pause_150"];
            }
            else if(indexPath.section==13)
            {
                if([[arrayForBool14a objectAtIndex:rowPlay]isEqual:@"YES"])
                    cell.imgVal.image=[UIImage imageNamed:@"play_150"];
                
                else
                    cell.imgVal.image=[UIImage imageNamed:@"pause_150"];
            }
            else if(indexPath.section==14)
            {
                if([[arrayForBool15a objectAtIndex:rowPlay]isEqual:@"YES"])
                    cell.imgVal.image=[UIImage imageNamed:@"play_150"];
                
                else
                    cell.imgVal.image=[UIImage imageNamed:@"pause_150"];
            }
            else if(indexPath.section==15)
            {
                if([[arrayForBool16a objectAtIndex:rowPlay]isEqual:@"YES"])
                    cell.imgVal.image=[UIImage imageNamed:@"play_150"];
                
                else
                    cell.imgVal.image=[UIImage imageNamed:@"pause_150"];
            }
            else if(indexPath.section==16)
            {
                if([[arrayForBool17a objectAtIndex:rowPlay]isEqual:@"YES"])
                    cell.imgVal.image=[UIImage imageNamed:@"play_150"];
                
                else
                    cell.imgVal.image=[UIImage imageNamed:@"pause_150"];
            }
            else if(indexPath.section==17)
            {
                if([[arrayForBool18a objectAtIndex:rowPlay]isEqual:@"YES"])
                    cell.imgVal.image=[UIImage imageNamed:@"play_150"];
                
                else
                    cell.imgVal.image=[UIImage imageNamed:@"pause_150"];
            }
        }
        
        else
        {
            cell.imgVal.image=[UIImage imageNamed:@"pause_150"];
        }
    }
    
    UITapGestureRecognizer *tappedPlay1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedPlayButton:)];
    tappedPlay1.numberOfTapsRequired=1;
    [cell.imgVal addGestureRecognizer:tappedPlay1];
    
    UITapGestureRecognizer *tappedChkBox=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedCheckBox:)];
    tappedChkBox.numberOfTapsRequired=1;
    [cell.countImgVal addGestureRecognizer:tappedChkBox];
    
    return cell;
}

-(void)tappedCheckBox:(UITapGestureRecognizer *)gesture
{
    NSLog(@"tapped");
    
    tappedCheck=1;
    
    long val=gesture.view.tag;
    
    rowCheck =(int)val%1000;
    sectionCheck=(int)val/1000;
    
    if(sectionCheck==0)
    {
        if([[arrayForBool1 objectAtIndex:rowCheck]isEqualToString:@"NO"])
        {
            self.doneOutlet.tintColor=[UIColor whiteColor];
            self.doneOutlet.enabled=YES;
            
            for(int i=0;i<[arrayForBool1 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool1 replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool1 replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
        }
        else
        {
            self.doneOutlet.tintColor=[UIColor clearColor];
            self.doneOutlet.enabled=NO;
            
            for(int i=0;i<[arrayForBool1 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool1 replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool1 replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
        }
    }
    
    else if(sectionCheck==1)
    {
        if([[arrayForBool2 objectAtIndex:rowCheck]isEqualToString:@"NO"])
        {
            self.doneOutlet.tintColor=[UIColor whiteColor];
            self.doneOutlet.enabled=YES;
            
            for(int i=0;i<[arrayForBool2 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool2 replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool2 replaceObjectAtIndex:i withObject:@"NO"];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            self.doneOutlet.tintColor=[UIColor clearColor];
            self.doneOutlet.enabled=NO;
            
            for(int i=0;i<[arrayForBool2 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool2 replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool2 replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
        }
    }
    
    else if(sectionCheck==2)
    {
        if([[arrayForBool3 objectAtIndex:rowCheck]isEqualToString:@"NO"])
        {
            self.doneOutlet.tintColor=[UIColor whiteColor];
            self.doneOutlet.enabled=YES;
            
            for(int i=0;i<[arrayForBool3 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool3 replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool3 replaceObjectAtIndex:i withObject:@"NO"];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            self.doneOutlet.tintColor=[UIColor clearColor];
            self.doneOutlet.enabled=NO;
            
            for(int i=0;i<[arrayForBool3 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool3 replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool3 replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
        }
    }
    else if(sectionCheck==3)
    {
        if([[arrayForBool4 objectAtIndex:rowCheck]isEqualToString:@"NO"])
        {
            self.doneOutlet.tintColor=[UIColor whiteColor];
            self.doneOutlet.enabled=YES;
            
            for(int i=0;i<[arrayForBool4 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool4 replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool4 replaceObjectAtIndex:i withObject:@"NO"];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            self.doneOutlet.tintColor=[UIColor clearColor];
            self.doneOutlet.enabled=NO;
            
            for(int i=0;i<[arrayForBool4 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool4 replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool4 replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
        }
    }
    
    else if(sectionCheck==4)
    {
        if([[arrayForBool5 objectAtIndex:rowCheck]isEqualToString:@"NO"])
        {
            self.doneOutlet.tintColor=[UIColor whiteColor];
            self.doneOutlet.enabled=YES;
            
            for(int i=0;i<[arrayForBool5 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool5 replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool5 replaceObjectAtIndex:i withObject:@"NO"];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            self.doneOutlet.tintColor=[UIColor clearColor];
            self.doneOutlet.enabled=NO;
            
            for(int i=0;i<[arrayForBool5 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool5 replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool5 replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
        }
    }
    else if(sectionCheck==5)
    {
        if([[arrayForBool6 objectAtIndex:rowCheck]isEqualToString:@"NO"])
        {
            self.doneOutlet.tintColor=[UIColor whiteColor];
            self.doneOutlet.enabled=YES;
            
            for(int i=0;i<[arrayForBool6 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool6 replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool6 replaceObjectAtIndex:i withObject:@"NO"];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            self.doneOutlet.tintColor=[UIColor clearColor];
            self.doneOutlet.enabled=NO;
            
            for(int i=0;i<[arrayForBool6 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool6 replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool6 replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
        }
    }
    
    else if(sectionCheck==6)
    {
        if([[arrayForBool7 objectAtIndex:rowCheck]isEqualToString:@"NO"])
        {
            self.doneOutlet.tintColor=[UIColor whiteColor];
            self.doneOutlet.enabled=YES;
            
            for(int i=0;i<[arrayForBool7 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool7 replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool7 replaceObjectAtIndex:i withObject:@"NO"];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            self.doneOutlet.tintColor=[UIColor clearColor];
            self.doneOutlet.enabled=NO;
            
            for(int i=0;i<[arrayForBool7 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool7 replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool7 replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
        }
    }
    else if(sectionCheck==7)
    {
        if([[arrayForBool8 objectAtIndex:rowCheck]isEqualToString:@"NO"])
        {
            self.doneOutlet.tintColor=[UIColor whiteColor];
            self.doneOutlet.enabled=YES;
            
            for(int i=0;i<[arrayForBool8 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool8 replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool8 replaceObjectAtIndex:i withObject:@"NO"];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            self.doneOutlet.tintColor=[UIColor clearColor];
            self.doneOutlet.enabled=NO;
            
            for(int i=0;i<[arrayForBool8 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool8 replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool8 replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
        }
    }
    
    else if(sectionCheck==8)
    {
        if([[arrayForBool9 objectAtIndex:rowCheck]isEqualToString:@"NO"])
        {
            self.doneOutlet.tintColor=[UIColor whiteColor];
            self.doneOutlet.enabled=YES;
            
            for(int i=0;i<[arrayForBool9 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool9 replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool9 replaceObjectAtIndex:i withObject:@"NO"];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            self.doneOutlet.tintColor=[UIColor clearColor];
            self.doneOutlet.enabled=NO;
            
            for(int i=0;i<[arrayForBool9 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool9 replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool9 replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
        }
    }
    
    else if(sectionCheck==9)
    {
        if([[arrayForBool10 objectAtIndex:rowCheck]isEqualToString:@"NO"])
        {
            self.doneOutlet.tintColor=[UIColor whiteColor];
            self.doneOutlet.enabled=YES;
            
            for(int i=0;i<[arrayForBool10 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool10 replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool10 replaceObjectAtIndex:i withObject:@"NO"];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            self.doneOutlet.tintColor=[UIColor clearColor];
            self.doneOutlet.enabled=NO;
            
            for(int i=0;i<[arrayForBool10 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool10 replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool10 replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
        }
    }
    else if(sectionCheck==10)
    {
        if([[arrayForBool11 objectAtIndex:rowCheck]isEqualToString:@"NO"])
        {
            self.doneOutlet.tintColor=[UIColor whiteColor];
            self.doneOutlet.enabled=YES;
            
            for(int i=0;i<[arrayForBool11 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool11 replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool11 replaceObjectAtIndex:i withObject:@"NO"];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            self.doneOutlet.tintColor=[UIColor clearColor];
            self.doneOutlet.enabled=NO;
            
            for(int i=0;i<[arrayForBool11 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool11 replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool11 replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
        }
    }
    else if(sectionCheck==11)
    {
        if([[arrayForBool12 objectAtIndex:rowCheck]isEqualToString:@"NO"])
        {
            self.doneOutlet.tintColor=[UIColor whiteColor];
            self.doneOutlet.enabled=YES;
            
            for(int i=0;i<[arrayForBool12 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool12 replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool12 replaceObjectAtIndex:i withObject:@"NO"];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            self.doneOutlet.tintColor=[UIColor clearColor];
            self.doneOutlet.enabled=NO;
            
            for(int i=0;i<[arrayForBool12 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool12 replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool12 replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
        }
    }
    else if(sectionCheck==12)
    {
        if([[arrayForBool13 objectAtIndex:rowCheck]isEqualToString:@"NO"])
        {
            self.doneOutlet.tintColor=[UIColor whiteColor];
            self.doneOutlet.enabled=YES;
            
            for(int i=0;i<[arrayForBool13 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool13 replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool13 replaceObjectAtIndex:i withObject:@"NO"];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            self.doneOutlet.tintColor=[UIColor clearColor];
            self.doneOutlet.enabled=NO;
            
            for(int i=0;i<[arrayForBool13 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool13 replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool13 replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
        }
    }
    else if(sectionCheck==13)
    {
        if([[arrayForBool14 objectAtIndex:rowCheck]isEqualToString:@"NO"])
        {
            self.doneOutlet.tintColor=[UIColor whiteColor];
            self.doneOutlet.enabled=YES;
            
            for(int i=0;i<[arrayForBool14 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool14 replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool14 replaceObjectAtIndex:i withObject:@"NO"];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            self.doneOutlet.tintColor=[UIColor clearColor];
            self.doneOutlet.enabled=NO;
            
            for(int i=0;i<[arrayForBool14 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool14 replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool14 replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
        }
    }
    else if(sectionCheck==14)
    {
        if([[arrayForBool15 objectAtIndex:rowCheck]isEqualToString:@"NO"])
        {
            self.doneOutlet.tintColor=[UIColor whiteColor];
            self.doneOutlet.enabled=YES;
            
            for(int i=0;i<[arrayForBool15 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool15 replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool15 replaceObjectAtIndex:i withObject:@"NO"];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            self.doneOutlet.tintColor=[UIColor clearColor];
            self.doneOutlet.enabled=NO;
            
            for(int i=0;i<[arrayForBool15 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool15 replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool15 replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
        }
    }
    else if(sectionCheck==15)
    {
        if([[arrayForBool16 objectAtIndex:rowCheck]isEqualToString:@"NO"])
        {
            self.doneOutlet.tintColor=[UIColor whiteColor];
            self.doneOutlet.enabled=YES;
            
            for(int i=0;i<[arrayForBool16 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool16 replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool16 replaceObjectAtIndex:i withObject:@"NO"];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            self.doneOutlet.tintColor=[UIColor clearColor];
            self.doneOutlet.enabled=NO;
            
            for(int i=0;i<[arrayForBool16 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool16 replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool16 replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
        }
    }
    else if(sectionCheck==16)
    {
        if([[arrayForBool17 objectAtIndex:rowCheck]isEqualToString:@"NO"])
        {
            self.doneOutlet.tintColor=[UIColor whiteColor];
            self.doneOutlet.enabled=YES;
            
            for(int i=0;i<[arrayForBool17 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool17 replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool17 replaceObjectAtIndex:i withObject:@"NO"];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            self.doneOutlet.tintColor=[UIColor clearColor];
            self.doneOutlet.enabled=NO;
            
            for(int i=0;i<[arrayForBool17 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool17 replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool17 replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
        }
    }
    else if(sectionCheck==17)
    {
        if([[arrayForBool18 objectAtIndex:rowCheck]isEqualToString:@"NO"])
        {
            self.doneOutlet.tintColor=[UIColor whiteColor];
            self.doneOutlet.enabled=YES;
            
            for(int i=0;i<[arrayForBool18 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool18 replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool18 replaceObjectAtIndex:i withObject:@"NO"];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            self.doneOutlet.tintColor=[UIColor clearColor];
            self.doneOutlet.enabled=NO;
            
            for(int i=0;i<[arrayForBool18 count];i++)
            {
                if(i==rowCheck)
                {                [arrayForBool18 replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool18 replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
        }
    }
}


-(void)tappedPlayButton:(UITapGestureRecognizer *)gesture
{
    NSLog(@"tapped playbutton");
    
    tappedMusic=1;
    
    long val=gesture.view.tag;
    
    rowPlay =(int)val%1000;
    sectionPlay=(int)val/1000;
    
    if(sectionPlay==0)
    {
        if([[arrayForBool1a objectAtIndex:rowPlay]isEqualToString:@"NO"])
        {
            
            for(int i=0;i<[arrayForBool1a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool1a replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool1a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            
            NSString *musicURL=@"https://www.hypdra.com/Audio/5a8d5735a5a56.mp3";
            NSURL *urls=[[NSURL alloc] initWithString:musicURL];
            
           // NSURL *urls=[[NSURL alloc]initWithString:[CArray1 objectAtIndex:rowPlay]];

            player = [AVPlayer playerWithURL:urls];
            
           AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];

            [controller.contentOverlayView setBackgroundColor:[UIColor greenColor]];

            controller.allowsPictureInPicturePlayback = YES;

            [self presentViewController:controller animated:YES completion:nil];
            controller.player = player;
            [player play];
            
        }
        else
        {
            
            for(int i=0;i<[arrayForBool1a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool1a replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool1a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            
            [player pause];
            
        }
    }
    
    else if(sectionPlay==1)
    {
        if([[arrayForBool2a objectAtIndex:rowPlay]isEqualToString:@"NO"])
        {
            
            for(int i=0;i<[arrayForBool2a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool2a replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool2a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            NSURL *urls=[[NSURL alloc]initWithString:[CArray2 objectAtIndex:rowPlay]];
            
            player = [AVPlayer playerWithURL:urls];
            
            AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
            
            [controller.contentOverlayView setBackgroundColor:[UIColor greenColor]];
            
            controller.allowsPictureInPicturePlayback = YES;
            
            [self presentViewController:controller animated:YES completion:nil];
            controller.player = player;
            [player play];
        }
        else
        {
            
            for(int i=0;i<[arrayForBool2a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool2a replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool2a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            [player pause];
        }
    }
    
    else if(sectionPlay==2)
    {
        if([[arrayForBool3a objectAtIndex:rowPlay]isEqualToString:@"NO"])
        {
            
            for(int i=0;i<[arrayForBool3a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool3a replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool3a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            NSURL *urls=[[NSURL alloc]initWithString:[CArray3 objectAtIndex:rowPlay]];
            
            player = [AVPlayer playerWithURL:urls];
            
            AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
            
            [controller.contentOverlayView setBackgroundColor:[UIColor greenColor]];
            
            controller.allowsPictureInPicturePlayback = YES;
            
            [self presentViewController:controller animated:YES completion:nil];
            controller.player = player;
            [player play];
        }
        else
        {
            
            for(int i=0;i<[arrayForBool3a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool3a replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool3a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            [player pause];
        }
    }
    
    else if(sectionPlay==3)
    {
        if([[arrayForBool4a objectAtIndex:rowPlay]isEqualToString:@"NO"])
        {
            
            for(int i=0;i<[arrayForBool4a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool4a replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool4a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            NSURL *urls=[[NSURL alloc]initWithString:[CArray4 objectAtIndex:rowPlay]];
            
            player = [AVPlayer playerWithURL:urls];
            
            AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
            
            [controller.contentOverlayView setBackgroundColor:[UIColor greenColor]];
            
            controller.allowsPictureInPicturePlayback = YES;
            
            [self presentViewController:controller animated:YES completion:nil];
            controller.player = player;
            [player play];
        }
        else
        {
            
            for(int i=0;i<[arrayForBool4a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool4a replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool4a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            [player pause];
        }
    }
    
    else if(sectionPlay==4)
    {
        if([[arrayForBool5a objectAtIndex:rowPlay]isEqualToString:@"NO"])
        {
            
            for(int i=0;i<[arrayForBool5a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool5a replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool5a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            NSURL *urls=[[NSURL alloc]initWithString:[CArray5 objectAtIndex:rowPlay]];
            
            player = [AVPlayer playerWithURL:urls];
            
            AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
            
            [controller.contentOverlayView setBackgroundColor:[UIColor greenColor]];
            
            controller.allowsPictureInPicturePlayback = YES;
            
            [self presentViewController:controller animated:YES completion:nil];
            controller.player = player;
            [player play];
        }
        else
        {
            
            for(int i=0;i<[arrayForBool5a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool5a replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool5a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            [player pause];
        }
    }
    
    else if(sectionPlay==5)
    {
        if([[arrayForBool6a objectAtIndex:rowPlay]isEqualToString:@"NO"])
        {
            
            for(int i=0;i<[arrayForBool6a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool6a replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool6a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            NSURL *urls=[[NSURL alloc]initWithString:[CArray6 objectAtIndex:rowPlay]];
            
            player = [AVPlayer playerWithURL:urls];
            
            AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
            
            [controller.contentOverlayView setBackgroundColor:[UIColor greenColor]];
            
            controller.allowsPictureInPicturePlayback = YES;
            
            [self presentViewController:controller animated:YES completion:nil];
            controller.player = player;
            [player play];
        }
        else
        {
            
            for(int i=0;i<[arrayForBool6a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool6a replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool6a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            [player pause];
        }
    }
    
    else if(sectionPlay==6)
    {
        if([[arrayForBool7a objectAtIndex:rowPlay]isEqualToString:@"NO"])
        {
            
            for(int i=0;i<[arrayForBool7a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool7a replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool7a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            NSURL *urls=[[NSURL alloc]initWithString:[CArray7 objectAtIndex:rowPlay]];
            
            player = [AVPlayer playerWithURL:urls];
            
            AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
            
            [controller.contentOverlayView setBackgroundColor:[UIColor greenColor]];
            
            controller.allowsPictureInPicturePlayback = YES;
            
            [self presentViewController:controller animated:YES completion:nil];
            controller.player = player;
            [player play];
        }
        else
        {
            
            for(int i=0;i<[arrayForBool7a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool7a replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool7a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            [player pause];
        }
    }
    else if(sectionPlay==7)
    {
        if([[arrayForBool8a objectAtIndex:rowPlay]isEqualToString:@"NO"])
        {
            
            for(int i=0;i<[arrayForBool8a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool8a replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool8a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            NSURL *urls=[[NSURL alloc]initWithString:[CArray8 objectAtIndex:rowPlay]];
            
            player = [AVPlayer playerWithURL:urls];
            
            AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
            
            [controller.contentOverlayView setBackgroundColor:[UIColor greenColor]];
            
            controller.allowsPictureInPicturePlayback = YES;
            
            [self presentViewController:controller animated:YES completion:nil];
            controller.player = player;
            [player play];
        }
        else
        {
            
            for(int i=0;i<[arrayForBool8a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool8a replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool8a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            [player pause];
        }
    }
    else if(sectionPlay==8)
    {
        if([[arrayForBool9a objectAtIndex:rowPlay]isEqualToString:@"NO"])
        {
            
            for(int i=0;i<[arrayForBool9a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool9a replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool9a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            NSURL *urls=[[NSURL alloc]initWithString:[CArray9 objectAtIndex:rowPlay]];
            
            player = [AVPlayer playerWithURL:urls];
            
            AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
            
            [controller.contentOverlayView setBackgroundColor:[UIColor greenColor]];
            
            controller.allowsPictureInPicturePlayback = YES;
            
            [self presentViewController:controller animated:YES completion:nil];
            controller.player = player;
            [player play];
        }
        else
        {
            
            for(int i=0;i<[arrayForBool9a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool9a replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool9a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            [player pause];
        }
    }
    else if(sectionPlay==9)
    {
        if([[arrayForBool10a objectAtIndex:rowPlay]isEqualToString:@"NO"])
        {
            
            for(int i=0;i<[arrayForBool10a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool10a replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool10a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            NSURL *urls=[[NSURL alloc]initWithString:[CArray10 objectAtIndex:rowPlay]];
            
            player = [AVPlayer playerWithURL:urls];
            
            AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
            
            [controller.contentOverlayView setBackgroundColor:[UIColor greenColor]];
            
            controller.allowsPictureInPicturePlayback = YES;
            
            [self presentViewController:controller animated:YES completion:nil];
            controller.player = player;
            [player play];
        }
        else
        {
            
            for(int i=0;i<[arrayForBool10a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool10a replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool10a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            [player pause];
        }
    }
    else if(sectionPlay==10)
    {
        if([[arrayForBool11a objectAtIndex:rowPlay]isEqualToString:@"NO"])
        {
            
            for(int i=0;i<[arrayForBool11a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool11a replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool11a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            NSURL *urls=[[NSURL alloc]initWithString:[CArray11 objectAtIndex:rowPlay]];
            
            player = [AVPlayer playerWithURL:urls];
            
            AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
            
            [controller.contentOverlayView setBackgroundColor:[UIColor greenColor]];
            
            controller.allowsPictureInPicturePlayback = YES;
            
            [self presentViewController:controller animated:YES completion:nil];
            controller.player = player;
            [player play];
        }
        else
        {
            
            for(int i=0;i<[arrayForBool11a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool11a replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool11a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            [player pause];
        }
    }
    else if(sectionPlay==11)
    {
        if([[arrayForBool12a objectAtIndex:rowPlay]isEqualToString:@"NO"])
        {
            
            for(int i=0;i<[arrayForBool12a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool12a replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool12a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            NSURL *urls=[[NSURL alloc]initWithString:[CArray12 objectAtIndex:rowPlay]];
            
            player = [AVPlayer playerWithURL:urls];
            
            AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
            
            [controller.contentOverlayView setBackgroundColor:[UIColor greenColor]];
            
            controller.allowsPictureInPicturePlayback = YES;
            
            [self presentViewController:controller animated:YES completion:nil];
            controller.player = player;
            [player play];
        }
        else
        {
            
            for(int i=0;i<[arrayForBool12a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool12a replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool12a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            [player pause];
        }
    }
    else if(sectionPlay==12)
    {
        if([[arrayForBool13a objectAtIndex:rowPlay]isEqualToString:@"NO"])
        {
            
            for(int i=0;i<[arrayForBool13a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool13a replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool13a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            NSURL *urls=[[NSURL alloc]initWithString:[CArray13 objectAtIndex:rowPlay]];
            
            player = [AVPlayer playerWithURL:urls];
            
            AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
            
            [controller.contentOverlayView setBackgroundColor:[UIColor greenColor]];
            
            controller.allowsPictureInPicturePlayback = YES;
            
            [self presentViewController:controller animated:YES completion:nil];
            controller.player = player;
            [player play];
        }
        else
        {
            
            for(int i=0;i<[arrayForBool13a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool13a replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool13a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            [player pause];
        }
    }
    else if(sectionPlay==13)
    {
        if([[arrayForBool14a objectAtIndex:rowPlay]isEqualToString:@"NO"])
        {
            
            for(int i=0;i<[arrayForBool14a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool14a replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool14a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            NSURL *urls=[[NSURL alloc]initWithString:[CArray14 objectAtIndex:rowPlay]];
            
            player = [AVPlayer playerWithURL:urls];
            
            AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
            
            [controller.contentOverlayView setBackgroundColor:[UIColor greenColor]];
            
            controller.allowsPictureInPicturePlayback = YES;
            
            [self presentViewController:controller animated:YES completion:nil];
            controller.player = player;
            [player play];
        }
        else
        {
            
            for(int i=0;i<[arrayForBool14a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool14a replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool14a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            [player pause];
        }
    }
    else if(sectionPlay==14)
    {
        if([[arrayForBool15a objectAtIndex:rowPlay]isEqualToString:@"NO"])
        {
            
            for(int i=0;i<[arrayForBool15a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool15a replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool15a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            NSURL *urls=[[NSURL alloc]initWithString:[CArray15 objectAtIndex:rowPlay]];
            
            player = [AVPlayer playerWithURL:urls];
            
            AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
            
            [controller.contentOverlayView setBackgroundColor:[UIColor greenColor]];
            
            controller.allowsPictureInPicturePlayback = YES;
            
            [self presentViewController:controller animated:YES completion:nil];
            controller.player = player;
            [player play];
        }
        else
        {
            
            for(int i=0;i<[arrayForBool15a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool15a replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool15a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            [player pause];
        }
    }
    else if(sectionPlay==15)
    {
        if([[arrayForBool16a objectAtIndex:rowPlay]isEqualToString:@"NO"])
        {
            
            for(int i=0;i<[arrayForBool16a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool16a replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool16a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            NSURL *urls=[[NSURL alloc]initWithString:[CArray16 objectAtIndex:rowPlay]];
            
            player = [AVPlayer playerWithURL:urls];
            
            AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
            
            [controller.contentOverlayView setBackgroundColor:[UIColor greenColor]];
            
            controller.allowsPictureInPicturePlayback = YES;
            
            [self presentViewController:controller animated:YES completion:nil];
            controller.player = player;
            [player play];
        }
        else
        {
            
            for(int i=0;i<[arrayForBool16a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool16a replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool16a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            [player pause];
        }
    }
    else if(sectionPlay==16)
    {
        if([[arrayForBool17a objectAtIndex:rowPlay]isEqualToString:@"NO"])
        {
            
            for(int i=0;i<[arrayForBool17a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool17a replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool17a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            NSURL *urls=[[NSURL alloc]initWithString:[CArray17 objectAtIndex:rowPlay]];
            
            player = [AVPlayer playerWithURL:urls];
            
            AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
            
            [controller.contentOverlayView setBackgroundColor:[UIColor greenColor]];
            
            controller.allowsPictureInPicturePlayback = YES;
            
            [self presentViewController:controller animated:YES completion:nil];
            controller.player = player;
            [player play];
        }
        else
        {
            
            for(int i=0;i<[arrayForBool17a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool17a replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool17a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            [player pause];
        }
    }
    else if(sectionPlay==17)
    {
        if([[arrayForBool18a objectAtIndex:rowPlay]isEqualToString:@"NO"])
        {
            
            for(int i=0;i<[arrayForBool18a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool18a replaceObjectAtIndex:i withObject:@"YES"];
                    continue;
                }
                
                [arrayForBool18a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            NSURL *urls=[[NSURL alloc]initWithString:[CArray18 objectAtIndex:rowPlay]];
            
            player = [AVPlayer playerWithURL:urls];
            
            AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
            
            [controller.contentOverlayView setBackgroundColor:[UIColor greenColor]];
            
            controller.allowsPictureInPicturePlayback = YES;
            
            [self presentViewController:controller animated:YES completion:nil];
            controller.player = player;
            [player play];
        }
        else
        {
            
            for(int i=0;i<[arrayForBool18a count];i++)
            {
                if(i==rowPlay)
                {                [arrayForBool18a replaceObjectAtIndex:i withObject:@"NO"];
                    continue;
                }
                
                [arrayForBool18a replaceObjectAtIndex:i withObject:@"NO"];
                
            }
            
            [self.tableView reloadData];
            [player pause];
        }
    }
}

-(void)loadCategory
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)    {
        NSLog(@"Not Connected to Internet");
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert"
                                                                      message:@"Internet connection is down"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        NSLog(@"you pressed Yes, please button");
                                        
                                    }];
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        @try
        {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=view_all_admin_audios_according_to_category";
            
            NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS"};
            
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
            hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
            
            [_currentWindow addSubview:_BlurView];
            
            [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
             {
                 
                 NSMutableDictionary *response=responseObject;
                 
                 music_response= [response objectForKey:@"view_admin_music"];
                 
                 //start of subcat count
                 for(NSDictionary *musicDic in music_response)
                 {
                     NSLog(@"musicdicc %@\n",musicDic);
                     
                     NSEnumerator *enumerator = [musicDic keyEnumerator];
                     id key;
                     NSArray *musicArr;
                     
                     while((key = [enumerator nextObject]))
                     {
                         [montage_music addObject:key];
                         
                         musicArr=[musicDic objectForKey:key];
                         
                         [music_count addObject:[NSNumber numberWithLong:musicArr.count]];
                     }
                 }
                 
                 //end of subcat count
                 
                 for (int i=0; i<[montage_music count]; i++)
                 {
                     [arrayForBool addObject:[NSNumber numberWithBool:NO]];
                 }
                 
                 NSLog(@"Image Response %@",music_response);
                 
                 for (int i=0; i<music_response.count; i++)
                 {
                     NSDictionary *musicTitleObject=[music_response objectAtIndex:i];
                     
                     NSEnumerator *enumerator = [musicTitleObject keyEnumerator];
                     id key;
                     
                     key = [enumerator nextObject];
                     
                     NSArray *musicTitleArray=[musicTitleObject objectForKey:key];
                     
                     for (int j=0; j<musicTitleArray.count; j++)
                     {
                         
                         NSDictionary *musicDetails=[musicTitleArray objectAtIndex:j];
                         
                         NSString *name=[musicDetails objectForKey:@"name"];
                         NSString *content=[musicDetails objectForKey:@"content"];
                         NSString *idVal=[musicDetails objectForKey:@"id"];
                         
                         if([key isEqual:@"Alternative Rock"])
                         {
                             [Array1 addObject:name];
                             [CArray1 addObject:content];
                             [IdArray1 addObject:idVal];
                         }
                         else if([key isEqual:@"4th of july"])
                         {
                             [Array2 addObject:name];
                             [CArray2 addObject:content];
                             [IdArray2 addObject:idVal];
                         }
                         else if([key isEqual:@"Blues"])
                         {
                             [Array3 addObject:name];
                             [CArray3 addObject:content];
                             [IdArray3 addObject:idVal];
                         }
                         else if([key isEqual:@"Christmas"])
                         {
                             [Array4 addObject:name];
                             [CArray4 addObject:content];
                             [IdArray4 addObject:idVal];
                         }
                         else if([key isEqual:@"Classic rock"])
                         {
                             [Array5 addObject:name];
                             [CArray5 addObject:content];
                             [IdArray5 addObject:idVal];
                         }
                         else if([key isEqual:@"Classical"])
                         {
                             [Array6 addObject:name];
                             [CArray6 addObject:content];
                             [IdArray6 addObject:idVal];
                         }
                         else if([key isEqual:@"Corporate"])
                         {
                             [Array7 addObject:name];
                             [CArray7 addObject:content];
                             [IdArray7 addObject:idVal];
                         }
                         else if([key isEqual:@"Country"])
                         {
                             [Array8 addObject:name];
                             [CArray8 addObject:content];
                             [IdArray8 addObject:idVal];
                         }
                         else if([key isEqual:@"Easy listening"])
                         {
                             [Array9 addObject:name];
                             [CArray9 addObject:content];
                             [IdArray9 addObject:idVal];
                         }
                         else if([key isEqual:@"Epic"])
                         {
                             [Array10 addObject:name];
                             [CArray10 addObject:content];
                             [IdArray10 addObject:idVal];
                         }
                         else if([key isEqual:@"Happy _ Inspiring"])
                         {
                             [Array11 addObject:name];
                             [CArray11 addObject:content];
                             [IdArray11 addObject:idVal];
                         }
                         else if([key isEqual:@"Hip Hop"])
                         {
                             [Array12 addObject:name];
                             [CArray12 addObject:content];
                             [IdArray12 addObject:idVal];
                         }
                         else if([key isEqual:@"island"])
                         {
                             [Array13 addObject:name];
                             [CArray13 addObject:content];
                             [IdArray13 addObject:idVal];
                         }
                         else if([key isEqual:@"Jazz"])
                         {
                             [Array14 addObject:name];
                             [CArray14 addObject:content];
                             [IdArray14 addObject:idVal];
                         }
                         else if([key isEqual:@"Sad"])
                         {
                             [Array15 addObject:name];
                             [CArray15 addObject:content];
                             [IdArray15 addObject:idVal];
                         }
                         else if([key isEqual:@"Sentimental"])
                         {
                             [Array16 addObject:name];
                             [CArray16 addObject:content];
                             [IdArray16 addObject:idVal];
                         }
                         else if([key isEqual:@"Techno"])
                         {
                             [Array17 addObject:name];
                             [CArray17 addObject:content];
                             [IdArray17 addObject:idVal];
                         }
                         else if([key isEqual:@"World"])
                         {
                             [Array18 addObject:name];
                             [CArray18 addObject:content];
                             [IdArray18 addObject:idVal];
                         }
                     }
                 }
                 
                 for (int i=0; i<[CArray1 count]; i++)
                 {
                     [arrayForBool1 insertObject:@"NO" atIndex:i];
                     [arrayForBool1a insertObject:@"NO" atIndex:i];
                 }
                 
                 for (int i=0; i<[CArray2 count]; i++)
                 {
                     [arrayForBool2 insertObject:@"NO" atIndex:i];
                     [arrayForBool2a insertObject:@"NO" atIndex:i];
                 }
                 
                 for (int i=0; i<[CArray3 count]; i++)
                 {
                     [arrayForBool3 insertObject:@"NO" atIndex:i];
                     [arrayForBool3a insertObject:@"NO" atIndex:i];
                 }
                 
                 for (int i=0; i<[CArray4 count]; i++)
                 {
                     [arrayForBool4 insertObject:@"NO" atIndex:i];
                     [arrayForBool4a insertObject:@"NO" atIndex:i];
                 }
                 
                 for (int i=0; i<[CArray5 count]; i++)
                 {
                     [arrayForBool5 insertObject:@"NO" atIndex:i];
                     [arrayForBool5a insertObject:@"NO" atIndex:i];
                 }
                 
                 for (int i=0; i<[CArray6 count]; i++)
                 {
                     [arrayForBool6 insertObject:@"NO" atIndex:i];
                     [arrayForBool6a insertObject:@"NO" atIndex:i];
                 }
                 
                 for (int i=0; i<[CArray7 count]; i++)
                 {
                     [arrayForBool7 insertObject:@"NO" atIndex:i];
                     [arrayForBool7a insertObject:@"NO" atIndex:i];
                 }
                 
                 for (int i=0; i<[CArray8 count]; i++)
                 {
                     [arrayForBool8 insertObject:@"NO" atIndex:i];
                     [arrayForBool8a insertObject:@"NO" atIndex:i];
                 }
                 
                 for (int i=0; i<[CArray9 count]; i++)
                 {
                     [arrayForBool9 insertObject:@"NO" atIndex:i];
                     [arrayForBool9a insertObject:@"NO" atIndex:i];
                 }
                 
                 for (int i=0; i<[CArray10 count]; i++)
                 {
                     [arrayForBool10 insertObject:@"NO" atIndex:i];
                     [arrayForBool10a insertObject:@"NO" atIndex:i];
                 }
                 
                 for (int i=0; i<[CArray11 count]; i++)
                 {
                     [arrayForBool11 insertObject:@"NO" atIndex:i];
                     [arrayForBool11a insertObject:@"NO" atIndex:i];
                 }
                 
                 for (int i=0; i<[CArray12 count]; i++)
                 {
                     [arrayForBool12 insertObject:@"NO" atIndex:i];
                     [arrayForBool12a insertObject:@"NO" atIndex:i];
                 }
                 for (int i=0; i<[CArray13 count]; i++)
                 {
                     [arrayForBool13 insertObject:@"NO" atIndex:i];
                     [arrayForBool13a insertObject:@"NO" atIndex:i];
                 }
                 
                 for (int i=0; i<[CArray14 count]; i++)
                 {
                     [arrayForBool14 insertObject:@"NO" atIndex:i];
                     [arrayForBool14a insertObject:@"NO" atIndex:i];
                 }
                 
                 for (int i=0; i<[CArray15 count]; i++)
                 {
                     [arrayForBool15 insertObject:@"NO" atIndex:i];
                     [arrayForBool15a insertObject:@"NO" atIndex:i];
                 }
                 
                 for (int i=0; i<[CArray16 count]; i++)
                 {
                     [arrayForBool16 insertObject:@"NO" atIndex:i];
                     [arrayForBool16a insertObject:@"NO" atIndex:i];
                 }
                 for (int i=0; i<[CArray17 count]; i++)
                 {
                     [arrayForBool17 insertObject:@"NO" atIndex:i];
                     [arrayForBool17a insertObject:@"NO" atIndex:i];
                 }
                 
                 for (int i=0; i<[CArray18 count]; i++)
                 {
                     [arrayForBool18 insertObject:@"NO" atIndex:i];
                     [arrayForBool18a insertObject:@"NO" atIndex:i];
                 }
                 
                 [self.tableView reloadData];
                 
                 [hud hideAnimated:YES];
                 [_BlurView removeFromSuperview];
                 
             }
                  failure:^(NSURLSessionTask *operation, NSError *error)
             {
                 NSLog(@"Error9: %@", error);
                 
                 [hud hideAnimated:YES];
                 
                 [_BlurView removeFromSuperview];
                 
                 UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Error"
                                                                               message:@"Could not connect to server"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:nil];
                 
                 [alert addAction:yesButton];
                 
                 [self presentViewController:alert animated:YES completion:nil];
                 
             }];
        }
        @catch (NSException *exception)
        {
            NSLog(@"Exception = %@",exception);
            
            [hud hideAnimated:YES];
            
            [_BlurView removeFromSuperview];
            
        }
        @finally
        {
            NSLog(@"Finally Exception");
        }
    }
}

- (IBAction)back:(id)sender
{
    NSString *option=[[NSUserDefaults standardUserDefaults]objectForKey:@"isWizardOrAdvance"];
    
    if([option isEqualToString:@"Wizard"])
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_20" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:nil];
        
        /*  UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
         
         DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
         
         [vc awakeFromNib:@"contentController_7" arg:@"menuController"];
         
         vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
         [self presentViewController:vc animated:YES completion:NULL];
         */
    }
    else
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAdvance" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_3" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"CreateNewFinalDic"];
    }
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(AdminMusicViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section %2 ==0)
    {
    if(indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor whiteColor];

    else
        cell.backgroundColor =UIColorFromRGB(0xE4E4E4);
    }
    
    else
    {
        if(indexPath.row % 2 == 0)
            cell.backgroundColor =UIColorFromRGB(0xE4E4E4);
        
        else
            cell.backgroundColor = [UIColor whiteColor];

    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView=[[UIView alloc]init];
    UIImageView *plusImg;
    UILabel *viewLabel;
    UIImageView *roundImg;
    UILabel *countLbl;
    
    if(section % 2 == 0)
    {
        sectionView.backgroundColor =UIColorFromRGB(0xE4E4E4);
    }
    else
        sectionView.backgroundColor = [UIColor whiteColor];
    
    sectionView.tag=section;
    
if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    plusImg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 30, 30)];
    else
        plusImg=[[UIImageView alloc]initWithFrame:CGRectMake(40, 20, 32, 32)];
    
    plusImg.image=[UIImage imageNamed:@"music_close_150"];
    
if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(63, 10, self.tableView.frame.size.width-150, 40)];
    else
        viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 18, self.tableView.frame.size.width-50, 40)];
    
    viewLabel.textColor=[UIColor blackColor];
    
    viewLabel.font = [UIFont fontWithName:@"FuturaT-Book" size:20.0f];
    
    viewLabel.text=[montage_music objectAtIndex:section];
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    
    //roundImg=[[UIImageView alloc]initWithFrame:CGRectMake(367, 15, 30, 30)];
    
    roundImg=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-46,15 , 30, 30)];
    
    else
        roundImg=[[UIImageView alloc]initWithFrame:CGRectMake(710, 18, 30, 30)];
    
    roundImg.image=[UIImage imageNamed:@"backround_music_count"];
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    countLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-40, 15, 30, 30)];
    
    else
        countLbl=[[UILabel alloc]initWithFrame:CGRectMake(717, 18, 30, 30)];
    
    countLbl.text=[NSString stringWithFormat:@"%@",[music_count objectAtIndex:section]];
    
    countLbl.textColor=[UIColor whiteColor];
    
    countLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    
    [sectionView addSubview:plusImg];
    [sectionView addSubview:viewLabel];
    [sectionView addSubview:roundImg];
    
    [sectionView addSubview:countLbl];
    
    BOOL expanded  = [[arrayForBool objectAtIndex:section] boolValue];
    
    if(expanded)
        plusImg.image=[UIImage imageNamed:@"music_open_150.png"];
    else
        plusImg.image=[UIImage imageNamed:@"music_close_150"];
    
    /********** Add UITapGestureRecognizer to SectionView   **************/
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    
    [sectionView addGestureRecognizer:headerTapped];
    
    return  sectionView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        return 70;
    else
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    return 70;
    else
        return 60;
}


- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0)
    {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        
        for (int i=0; i<[music_response count]; i++)
        {
            if (indexPath.section==i)
            {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (IBAction)doneAction:(id)sender
{
    if(sectionCheck==0)
        idVal=[IdArray1 objectAtIndex:rowCheck];
    else if(sectionCheck==1)
        idVal=[IdArray2 objectAtIndex:rowCheck];
    
    else if(sectionCheck==2)
        idVal=[IdArray3 objectAtIndex:rowCheck];
    else if(sectionCheck==3)
        idVal=[IdArray4 objectAtIndex:rowCheck];
    else if(sectionCheck==4)
        idVal=[IdArray5 objectAtIndex:rowCheck];
    else if(sectionCheck==5)
        idVal=[IdArray6 objectAtIndex:rowCheck];
    else if(sectionCheck==6)
        idVal=[IdArray7 objectAtIndex:rowCheck];
    else if(sectionCheck==7)
        idVal=[IdArray8 objectAtIndex:rowCheck];
    else if(sectionCheck==8)
        idVal=[IdArray9 objectAtIndex:rowCheck];
    else if(sectionCheck==9)
        idVal=[IdArray10 objectAtIndex:rowCheck];
    else if(sectionCheck==10)
        idVal=[IdArray11 objectAtIndex:rowCheck];
    else if(sectionCheck==11)
        idVal=[IdArray12 objectAtIndex:rowCheck];
    else if(sectionCheck==12)
        idVal=[IdArray13 objectAtIndex:rowCheck];
    else if(sectionCheck==13)
        idVal=[IdArray14 objectAtIndex:rowCheck];
    else if(sectionCheck==14)
        idVal=[IdArray15 objectAtIndex:rowCheck];
    else if(sectionCheck==15)
        idVal=[IdArray16 objectAtIndex:rowCheck];
    else if(sectionCheck==16)
        idVal=[IdArray17 objectAtIndex:rowCheck];
    else if(sectionCheck==17)
        idVal=[IdArray18 objectAtIndex:rowCheck];
    
    NSLog(@"Selected ID = %@",idVal);
    
    NSString *option=[[NSUserDefaults standardUserDefaults]objectForKey:@"isWizardOrAdvance"];
    NSLog(@"Wizard Option:%@",option);
    
    if([option isEqualToString:@"Wizard"])
    {
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[NSUserDefaults standardUserDefaults]setObject:idVal forKey:@"WizardMusicId"];
        [[NSUserDefaults standardUserDefaults]setObject:@"admin" forKey:@"WizardMusictype"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_20" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:nil];
        
//        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
//
//        WizardAddTitileViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AddTitle"];
//
//        //vc.playerURL = rID;
//
//        [self.navigationController presentViewController:vc animated:YES completion:NULL];
    }
    else
    {
        //Chcking MainArray
        MainArray=[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"MainArray"]];
        NSLog(@"MainArray_didLoad_1 %@",MainArray);
        if(MainArray == nil ){
            MainArray= [[NSMutableArray alloc]init];
        }
        
        //Generating Random Color
        CGFloat hue = ( arc4random() % 256 / 256.0 ); // 0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0, away from black
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        NSString *colorString = [self hexStringFromColor:color];
        
        //Chcking MainArray
        
        NSMutableDictionary *finalDic = [MainArray objectAtIndex:selected_cell_index];
        [finalDic setValue:@"admin" forKey:@"music_type"];
        [finalDic setValue:idVal forKey:@"music"];
        [finalDic setValue:@"1" forKey:@"music_color_identification"];
        [finalDic setValue:colorString forKey:@"music_color"];
        
        for(int i=selected_cell_index+1;i<MainArray.count;i++){

            NSMutableDictionary *finalDic = [MainArray objectAtIndex:i];
            if([[finalDic valueForKey:@"music_color_identification"] isEqualToString:@"0"]){
                [finalDic setValue:@"admin" forKey:@"music_type"];
                [finalDic setValue:idVal forKey:@"music"];
                [finalDic setValue:colorString forKey:@"music_color"];
                
                [MainArray replaceObjectAtIndex:i withObject:finalDic];
            }else{
                break;
            }
        }
        [MainArray replaceObjectAtIndex:selected_cell_index withObject:finalDic];
        //Generating Final
        
        //UPDAteMainArrayUserDefaults
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:MainArray]  forKey:@"MainArray"];
        [defaults synchronize];
        //UPDAteMainArrayUserDefaults
        
        NSLog(@"MainArray_cellLoad %@",MainArray);
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAdvance" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_3" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
    }
    
}

/*{
    if(sectionCheck==0)
        idVal=[IdArray1 objectAtIndex:rowCheck];
    else if(sectionCheck==1)
        idVal=[IdArray2 objectAtIndex:rowCheck];
    
    else if(sectionCheck==2)
        idVal=[IdArray3 objectAtIndex:rowCheck];
    else if(sectionCheck==3)
        idVal=[IdArray4 objectAtIndex:rowCheck];
    else if(sectionCheck==4)
        idVal=[IdArray5 objectAtIndex:rowCheck];
    else if(sectionCheck==5)
        idVal=[IdArray6 objectAtIndex:rowCheck];
    else if(sectionCheck==6)
        idVal=[IdArray7 objectAtIndex:rowCheck];
    else if(sectionCheck==7)
        idVal=[IdArray8 objectAtIndex:rowCheck];
    else if(sectionCheck==8)
        idVal=[IdArray9 objectAtIndex:rowCheck];
    else if(sectionCheck==9)
        idVal=[IdArray10 objectAtIndex:rowCheck];
    else if(sectionCheck==10)
        idVal=[IdArray11 objectAtIndex:rowCheck];
    else if(sectionCheck==11)
        idVal=[IdArray12 objectAtIndex:rowCheck];
    else if(sectionCheck==12)
        idVal=[IdArray13 objectAtIndex:rowCheck];
    else if(sectionCheck==13)
        idVal=[IdArray14 objectAtIndex:rowCheck];
    else if(sectionCheck==14)
        idVal=[IdArray15 objectAtIndex:rowCheck];
    else if(sectionCheck==15)
        idVal=[IdArray16 objectAtIndex:rowCheck];
    else if(sectionCheck==16)
        idVal=[IdArray17 objectAtIndex:rowCheck];
    else if(sectionCheck==17)
        idVal=[IdArray18 objectAtIndex:rowCheck];
    
    NSLog(@"sectioncheck and id val %d%@",sectionCheck,idVal);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Accesss Number"
                                                    message:Nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:[NSString stringWithFormat:@"section %d",sectionCheck],[NSString stringWithFormat:@"Id %@",idVal],nil];
    [alert show];
 
}*/

-(NSString*)hexStringFromColor:(UIColor*)color
{
    NSString *webColor = nil;
    
    // This method only works for RGB colors
    if (color &&
        CGColorGetNumberOfComponents(color.CGColor) == 4)
    {
        // Get the red, green and blue components
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        
        // These components range from 0.0 till 1.0 and need to be converted to 0 till 255
        CGFloat red, green, blue;
        red = roundf(components[0] * 255.0);
        green = roundf(components[1] * 255.0);
        blue = roundf(components[2] * 255.0);
        
        // Convert with %02x (use 02 to always get two chars)
        webColor = [[NSString alloc]initWithFormat:@"#%02x%02x%02x", (int)red, (int)green, (int)blue];
    }
    return webColor;
}

@end

