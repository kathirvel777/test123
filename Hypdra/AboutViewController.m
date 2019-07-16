//
//  ViewController.m
//  About
//
//  Created by MacBookPro on 7/6/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutTableViewCell.h"
#import "REFrostedViewController.h"
#import "DEMORootViewController.h"
#import "DEMOMenuViewController.h"

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

@interface AboutViewController ()
{
    NSArray *titleArray,*desValue,*disImage;
}

@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // disImage = @[@"1-1",@"2-1",@"3-1",@"4-1",@"5-1",@"6-1",@"7-1"];
    
    disImage = @[@"1.",@"2.",@"3.",@"4.",@"5.",@"6.",@"7."];
    
    titleArray = @[@"About us",@"Our Mission",@"Our Emotion Sense Technology (EST)",@"Leave Impression While Communicating",@"Enjoy Beautiful Results for Effortless Creation",@"We Have a team of Super Smart and Collaborative People",@"Our Vision-We Promote Creativity"];
    
    
    desValue = @[@"We understand and evaluate your objectives, before turning your videos and photos into attractive short movies adding emotions and excitement to the core story.",@"We believe and try to follow the people, who have experienced life to the fullest. We appreciate and applaud the creativity of people and try to represent their work before the audience.",@"For us, EST is a breathtaking technology that helps us executing our tasks and achieving the desired result. Our EST tool allow users to transform their photos and videos into high-quality movies. The tool helps users to include Hollywood-styled suspense or nerve-exciting action in their video clips.",@"Create impactful social graphics, meaningful photos and animated videos and represent them before the audience. We will help you to make your creation more attractive and interesting without harming its actual purpose.",@"We have gained expertise in this field with our years of experience. Our technical team always use the best tool to turn users' content into an attractive, relevant and significant material.",@"We believe that it is not only the perks that can keep people excited and motivated on their job. We work with a team of super smart and collaborative people who are experts in addressing challenging problems. We feel proud to say that people associated with our company are passionate about helping others in sharing their stories and creativities with the masses through well-polished and high-quality videos.",@"We always give value to trust, transparency and wellness and we feel proud to say that these features are an integral part of our vision. We promote creativity and provide room for personal growth to our staff.              "];
    
    //self.tableView.estimatedRowHeight = 178.0;
  //  self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.bounces = false;
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self.tableView setAllowsSelection:NO];
    
    UIImage *backgroundImage=[UIImage imageNamed:@"tag-1"];//@"background_about_us_row_item.9"];
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithPatternImage:backgroundImage];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [desValue count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"AboutTableViewCell";
    
    AboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
        cell = [[AboutTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    cell.titleValue.text = titleArray[indexPath.row];
    [cell.titleValue setFont:[UIFont fontWithName:@"FuturaT-Book" size:20.0]];
    cell.descriptionValue.text = desValue[indexPath.row];
    [cell.titleValue setFont:[UIFont fontWithName:@"FuturaT-Book" size:17.0]];
    // cell.disImage.image = [UIImage imageNamed:disImage[indexPath.row]];
    cell.number.text = disImage[indexPath.row];
    [cell.titleValue setFont:[UIFont fontWithName:@"FuturaT-Book" size:20.0]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.tableView.estimatedRowHeight = 178.0;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    return UITableViewAutomaticDimension;
    if(IS_PAD){
    if(indexPath.row==2)
    {
    return 150;
    }else if (indexPath.row == 0){
        return 120;
    }else if (indexPath.row == 1){
        return 120;
    }
    else if(indexPath.row==3)
        return 140;
else if (indexPath.row == 4)
    return 120;
    else if(indexPath.row==5)
        return 200;

    else if(indexPath.row==6)
        return 130;

    else
        return 175;
    }else{
        if(indexPath.row==2)
        {
            return 220;
        }else if (indexPath.row == 0){
            return 165;
        }else if (indexPath.row == 1){
            return 165;
        }
        else if(indexPath.row==3)
            return 190;
        
        else if(indexPath.row==5)
            return 310;
        
        else if(indexPath.row==6)
            return 200;
        
        else
            return 175;
    }
}

- (IBAction)back:(id)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"demo_pageselection" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)menu:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setInteger:6 forKey:@"SelectedIndex"];

    [self.view endEditing:YES];

    [self.frostedViewController.view endEditing:YES];

    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;

    [self.frostedViewController presentMenuViewController];
}

@end

