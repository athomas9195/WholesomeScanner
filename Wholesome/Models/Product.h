//
//  Product.h
//  Wholesome
//
//  Created by Anna Thomas on 7/15/21.
//

#import <Foundation/Foundation.h>
#import "Scan.h"
#import <Parse/ParseUIConstants.h>
#import <Parse/PFInstallation.h>
#import <Parse/Parse.h>
#import <Parse/PFImageView.h>

@class Scan; 

NS_ASSUME_NONNULL_BEGIN

@interface Product : NSObject

// MARK: Properties
@property (nonatomic, strong) NSString *upc; 

@property (nonatomic, strong) PFFileObject *image;   
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSNumber *safetyRating; 
@property (nonatomic, strong) NSString *nutriscore;
@property (nonatomic, strong) NSNumber *nova;
@property (nonatomic, strong) NSArray *novaGroup;

@property (nonatomic, strong) NSNumber *itemID;

@property (nonatomic, strong) NSString *foodName;
@property (nonatomic, strong) NSString *brandName;
//@property (nonatomic, strong) NSString *category;

@property (nonatomic, strong) NSString *allIngred;
@property (nonatomic, strong) NSArray *keyIngred;

@property (nonatomic, strong) NSArray *additives;
@property (nonatomic, strong) NSArray *allergens;
 
@property (nonatomic, strong) NSArray *badIngred;

@property (nonatomic, strong) NSMutableArray *pieChartSlices; 

//methods
- (instancetype)initWithDictionary:(NSDictionary *)dictionary :(NSDictionary *)openFoodFacts :(NSString *)upc;
- (instancetype)initWithDictionary:(NSDictionary *)nutritionix; 
- (instancetype)initWithScan:(Scan *) scan;
- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image ;
 
@end

NS_ASSUME_NONNULL_END
