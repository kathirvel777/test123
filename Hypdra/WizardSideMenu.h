//
//  WizardSideMenu.h
//  Hypdra
//
//  Created by Mac on 7/9/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WizardSideMenu : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)closeTap:(id)sender;
//@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;

@end
