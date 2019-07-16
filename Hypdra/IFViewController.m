//
//  IFViewController.m
//  Montage
//
//  Created by apple on 24/07/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "IFViewController.h"
#import "SimpleTableCell.h"


@interface IFViewController ()
{
    NSMutableArray *checkmark;
    BOOL check;
    BOOL clicked;
    NSMutableArray *arrayName;
    NSMutableArray *contactNumbersArray;
    NSMutableArray *arrayProfileImg;
}
@end

@implementation IFViewController

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
            
            noofContacts.text=[NSString stringWithFormat: @"%li %@", count,@"Contacts"];
            

            NSLog(@"Store:%@",store);
            if (error)
            {
//                NSLog(@"error fetching contacts %@", error);
            }
            else
            {
                NSString *fullName;
                NSString *firstName;
                NSString *lastName;
                
                for (CNContact *contact in cnContacts)
                {
                    // copy data to my custom Contacts class.
//                    NSLog(@"contacts:%@",cnContacts);
                    
                   
                    firstName = contact.givenName;
                    lastName = contact.familyName;
                    
                    NSLog(@"Begin First = %@",firstName);
                    NSLog(@"Begin Last = %@",lastName);
                    
                    NSLog(@"Here4");
                        
                        if ([firstName isEqualToString:@""] && [lastName isEqualToString:@""])
                        {
                            NSLog(@"UN");
                            
                            fullName=@"Unknown";
                        }
                        else
                        {
                            NSLog(@"AN");
                            fullName=[NSString stringWithFormat:@"%@%@",firstName,lastName];
                        }
                    
                    if ( contact.imageData.length != 0)
                    {
                        NSLog(@"Image Exists");
                        
                        UIImage *image = [UIImage imageWithData:contact.imageData];
                        
                        [arrayProfileImg addObject:image];
                    }
                    else
                    {
                        
                        NSLog(@"Image not Exist");
                        
                        UIImage *image = [UIImage  imageNamed:@"1.jpg"];
                        
                        [arrayProfileImg addObject:image];
                    }
                    
                    for (CNLabeledValue *label in contact.phoneNumbers)
                    {
                        CNPhoneNumber *number = label.value;
                        NSString *digits = number.stringValue;
                    
                        if ([digits length] > 0)
                        {
                            [contactNumbersArray addObject:digits];
                            
                            break;
                        }
                    }
                
                    
//                    NSDictionary* personDict = [[NSDictionary alloc] initWithObjectsAndKeys: fullName,@"fullName", nil];
//                    
                    
                    [arrayName addObject:fullName];
                    
                    
                    
                }
                
                NSLog(@"ArrayName = %@",arrayName);
                NSLog(@"contactNumbersArray = %@",contactNumbersArray);


//                dispatch_async(dispatch_get_main_queue(),
//                ^{
//                 });
            }
        }
        
        NSLog(@"Quick End");
        
          }];
    
    for(int i=0;i<arrayName.count;i++)
    {
        [checkmark addObject:@"0"];
    }
    
    NSLog(@"End");
    
    [tableViewData reloadData];

}



- (IBAction)btninvite:(id)sender
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
    
    SimpleTableCell *cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
//    cell.lbl_name.text = arrayName[indexPath.row];
    
    cell.lbl_mailid.text = @"Welcome";
    
//    UIImage *img = arrayProfileImg[indexPath.row];
//    
//    cell.Iv_profile.image=img;
    
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
  
         if(clicked ==true)
      {
    
        UIImage *img2=[UIImage imageNamed:@"btn_check_off_disable.png"];

        [btn_invite setImage:img2 forState:UIControlStateNormal];
      }
    
      else
      {
        
        
         UIImage *img2=[UIImage imageNamed:@"box64.png"];
        
         [btn_invite setImage:img2 forState:UIControlStateNormal];
        
         
       }
       [tableViewData reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayName count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



@end
