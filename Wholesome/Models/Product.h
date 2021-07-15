//
//  Product.h
//  Wholesome
//
//  Created by Anna Thomas on 7/15/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Product : NSObject

// MARK: Properties
//@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSNumber *safetyRating;

@property (nonatomic, strong) NSNumber *itemID;

@property (nonatomic, strong) NSString *foodName;
@property (nonatomic, strong) NSString *brandName;

@property (nonatomic, strong) NSArray *allIngred;
@property (nonatomic, strong) NSArray *keyIngred;
@property (nonatomic, strong) NSArray *badIngred;
@property (nonatomic, strong) NSArray *goodIngred;

//@property (nonatomic, strong) NSString *createdAtString; // Display date

//// For Retweets
//@property (nonatomic, strong) User *retweetedByUser;  // user who retweeted if tweet is retweet


//methods
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

//+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries; 

@end

NS_ASSUME_NONNULL_END
