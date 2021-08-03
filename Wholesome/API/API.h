//
//  API.h
//  Wholesome
//
//  Created by Anna Thomas on 7/21/21.
//

#import <Foundation/Foundation.h>
#import "Product.h"

NS_ASSUME_NONNULL_BEGIN

@interface API : NSObject

+ (NSDictionary*)getItemWithUPC:(NSString *)upc completion:(void(^)(NSDictionary *dictComp, NSError *error))completion;
+ (NSDictionary*)getFoodFacts:(NSString *)upc completion:(void(^)(NSDictionary *dict, NSError *error))completion; 
+ (NSDictionary*)searchItems:(NSString *)food completion:(void(^)(NSDictionary *dictComp, NSError *error))completion;
+ (NSDictionary*)searchAlternatives:(NSString *)food completion:(void(^)(NSDictionary *dictComp, NSError *error))completion; 

@end


NS_ASSUME_NONNULL_END
