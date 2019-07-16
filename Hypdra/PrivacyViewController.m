//
//  PrivacyViewController.m
//  About
//
//  Created by MacBookPro on 7/7/17.
//  Copyright © 2017 sssn. All rights reserved.

#import "PrivacyViewController.h"
#import "PrivacyTableViewCell.h"
#import "REFrostedViewController.h"
#import "DEMORootViewController.h"

@interface PrivacyViewController ()
{
    NSArray *titleArray,*desValue;
}
@end

@implementation PrivacyViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    titleArray = @[@"THE WAYS WE COLLECT INFORMATION AND USE THEM",@"INFORMATION PROVIDED BY USERS DIRECTLY",@"THIRD PARTY INFORMATION",@"COOKIES INFORMATION",@"LOG FILE INFORMATION",@"DEVICE IDENTIFIERS",@"GEOGRAPHICAL INFORMATION",@"THE USE OF INFORMATION, WE COLLECT FROM YOU",@"WE CAN SHARE INFORMATION WITH THIRD PARTIES",@"CHILDREN'S PRIVACY",@"HOW TO CONTACT US"];
//
//    desValue = @[@"Here, we will stress on the ways we collect your information and use them for our service.",@"Certain information such as your username, first and last name, date of birth, mobile phone number, email address will be required when you will become our registered user. We use your valuable information to operate and maintain all the features and functionality of our service.",@"We also receive information from third parties. If you access our service through third party connections like Facebook, the third party will then pass some information about you to our database.",@"You can receive one or more cookies in the form of some alphanumeric characters. We do this to identify your browser that helps our technical experts to make the login process faster and better the process of navigation through the site.",@"We receive your log file information whenever you access our service. Whenever you log in to our site, our server records your log file information automatically.",@"Whenever you access our service through your mobile device, we are open to collect, monitor and store information of your device. We use device identifier tool that helps us collect information about your device and browsers.",@"Whenever you access our service through a mobile device or any other tools, we collect remotely stored \"location Data\" including GPS coordinates that help us to accumulate information on your exact location.",@"We collect as much information as possible from you through cookies, log file, device identifiers and geographical data. Here are some ways through which we use our customers' data.\n\t 1.We remember every detail you have shared with us\n\t 2.Always offer custom and personalized content\n\t 3.We collect information on the total number of visitors and demographic pattern\n\t 4.Diagnose or fix technology problems",@"In order to provide better service to you, we often share our information with third parties, who can be our business partners. No matter if you like it or not, our external partners will provide limited access to your information.",@"Our privacy policy does not accept information from children less than 13 years of age. If a child pretends to be above 18 and has not provided any correct information, we will eliminate such accounts by considering them false and unfounded.",@"If you are finding it difficult to understand any part of our Privacy Policy, mail us at support@hypdra.com\n\n"];
//
//    self.tableView.estimatedRowHeight = 168.0;
//
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.bounces = false;
//
//    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//    [self.tableView setAllowsSelection:NO];
    
    UIImage *backgroundImage=[UIImage imageNamed:@"tag-1"];//@"background_about_us_row_item.9"];
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithPatternImage:backgroundImage];
    NSURL *url = [NSURL URLWithString:@"https://www.hypdra.com/privacy.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    static NSString *cellIdentifier = @"Cell";
    PrivacyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
        cell = [[PrivacyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    cell.nameValue.text = titleArray[indexPath.row];
    cell.desValue.text = desValue[indexPath.row];
    
    return cell;
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
    [[NSUserDefaults standardUserDefaults]setInteger:8 forKey:@"SelectedIndex"];
    [self.view endEditing:YES];
    
    [self.frostedViewController.view endEditing:YES];
    
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    
    [self.frostedViewController presentMenuViewController];
}

@end

