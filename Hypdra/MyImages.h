//
//  MyImages.h
//  Montage
//
//  Created by MacBookPro on 3/21/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerHeader.h"


@interface MyImages : UIViewController<ELCImagePickerControllerDelegate>



- (IBAction)Next:(id)sender;



@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;


- (IBAction)pickImage:(id)sender;

@property (nonatomic, copy) NSMutableArray *chosenImages;

@end
