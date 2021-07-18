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
@property (nonatomic, strong) NSURL *image; 
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSString *nutriscore;
@property (nonatomic, strong) NSNumber *nova; 


@property (nonatomic, strong) NSNumber *itemID;

@property (nonatomic, strong) NSString *foodName;
@property (nonatomic, strong) NSString *brandName;
//@property (nonatomic, strong) NSString *category;

@property (nonatomic, strong) NSArray *allIngred;
@property (nonatomic, strong) NSArray *keyIngred;
@property (nonatomic, strong) NSArray *novaGroup;  
//@property (nonatomic, strong) NSArray *badIngred;
//@property (nonatomic, strong) NSArray *goodIngred;

@property (nonatomic, strong) NSArray *additives;
@property (nonatomic, strong) NSArray *allergens;
@property (nonatomic, strong) NSArray *traces; 



//@property (nonatomic, strong) NSString *createdAtString; // Display date

//// For Retweets
//@property (nonatomic, strong) User *retweetedByUser;  // user who retweeted if tweet is retweet


//methods
- (instancetype)initWithDictionary:(NSDictionary *)dictionary :(NSDictionary *)openFoodFacts; 

//+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries; 

@end

NS_ASSUME_NONNULL_END
