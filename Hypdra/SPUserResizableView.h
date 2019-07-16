//
//  SPUserResizableView.h
//  NotePad Plus
//
//  Created by apple on 20/05/16.
//  Copyright © 2016 com.seek. All rights reserved.

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


typedef struct SPUserResizableViewAnchorPoint {
    CGFloat adjustsX;
    CGFloat adjustsY;
    CGFloat adjustsH;
    CGFloat adjustsW;
} SPUserResizableViewAnchorPoint;

@protocol SPUserResizableViewDelegate;
@protocol ReDrawaPaintDelegate;

@class SPGripViewBorderView;

@interface SPUserResizableView : UIView<UIGestureRecognizerDelegate>
{
    
    UIPopoverController *popover;
    
    SPGripViewBorderView *borderView;
    //UIView *contentView;
    CGPoint touchStart;
    CGFloat minWidth;
    CGFloat minHeight;
    NSString *ModeOfDrawing;
    // Used to determine which components of the bounds we'll be modifying, based upon where the user's touch started.
    SPUserResizableViewAnchorPoint anchorPoint;
    
    //id <SPUserResizableViewDelegate> delegate;
}
@property (nonatomic,retain)UIPopoverController *popover;
@property (strong,nonatomic)UIButton *cancel;

@property (strong,nonatomic)UIButton *Menu;
@property (nonatomic, assign) NSString *Status;

@property (nonatomic, strong) NSMutableArray *setArray;


@property (nonatomic, assign) BOOL resizableStatus;


@property (nonatomic, assign) id <SPUserResizableViewDelegate> delegate;
@property (unsafe_unretained) id <ReDrawaPaintDelegate> delegate1;

// Will be retained as a subview.
@property (nonatomic, assign) UIView *contentView;

// Default is 48.0 for each.
@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat minHeight;

// Defaults to YES. Disables the user from dragging the view outside the parent view's bounds.
@property (nonatomic) BOOL preventsPositionOutsideSuperview;

- (void)hideEditingHandles;
- (void)showEditingHandles;
- (void)hideCancel;
- (void)removeBorder;

@end

@protocol SPUserResizableViewDelegate <NSObject>


@optional

// Called when the resizable view receives touchesBegan: and activates the editing handles.
- (void)userResizableViewDidBeginEditing:(SPUserResizableView *)userResizableView;
// Called when the resizable view receives touchesEnded: or touchesCancelled:
- (void)userResizableViewDidEndEditing:(SPUserResizableView *)userResizableView;
-(void)userResizableviewBeingResized:(SPUserResizableView *) userResizableView;
-(void)RedrawImage:(SPUserResizableView *) userResizableView;
-(void)openCamera;
-(void)AudioPlay:(SPUserResizableView *) userResizableView;

@end

@protocol ReDrawaPaintDelegate <NSObject>
@optional

@end
