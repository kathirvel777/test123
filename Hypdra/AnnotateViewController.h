//
//  AnnotateViewController.h
//  Montage
//
//  Created by MacBookPro on 4/29/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkerSPView.h"

@interface AnnotateViewController : UIViewController



- (IBAction)fillCircle:(id)sender;


- (IBAction)roundMap:(id)sender;


- (IBAction)fillMap:(id)sender;


- (IBAction)redMap:(id)sender;


- (IBAction)pinRed:(id)sender;


- (IBAction)pinBlue:(id)sender;


- (IBAction)pinGreen:(id)sender;


- (IBAction)thickCircle:(id)sender;


- (IBAction)thinCircle:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) IBOutlet UICollectionView *CollectionView;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;



@property (strong, nonatomic) IBOutlet UIView *topView;


@property (strong,nonatomic)MarkerSPView *freeHandResizableView,*userResizableView,*lastEditedView,*currentlyEditingView;


- (IBAction)Done:(id)sender;



@property (strong, nonatomic) IBOutlet UIView *iconView;


@end
