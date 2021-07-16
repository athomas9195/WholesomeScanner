//
//  APIManager.m
//  Wholesome
//
//  Created by Anna Thomas on 7/15/21.
//

#import "APIManager.h"
#import "Product.h"
#import <Foundation/Foundation.h>

static NSString * const baseURLString = @"https://trackapi.nutritionix.com";

//https://trackapi.nutritionix.com/v2/search/item?nix_item_id=513fc9e73fe3ffd40300109f

@interface APIManager()
@end

@implementation APIManager 

//+ (instancetype)shared {
//    static APIManager *sharedManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedManager = [[self alloc] init];
//    });
//    return sharedManager;
//}

//- (instancetype)init {
//
//    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
//    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
//
//    NSString *appID= [dict objectForKey: @"app_Id"];
//    NSString *appKey = [dict objectForKey: @"app_Key"];
//
//    NSDictionary *headers = @{ @"x-app-id": appID,
//                               @"x-app-key": appKey };
//
//    // Check for launch arguments override
//    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"app_Id"]) {
//        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"app_Id"];
//    }
//    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"app_Key"]) {
//        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"app_Key"];
//    }
//
//    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
//    if (self) {
//
//    }
//    return self;
//}

//retrieves home timeline of tweets
- (void)getItemWithUPC:(NSString *)upc completion:(void(^)(Product *product, NSError *error))completion {

    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    
    NSString *appID= [dict objectForKey: @"app_Id"];
    NSString *appKey = [dict objectForKey: @"app_Key"];
    
    NSDictionary *headers = @{ @"x-app-id": appID,
                               @"x-app-key": appKey };
    
    //START
    NSString *base = @"https://trackapi.nutritionix.com/v2/search/item?upc=";
    NSString *fullURL = [base stringByAppendingString:upc];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse); 
                                                    }
                                                }];
    [dataTask resume];
    
    
//    // Create a GET Request
//    [self GET:@"1.1/statuses/home_timeline.json"
//       parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
//           // Success
//           NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
//        //NSLog(@"%d", [tweets count]);
//           completion(tweets, nil);
//       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//           // There was a problem
//           completion(nil, error);
//    }];
}

//// Post Composed Tweet Method
//- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion{
//    NSString *urlString = @"1.1/statuses/update.json";
//    NSDictionary *parameters = @{@"status": text};
//
//    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
//        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
//        completion(tweet, nil);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        completion(nil, error);
//    }];
//}
//
////calls api to favorite a tweet
//- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
//
//    NSString *urlString = @"1.1/favorites/create.json";
//    NSDictionary *parameters = @{@"id": tweet.idStr};
//    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
//        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
//        completion(tweet, nil);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        completion(nil, error);
//    }];
//}
//
////calls api to unfavorite a tweet
//- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
//
//    NSString *urlString = @"1.1/favorites/destroy.json";
//    NSDictionary *parameters = @{@"id": tweet.idStr};
//    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
//        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
//        completion(tweet, nil);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        completion(nil, error);
//    }];
//}
//
////calls api to retweet
//-(void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
//
//    NSString *urlString = @"1.1/statuses/retweet.json";
//    NSDictionary *parameters = @{@"id": tweet.idStr};
//    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
//        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
//        completion(tweet, nil);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        completion(nil, error);
//    }];
//
//}
//
////calls api to unretweet a tweet
//-(void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
//
//    NSString *urlString = @"1.1/statuses/unretweet.json";
//    NSDictionary *parameters = @{@"id": tweet.idStr};
//    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
//        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
//        completion(tweet, nil);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        completion(nil, error);
//    }];
//
//}
//

@end
