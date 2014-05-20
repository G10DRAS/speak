//
//  ViewController.m
//  OCRSDKDemo
//
//  Created by Shalin Shah on 5/2/14.
//  Copyright (c) 2014 ABBYY. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

int const maxImagePixelsAmount = 3200000; // 3.2 MP

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView.image = [UIImage imageNamed:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(id)sender {
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.sourceType = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ? UIImagePickerControllerSourceTypeCamera :  UIImagePickerControllerSourceTypePhotoLibrary;
	imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
	imagePicker.allowsEditing = NO;
	imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (IBAction)recognizePhoto:(id)sender {
    tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
//    [tesseract setVariableValue:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz@.:/()&-,_+!?" forKey:@"tessedit_char_whitelist"];
    UIImage *changedImage = scaleAndRotateImage(self.imageView.image, maxImagePixelsAmount);
    [self toGrayscale:changedImage];
    
    NSData *imageData = UIImagePNGRepresentation(changedImage);
    [tesseract setImage:[UIImage imageWithData:imageData]];
    [tesseract recognize];
    if (self.textViewController == nil) {
        self.textViewController = [[SpeakViewController alloc] initWithNibName:nil bundle:nil];
    }
    self.textViewController.text = [[NSString alloc] initWithString:[tesseract recognizedText]];
    self.textViewController.speakText.text = [[NSString alloc] initWithString:[tesseract recognizedText]];
//    [self.navigationController pushViewController:self.textViewController animated:NO];
    NSLog(@"%@", [tesseract recognizedText]);
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	self.imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
	[picker dismissViewControllerAnimated:YES completion:nil];
}
/*
 
 THESE MAKE TESSERACT'S IMAGE READING MORE ACCURATE AND WORK BETTER
 (IT MAY ALSO MAKE IT SLOWER)
 
 */
UIImage *scaleAndRotateImage(UIImage *image, int maxPixelsAmount)
{
	CGImageRef imgRef = image.CGImage;
    
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
    
	// Reduce image width and height by 2^n times to match condition: width*height <= maxPixelAmount,
	// where n = floor( log4( maxPixelsAmount / (width * height) ) )
	CGFloat scaleRatio = fmin( 1., pow( 2., floor( 1e-12 + log2( (double)maxPixelsAmount / (width * height) ) / 2. ) ) );
    
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	bounds.size.width = width * scaleRatio;
	bounds.size.height = height * scaleRatio;
    
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	UIImageOrientation orient = image.imageOrientation;
    //orient = UIImageOrientationDown;
	switch(orient) {
		case UIImageOrientationUp:
			transform = CGAffineTransformIdentity;
			break;
            
		case UIImageOrientationUpMirrored:
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
            
		case UIImageOrientationDown:
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
            
		case UIImageOrientationDownMirrored:
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
            
		case UIImageOrientationLeftMirrored:
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
            
		case UIImageOrientationLeft:
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
            
		case UIImageOrientationRightMirrored:
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
            
		case UIImageOrientationRight:
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
            
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
	}
    
	UIGraphicsBeginImageContext(bounds.size);
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
    
	CGContextConcatCTM(context, transform);
    
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
	return imageCopy;
}
//UIImage * gs_convert_image (UIImage * src_img) {
//    
//    CGColorSpaceRef d_colorSpace = CGColorSpaceCreateDeviceRGB();
//    /*
//     * Note we specify 4 bytes per pixel here even though we ignore the
//     * alpha value; you can't specify 3 bytes per-pixel.
//     */
//    size_t d_bytesPerRow = src_img.size.width * 4;
//    unsigned char * imgData = (unsigned char*)malloc(src_img.size.height*d_bytesPerRow);
//    CGContextRef context =  CGBitmapContextCreate(imgData, src_img.size.width,
//                                                  src_img.size.height,
//                                                  8, d_bytesPerRow,
//                                                  d_colorSpace,
//                                                  kCGImageAlphaNoneSkipFirst);
//    
//    UIGraphicsPushContext(context);
//    // These next two lines 'flip' the drawing so it doesn't appear upside-down.
//    CGContextTranslateCTM(context, 0.0, src_img.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    // Use UIImage's drawInRect: instead of the CGContextDrawImage function, otherwise you'll have issues when the source image is in portrait orientation.
//    [src_img drawInRect:CGRectMake(0.0, 0.0, src_img.size.width, src_img.size.height)];
//    UIGraphicsPopContext();
//    
//    /*
//     * At this point, we have the raw ARGB pixel data in the imgData buffer, so
//     * we can perform whatever image processing here.
//     */
//    
//    
//    // After we've processed the raw data, turn it back into a UIImage instance.
//    CGImageRef new_img = CGBitmapContextCreateImage(context);
//    UIImage * convertedImage = [[UIImage alloc] initWithCGImage:
//                                new_img];
//    
//    CGImageRelease(new_img);
//    CGContextRelease(context);
//    CGColorSpaceRelease(d_colorSpace);
//    free(imgData);
//    return convertedImage;
//}


//-(UIImage *)resizeImage:(UIImage *)image {
//    
//    CGImageRef imageRef = [image CGImage];
//    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
//    CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
//    
//    if (alphaInfo == kCGImageAlphaNone)
//        alphaInfo = kCGImageAlphaNoneSkipLast;
//    
//    int width, height;
//    
//    width = 640;//[image size].width;
//    height = 640;//[image size].height;
//    
//    CGContextRef bitmap;
//    
//    if (image.imageOrientation == UIImageOrientationUp | image.imageOrientation == UIImageOrientationDown) {
//        bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
//        
//    } else {
//        bitmap = CGBitmapContextCreate(NULL, height, width, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
//        
//    }
//    
//    if (image.imageOrientation == UIImageOrientationLeft) {
//        NSLog(@"image orientation left");
//        CGContextRotateCTM (bitmap, radians(90));
//        CGContextTranslateCTM (bitmap, 0, -height);
//        
//    } else if (image.imageOrientation == UIImageOrientationRight) {
//        NSLog(@"image orientation right");
//        CGContextRotateCTM (bitmap, radians(-90));
//        CGContextTranslateCTM (bitmap, -width, 0);
//        
//    } else if (image.imageOrientation == UIImageOrientationUp) {
//        NSLog(@"image orientation up");
//        
//    } else if (image.imageOrientation == UIImageOrientationDown) {
//        NSLog(@"image orientation down");
//        CGContextTranslateCTM (bitmap, width,height);
//        CGContextRotateCTM (bitmap, radians(-180.));
//        
//    }
//    
//    CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
//    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
//    UIImage *result = [UIImage imageWithCGImage:ref];
//    
//    CGContextRelease(bitmap);
//    CGImageRelease(ref);
//    
//    return result;
//    
//}
//
//
- (UIImage *) toGrayscale:(UIImage*)img
{
    const int RED = 1;
    const int GREEN = 2;
    const int BLUE = 3;
    
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, img.size.width * img.scale, img.size.height * img.scale);
    
    int width = imageRect.size.width;
    int height = imageRect.size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [img CGImage]);
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            // convert to grayscale using recommended method:   http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image
                                                 scale:img.scale
                                           orientation:UIImageOrientationUp];
    
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}
@end