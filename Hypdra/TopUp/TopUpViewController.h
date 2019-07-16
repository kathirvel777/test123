//
//  TopUpViewController.h
//  Montage
//
//  Created by MacBookPro on 7/26/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKDropdownMenu.h"

@interface TopUpViewController : UIViewController


@property (strong, nonatomic) IBOutlet MKDropdownMenu *minutesList;


@property (strong, nonatomic) IBOutlet MKDropdownMenu *spaceList;


- (IBAction)minutesBtn:(id)sender;


- (IBAction)spaceBtn:(id)sender;



@property (strong, nonatomic) IBOutlet UIButton *minutesVal;


@property (strong, nonatomic) IBOutlet UIButton *spaceVal;

- (IBAction)back:(id)sender;

@end
