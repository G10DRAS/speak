//
//  IPDFCameraViewController.h
//  Voice
//
//  Created by Shalin Shah on 01/17/15.
//  Copyright (c) 2014 Shalin Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

typedef NS_ENUM(NSInteger,IPDFCameraViewType)
{
    IPDFCameraViewTypeBlackAndWhite,
    IPDFCameraViewTypeNormal
};

@interface IPDFCameraViewController : UIView <AVSpeechSynthesizerDelegate> {
    BOOL camStopped;
}

- (void)setupCameraView;

- (void)start;
- (void)stop;

@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;

@property (nonatomic,assign,getter=isBorderDetectionEnabled) BOOL enableBorderDetection;
@property (nonatomic,assign,getter=isTorchEnabled) BOOL enableTorch;

@property (nonatomic,assign) IPDFCameraViewType cameraViewType;

- (void)focusAtPoint:(CGPoint)point completionHandler:(void(^)())completionHandler;

- (void)captureImageWithCompletionHander:(void(^)(id data))completionHandler;
-(void)autoCaptureImage;

@end
