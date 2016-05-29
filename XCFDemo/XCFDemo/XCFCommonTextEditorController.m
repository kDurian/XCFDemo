//
//  XCFCommonTextEditorController.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/31/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "XCFCommonTextEditorController.h"

@interface XCFCommonTextEditorController ()

@end

@implementation XCFCommonTextEditorController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavBar];
    
    self.textView.text = self.currentText;
    
    
}

- (void)setupNavBar
{
    self.title = self.titleName;
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTextEditor)];
    
    UIBarButtonItem *conformBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(completeTextEditor)];
    
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    self.navigationItem.rightBarButtonItem = conformBarButtonItem;
    
}

- (void)cancelTextEditor
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)completeTextEditor
{
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidFinishEditing:withViewControllerTitle:withIndexPath:)]) {
        [self.delegate textViewDidFinishEditing:self.textView withViewControllerTitle:self.title withIndexPath:self.indexPath];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
