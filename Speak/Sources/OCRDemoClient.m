#import "OCRDemoClient.h"

//#error Provide Application ID and Password
// To create an application and obtain a password,
// register at http://cloud.ocrsdk.com/Account/Register
static NSString * const kApplicationId = @"Speak App";
static NSString * const kPassowrd = @"RgvukDA//PbqMzzd4RXOKjja";

@implementation OCRDemoClient

+ (instancetype)sharedClient
{
	static OCRDemoClient* sharedClient;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedClient = [[OCRDemoClient alloc] initWithApplicationId:kApplicationId password:kPassowrd];
	});
	
	return sharedClient;
}

@end
