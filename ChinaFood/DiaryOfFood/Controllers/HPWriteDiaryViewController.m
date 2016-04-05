//
//  HPWriteDiaryViewController.m
//  全民菜谱
//
//  Created by tarena on 16/1/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPWriteDiaryViewController.h"
#import "HPNameCell.h"
#import "HPSumaryCell.h"
#import "HPWriteIngredientsCell.h"
#import "HPAddCell.h"
#import "HPTextView.h"
#import "HPWriteStepViewController.h"
#import "HPTableView.h"
#import "MBProgressHUD+KR.h"
@interface HPWriteDiaryViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) HPTableView *tableView;
@property (nonatomic, strong) UIView *tableHeadView;
@property (nonatomic, strong) NSMutableArray *ingredients;
@property (nonatomic, assign) NSInteger ingredientCellCount;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) HPTextView *sumaryTextView;
@property (nonatomic, weak) UIButton *headButton;
@property (nonatomic, weak) UIImage *headButtonImage;

@end

@implementation HPWriteDiaryViewController

- (NSInteger)ingredientCellCount{
    if (!_ingredientCellCount) {
        _ingredientCellCount = 2;
    }
    return _ingredientCellCount;
}

- (NSMutableArray *)ingredients{
    if (!_ingredients) {
        _ingredients = [NSMutableArray array];
    }
    return _ingredients;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    [self setRightUpNavigation];
    [self setUpTableView];
    [self setUptableHeadImageButton];
    [self.tableView registerClass:[HPNameCell class] forCellReuseIdentifier:@"nameCell"];
    [self.tableView registerClass:[HPSumaryCell class] forCellReuseIdentifier:@"sumaryCell"];
    [self.tableView registerClass:[HPAddCell class] forCellReuseIdentifier:@"addCell"];
    [self.tableView registerClass:[HPWriteIngredientsCell class] forCellReuseIdentifier:@"ingredientsCell"];
}

- (void)setRightUpNavigation{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(clickNextStep)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
}

- (void)setUpTableView{
    self.tableView = [[HPTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
//    tableViewGesture.numberOfTapsRequired = 1;
//    tableViewGesture.cancelsTouchesInView = NO;
//    [self.tableView addGestureRecognizer:tableViewGesture];
}

- (void)setUptableHeadImageButton{
    self.tableHeadView = [[UIView alloc] init];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headButton = btn;
    [btn addTarget:self action:@selector(photo) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(10, 10, kScreenWidth - 20, 220);
    [self.tableHeadView addSubview:btn];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:11];
    label.frame = CGRectMake(kScreenWidth - 110, 200, 100, 20);

    label.text = @"点击可更换封面图";
    label.userInteractionEnabled = NO;
    label.textColor = [UIColor blackColor];
    [self.tableHeadView addSubview:label];
    
    self.tableHeadView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(btn.frame) + 10);
    self.tableView.tableHeaderView = self.tableHeadView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        //名称
        return 1;
    }else if(section == 1){
        //简介
        return 1;
    }else {
        return self.ingredientCellCount;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        HPNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nameCell" forIndexPath:indexPath];
        self.nameTextField = cell.textField;
        [[NSNotificationCenter defaultCenter ] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:cell.textField];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEdit:) name:UITextFieldTextDidBeginEditingNotification object:cell.textField];
        return cell;
    }else if(indexPath.section == 1){
        HPSumaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sumaryCell" forIndexPath:indexPath];
        self.sumaryTextView = cell.textView;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:cell.textView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEdit:) name:UITextViewTextDidBeginEditingNotification object:cell.textView];
        return cell;
    }else {
        if (indexPath.row == self.ingredientCellCount - 1) {
            HPAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addCell" forIndexPath:indexPath];
            [cell.addButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
            cell.addButton.userInteractionEnabled = YES;
            cell.buttonTitle = @"添加";
            return cell;
        }else{
            HPWriteIngredientsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ingredientsCell" forIndexPath:indexPath];
            [[NSNotificationCenter defaultCenter ] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:cell.usage];
            [[NSNotificationCenter defaultCenter ] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:cell.ingredients];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEdit:) name:UITextFieldTextDidBeginEditingNotification object:cell.usage];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEdit:) name:UITextFieldTextDidBeginEditingNotification object:cell.ingredients];
            return cell;
        }
        
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else if(indexPath.section == 1){
        return 80;
    }else{
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (indexPath.row == self.ingredientCellCount - 1) {
            self.ingredientCellCount++;
            [tableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.ingredientCellCount - 2) inSection:2];
            HPWriteIngredientsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell.ingredients becomeFirstResponder];
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (indexPath.row != self.ingredientCellCount - 1) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    self.ingredientCellCount--;
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)clickNextStep{
    NSManagedObjectContext *context = self.context;
    if (self.cookBook == nil) {
        self.cookBook = [NSEntityDescription insertNewObjectForEntityForName:@"HPDiaryCookBook" inManagedObjectContext:context];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy年MM月dd日"];
        NSDate *date = [NSDate date];
        NSString *dateString = [dateformatter stringFromDate:date];
        
        NSDateFormatter *timeformatter = [[NSDateFormatter alloc] init];
        [timeformatter setDateFormat:@"HH:mm:ss"];
        NSString *timeString = [timeformatter stringFromDate:date];
        NSString *fullDateString = [dateString stringByAppendingString:timeString];
        self.cookBook.date = dateString;
        self.cookBook.time = timeString;
        self.cookBook.fulldate = fullDateString;

    }
    if(self.nameTextField.text.length == 0){
        [MBProgressHUD showError:@"菜谱名未填"];
        return;
    }else{
        self.cookBook.name = self.nameTextField.text;
    }
    
    if (self.sumaryTextView.text.length == 0) {
        [MBProgressHUD showError:@"菜谱简介未填"];
        return;
    }else{
        self.cookBook.sumary = self.sumaryTextView.text;
    }
    
    NSMutableArray *ingredientArr = [NSMutableArray array];
    for (int i = 0; i < self.ingredientCellCount - 1; i ++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:2];
        HPWriteIngredientsCell *cell = [self.tableView cellForRowAtIndexPath:path];
        if (!(cell.ingredients.text.length && cell.usage.text.length)) {
            [MBProgressHUD showError:@"有材料名或用量未填"];
            return;
        }
        NSString *str = [cell.ingredients.text stringByAppendingString:cell.usage.text];
        [ingredientArr addObject:str];
    }
    NSData *recipeData = [NSKeyedArchiver archivedDataWithRootObject:ingredientArr];
    self.cookBook.recipes = recipeData;
    if (self.headButtonImage) {
        self.cookBook.image = UIImagePNGRepresentation(self.headButtonImage);
    }else{
    }
    
    
    HPWriteStepViewController *stepViewController = [[HPWriteStepViewController alloc] init];

    
    stepViewController.diaryCookBook = self.cookBook;
    stepViewController.context = self.context;
    
    [self.navigationController pushViewController:stepViewController animated:YES];
}

- (void)cancel{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"已经修改的内容将会丢失." message:@"是否离开此页" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.cookBook) {
            [self.context deleteObject:self.cookBook];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [controller addAction:action1];
    [controller addAction:action2];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)setContext:(NSManagedObjectContext *)context{
    _context = context;
}


#pragma 获取照片
- (void)photo{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请选择" message:@"请选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pc = [[UIImagePickerController alloc] init];
        pc.allowsEditing = YES;
        pc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pc.delegate = self;
        [self presentViewController:pc animated:YES completion:nil];
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *pc = [[UIImagePickerController alloc] init];
            pc.allowsEditing = YES;
            pc.sourceType = UIImagePickerControllerSourceTypeCamera;
            pc.delegate = self;
            [self presentViewController:pc animated:YES completion:nil];
        }
    }];
    [controller addAction:cancelAction];
    [controller addAction:photoAction];
    [controller addAction:cameraAction];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<    NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.headButtonImage = image;
    [self.headButton setBackgroundImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textDidEdit:(NSNotification*)notification{
    UITextField *textfield = (UITextField *)notification.object;
    NSLog(@"dssfa");
    if (textfield == self.nameTextField) {
        [UIView animateWithDuration:0 delay:0.0 options:7 << 16 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -216);
        } completion:nil];
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.contentOffset = CGPointMake(0, -41);
        }];
    }else{
        [UIView animateWithDuration:0 delay:0.0 options:7 << 16 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -216);
        } completion:nil];
        CGPoint point = [textfield convertPoint:textfield.frame.origin toView:self.tableView];
        CGFloat y = point.y;
        NSLog(@"%f",y);
        NSInteger row = (y - 434) / 44;
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.contentOffset = CGPointMake(0, 154 + row * 44);
        }];
    }
    
}

- (void)textViewDidEdit:(NSNotification *)notification{
    [UIView animateWithDuration:0 delay:0.0 options:7 << 16 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -216);
    } completion:nil];
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentOffset = CGPointMake(0, 38);
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)add{
    NSLog(@"add");
    self.ingredientCellCount++;
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.ingredientCellCount - 2) inSection:2];
    HPWriteIngredientsCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.ingredients becomeFirstResponder];
}





@end
