//
//  TestTableViewController.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/30/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "RecipeEditedController.h"

#import "RecipeEditedPageCellManager.h"

#import "XCFRecipeCoverCell.h"

#import "XCFRecipeStepAdjustCell.h"

#import "XCFRecipeStepCell.h"

#import "XCFRecipeFileFateCell.h"

#import "XCFCommonTextEditorController.h"
#import "RecipeIngredientController.h"
#import "RecipeDraftController.h"
#import "RecipeInitialEntryController.h"

#import "UITableView+FDTemplateLayoutCell.h"

#import "Recipe.h"

#import <Realm/Realm.h>
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"

extern NSString * const kRecipeDescCellID;
extern NSString * const kRecipeIngsCellID;
extern NSString * const kRecipeTextStepCellID;
extern NSString * const kRecipeTipsCellID;
extern NSString * const kRecipeStepCellID;

static NSString * const kRecipeDraftControllerStoryboardID = @"kRecipeDraftControllerStoryboardID";
static NSString * const kRecipeCreatedStroyboardName = @"RecipeCreated";

@interface RecipeEditedController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, XCFCommonTextEditorDelegate, RecipeIngredientDelegate>

@property(nonatomic, strong) Recipe *recipe;

@property(nonatomic, strong) NSIndexPath *imageIndexPath;

@property(nonatomic, assign) BOOL previousControllerIsInitialEntry;

@property(nonatomic, assign) RecipeManageStyle recipeManageStyle;

@property(nonatomic, assign) EmptyRecipe recipeState;

@property(nonatomic, strong) NSMutableArray *emptyTextStepIndexs;

@property(nonatomic, strong) RLMRealm *realm;

@end


@implementation RecipeEditedController
#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.fd_debugLogEnabled = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView setAllowsSelectionDuringEditing:YES];
    
    self.realm = [RLMRealm defaultRealm];

    [self registerNibForCell];
    
    [self setNavBar];
    
    [self initRecipe];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)setNavBar
{
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backStretchBackgroundNormal"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonItemDidClicked)];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (BOOL)previousControllerIsInitialEntry
{
    NSArray *controllers = self.navigationController.viewControllers;
    NSInteger count = controllers.count;
    if ([[controllers objectAtIndex:count - 2] isKindOfClass:[RecipeInitialEntryController class]]) {
        return YES;
    }
    return NO;
}

#pragma mark - Init Recipe
- (void)initRecipe
{
    if (_currentRecipe) {
        self.recipe = _currentRecipe;
    }else {
        self.recipe = ({
            Recipe *recipe = [[Recipe alloc] init];
            recipe.name = self.recipeName;
            recipe.practiceSteps = ({
                RLMArray<RecipePracticeStep *><RecipePracticeStep> *practiceSteps = [[RLMArray<RecipePracticeStep *><RecipePracticeStep> alloc] initWithObjectClassName:@"RecipePracticeStep"];
                RecipePracticeStep *step1 = [[RecipePracticeStep alloc] init];
                RecipePracticeStep *step2 = [[RecipePracticeStep alloc] init];
                [practiceSteps addObjects:@[step1, step2]];
                practiceSteps;
            });
            recipe.updateTime = ({
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
                NSString *updateTimeString = [NSString stringWithFormat:@"更新时间:%@", dateStr];
                updateTimeString;
            });
            recipe;
        });
        
        if ([RecipeDraft allObjects].count == 0) {
            RecipeDraft *recipeDraft = [[RecipeDraft alloc] init];
            [recipeDraft.recipes insertObject:self.recipe atIndex:0];
            [self.realm transactionWithBlock:^{
                [self.realm addOrUpdateObject:recipeDraft];
            }];
        }else {
            RecipeDraft *recipeDraft = [RecipeDraft allObjects].firstObject;
            [self.realm transactionWithBlock:^{
                [recipeDraft.recipes insertObject:self.recipe atIndex:0];
                [self.realm addOrUpdateObject:recipeDraft];
            }];
        }
    }
}

#pragma mark - Register cell
- (void)registerNibForCell
{
    [self.tableView registerNib:[UINib nibWithNibName:@"XCFRecipeDescCell" bundle:nil] forCellReuseIdentifier:kRecipeDescCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"XCFRecipeIngsCell" bundle:nil] forCellReuseIdentifier:kRecipeIngsCellID];
//    [self.tableView registerNib:[UINib nibWithNibName:@"XCFRecipeTextStepCell" bundle:nil] forCellReuseIdentifier:kRecipeTextStepCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"XCFRecipeTipsCell" bundle:nil] forCellReuseIdentifier:kRecipeTipsCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"XCFRecipeStepCell" bundle:nil] forCellReuseIdentifier:kRecipeStepCellID];
}

#pragma mark - Table view data source

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    if (section == 1) {
        return self.recipe.ingredients.count ? self.recipe.ingredients.count + 1 : 2;
    }
    if (section == 2) {
        return self.recipe.practiceSteps.count + 1;
    }
    if (section == 3) {
        return 4;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [RecipeEditedPageCellManager cellWithTableView:tableView withIndexPath:indexPath withRecipe:self.recipe];
    
    if (indexPath.section == 2 && indexPath.row != 0) {
        XCFRecipeStepCell *recipeStepCell = (XCFRecipeStepCell *)cell;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setRecipePicStep:)];
        [recipeStepCell.picStepImageView addGestureRecognizer:tapGestureRecognizer];
        [recipeStepCell.addRecipeTextStepButton addTarget:self action:@selector(setRecipeTextStep:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        XCFRecipeStepAdjustCell *stepAdjustCell = (XCFRecipeStepAdjustCell *)cell;
        [stepAdjustCell.addRecipeStepButton addTarget:self action:@selector(addRecipeStepButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [stepAdjustCell.adjustRecipeStepButton addTarget:self action:@selector(adjustRecipeStepButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (indexPath.section == 3 && indexPath.row == 3) {
        XCFRecipeFileFateCell *recipeFileFateCell = (XCFRecipeFileFateCell *)cell;
        [recipeFileFateCell.saveRecipeButton addTarget:self action:@selector(saveRecipe:) forControlEvents:UIControlEventTouchUpInside];
        [recipeFileFateCell.releaseRecipeButton addTarget:self action:@selector(releaseRecipe:) forControlEvents:UIControlEventTouchUpInside];
        [recipeFileFateCell.deleteRecipeButton addTarget:self action:@selector(deleteRecipe:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RecipeEditedPageCellManager tableView:tableView heightForRowAtIndexPath:indexPath withRecipe:self.recipe];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                self.imageIndexPath = indexPath;
                [self pickCoverPicFromCameraOrAlbum];
                break;
            }
            case 1:
            {
                [self setupRecipeName];
                break;
            }
            case 2:
            {
                [self setupRecipeDesc];
                break;
            }
            default:
                break;
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
        }else {
            [self setupRecipeIngredient];
        }
    }
    
    if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0:
            case 2:
            case 3:
            {
                break;
            }
            case 1:
            {
                [self setupRecipeTips];
                break;
            }
            default:
                break;
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row != 0) {
        return YES;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.recipe.practiceSteps.count > indexPath.row - 1) {
            
            [self.realm transactionWithBlock:^{
                [self.realm deleteObject:[self.recipe.practiceSteps objectAtIndex:indexPath.row - 1]];
            }];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            for (NSInteger i = indexPath.row; i <= self.recipe.practiceSteps.count; i++)
            {
                XCFRecipeStepCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]];
                cell.stepNumberLabel.text = [NSString stringWithFormat:@"%ld", i];
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row != 0) {
        return YES;
    }
    return NO;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        if (sourceIndexPath.section > proposedDestinationIndexPath.section) {
            return [NSIndexPath indexPathForRow:1 inSection:sourceIndexPath.section];
        }else if (sourceIndexPath.section < proposedDestinationIndexPath.section){
            return [NSIndexPath indexPathForRow:self.recipe.practiceSteps.count inSection:sourceIndexPath.section];
        }
    }else if (proposedDestinationIndexPath.row == 0){
        return [NSIndexPath indexPathForRow:1 inSection:sourceIndexPath.section];
    }else if (proposedDestinationIndexPath.row > self.recipe.practiceSteps.count){
        return [NSIndexPath indexPathForRow:self.recipe.practiceSteps.count inSection:sourceIndexPath.section];
    }
    return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    RecipePracticeStep *sourceStep = [self.recipe.practiceSteps objectAtIndex:sourceIndexPath.row - 1];
    
    [[RLMRealm defaultRealm] transactionWithBlock:^{
        [self.recipe.practiceSteps removeObjectAtIndex:sourceIndexPath.row - 1];
        [self.recipe.practiceSteps insertObject:sourceStep atIndex:destinationIndexPath.row - 1];
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Update Model
- (void)updateRecipeDraft
{
    RecipeDraft *recipeDraft = [RecipeDraft allObjects].firstObject;
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:recipeDraft];
    [realm commitWriteTransaction];
}

- (void)updateAndRearrangeRecipeDraft
{
    RecipeDraft *recipeDraft = [RecipeDraft allObjects].firstObject;
    Recipe *recipe = recipeDraft.recipes[self.currentRecipeIndex];
    
    [self.realm transactionWithBlock:^{
        [recipeDraft.recipes removeObjectAtIndex:self.currentRecipeIndex];
        [recipeDraft.recipes insertObject:recipe atIndex:0];
        [self.realm addOrUpdateObject:recipeDraft];
    }];
}

- (void)removeRecipeOfRecipeDraft
{
//    RecipeDraft *recipeDraft = [RecipeDraft allObjects].firstObject;
    if (self.previousControllerIsInitialEntry) {
        [self.realm transactionWithBlock:^{
            [self.realm deleteObjects:self.recipe.ingredients];
            [self.realm deleteObjects:self.recipe.practiceSteps];
            [self.realm deleteObject:self.recipe];
        
//            [self.realm deleteObject:[recipeDraft.recipes objectAtIndex:0]];
        }];
    }else {
        [self.realm transactionWithBlock:^{
//            [self.realm deleteObject:[recipeDraft.recipes objectAtIndex:self.currentRecipeIndex]];
            [self.realm deleteObjects:self.recipe.ingredients];
            [self.realm deleteObjects:self.recipe.practiceSteps];
            [self.realm deleteObject:self.recipe];
        }];
    }
}

#pragma mark - Show Alert Message
- (void)showAlertMessage
{
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    Hud.userInteractionEnabled = NO;
    Hud.mode = MBProgressHUDModeText;
    Hud.yOffset = 200.0f;
    
    switch (self.recipeManageStyle) {
        case RecipeManageStyleSave:
        {
            Hud.labelText = @"保存成功";
            break;
        }
        case RecipeManageStyleRelease:
        {
            Hud.labelText = @"发布成功";
            break;
        }
        case RecipeManageStyleDelete:
        {
            Hud.labelText = @"删除成功";
            break;
        }
        default:
            break;
    }
    [Hud hide:YES afterDelay:2];
}

- (void)showReleaseRecipeAlertMessage
{
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    Hud.userInteractionEnabled = NO;
    Hud.mode = MBProgressHUDModeText;
    Hud.margin = 10.0f;
    Hud.cornerRadius = 5.0f;
    Hud.opacity = 0.5f;
    Hud.labelFont = [UIFont systemFontOfSize:14.0f];
    Hud.yOffset = CGRectGetHeight([UIScreen mainScreen].bounds) * 1 / 3;
    
    switch (self.recipeState) {
        case EmptyRecipeCoverImage:
        {
            Hud.labelText = @" 请上传菜谱封面 ";
            break;
        }
        case EmptyRecipeIngredient:
        {
            Hud.labelText = @" 用料不能为空 ";
            break;
        }
        case EmptyRecipePracticeStep:
        {
            Hud.labelText = @" 步骤不能为空 ";
            break;
        }
        case EmptyRecipePracticeTextStep:
        {
            NSNumber *number = self.emptyTextStepIndexs.firstObject;
            Hud.labelText = [NSString stringWithFormat:@" 步骤%ld描述为空 ", [number integerValue] + 1];
            break;
        }
        default:
            break;
    }
    [Hud hide:YES afterDelay:2];
}

#pragma mark - Jump Logic
- (void)backBarButtonItemDidClicked
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kRecipeCreatedStroyboardName bundle:nil];
    RecipeDraftController *recipeDraftController = [storyboard instantiateViewControllerWithIdentifier:kRecipeDraftControllerStoryboardID];

    if (self.previousControllerIsInitialEntry){
        [self updateRecipeDraft];
        
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [viewControllers removeLastObject];
        [viewControllers removeLastObject];
        [viewControllers addObject:recipeDraftController];
        [self.navigationController setViewControllers:viewControllers];
    }else {
        [self updateAndRearrangeRecipeDraft];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)saveRecipe:(UIButton *)sender
{
    if (self.previousControllerIsInitialEntry){
        [self updateRecipeDraft];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        [self updateAndRearrangeRecipeDraft];
        [self.navigationController popViewControllerAnimated:YES];
    }
    //Show alert Message
    self.recipeManageStyle = RecipeManageStyleSave;
    [self showAlertMessage];
}

- (void)releaseRecipe:(UIButton *)sender
{
    if (self.recipe.ingredients.count == 0) {
        self.recipeState = EmptyRecipeIngredient;
        [self showReleaseRecipeAlertMessage];
        return;
    }else if (self.recipe.coverImageData.length == 0){
        self.recipeState = EmptyRecipeCoverImage;
        [self showReleaseRecipeAlertMessage];
        return;
    }else if ([self recipePracticeStepIsEmpty]){
        self.recipeState = EmptyRecipePracticeStep;
        [self showReleaseRecipeAlertMessage];
        return;
    }else if ([self recipePracticeTextStepIsEmpty]){
        self.recipeState = EmptyRecipePracticeTextStep;
        [self showReleaseRecipeAlertMessage];
        return;
    }
}

- (BOOL)recipePracticeStepIsEmpty
{
    NSInteger i = 0;
    NSInteger count = self.recipe.practiceSteps.count;
    for (NSInteger index = 0; index < count; ++index) {
        RecipePracticeStep *step = self.recipe.practiceSteps[index];
        if (step.text.length == 0 && step.imageData.length == 0) {
            i++;
        }
    }
    if (i == count) {
        return YES;
    }
    return NO;
}

- (BOOL)recipePracticeTextStepIsEmpty
{
    NSMutableArray *emptyTextStepIndexs = [NSMutableArray array];
    NSInteger count = self.recipe.practiceSteps.count;
    for (NSInteger index = 0; index < count; ++index) {
        RecipePracticeStep *step = self.recipe.practiceSteps[index];
        if (step.imageData.length > 0 && step.text.length == 0) {
            [emptyTextStepIndexs addObject:[NSNumber numberWithInteger:index]];
        }
    }
    if (emptyTextStepIndexs.count > 0) {
        self.emptyTextStepIndexs = emptyTextStepIndexs;
        return YES;
    }
    return NO;
}

- (void)deleteRecipe:(UIButton *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除此草稿吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (self.previousControllerIsInitialEntry){
            [self removeRecipeOfRecipeDraft];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else {
            [self removeRecipeOfRecipeDraft];
            [self.navigationController popViewControllerAnimated:YES];
        }
        self.recipeManageStyle = RecipeManageStyleDelete;
        [self showAlertMessage];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Edit recipes practice
- (void)setRecipePicStep:(UITapGestureRecognizer *)gestureRecognizer
{
    UIImageView *imageView = (UIImageView *)gestureRecognizer.view;
    CGPoint pointInTable = [imageView convertPoint:imageView.bounds.origin toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:pointInTable];
    self.imageIndexPath = indexPath;
    [self pickCoverPicFromCameraOrAlbum];
}

- (void)setRecipeTextStep:(UIButton *)sender
{
    XCFCommonTextEditorController *textEditorController = [[XCFCommonTextEditorController alloc] initWithNibName:@"XCFCommonTextEditorController" bundle:nil];
    CGPoint pointInTable = [sender convertPoint:sender.bounds.origin toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:pointInTable];
    RecipePracticeStep *practiceStep = self.recipe.practiceSteps[indexPath.row - 1];
    textEditorController.currentText = practiceStep.text;
    textEditorController.titleName = @"步骤";
    textEditorController.delegate = self;
    textEditorController.indexPath = indexPath;
    [self.navigationController pushViewController:textEditorController animated:YES];
}

#pragma mark - Adjust Recipes Practice
- (void)addRecipeStepButtonDidClicked:(UIButton *)sender
{
    if (self.tableView.editing) {
        
    }else {
        RecipePracticeStep *practiceStep = [[RecipePracticeStep alloc] init];
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            [self.recipe.practiceSteps addObject:practiceStep];
        }];
        [self.tableView reloadData];
    }
}

- (void)adjustRecipeStepButtonDidClicked:(UIButton *)sender
{
    self.tableView.editing = !self.tableView.editing;
    if (self.tableView.editing) {
        [self.tableView setEditing:YES animated:YES];
        [sender setTitle:@"调整完成" forState:UIControlStateNormal];
    }else {
        [self.tableView setEditing:NO animated:YES];
        [sender setTitle:@"调整" forState:UIControlStateNormal];
    }
}

#pragma mark - Edit Recipes Name/Desc/Ingredient/Tips
- (void)setupRecipeTips
{
    XCFCommonTextEditorController *textEditorController = [[XCFCommonTextEditorController alloc] initWithNibName:@"XCFCommonTextEditorController" bundle:nil];
    textEditorController.titleName = @"小贴士";
    textEditorController.delegate = self;
    textEditorController.currentText = self.recipe.tips;
    [self.navigationController pushViewController:textEditorController animated:YES];
}

- (void)setupRecipeIngredient
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"RecipeIngsEdited" bundle:nil];
    RecipeIngredientController *recipeIngredientController = [storyBoard instantiateInitialViewController];
    recipeIngredientController.recipeIngredients = self.recipe.ingredients;
    recipeIngredientController.delegate = self;
    [self.navigationController pushViewController:recipeIngredientController animated:YES];
}

- (void)setupRecipeDesc
{
    XCFCommonTextEditorController *textEditorController = [[XCFCommonTextEditorController alloc] initWithNibName:@"XCFCommonTextEditorController" bundle:nil];
    textEditorController.currentText = self.recipe.desc;
    textEditorController.titleName = @"简介";
    textEditorController.delegate = self;
    [self.navigationController pushViewController:textEditorController animated:YES];
}

- (void)setupRecipeName
{
    XCFCommonTextEditorController *textEditorController = [[XCFCommonTextEditorController alloc] initWithNibName:@"XCFCommonTextEditorController" bundle:nil];
    textEditorController.currentText = self.recipe.name;
    textEditorController.titleName = @"菜谱名称";
    textEditorController.delegate = self;
    [self.navigationController pushViewController:textEditorController animated:YES];
}

#pragma mark - Private Methods
- (void)pickCoverPicFromCameraOrAlbum
{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.delegate = weakSelf;
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [weakSelf presentViewController:pickerController animated:YES completion:nil];
        }
    }];
    UIAlertAction *pickPicAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.delegate = weakSelf;
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [weakSelf presentViewController:pickerController animated:YES completion:nil];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:takePhotoAction];
    [alertController addAction:pickPicAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *zipImageData = UIImageJPEGRepresentation(image, 0.5);
    NSIndexPath *indexPath = self.imageIndexPath;
    if (indexPath.section == 0)
    {
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            self.recipe.coverImageData = zipImageData;
        }];
    }else {
        RecipePracticeStep *practiceStep = self.recipe.practiceSteps[indexPath.row - 1];
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            practiceStep.imageData = zipImageData;
        }];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - XCFTextEditorDelegate
- (void)textViewDidFinishEditing:(UITextView *)textView withViewControllerTitle:(NSString *)title withIndexPath:(NSIndexPath *)indexPath
{
    if ([title isEqualToString:@"菜谱名称"]) {
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            self.recipe.name = textView.text;
        }];
    }
    if ([title isEqualToString:@"简介"]) {
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            self.recipe.desc = textView.text;
        }];
    }
    if ([title isEqualToString:@"步骤"]) {
        RecipePracticeStep *practiceStep = self.recipe.practiceSteps[indexPath.row - 1];
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            practiceStep.text = textView.text;
        }];
        
    }
    if ([title isEqualToString:@"小贴士"]) {
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            self.recipe.tips = textView.text;
        }];
    }
}

#pragma mark - RecipeIngredientDelegate
- (void)recipeIngredientDidEndEditing:(RecipeIngredientController *)viewController withContent:(RLMArray<RecipeIngredient *><RecipeIngredient> *)content
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@) && (%K == %@)", @"ingredientName", @"", @"ingredientAmount", @""];

    NSUInteger index = 0;
    while (index != NSNotFound)
    {
        index = [content indexOfObjectWithPredicate:predicate];
        if (index != NSNotFound) {
            [self.realm transactionWithBlock:^{
                [self.realm deleteObject:[content objectAtIndex:index]];
            }];
        }
    }
}
@end
