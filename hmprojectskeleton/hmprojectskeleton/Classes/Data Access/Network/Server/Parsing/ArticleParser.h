//
//  ArticleParser.h
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 22/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleParser : NSObject

- (void)parseDictionaryIntoArticlesArray:(NSDictionary *)data completionHandler:(void(^)(NSArray *result))completionHandler;

@end
