//
//  MarkerSPView.h
//  Evernote CLone
//
//  Created by Srinivasan on 11/11/16.
//  Copyright © 2016 com.seek.app.EvernoteCLone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"

typedef struct MarkerSPUserResizableViewAnchorPoint {
    CGFloat adjustsX;
    CGFloat adjustsY;
    CGFloat adjustsH;
    CGFloat adjustsW;
} MarkerSPUserResizableViewAnchorPoint;

@protocol MarkerSPUserResizableViewDelegate;
@class MarkerSPGripViewBorderView;
@interface MarkerSPView : UIView{
    MarkerSPGripViewBorderView *borderView;
    //UIView *contentView;
    CGPoint touchStart;
    CGFloat minWidth;
    CGFloat minHeight;
    
    UITextView *textViewDemo;
    
    // Used to determine which components of the bounds we'll be modifying, based upon where the user's touch started.
    MarkerSPUserResizableViewAnchorPoint anchorPoint;
    
    id <MarkerSPUserResizableViewDelegate> delegate1;

}




@property (nonatomic,assign) UIButton *closeButton;
@property (nonatomic,assign) UITextField *textView;
@property (nonatomic,strong) UITextView *textView_1;


@property WYPopoverController *popoverController;


@property (nonatomic, assign) id <MarkerSPUserResizableViewDelegate> delegate;

// Will be retained as a subview.
@property (nonatomic, assign) UIView *contentView;

// Default is 48.0 for each.
@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat minHeight;

// Defaults to YES. Disables the user from dragging the view outside the parent view's bounds.
@property (nonatomic) BOOL preventsPositionOutsideSuperview;

- (void)hideEditingHandles;
- (void)showEditingHandles;

@end

@protocol MarkerSPUserResizableViewDelegate <NSObject>

@optional

// Called when the resizable view receives touchesBegan: and activates the editing handles.
- (void)userResizableViewDidBeginEditing:(MarkerSPView *)userResizableView;

// Called when the resizable view receives touchesEnded: or touchesCancelled:
- (void)userResizableViewDidEndEditing:(MarkerSPView *)userResizableView;

@end
