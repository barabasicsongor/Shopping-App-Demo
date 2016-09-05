//
//  ArticleService.h
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 22/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleService : NSObject

- (void)loadArticlesWithCompletionHandler:(void(^)(NSArray *result))completionHandler;

@end
