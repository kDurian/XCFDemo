//
//  CustomPresentController.m
//  XCFDemo
//
//  Created by Durian on 5/18/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "CustomPresentController.h"

@interface CustomPresentController ()
@property(nonatomic, strong) UIView *bgView;
@end

static const CGFloat kPresentedViewHeight = 345;

@implementation CustomPresentController

- (void)presentationTransitionWillBegin
{
    self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurView.frame = self.containerView.bounds;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [blurView addGestureRecognizer:tapGesture];
    [self.bgView addSubview:blurView];
    
    UIView *containerView = self.containerView;
    [containerView addSubview:self.presentingViewController.view];
    [containerView addSubview:self.bgView];
    [containerView addSubview:self.presentedView];
    
    self.bgView.alpha = 0.0;
    
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.bgView.alpha = 0.7;
        self.presentingViewController.view.transform = CGAffineTransformScale(self.presentingViewController.view.transform, 0.92, 0.92);
    } completion:nil];
}

- (void)dismiss
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldRemovePresentersView
{
    return NO;
}

- (void)presentationTransitionDidEnd:(BOOL)completed
{
    if (!completed) {
        [self.bgView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin
{
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.bgView.alpha = 0.0;
        self.presentingViewController.view.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    if (completed) {
        [self.bgView removeFromSuperview];
    }
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.presentingViewController.view];
}

- (CGRect)frameOfPresentedViewInContainerView
{
    CGRect initFrame = self.containerView.bounds;
    CGRect finalFrame = CGRectMake(initFrame.origin.x, initFrame.origin.y + (initFrame.size.height - kPresentedViewHeight), initFrame.size.width, kPresentedViewHeight);
    return finalFrame;
}
@end
