# HDEspTouch
smartconfig one line code call

## 适用于smartconfig的设备配网

基于EspTouch封装,简单的一句话调用.

将项目中Library文件夹中的HDEspTouch文件夹(其中包括EspTouch)拷贝出来,导入你的项目中.

使用时在类中引用HDEspTouch即可.

## 使用方法

调用HDEspTouch的方法:

	/**
 	开始配置WiFi

 	@param password WiFi密码
 	@param count 同时可配置的设备数量
 	@param espBlock 成功与否的回调
 	*/
	+ (void)startConfigWithPassword:(NSString *)password withTaskCount:(int)count withComplent:(void(^)(BOOL isSuccess))espBlock;

Demo中的使用:

	[HDEspTouch startConfigWithPassword:self.wifiPwdTf.text withTaskCount:[self.deviceCountTf.text intValue] withComplent:^(BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.hintLabel.text = @"配置成功!";
        }else{
            weakSelf.hintLabel.text = @"配置失败,请重试";
        }
    }];
    //self.wifiPwdTf.text无线网密码
    //[self.deviceCountTf.text intValue]需要配网的设备数量
    //weakSelf.hintLabel.text提示性文字
    
取消方法调用:

	/**
 	取消配置
 	*/
	+ (void)cancel;
Demo中取消使用:

	[HDEspTouch cancel];

详细信息请下载demo查看;

## 说明

根据EspTouch "https://github.com/EspressifApp/EsptouchForIOS" 封装;</br>
目前引用的版本号"v0.3.6.1"

Android版本友好链接 "https://github.com/EspressifApp/EsptouchForAndroid"

Android经过封装的版本 "https://github.com/Rairmmd/AndEsptouch"

谢谢
