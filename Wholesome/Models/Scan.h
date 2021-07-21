//
//  Scan.h
//  Wholesome
//
//  Created by Anna Thomas on 7/14/21.
//

#import <Parse/Parse.h>
#import "Product.h" 

NS_ASSUME_NONNULL_BEGIN

@interface Scan : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *scanID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;

@property (nonatomic, strong) NSString *upc;

@property (nonatomic, strong) NSURL *image;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSNumber *safetyRating;
@property (nonatomic, strong) NSString *nutriscore;
@property (nonatomic, strong) NSNumber *nova;
@property (nonatomic, strong) NSArray *novaGroup;

@property (nonatomic, strong) NSNumber *itemID;

@property (nonatomic, strong) NSString *foodName;
@property (nonatomic, strong) NSString *brandName;
//@property (nonatomic, strong) NSString *category;

@property (nonatomic, strong) NSArray *allIngred;
@property (nonatomic, strong) NSArray *keyIngred;

@property (nonatomic, strong) NSArray *additives;
@property (nonatomic, strong) NSArray *allergens;

@property (nonatomic, strong) NSArray *badIngred; 

@property (nonatomic, strong) NSMutableArray *pieChartSlices;

+ (void) postScan: (Product *) product withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;

@end

NS_ASSUME_NONNULL_END
