//
//  MailIFViewController.m
//  Montage
//
//  Created by apple on 01/08/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "MailIFViewController.h"
#import "MailTableCell.h"


@interface MailIFViewController ()
{
    NSMutableArray *checkmark;
    BOOL check;
    BOOL clicked;
    NSMutableArray *arrayName;
    NSMutableArray *contactNumbersArray;
    NSMutableArray *arrayProfileImg;
    
}

@end

@implementation MailIFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    contactNumbersArray = [[NSMutableArray alloc]init];
    arrayName = [[NSMutableArray alloc] init];
    arrayProfileImg=[[NSMutableArray alloc] init];
    
    check=false;
    clicked=false;
    checkmark=[[NSMutableArray alloc]init];
    
    [self fetchContactsandAuthorization];
    
    
}
- (IBAction)backAction:(id)sender {
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
        InviteFriendsViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"InviteFriends"];
    
    
        [self presentViewController:vc animated:YES completion:NULL];

}


//This is for fetching contacts from iPhone.Also It asks authorization permission.
-(void)fetchContactsandAuthorization
{
    
    // Request authorization to Contacts
    CNContactStore *store = [[CNContactStore alloc] init];
    
    
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error)
     {
         if (granted == YES)
         {
             //keys with fetching properties
             NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
             
             
             NSString *containerId = store.defaultContainerIdentifier;
             
             NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
             
             NSError *error;
             
             NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
             
             count=cnContacts.count;
             
             noOfContacts.text=[NSString stringWithFormat: @"%li %@", count,@"Contacts"];
             
             
             NSLog(@"Store:%@",store);
             if (error)
             {
                 NSLog(@"error fetching contacts %@", error);
             }
             else
             {
                 NSString *fullName;
                 NSString *firstName;
                 NSString *lastName;
                 
                 
                 
                 for (CNContact *contact in cnContacts)
                 {
                     // copy data to my custom Contacts class.
                     NSLog(@"contacts:%@",cnContacts);
                     
                     
                     firstName = contact.givenName;
                     lastName = contact.familyName;
                     
                     if (lastName == nil) {
                         fullName=[NSString stringWithFormat:@"%@",firstName];
                     }else if (firstName == nil){
                         fullName=[NSString stringWithFormat:@"%@",lastName];
                     }
                     else
                     {
                         fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
                     }
                     
                     if ( contact.imageData.length != 0)
                     {
                         NSLog(@"Ïmage Exists");
                         
                         UIImage *image = [UIImage imageWithData:contact.imageData];
                         
                         [arrayProfileImg addObject:image];
                         
                     }
                     else
                     {
                         
                         NSLog(@"Ïmage not Exist");
                         
                         UIImage *image = [UIImage  imageNamed:@"1.jpg"];
                         
                         [arrayProfileImg addObject:image];
                     }
                     
                     
                     
                     for (CNLabeledValue *label in contact.phoneNumbers) {
                         
                         CNPhoneNumber *number = label.value;
                         NSString *digits = number.stringValue;
                         
                         if ([digits length] > 0) {
                             [contactNumbersArray addObject:digits];
                         }
                     }
                     
                     
                     NSDictionary* personDict = [[NSDictionary alloc] initWithObjectsAndKeys: fullName,@"fullName", nil];
                     
                     
                     [arrayName addObject:[NSString stringWithFormat:@"%@",[personDict objectForKey:@"fullName"]]];
                 }
                 
                 for(int i=0;i<arrayName.count;i++)
                 {
                     [checkmark addObject:@"0"];
                 }
                 dispatch_async(dispatch_get_main_queue(),
                                ^{
                                    [tableViewData reloadData];
                                });
             }
         }
         
     }];
}


- (IBAction)btn_invite:(id)sender
{
    
    if(clicked)
    {
        
        UIImage *img1=[UIImage imageNamed:@"box64.png"];
        
        [sender setImage:img1 forState:UIControlStateNormal];
        clicked=false;
        
    }
    
    else
    {
        UIImage *img1=[UIImage imageNamed:@"btn_check_off_disable.png"];
        
        [sender setImage:img1 forState:UIControlStateNormal];
        clicked=true;
    }
    
    checkmark =[[NSMutableArray alloc]init];
    
    if(check==false)
    {
        for(int i=0;i<arrayName.count;i++)
        {
            [checkmark addObject:@"1"];
        }
        check=true;
    }
    else
    {
        for(int i=0;i<arrayName.count;i++)
        {
            [checkmark addObject:@"0"];
        }
        check=false;
    }
    NSLog(@"checkmark:%@",checkmark);
    
    
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [tableViewData reloadData];
                   });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    MailTableCell *cell = (MailTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.lbl_name.text = [arrayName objectAtIndex:indexPath.row];
    
    cell.lbl_mailid.text = [contactNumbersArray objectAtIndex:indexPath.row];
    
    UIImage *img = arrayProfileImg[indexPath.row];
    
    cell.Iv_profile.image=img;
    
    CALayer *cellImageLayer = cell.Iv_profile.layer;
    [cellImageLayer setCornerRadius:40.58f];
    [cellImageLayer setMasksToBounds:YES];
    
    
    if([[checkmark objectAtIndex:indexPath.row] isEqualToString:@"1"])
    {
        NSLog(@"check mark1");
        UIImage *img1=[UIImage imageNamed:@"btn_check_off_disable.png"];
        
        
        [cell.btn_checkbox setImage:img1 forState:UIControlStateNormal];
        
        
    }
    else
    {
        UIImage *img1=[UIImage imageNamed:@"box64.png"];
        [cell.btn_checkbox setImage:img1 forState:UIControlStateNormal];
    }
    
    cell.btn_checkbox.tag=indexPath.row;
    
    [cell.btn_checkbox addTarget:self action:@selector(navigatePics:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    return cell;
}

-(void)navigatePics:(UIButton *)sender
{
    NSLog(@"btn clicked %d", sender.tag);
    
    
    //clicked=false;
    NSString *status=[checkmark objectAtIndex:sender.tag];
    NSLog(@"The checkmark is %@",checkmark);
    NSLog(@"the status is%@",status);
    
    if([status isEqualToString:@"1"])
    {
        [checkmark replaceObjectAtIndex:sender.tag withObject:@"0"];
    }
    else
    {
        [checkmark replaceObjectAtIndex:sender.tag withObject:@"1"];
    }
    
    for (int i=0; i<checkmark.count; i++)
    {
        NSString *checkstatus=[checkmark objectAtIndex:i];
        
        if([checkstatus isEqualToString:@"1"])
        {
            clicked=true;
        }
        else
        {
            clicked=false;
            break;
        }
    }
    
    // for(int i=0;i<arrayName.count;i++)
    //{
    
    if(clicked ==true)// && [checkmark[i] isEqualToString:@"1"])
    {
        
        UIImage *img2=[UIImage imageNamed:@"btn_check_off_disable.png"];
        
        [btn_invite setImage:img2 forState:UIControlStateNormal];
    }
    
    else
    {
        
        
        UIImage *img2=[UIImage imageNamed:@"box64.png"];
        
        [btn_invite setImage:img2 forState:UIControlStateNormal];
        
        
    }
    // }
    // NSLog(@"sfds")
    
    [tableViewData reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return count;
}




@end

