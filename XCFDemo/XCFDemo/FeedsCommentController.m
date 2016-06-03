//
//  FeedsCommentController.m
//  XCFDemo
//
//  Created by Durian on 6/1/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "FeedsCommentController.h"
#import "FeedsCommentCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

static NSString * const kFeedsCommentCellID = @"kFeedsCommentCell";

@interface FeedsCommentController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;

@end

@implementation FeedsCommentController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)hidesBottomBarWhenPushed{
    return YES;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.sendButton.layer.cornerRadius = 3.0;
    [self setNavBar];
    [self registerKeyboardNotification];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.textView resignFirstResponder];
}

- (void)setNavBar{
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backStretchBackgroundNormal"] style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviousPage)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.title = @"留言";
}

- (void)backToPreviousPage{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - About Keyboard
- (void)registerKeyboardNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    NSLog(@"keyboardWillChangeFrame: %@", notification.userInfo);
    NSDictionary *info = [notification userInfo];
    CGPoint kbBeginOrigin = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].origin;
    CGPoint kbEndOrigin = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin;
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    CGRect rect = self.view.frame;
    rect.size.height -= kbBeginOrigin.y - kbEndOrigin.y;
    [UIView animateWithDuration:duration
                          delay:0
                        options:(UIViewAnimationOptions)animationCurve
                     animations:^{
        self.view.frame = rect;
    }
                     completion:nil];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    CGRect bounds = textView.bounds;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(bounds), CGFLOAT_MAX)];
    self.containerViewHeightConstraint.constant = newSize.height + 10;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.textView resignFirstResponder];
}

#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedsCommentCellID forIndexPath:indexPath];
    if (self.comments.count > indexPath.row) {
        cell.comment = self.comments[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LatestComment *comment = [LatestComment new];
    if (self.comments.count > indexPath.row) {
        comment = self.comments[indexPath.row];
    }
    return [tableView fd_heightForCellWithIdentifier:kFeedsCommentCellID cacheByIndexPath:indexPath configuration:^(FeedsCommentCell *cell) {
        cell.comment = comment;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.comments.count > indexPath.row) {
        LatestComment *comment = self.comments[indexPath.row];
        NSString *tmpStr = [NSString stringWithFormat:@"%@@%@ ", self.textView.text, comment.author.name];
        self.textView.text = tmpStr;
        [self textViewDidChange:self.textView];
        [self.textView setNeedsDisplay];
    }
}
@end
