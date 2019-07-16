//
//  AdvancedViewController.h
//  Montage
//
//  Created by MacBookPro on 4/4/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvancedViewController : UIViewController


@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIView *CollectView;



- (IBAction)photos:(id)sender;



- (IBAction)transitions:(id)sender;



- (IBAction)effects:(id)sender;


- (IBAction)text:(id)sender;


- (IBAction)music:(id)sender;



- (IBAction)album:(id)sender;



- (IBAction)AddCell:(id)sender;


- (IBAction)Album:(id)sender;



@property (strong, nonatomic) IBOutlet UIView *mainView;

@end
