//
//  ArticleService.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 22/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "ArticleService.h"
#import "LoadArticlesOperation.h"

@implementation ArticleService

- (void)loadArticlesWithCompletionHandler:(void (^)(NSArray *))completionHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        LoadArticlesOperation *operation = [LoadArticlesOperation new];
        [operation loadArticlesWithCompletionHandler:^(NSArray *result) {
            if (completionHandler) {
                completionHandler(result);
            }
        }];
    });
}

@end
