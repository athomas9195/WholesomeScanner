//
//  APIManager.h
//  Wholesome
//
//  Created by Anna Thomas on 7/15/21.
//

#import "BDBOAuth1SessionManager.h"
//#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"
#import "Product.h"

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : BDBOAuth1SessionManager

+ (instancetype)shared;

- (void)getItemWithUPC:(NSString *)upc completion:(void(^)(Product *product, NSError *error))completion;

//- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;
//
//- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion;
//
//- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;
//
//- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;
//
//-(void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;
//
//-(void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;


@end

NS_ASSUME_NONNULL_END
