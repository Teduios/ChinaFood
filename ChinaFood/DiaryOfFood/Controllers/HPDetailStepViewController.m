//
//  HPDetailStepViewController.m
//  全民菜谱
//
//  Created by tarena on 16/1/25.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPDetailStepViewController.h"
#import "HPTextView.h"
@interface HPDetailStepViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
@property (nonatomic, weak) UIButton *button;
@property (nonatomic, weak) HPTextView *textView;

@end

@implementation HPDetailStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNavigation];
    [self setButton];
    [self setTextView];
}

- (void)setUpNavigation {
    self.navigationItem.title = @"添加步骤";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(clickDownButton)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickCancelButton)];
}

- (void)setButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button = button;
    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 64, kScreenWidth, 200);
    [self.view addSubview:button];
}

- (void)setTextView{
    HPTextView *textView = [[HPTextView alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEdit:) name:UITextViewTextDidBeginEditingNotification object:textView];
    self.textView = textView;
    textView.myPlaceholder = @"请填写步骤说明(不超过100字,必填)";
    textView.delegate = self;
    textView.frame = CGRectMake(0, 300, kScreenWidth, 80);
    [self.view addSubview:textView];
    
}

- (void)addImage{
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self.button setBackgroundImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickDownButton{
    NSManagedObjectContext *context = [self.resultController managedObjectContext];
    if (self.step == nil) {
        self.step = [NSEntityDescription insertNewObjectForEntityForName:@"HPSteps" inManagedObjectContext:context];
    }
    self.step.fullDate = self.fullDate;
    self.step.stepImage = UIImagePNGRepresentation(self.button.currentBackgroundImage);
    self.step.stepString = self.textView.text;
    self.step.number = @(self.stepNumber);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickCancelButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textViewDidEdit:(NSNotification*)notification{
    [UIView animateWithDuration:0 delay:0.0 options:7 << 16 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -216);
    } completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0 delay:0.0 options:7 << 16 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if (self.textView == textView)
    {
        if ([toBeString length] > 100) {
            textView.text = [toBeString substringToIndex:100];
            return NO;
        }
    }
    return YES;}

@end
