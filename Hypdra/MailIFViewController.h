//
//  MailIFViewController.h
//  Montage
//
//  Created by apple on 01/08/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleTableCell.h"
#import <Contacts/Contacts.h>

#import "InviteFriendsViewController.h"

@interface MailIFViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
    long count;
    
    IBOutlet UIBarButtonItem *backAction;
   
    
        
    
    //IBOutlet UIImageView *ivcontacts;
    
    IBOutlet UITableView *tableViewData;
    
    IBOutlet UIButton *btn_invite;
        
    IBOutlet UILabel *noOfContacts;
}





@end
