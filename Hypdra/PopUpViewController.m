//
//  PopUpViewController.m
//  Montage
//
//  Created by MacBookPro4 on 9/30/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "PopUpViewController.h"

@interface PopUpViewController ()
{
    NSArray *options,*libOptions;
}

@end

@implementation PopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    options=@[@"Edit button",@"Use for video",@"Make a copy",@"Delete"];
    libOptions=@[@"Edit",@"Use for Video"];
    
    NSLog(@"fromLIB:%@",_fromLib);
    
    [self.popUpTableView reloadData];
}

- (void)didReceiveMemoryWarning {
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([_fromLib isEqualToString:@"yes"])
    {
        return  libOptions.count;
    }
    else
    {
        return options.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *simpleTableIdentifier = @"ChoosesUserNameTableViewCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"popCell"];
    //  if (cell == nil)
    //  {
    //      NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChoosesUserNameTableViewCell" owner:self options:nil];
    //      cell = [nib objectAtIndex:0];
    //  }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [cell.textLabel setFont:[UIFont fontWithName:@"FuturaT-Book" size:18]];
        
    }else{
        [cell.textLabel setFont:[UIFont fontWithName:@"FuturaT-Book" size:13]];
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    
    if([_fromLib isEqualToString:@"yes"])
    {
        cell.textLabel.text=[libOptions objectAtIndex:indexPath.row];
        
    }
    else
    {
        cell.textLabel.text=[options objectAtIndex:indexPath.row];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected option:%@",[options objectAtIndex:indexPath.row]);
    
    if([_fromLib isEqualToString:@"yes"])
    {
        if(indexPath.row==0)
        {
            NSLog(@"tableview index 0");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CallToActionEditLibrary" object:nil];
        }
        else if (indexPath.row==1)
        {
            NSLog(@"tableview index 1");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CallToActionUseforVideoLibrary" object:nil];
        }
    }
    else
    {
        if(indexPath.row==0)
        {
            NSLog(@"tableview index 0");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CallToActionEdit" object:nil];
            
        }
        else if (indexPath.row==1)
        {
            NSLog(@"tableview index 1");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CallToActionUseforVideo" object:nil];
        }
        else if (indexPath.row==2)
        {
            NSLog(@"tableview index 2");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Duplicate" object:nil];
            
            
        }
        else if (indexPath.row==3)
        {
            NSLog(@"tableview index 3");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Delete" object:nil];
        }
    }
    
}

@end
