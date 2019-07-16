//
//  OutlookViewController.m
//  Montage
//
//  Created by MacBookPro on 3/2/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import "OutlookViewController.h"
#import "GmailTableCell.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "InviteFriendsViewController.h"
#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "CustomPopUp.h"
#import "UIColor+Utils.h"

@interface OutlookViewController ()<UISearchBarDelegate,ClickDelegates>
{
    BOOL check,clicked,searchEnabled,checkForSearch,clickedForSearch;
    
    NSMutableArray *checkmark,*checkmarkForSearch,*searchMailArray,*inviteEmail,*mailArray,*responseArray;
    
    NSDictionary *dict1,*dict2;
    
    MBProgressHUD *hud;
    
    NSString *user_id,*finalGmailContacts,*finalGmailContactsAfterSearch;
    
    int cellChkBoxCount,masterChkBoxCount;
    NSString *inviteT;
}

@end

@implementation OutlookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36", @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    _inviteFor = [[NSUserDefaults standardUserDefaults]stringForKey:@"InviteFor"];
    _inviteThrough = [[NSUserDefaults standardUserDefaults]stringForKey:@"InviteThrough"];
    _inviteVideoID=[[NSUserDefaults standardUserDefaults]stringForKey:@"InviteVideoID"];
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        self.imgWidth.constant=-33;
        self.imgHeight.constant=-14;
        [self.inviteAllImgView updateConstraints];
        self.inviteallLabel.textAlignment=NSTextAlignmentRight;
        self.noOfContacts.textAlignment=NSTextAlignmentLeft;
        
    }
    
    else
    {
        self.inviteallLabel.textAlignment=NSTextAlignmentLeft;
        self.noOfContacts.textAlignment=NSTextAlignmentRight;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User id is %@",user_id);
    
    _ViewHoldsWebView.hidden=NO;
    _topView.hidden=YES;
    _noOfContacts.hidden=YES;
    
    searchEnabled=NO;
    cellChkBoxCount=0;
    masterChkBoxCount=0;
    
    checkmark=[[NSMutableArray alloc]init];
    checkmarkForSearch=[[NSMutableArray alloc]init];
    inviteEmail=[[NSMutableArray alloc]init];
    
    
    NSString *currentURL=[NSString stringWithFormat:@"https://www.hypdra.com/Outlook/ReturnOutlook.php?User_ID=%@&ServiceType=%@",user_id,_inviteFor];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:currentURL]];
    
    [_webView1 loadRequest:request];
    
}
- (void) dismissKeyboard
{
    [self.searchBar resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Mozilla/5.0 (iPhone; CPU iPhone OS 10_2 like Mac OS X) AppleWebKit/602.3.12 (KHTML, like Gecko) Mobile/14C89", @"UserAgent", nil];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    @try
    {
        NSURL *currentURL = [[webView request] URL];
        
        NSLog(@"curr url is %@",currentURL);
        
        for (NSString *qs in [currentURL.query componentsSeparatedByString:@"?"])
        {
            NSLog(@"the string qs %@",qs);
            // Get the parameter name
            NSString *key = [[qs componentsSeparatedByString:@"="] objectAtIndex:0];
            
            // Get the parameter value
            NSString *value = [[qs componentsSeparatedByString:@"="] objectAtIndex:1];
            
            if([key isEqualToString:@"msg"] && [value isEqualToString:@"true"])
            {
                NSLog(@"result is success");
                
                _ViewHoldsWebView.hidden=YES;
                _topView.hidden=NO;
                
                [self getGmailResponse];
                
            }
            else if([key isEqualToString:@"msg"] && [value isEqualToString:@"NoEmail"])
            {
                _ViewHoldsWebView.hidden=YES;
                _topView.hidden=NO;
                _noOfContacts.hidden=NO;
                _inviteTopLabel.hidden=YES;
                _inviteTopLblView.hidden=YES;
                
            }
            
            else
            {
                _ViewHoldsWebView.hidden=NO;
                _topView.hidden=YES;
                _inviteTopLabel.hidden=YES;
                _inviteTopLblView.hidden=YES;
                [hud hideAnimated:YES];
                
            }
        }
        
    }@catch(NSException *ex)
    {
        
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error in WEBVIEW: %@", [error description]);
    
    NSString *desc=[error description];
    if([desc containsString:@"-999"])
    {
        
    }
    else
    {
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Could not connect to server to load webview" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.accessibilityHint = @"WebView_Loading";
        popUp.okay.backgroundColor=[UIColor lightGreen];
        popUp.agreeBtn.hidden=YES;
        popUp.cancelBtn.hidden=YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
}

-(void)getGmailResponse
{
    @try
    {
        NSDictionary *parameters =@{@"User_ID":user_id,@"EmailDomain":@"outlook",@"lang":@"iOS"};
        
        NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=GetEmailForInvites";
        
        NSError *error;      // Initialize NSError
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];  // Convert your parameter to NSDATA
        
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];  // Convert data into string using NSUTF8StringEncoding
        
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URL parameters:nil error:nil];  // make NSMutableURL req
        
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue]; // add paramerets to NSMutableURLRequest
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              
              if (!error)
              {
                  mailArray=[[NSMutableArray alloc]init];
                  
                  dict1=[responseObject objectForKey:@"GetEmailForInvites"];
                  
                  NSLog(@"d1 is %@",dict1);
                  
                  responseArray=[dict1 objectForKey:@"MailID"];
                  
                  NSLog(@"arr1 is %@",responseArray);
                  
                  for(int i=0;i<responseArray.count;i++)
                  {
                      dict2=[responseArray objectAtIndex:i];
                      
                      [mailArray addObject:dict2];
                      
                      if([[dict2 valueForKey:@"Invite_status"] isEqualToString:@"Already Invited"] || [[dict2 valueForKey:@"Invite_status"] isEqualToString:@"Already User"])
                      {
                          [checkmark addObject:@"2"];
                      }
                      else
                      {
                          [checkmark addObject:@"0"];
                      }
                  }
                  
                  _noOfContacts.hidden=NO;
                  
                  NSString *numOfContacts=[NSString stringWithFormat:@"%lu Contacts",(unsigned long)mailArray.count];
                  
                  _noOfContacts.text=numOfContacts;
                  
                  [self.tableViewMail reloadData];
                  
                  [hud hideAnimated:YES];
                  
              }
              
              else
              {
                  CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Could not connect to server " withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                  popUp.accessibilityHint = @"error_InServer";
                  popUp.okay.backgroundColor=[UIColor lightGreen];
                  popUp.agreeBtn.hidden=YES;
                  popUp.cancelBtn.hidden=YES;
                  popUp.inputTextField.hidden = YES;
                  [popUp show];
                  
              }
          }]resume];
    }@catch(NSException *ex)
    {
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try
    {
        static NSString *simpleTableIdentifier = @"GmailTableCell";
        GmailTableCell *cell;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            
            cell = (GmailTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GmailTableCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
        }
        
        else
        {
            cell=(GmailTableCell *)[tableView dequeueReusableCellWithIdentifier:@"GmailTableCellIpad"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GmailTableCellIpad" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
        }
        
        if (searchEnabled==YES)
        {
            cell.nameLbl.text = [[searchMailArray objectAtIndex:indexPath.row]objectForKey:@"Name"];
            cell.mailIdLbl.text = [[searchMailArray objectAtIndex:indexPath.row]objectForKey:@"EmailID"];
            NSURL *url=[[searchMailArray objectAtIndex:indexPath.row]objectForKey:@"Image"];
            [cell.profileImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Placeholder_no_text.png"]];
            
            
            if([[checkmarkForSearch objectAtIndex:indexPath.row] isEqualToString:@"1"])
            {
                UIImage *img1=[UIImage imageNamed:@"64-tick-box"];
                [cell.checkBtn setImage:img1 forState:UIControlStateNormal];
                
                [cell.checkBtn addTarget:self action:@selector(navigateToCellBtn:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
            else if([[checkmarkForSearch objectAtIndex:indexPath.row] isEqualToString:@"0"])
            {
                UIImage *img1=[UIImage imageNamed:@"32-box"];
                
                [cell.checkBtn setImage:img1 forState:UIControlStateNormal];
                
                [cell.checkBtn addTarget:self action:@selector(navigateToCellBtn:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            else
            {
                UIImage *img1=[UIImage imageNamed:@"close_delete-128.png"];//@"close_250.png"];//close_delete-128.png
                
                [cell.checkBtn setImage:img1 forState:UIControlStateNormal];
            }
            
        }
        else
        {
            cell.nameLbl.text = [[mailArray objectAtIndex:indexPath.row]objectForKey:@"Name"];
            
            cell.mailIdLbl.text = [[mailArray objectAtIndex:indexPath.row]objectForKey:@"EmailID"];
            
            NSString *profile_Img = [[mailArray objectAtIndex:indexPath.row]objectForKey:@"Image"];
            
            if([profile_Img isEqual:[NSNull null]])
            {
                cell.profileImg.image=[UIImage imageNamed:@"Placeholder_no_text.png"];
            }
            else
            {
                NSURL *url=[NSURL URLWithString:profile_Img];
                
                [cell.profileImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Placeholder_no_text.png"]];
            }
            
            if([[checkmark objectAtIndex:indexPath.row] isEqualToString:@"1"])
            {
                UIImage *img1=[UIImage imageNamed:@"64-tick-box"];
                [cell.checkBtn setImage:img1 forState:UIControlStateNormal];
                
                [cell.checkBtn addTarget:self action:@selector(navigateToCellBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if([[checkmark objectAtIndex:indexPath.row] isEqualToString:@"0"])
            {
                UIImage *img1=[UIImage imageNamed:@"32-box"];
                
                [cell.checkBtn setImage:img1 forState:UIControlStateNormal];
                
                [cell.checkBtn addTarget:self action:@selector(navigateToCellBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                UIImage *img1=[UIImage imageNamed:@"close_delete-128.png"];
                
                //@"close_250.png"];
                
                [cell.checkBtn setImage:img1 forState:UIControlStateNormal];
            }
            
        }
        cell.profileImg.layer.cornerRadius=cell.profileImg.frame.size.width/2;
        cell.profileImg.layer.masksToBounds=YES;
        
        cell.checkBtn.tag=indexPath.row;
        
        return cell;
    }
    @catch (NSException *exception)
    {
        NSLog(@"the exception is %@",exception);
    }
}

-(void)navigateToCellBtn:(UIButton *)sender
{
    @try
    {
        if(searchEnabled==YES)
        {
            NSString *status=[checkmarkForSearch objectAtIndex:sender.tag];
            
            NSString *email=[[searchMailArray objectAtIndex:sender.tag]objectForKey:@"EmailID"];
            
            if([status isEqualToString:@"1"])
            {
                [checkmarkForSearch replaceObjectAtIndex:sender.tag withObject:@"0"];
                [inviteEmail removeObject:email];
                cellChkBoxCount=0;
                
            }
            else
            {
                [checkmarkForSearch replaceObjectAtIndex:sender.tag withObject:@"1"];
                [inviteEmail addObject:email];
                cellChkBoxCount=1;
                
            }
            
            finalGmailContactsAfterSearch =[inviteEmail componentsJoinedByString:@","];
            
            
            
            for (int i=0; i<searchMailArray.count; i++)
            {
                NSString *iv=[[searchMailArray objectAtIndex:i]objectForKey:@"Invite_status"];
                
                
                if(![iv isEqualToString:@"Already Invited"] || ![iv isEqualToString:@"Already User"])
                {
                    
                    NSString *checkstatus=[checkmarkForSearch objectAtIndex:i];
                    
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
                
            }
            
            if(clicked ==true)
            {
                UIImage *img2=[UIImage imageNamed:@"64-tick-box"];
                self.inviteAllImgView.image=img2;
                
                // [_inviteAll setImage:img2 forState:UIControlStateNormal];
            }
            else
            {
                UIImage *img2=[UIImage imageNamed:@"32-box"];
                self.inviteAllImgView.image=img2;
                
                // [_inviteAll setImage:img2 forState:UIControlStateNormal];
            }
            
        }
        else
        {
            check=false;
            NSString *status=[checkmark objectAtIndex:sender.tag];
            NSString *email=[[mailArray objectAtIndex:sender.tag]objectForKey:@"EmailID"];
            
            
            if([status isEqualToString:@"1"])
            {
                [checkmark replaceObjectAtIndex:sender.tag withObject:@"0"];
                [inviteEmail removeObject:email];
                cellChkBoxCount=0;
                
            }
            else
            {
                [checkmark replaceObjectAtIndex:sender.tag withObject:@"1"];
                [inviteEmail addObject:email];
                cellChkBoxCount=1;
                
            }
            
            finalGmailContacts = [inviteEmail componentsJoinedByString:@","];
            
            for (int i=0; i<mailArray.count; i++)
            {
                NSString *iv=[[mailArray objectAtIndex:i]objectForKey:@"Invite_status"];
                
                
                if(![iv isEqualToString:@"Already Invited"] || ![iv isEqualToString:@"Already User"])
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
                
            }
            
            if(clicked ==true)
            {
                UIImage *img2=[UIImage imageNamed:@"64-tick-box"];
                self.inviteAllImgView.image=img2;
                
                // [_inviteAll setImage:img2 forState:UIControlStateNormal];
            }
            else
            {
                UIImage *img2=[UIImage imageNamed:@"32-box"];
                self.inviteAllImgView.image=img2;
                
                // [_inviteAll setImage:img2 forState:UIControlStateNormal];
            }
        }
        
        [_tableViewMail reloadData];
    }
    @catch (NSException *exception)
    {
        NSLog(@"the exception is %@",exception);
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (searchEnabled==YES)
    {
        return [searchMailArray count];
    }
    
    else
    {
        return [mailArray count];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (IBAction)inviteAllAction:(id)sender
{
    _inviteTopLabel.hidden=NO;
    _inviteTopLblView.hidden=NO;
    @try
    {
        inviteEmail=[[NSMutableArray alloc]init];
        
        if(searchEnabled==YES)
        {
            if(clickedForSearch)
            {
                UIImage *img1=[UIImage imageNamed:@"32-box"];
                self.inviteAllImgView.image=img1;
                // [sender setImage:img1 forState:UIControlStateNormal];
                clickedForSearch=false;
                masterChkBoxCount=0;
                
                for(int i=0;i<searchMailArray.count;i++)
                    
                {
                    NSString *iv=[[searchMailArray objectAtIndex:i]objectForKey:@"Invite_status"];
                    
                    
                    if([iv isEqualToString:@"Already Invited"] || [iv isEqualToString:@"Already User"] )
                    {
                        
                    }
                    else
                    {
                        [checkmarkForSearch replaceObjectAtIndex:i withObject:@"0"];
                    }
                }
            }
            else
            {
                masterChkBoxCount=1;
                
                UIImage *img1=[UIImage imageNamed:@"64-tick-box"];
                self.inviteAllImgView.image=img1;
                
                //[sender setImage:img1 forState:UIControlStateNormal];
                clickedForSearch=true;
                
                for(int i=0;i<searchMailArray.count;i++)
                {
                    
                    NSString *iv=[[searchMailArray objectAtIndex:i]objectForKey:@"Invite_status"];
                    
                    if([iv isEqualToString:@"Already Invited"] || [iv isEqualToString:@"Already User"])
                    {
                        
                    }
                    else
                    {
                        [checkmarkForSearch replaceObjectAtIndex:i withObject:@"1"];
                        
                        [inviteEmail addObject:[[searchMailArray objectAtIndex:i]objectForKey:@"EmailID"]];
                        
                    }
                    
                }
                
            }
        }
        else
        {
            if(clicked)
            {
                UIImage *img1=[UIImage imageNamed:@"32-box"];
                self.inviteAllImgView.image=img1;
                
                //[sender setImage:img1 forState:UIControlStateNormal];
                clicked=false;
                masterChkBoxCount=0;
                
                for(int i=0;i<mailArray.count;i++)
                {
                    NSString *iv=[[mailArray objectAtIndex:i]objectForKey:@"Invite_status"];
                    
                    
                    if([iv isEqualToString:@"Already Invited"] || [iv isEqualToString:@"Already User"])
                    {
                        
                    }
                    else
                    {
                        [checkmark replaceObjectAtIndex:i withObject:@"0"];
                    }
                }
            }
            
            else
            {
                UIImage *img1=[UIImage imageNamed:@"64-tick-box"];
                self.inviteAllImgView.image=img1;
                
                //[sender setImage:img1 forState:UIControlStateNormal];
                
                clicked=true;
                masterChkBoxCount=1;
                
                for(int i=0;i<mailArray.count;i++)
                {
                    
                    NSString *iv=[[mailArray objectAtIndex:i]objectForKey:@"Invite_status"];
                    
                    if([iv isEqualToString:@"Already Invited"] || [iv isEqualToString:@"Already User"])
                    {
                        
                    }
                    else
                    {
                        [checkmark replaceObjectAtIndex:i withObject:@"1"];
                        
                        [inviteEmail addObject:[[mailArray objectAtIndex:i]objectForKey:@"EmailID"]];
                    }
                    
                }
                
                finalGmailContacts = [inviteEmail componentsJoinedByString:@","];
            }
        }
        
        [_tableViewMail reloadData];
    }@catch(NSException *ex)
    {
        
    }
}

#pragma mark - Search delegate methods

- (void)filterContentForSearchText:(NSString*)searchText
{
    checkmarkForSearch=[[NSMutableArray alloc]init];
    @try
    {
        if([searchText isEqualToString:@""])
        {
            NSLog(@"search text is null");
        }
        else{
            searchEnabled=YES;
            
            searchMailArray=[[NSMutableArray alloc]init];
            
            for(int i=0;i<responseArray.count;i++)
            {
                NSDictionary *dict= [responseArray objectAtIndex:i];
                
                NSString *name=[dict objectForKey:@"Name"];
                NSString *email=[dict objectForKey:@"EmailID"];
                
                NSRange nameRange=[name rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                
                NSRange emailRange=[email rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                if(nameRange.location != NSNotFound || emailRange.location!=NSNotFound)
                {
                    [searchMailArray addObject:dict];
                }
                
            }
            
            for(int i=0;i<searchMailArray.count;i++)
            {
                if(searchEnabled==YES)
                {
                    if([[[searchMailArray objectAtIndex:i]objectForKey:@"Invite_status"] isEqualToString:@"Already Invited"] || [[[searchMailArray objectAtIndex:i]objectForKey:@"Invite_status"] isEqualToString:@"Already User"])
                    {
                        [checkmarkForSearch addObject:@"2"];
                    }
                    else
                    {
                        [checkmarkForSearch addObject:@"0"];
                        
                    }
                }
            }
            
            [_tableViewMail reloadData];
        }
    }
    @catch(NSException *exception)
    {
        NSLog(@"The exception is %@",exception);
    }
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    @try
    {
        NSLog(@"searchbar didchange called");
        
        if (searchBar.text.length == 0)
        {
            searchEnabled = NO;
            
            UIImage *img1=[UIImage imageNamed:@"32-box"];
            
            // [_inviteAll setImage:img1 forState:UIControlStateNormal];
            
            checkmarkForSearch=[[NSMutableArray alloc]init];
            
            for(int i=0;i<searchMailArray.count;i++)
            {
                [checkmarkForSearch addObject:@"0"];
            }
            
            [_tableViewMail reloadData];
            
        }
        else
        {
            searchEnabled = YES;
            [self filterContentForSearchText:searchBar.text];
            
        }
    }@catch(NSException *exception)
    {
        
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    
}

- (IBAction)inviteTopAction:(id)sender

{
    check=false;
    clicked=false;
    
    if([_inviteThrough isEqualToString:@"Advance"] || [_inviteThrough isEqualToString:@"Wizard"])
    {
        inviteT=@"";
    }
    else
    {
        inviteT=@"gmail";
    }
    
    @try
    {
        NSDictionary *parameters;
        
        if(cellChkBoxCount>=1 || masterChkBoxCount>=1)
        {
            NSLog(@"invite top gmail %@",finalGmailContacts);
            
            NSLog(@"invite top after gmail search %@",finalGmailContactsAfterSearch);
            
            if(searchEnabled==YES)
            {
                parameters =@{@"User_ID":user_id,@"Email_IDs":finalGmailContactsAfterSearch,@"lang":@"iOS",@"InviteFor":_inviteFor,@"InviteThrough":inviteT,@"InviteSection":_inviteThrough,@"VideoId":_inviteVideoID};
            }
            else
            {
                parameters =@{@"User_ID":user_id,@"Email_IDs":finalGmailContacts,@"lang":@"iOS",@"InviteFor":_inviteFor,@"InviteThrough":inviteT,@"InviteSection":_inviteThrough,@"VideoId":_inviteVideoID};
            }
            
            [self sendingInvite:parameters];
        }
        
        else
        {
            NSLog(@"select atleast one");
            
            CustomPopUp *popUp = [CustomPopUp new];
            [popUp initAlertwithParent:self withDelegate:self withMsg:@"select atleast one" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            
            popUp.okay.backgroundColor=[UIColor lightGreen];
            popUp.agreeBtn.hidden=YES;
            popUp.cancelBtn.hidden=YES;
            popUp.inputTextField.hidden = YES;
            [popUp show];
            
        }
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"The exception is %@",exception);
    }
}

-(void)sendingInvite:(NSDictionary *)parameters
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    @try
    {
        NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=SendEmailRefferal";
        
        NSError *error;      // Initialize NSError
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];  // Convert your parameter to NSDATA
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];  // Convert data into string using NSUTF8StringEncoding
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URL parameters:nil error:nil];  // make NSMutableURL req
        
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue]; // add parameters to NSMutableURLRequest
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              
              if (!error)
              {
                  NSLog(@"The response is %@",responseObject);
                  
                  NSMutableArray *emailId=[responseObject objectForKey:@"EmailSentInfo"];
                  
                  NSString *mailId;
                  
                  for(int i=0;i<emailId.count;i++)
                  {
                      NSDictionary *di=emailId[i];
                      mailId=[di objectForKey:@"msg"];
                  }
                  
                  CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Your invitation has been sent successfully" withTitle:@"" withImage:[UIImage imageNamed:@"Alert_Success.png"]];
                  popUp.accessibilityHint = @"Invited";
                  popUp.okay.backgroundColor=[UIColor lightGreen];
                  popUp.agreeBtn.hidden=YES;
                  popUp.cancelBtn.hidden=YES;
                  popUp.inputTextField.hidden = YES;
                  [popUp show];
                  
              }
              
              else
              {
                  
                  CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Could not connect to server " withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                  popUp.accessibilityHint = @"error_InServer";
                  popUp.okay.backgroundColor=[UIColor lightGreen];
                  popUp.agreeBtn.hidden=YES;
                  popUp.cancelBtn.hidden=YES;
                  popUp.inputTextField.hidden = YES;
                  [popUp show];
              }
              
          }]resume];
        
    }@catch(NSException *ex)
    {
        NSLog(@"Catch Executed");
        
        [hud hideAnimated:YES];
    }
}

-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"Invited"])
    {
        [hud hideAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    else if([alertView.accessibilityHint isEqualToString:@"WebView_Loading"])
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
        
        InviteFriendsViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"InviteFriends"];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if([alertView.accessibilityHint isEqualToString:@"error_InServer"])
    {
        [hud hideAnimated:YES];
    }
    
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    [alertView hide];
    alertView = nil;
    
    NSLog(@"Cancel");
}


- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
