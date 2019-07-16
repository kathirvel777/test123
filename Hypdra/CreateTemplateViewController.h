//
//  CreateTemplateViewController.h
//  Hypdra
//
//  Created by MacBookPro on 7/4/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldValidator/TextFieldValidator.h"


@interface CreateTemplateViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *VideoView;
- (IBAction)Submit:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *submit_out;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *ADView;

@end
