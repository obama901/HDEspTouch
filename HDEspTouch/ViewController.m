//
//  ViewController.m
//  HDEspTouch
//
//  Created by 马赫迪 on 2018/6/28.
//  Copyright © 2018年 马赫迪. All rights reserved.
//

#import "ViewController.h"
#import "UITextField+MHD_TextFieldCommonSetting.h"
#import "UIButton+MHD_ButtonCommonSetting.h"
#import "UILabel+MHD_LabelCommonSetting.h"
#import "HDEspTouch.h"

//屏幕尺寸
#define MAIN_SIZE ([ [ UIScreen mainScreen ] bounds ].size)

@interface ViewController ()
@property (nonatomic,retain)UIImageView *backgroundView;
@property (nonatomic,retain)UITextField *wifiNameTf;
@property (nonatomic,retain)UITextField *wifiPwdTf;
@property (nonatomic,retain)UITextField *deviceCountTf;
@property (nonatomic,retain)UILabel *hintLabel;
@property (nonatomic,retain)UIButton *confirmBtn;
@property (nonatomic,retain)UIButton *cancelBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backgroundView];
    [self wifiNameTf];
    [self wifiPwdTf];
    [self deviceCountTf];
    [self hintLabel];
    [self confirmBtn];
    [self cancelBtn];
}
- (UIImageView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc]init];
        _backgroundView.center = CGPointMake(MAIN_SIZE.width/2, MAIN_SIZE.height/4);
        _backgroundView.bounds = CGRectMake(0, 0, MAIN_SIZE.width, MAIN_SIZE.height/2);
        _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:_backgroundView];
    }
    _backgroundView.image = [UIImage imageNamed:[NSString stringWithFormat:@"back_ground_%u",arc4random()%3]];
    return _backgroundView;
}
- (UITextField *)wifiNameTf
{
    if (!_wifiNameTf) {
        _wifiNameTf = [[UITextField alloc]init];
        [_wifiNameTf mhd_textFieldWithText:[HDEspTouch getSSID] placeHolder:@"WiFi名称" textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft font:17];
        _wifiNameTf.backgroundColor = [UIColor whiteColor];
        _wifiNameTf.layer.cornerRadius = 12.5;
        _wifiNameTf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _wifiNameTf.leftViewMode = UITextFieldViewModeAlways;
        _wifiNameTf.center = CGPointMake(MAIN_SIZE.width/2, MAIN_SIZE.height/8);
        _wifiNameTf.bounds = CGRectMake(0, 0, MAIN_SIZE.width*3/4, 25);
        [self.view addSubview:_wifiNameTf];
    }
    return _wifiNameTf;
}
- (UITextField *)wifiPwdTf
{
    if (!_wifiPwdTf) {
        _wifiPwdTf = [[UITextField alloc]init];
        [_wifiPwdTf mhd_textFieldWithText:@"" placeHolder:@"WiFi密码" textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft font:17];
        _wifiPwdTf.backgroundColor = [UIColor whiteColor];
        _wifiPwdTf.layer.cornerRadius = 12.5;
        _wifiPwdTf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _wifiPwdTf.leftViewMode = UITextFieldViewModeAlways;
        _wifiPwdTf.center = CGPointMake(MAIN_SIZE.width/2, MAIN_SIZE.height/4);
        _wifiPwdTf.bounds = CGRectMake(0, 0, MAIN_SIZE.width*3/4, 25);
        [self.view addSubview:_wifiPwdTf];
    }
    return _wifiPwdTf;
}
- (UITextField *)deviceCountTf
{
    if (!_deviceCountTf) {
        _deviceCountTf = [[UITextField alloc]init];
        [_deviceCountTf mhd_textFieldWithText:@"" placeHolder:@"连接设备数" textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft font:17];
        _deviceCountTf.backgroundColor = [UIColor whiteColor];
        _deviceCountTf.layer.cornerRadius = 12.5;
        _deviceCountTf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _deviceCountTf.leftViewMode = UITextFieldViewModeAlways;
        _deviceCountTf.center = CGPointMake(MAIN_SIZE.width/2, MAIN_SIZE.height*3/8);
        _deviceCountTf.bounds = CGRectMake(0, 0, MAIN_SIZE.width*3/4, 25);
        [self.view addSubview:_deviceCountTf];
    }
    return _deviceCountTf;
}
- (UILabel *)hintLabel
{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc]init];
        [_hintLabel mhd_labelWithText:@"待配置" color:[UIColor darkGrayColor] font:17 alignment:NSTextAlignmentCenter];
        _hintLabel.center = CGPointMake(MAIN_SIZE.width/2, MAIN_SIZE.height*5/8);
        _hintLabel.bounds = CGRectMake(0, 0, MAIN_SIZE.width*3/4, 25);
        [self.view addSubview:_hintLabel];
    }
    return _hintLabel;
}
- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn mhd_buttonWithTitle:@"确认" backColor:[UIColor clearColor] font:17 titleColor:[UIColor whiteColor] cornerRadius:12.5];
        _confirmBtn.clipsToBounds = true;
        [_confirmBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"back_ground_%u",arc4random()%3]] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.center = CGPointMake(MAIN_SIZE.width/2, MAIN_SIZE.height*6/8);
        _confirmBtn.bounds = CGRectMake(0, 0, MAIN_SIZE.width*3/4, 25);
        [self.view addSubview:_confirmBtn];
    }
    return _confirmBtn;
}
- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn mhd_buttonWithTitle:@"取消" backColor:[UIColor clearColor] font:17 titleColor:[UIColor whiteColor] cornerRadius:12.5];
        _cancelBtn.clipsToBounds = true;
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"back_ground_%u",arc4random()%3]] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.center = CGPointMake(MAIN_SIZE.width/2, MAIN_SIZE.height*7/8);
        _cancelBtn.bounds = CGRectMake(0, 0, MAIN_SIZE.width*3/4, 25);
        [self.view addSubview:_cancelBtn];
    }
    return _cancelBtn;
}
- (void)confirmBtnAction:(UIButton *)btn
{
    self.hintLabel.text = @"配置中...";
    __weak ViewController *weakSelf = self;
    [HDEspTouch startConfigWithPassword:self.wifiPwdTf.text withTaskCount:[self.deviceCountTf.text intValue] withComplent:^(BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.hintLabel.text = @"配置成功!";
        }else{
            weakSelf.hintLabel.text = @"配置失败,请重试";
        }
    }];
}
- (void)cancelBtnAction:(UIButton *)btn
{
    [HDEspTouch cancel];
    self.hintLabel.text = @"已取消,待配置";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
