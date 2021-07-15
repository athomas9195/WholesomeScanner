//
//  Scan.h
//  Wholesome
//
//  Created by Anna Thomas on 7/14/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Scan : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *scanID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;

@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSNumber *safetyRating;

@property (nonatomic, strong) NSNumber *itemID;

@property (nonatomic, strong) NSArray *allIngred;
@property (nonatomic, strong) NSArray *keyIngred;
@property (nonatomic, strong) NSArray *badIngred;
@property (nonatomic, strong) NSArray *goodIngred;


@property (nonatomic, strong) NSString *foodName;
@property (nonatomic, strong) NSString *brandName;

+ (void) postScan: ( NSNumber * _Nullable )UPC withAllIngred: (NSArray * _Nullable)all withImage:(UIImage * _Nullable)image withCompletion: (PFBooleanResultBlock  _Nullable)completion; 
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;

@end

NS_ASSUME_NONNULL_END
