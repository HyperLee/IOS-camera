//
//  ViewController.m
//  noveltek
//
//  Created by noveltek on 2016/3/14.
//  Copyright (c) 2016年 noveltek. All rights reserved.
//
//
//
//
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight  [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<UIGestureRecognizerDelegate>
{
    NSArray *pickerDataSourceArray; //ISO array value//
}
//界面控件
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *switchCarmeraSegment;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *flashButton;
//AVFoundation

@property (nonatomic) dispatch_queue_t sessionQueue;
/**
 *  AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
 */
@property (nonatomic, strong) AVCaptureSession* session;
/**
 *  输入设备
 */
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;
/**
 *  照片输出流
 */
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;
/**
 *  预览图层
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;
/**
 *  记录开始的缩放比例
 */
@property (nonatomic,assign)CGFloat beginGestureScale;
/**
 *  最后的缩放比例
 */
@property (nonatomic,assign)CGFloat effectiveScale;
/**
 *  ISO; PickerView
 */
@property (nonatomic, assign, readonly) float ISO;
@property (nonatomic,assign)NSUInteger ISOValue;
@property (weak, nonatomic) IBOutlet UIPickerView *isoPickerView;

@end

@implementation ViewController{
    
    BOOL isUsingFrontFacingCamera;
}


#pragma mark life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAVCaptureSession];
    
    [self setUpGesture];
    
    isUsingFrontFacingCamera = NO;
    
    self.effectiveScale = self.beginGestureScale = 1.0f;
    
    pickerDataSourceArray = @[@"50", @"100", @"200", @"400"]; //iso array value//
    _isoPickerView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    if (self.session) {
        
        [self.session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    
    if (self.session) {
        
        [self.session stopRunning];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark private method
- (void)initAVCaptureSession{
    
    self.session = [[AVCaptureSession alloc] init];
    
    NSError *error;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device setTorchMode:AVCaptureTorchModeAuto];
    [device unlockForConfiguration];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    NSLog(@"%f",kMainScreenWidth);
    //set preview size; width, height//
    self.previewLayer.frame = CGRectMake(0, 0,kMainScreenWidth, kMainScreenHeight);
    self.backView.layer.masksToBounds = YES;
    [self.backView.layer addSublayer:self.previewLayer];
}

- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

#pragma  Gesture
- (void)setUpGesture{
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
    [self.backView addGestureRecognizer:pinch];
}

#pragma mark create ISO
- (void)setCameraISO:(float)ISO completionHandler:(void (^)(CMTime syncTime))handler {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device lockForConfiguration:nil]){
        
        ISO = MIN(ISO, device.activeFormat.maxISO);
        ISO = MAX(ISO, device.activeFormat.minISO);
        
        [device setExposureModeCustomWithDuration:AVCaptureExposureDurationCurrent ISO:ISO completionHandler:handler];
        
        [device unlockForConfiguration];
    }
}


#pragma mark gestureRecognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

#pragma mark respone method
//切换镜头; 預設值後鏡頭點選切換鈕可以切換至前鏡頭//
- (IBAction)switchCameraSegmentedControlClick:(UISegmentedControl *)sender {
    
    NSLog(@"%ld",(long)sender.selectedSegmentIndex);
    
    AVCaptureDevicePosition desiredPosition;
    if (isUsingFrontFacingCamera){
        desiredPosition = AVCaptureDevicePositionBack;

    }else{
        desiredPosition = AVCaptureDevicePositionFront;
    }
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [self.previewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            [self.previewLayer.session addInput:input];
            [self.previewLayer.session commitConfiguration];
            break;
        }
    }
    isUsingFrontFacingCamera = !isUsingFrontFacingCamera;
}

//take pic button click//
- (IBAction)takePhotoButtonClick:(UIBarButtonItem *)sender {
    
    NSLog(@"takephotoClick...");
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:self.effectiveScale];
    
    //準備拍照時間點//
    //  http://objccn.io/issue-21-3/  //
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
                                                                    imageDataSampleBuffer,
                                                                    kCMAttachmentMode_ShouldPropagate);
        
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
            //无权限
            return ;
        }
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:jpegData metadata:(__bridge id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
            
        }];
    }];
}

//flash button click//
- (IBAction)flashButtonClick:(UIBarButtonItem *)sender {
    
    NSLog(@"flashButtonClick");
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //修改前必须先锁定
    [device lockForConfiguration:nil];
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([device hasFlash]) {
        
        if (device.flashMode == AVCaptureFlashModeOff) {
            device.flashMode = AVCaptureFlashModeOn;
            
            [sender setTitle:@"flashOn"];
        } else if (device.flashMode == AVCaptureFlashModeOn) {
            device.flashMode = AVCaptureFlashModeAuto;
            [sender setTitle:@"flashAuto"];
        } else if (device.flashMode == AVCaptureFlashModeAuto) {
            device.flashMode = AVCaptureFlashModeOff;
            [sender setTitle:@"flashOff"];
        }
        
    } else {
        
        NSLog(@"不支持闪光灯");
    }
    [device unlockForConfiguration];
}

//torch button click//
- (IBAction)torchButtonClick:(UIBarButtonItem *)sender {
    NSLog(@"torchButtonClick");
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //修改前必须先锁定
    [device lockForConfiguration:nil];
    //必须判定是否有torch，否则如果没有torch会崩溃
    if ([device hasTorch]) {
        
        if (device.torchMode == AVCaptureTorchModeOff) {
            device.torchMode = AVCaptureTorchModeOn;
            
            [sender setTitle:@"torchOn"];
        } else if (device.torchMode == AVCaptureTorchModeOn) {
            device.torchMode = AVCaptureTorchModeAuto;
            [sender setTitle:@"torchAuto"];
        } else if (device.flashMode == AVCaptureTorchModeAuto) {
            device.torchMode = AVCaptureTorchModeOff;
            [sender setTitle:@"torchOff"];
        }
        
    } else {
        
        NSLog(@"不支持torch");
    }
    [device unlockForConfiguration];
}

//缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.backView];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
        
        NSLog(@"%f-------------->%f------------recognizerScale%f",self.effectiveScale,self.beginGestureScale,recognizer.scale);
        
        CGFloat maxScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        NSLog(@"%f",maxScaleAndCropFactor);
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
    }
    
}

- (IBAction)ISOTapped:(id)sender {
    
    //點選跑出pickviewUI再點選一次隱藏UI//
    //點選會呼叫出PickerView, 讓他做動作//
    _isoPickerView.hidden = !_isoPickerView.hidden;
}

#pragma mark - ISO UIPickerView datasource delegate
//一共多少列//
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..//
//每列對應多少行數; numbers = 4; 50, 100, 200, 400//
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerDataSourceArray.count;
}

//每列每行對應的顯示資料是什麼//
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str = [pickerDataSourceArray objectAtIndex:row];  //再pickerDataSourceArray 前面加上一個ISO字串//
    return  [NSString stringWithFormat:@"ISO %@", str]; //這樣在pickerview比較好閱讀//
}

// 当选中了pickerView的某一行的时候调用
// 会将选中的列号和行号作为参数传入
// 只有通过手指选中某一行的时候才会调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    NSString *iso = [pickerDataSourceArray objectAtIndex:row];
    _ISOValue = iso.integerValue;
    NSLog(@"ISOChanged  %zi",_ISOValue);
    [self setCameraISO:_ISOValue completionHandler:nil];
}

@end
