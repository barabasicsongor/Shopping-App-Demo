//
//  ArticleDetailViewController.h
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 23/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "BaseViewController.h"

@class Article;

@interface ArticleDetailViewController : BaseViewController

- (instancetype)initWithArticle:(Article *)article;

@end
