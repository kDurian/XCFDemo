//
//  XCFCommonTextEditorController.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/31/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XCFCommonTextEditorController;

@protocol XCFCommonTextEditorDelegate<NSObject>

- (void)textViewDidFinishEditing:(UITextView *)textView withViewControllerTitle:(NSString *)title withIndexPath:(NSIndexPath *)indexPath;

@end


@interface XCFCommonTextEditorController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property(nonatomic, copy) NSString *titleName;

@property(nonatomic, copy) NSString *currentText;

@property(nonatomic, weak) id<XCFCommonTextEditorDelegate> delegate;

@property(nonatomic, strong) NSIndexPath *indexPath;

@end
