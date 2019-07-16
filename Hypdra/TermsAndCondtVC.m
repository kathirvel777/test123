//
//  TermsAndCondtVC.m
//  Hypdra
//
//  Created by Mac on 7/8/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "TermsAndCondtVC.h"
#import "DEMORootViewController.h"
#import "REFrostedViewController.h"
#import "TermsAndCondt.h"

@interface TermsAndCondtVC (){
     TermsAndCondt *cell;
}

@end

@implementation TermsAndCondtVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialization];
    
    self.TermsNcond_tblview.estimatedRowHeight = 168.0;
    
    
    UIImage *backgroundImage=[UIImage imageNamed:@"tag-1"];//@"background_about_us_row_item.9"];
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithPatternImage:backgroundImage];
    
    NSURL *url = [NSURL URLWithString:@"https://www.hypdra.com/terms.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


#pragma  mark - Initialization

-(void)initialization
{
    arrayForBool=[[NSMutableArray alloc]init];
    sectionTitleArray=[[NSArray alloc]initWithObjects:
                       @"Terms and Conditions",
                       @"Eligibility",
                       @"User's Account",
                       @"Service Rules",
                       @"Uploading User Content",
                       @"Our Proprietary Rights",
                       @"No Warranty",
                       nil];
    
    sectionTitleArray1=[[NSArray alloc]initWithObjects:
                        @"We are the company that provides an online platform for video editing and sharing to the users. Our service features ready-made media and content that are licensable for use in accordance with various rules and regulations.",@"You will only be eligible to use our service if you form a binding contract in compliance with our agreements that are applicable to local, state, national and international laws. You will have to be at least 13 years old or above if you want to access our services. If anyone under 13 tries to use or access our services, the act will be considered as the violation of the agreement.",@"In order to be accepted as a registered user of our site, you will have to provide accurate and complete information. We may ask you to submit your valid photograph as an identification proof. Once you have become a registered user of our site, you will be responsible for all kind of activities that will occur on your account. We always suggest our customers to include a strong password, so that no unauthorized individual sources can access your account.",
                        @"If you have created an account at our site and have become a registered user that means you have agreed to our terms and conditions. With the completion of the agreement, you will be agreed to not practice the following prohibited activities: \n\n1.Copying, sharing and disclosing any part of our service\n2.Using automated system like robot and spiders\n3.Distribution or transmutation of spam, chain letters or any kind of unsolicited email\n4.Uploading invalid data, virus, worms and any other advanced software agents\n5.Collecting or harvesting any personal information including account names from our site\n6.You are using our platform for any kind of solicitation purposes",@"If you are a registered user of our service, then you are agreed not to include content that signifies loss, emotional distress, physical or mental injury. Your page is being used for the promotion of any unlawful activities. Your content should not carry any information encouraging discrimination against race, religion, sex, sexual activities, age and disability.",@"All the contents and materials such as software, images, logos, patents, trademark, copyrights you will find at our site are copyright protected. All the Intellectual Property Rights related to our site are our exclusive property. After going through our terms and condition page, you will be agreed not to sell, rent or modify, distribute, reproduced, transmit or public display of our content.",
                        @"We provide our service on \"as available\" basis. According to the applicable law, the service is provided to the users without any kind of warranties.\n\nWe do not warrant, promote, assume responsibility or warrant for the products or services offered by a third party player. We will not be a part or responsible for any kind of transaction between you and the third party service providers.",nil];
    
    for (int i=0; i<[sectionTitleArray count]; i++)
    {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
    
}


#pragma mark -
#pragma mark TableView DataSource and Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    static NSString *cellIdentifier = @"TermsAndCondt";
    
    cell = (TermsAndCondt*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TermsAndCondt" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //    static NSString *cellid=@"hello";
    //    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    //
    //    if (cell==nil)
    //    {
    //        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    //
    //    }
    
    
    BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
    
    /********** If the section supposed to be closed *******************/
    if(!manyCells)
    {
        cell.backgroundColor=[UIColor blackColor];
        
        cell.textLabel.text=@"";
    }
    /********** If the section supposed to be Opened *******************/
    else
    {
        cell.subLabel.text=[NSString stringWithFormat:@"%@",[sectionTitleArray1 objectAtIndex:indexPath.section]];
        
        // cell.textLabel.font=[UIFont systemFontOfSize:15.0f];
        
        [cell.subLabel setFont:[UIFont fontWithName:@"FuturaT-Book" size:14.0]];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone ;
        
    }
    cell.subLabel.textColor=[UIColor blackColor];
    cell.subLabel.numberOfLines = 0;
    
    
    //********* Add a custom Separator with cell ******************
    //    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 40, _expandableTableView.frame.size.width-15, 1)];
    //    separatorLineView.backgroundColor = [UIColor blackColor];
    //    [cell.contentView addSubview:separatorLineView];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionTitleArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*************** Close the section, once the data is selected ***********************************/
    /*    [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:NO]];
     
     [self.TermsNcond_tblview reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];*/
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue])
    {
        NSLog(@"UITableViewAutomaticDimension %f",UITableViewAutomaticDimension);
        //        return UITableViewAutomaticDimension;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
           /* if(indexPath.section==0)
                return 130;
            else if(indexPath.section==1)
                return 175;
            else if(indexPath.section==2)
                return 205;
            else if(indexPath.section==3)
                return 370;
            else if(indexPath.section==4)
                return 165;
            else if(indexPath.section==5)
                return 175;
            else if(indexPath.section==6)
                return 200;*/
            return [self calculateRowHeight:[sectionTitleArray1 objectAtIndex:indexPath.section]];
        }
        else
        {
            if(indexPath.section==0)
                return [self calculateRowHeight:[sectionTitleArray1 objectAtIndex:indexPath.section]];
            else if(indexPath.section==1)
                return 150;
            else if(indexPath.section==2)
                return 180;
            else if(indexPath.section==3)
                return 260;
            else if(indexPath.section==4)
                return 145;
            else if(indexPath.section==5)
                return 155;
            else if(indexPath.section==6)
                return 180;
        }
    }
    return 0;
}
-(int)calculateRowHeight:(NSString *)text{
    

    int height;
    
    UIFont *font = [UIFont fontWithName:@"FuturaT-Book" size:17.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    
    NSAttributedString *attrString;
    
    attrString = [[NSAttributedString alloc] initWithString:text attributes:attrsDictionary];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize size = [attrString boundingRectWithSize:CGSizeMake(cell.subLabel.frame.size.width/1.5, CGFLOAT_MAX) options:options context:nil].size;
    
    height = ceilf(size.height); // add 1 point as padding
    
   
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //this is the space
    return 0;
}

#pragma mark - Creating View for TableView Section

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView;
    sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.TermsNcond_tblview.frame.size.width,60)];
    
    sectionView.backgroundColor=[UIColor colorWithRed:233/255.0f green:231/255.0f blue:236/255.0f alpha:1];
    
    
    sectionView.tag=section;
    
    UIView *subView;
    
    subView= [[UIView alloc]initWithFrame:CGRectMake(self.TermsNcond_tblview.frame.size.width/20
                                                     , 0, self.TermsNcond_tblview.frame.size.width-80,
                                                     60)];
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        
        subView= [[UIView alloc]initWithFrame:CGRectMake(self.TermsNcond_tblview.frame.size.width/10
                                                         , 0, self.TermsNcond_tblview.frame.size.width-80,
                                                         60)];
    
    UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height)];
    
    viewLabel.backgroundColor=[UIColor clearColor];
    viewLabel.textColor=[UIColor blackColor];
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        [viewLabel setFont:[UIFont fontWithName:@"FuturaT-Book" size:20.0]];
    else
        [viewLabel setFont:[UIFont fontWithName:@"FuturaT-Book" size:22.0]];
    
    viewLabel.text=[sectionTitleArray objectAtIndex:section];
    viewLabel.textAlignment = NSTextAlignmentLeft;
    
    
    viewLabel.numberOfLines=0;
    viewLabel.lineBreakMode=YES;
    [viewLabel sizeToFit];
    [subView addSubview:viewLabel];
    [sectionView addSubview:subView];
    
    UIImageView *imageview1;
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        imageview1=[[UIImageView alloc]initWithFrame:CGRectMake(subView.frame.size.width-15, 10, ((subView.frame.size.width+20)-subView.frame.size.width),40)];
    }
    
    else
    {
        imageview1=[[UIImageView alloc]initWithFrame:CGRectMake(subView.frame.size.width+40, 10, ((subView.frame.size.width+20)-subView.frame.size.width),40)];
    }
    
    [sectionView addSubview:imageview1];
    
    viewLabel.center = CGPointMake(sectionView.frame.size.width/4, sectionView.frame.size.height/2);
    
    [viewLabel setFrame:CGRectMake(0, viewLabel.frame.origin.y, viewLabel.frame.size.width, viewLabel.frame.size.height)];
    //[imageview1 setContentMode:UIViewContentModeCenter];
    [imageview1 setContentMode:UIViewContentModeScaleAspectFit];
    
    BOOL expanded  = [[arrayForBool objectAtIndex:section] boolValue];
    
    if(expanded)
        imageview1.image=[UIImage imageNamed:@"term_up"];
    else
        imageview1.image=[UIImage imageNamed:@"term_down"];
    
    
    CGPoint center  = imageview1.center;
    center.y = 30;
    
    //[imageview1 setCenter:center];
    imageview1.center = center;
    NSLog(@"CenterX %f",center.y);
    /********** Add a custom Separator with Section view *******************/
    
    
    //    /********** Add UITapGestureRecognizer to SectionView   **************/
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
    
    sectionView.backgroundColor=[UIColor colorWithRed:233/255.0f green:231/255.0f blue:236/255.0f alpha:1];
    return sectionView;
}

//#pragma mark - Table header gesture tapped

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0)
    {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        
        for (int i=0; i<[sectionTitleArray count]; i++)
        {
            if (indexPath.section==i)
            {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        
        [self.TermsNcond_tblview reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)back:(id)sender
{     [[NSUserDefaults standardUserDefaults]setInteger:7 forKey:@"SelectedIndex"];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"demo_pageselection" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)menu:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setInteger:7 forKey:@"SelectedIndex"];
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    [self.frostedViewController presentMenuViewController];
}

@end

