//
//  AdminMusicCategory.h
//  Montage
//
//  Created by MacBookPro on 5/3/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdminMusicCategory : UIViewController


@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneOutlet;

- (IBAction)doneAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *secondView;


@property (strong, nonatomic) UIView* BlurView;
@property (strong, nonatomic) UIWindow* currentWindow;

@end
