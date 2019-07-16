//
//  AdvanceTabViewController.h
//  Montage
//
//  Created by MacBookPro4 on 4/29/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "TabBarViewController.h"

//@protocol DoneProtocolDelegate <NSObject>
//
//- (void) doneCompleted;
//
//@end

@interface AdvanceTabViewController : TabBarViewController<UITabBarDelegate>
{

}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btn_Add;

//
//@property (nonatomic,strong) id<DoneProtocolDelegate> doneDelegate;


- (IBAction)done:(id)sender;


@end
