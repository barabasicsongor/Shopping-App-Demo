//
//  KeychainManager.h
//  Dollarbird
//
//  Created by Attila Tamas on 3/6/12.
//  Copyright (c) 2012 Dollarbird. All rights reserved.
//

@interface KeychainManager : NSObject

+ (KeychainManager *)sharedInstance;

// Clear all keychain data for all username
- (void)clearKeychain;

@end
