//
//  APIManager.h
//  Wholesome
//
//  Created by Anna Thomas on 7/15/21.
//
 
#import "Product.h"
#import <Foundation/Foundation.h> 

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject 

+ (NSDictionary*)getItemWithUPC:(NSString *)upc completion:(void(^)(NSDictionary *dict, NSError *error))completion;
+ (NSDictionary*)getFoodFacts:(NSString *)upc completion:(void(^)(NSDictionary *dict, NSError *error))completion;
   
@end

NS_ASSUME_NONNULL_END
