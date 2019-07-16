//
//  IFViewController.h
//  Montage
//
//  Created by apple on 24/07/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>
#import "SimpleTableCell.h"
#import "InviteFriendsViewController.h"

@interface IFViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

{
    
    long count;
    
    IBOutlet UITableView *tableViewData;


    IBOutlet UIButton *btn_invite;
    
    
    IBOutlet UILabel *noofContacts;
}

@end
