//
//  CategoryMusicView.h
//  Montage
//
//  Created by MacBookPro on 5/3/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryMusicView : UIViewController


@property (strong, nonatomic) NSString *categoryName;



@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


- (IBAction)done:(id)sender;



@property (strong, nonatomic) IBOutlet UIBarButtonItem *done;



@property (strong, nonatomic) IBOutlet UIView *secondView;


@end
