//
//  DEMOMenuViewController.h
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "MKDropdownMenu.h"

@interface DEMOMenuViewController : UIViewController<MKDropdownMenuDataSource, MKDropdownMenuDelegate>



@property (strong, nonatomic) IBOutlet UITableView *tableViewDemo;


- (IBAction)pickProfile:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *userEmailLabel;


@property (strong, nonatomic) IBOutlet UIImageView *profileImage;


@property (strong, nonatomic) IBOutlet UILabel *userName;


@property (strong, nonatomic) IBOutlet UIView *toProfile;

@property(strong,nonatomic)NSString *index;
@property (strong, nonatomic) IBOutlet UIView *profile_pic_superView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ProfilePicHeightHighPrio;



@end
