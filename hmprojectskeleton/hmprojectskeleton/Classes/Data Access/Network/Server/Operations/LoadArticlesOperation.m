//
//  LoadArticlesOperation.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 22/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "LoadArticlesOperation.h"
#import "AFNetworking.h"
#import "ArticleParser.h"

@implementation LoadArticlesOperation

- (void)loadArticlesWithCompletionHandler:(void(^)(NSArray *result))completionHandler {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:kHTTPHeaderFieldAPIKey forHTTPHeaderField:kHTTPHeaderKeyAPIKey];
    [manager.requestSerializer setValue:kHTTPHeaderFieldAccept forHTTPHeaderField:kHTTPHeaderKeyAccept];
    
    [manager GET:kBaseURL parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        ArticleParser *articleParser = [ArticleParser new];
        [articleParser parseDictionaryIntoArticlesArray:(NSDictionary *)responseObject completionHandler:^(NSArray *result) {
            if (completionHandler) {
                completionHandler(result);
            }
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error loading categories");
    }];
}

@end
