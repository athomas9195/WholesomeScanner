//
//  ScanViewController.h
//  Wholesome
//
//  Created by Anna Thomas on 7/14/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScanViewController : UIViewController
+(void)updateData:(NSDictionary *) dict : (NSDictionary *) dict1 : (NSString *)capturedBarcode;
//+(void)updateData:(NSArray *) labels; 
@end

NS_ASSUME_NONNULL_END
