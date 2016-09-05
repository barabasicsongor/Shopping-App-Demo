//
//  KeychainManager.m
//  Dollarbird
//
//  Created by Attila Tamas on 3/6/12.
//  Copyright (c) 2012 Dollarbird. All rights reserved.
//

#import "KeychainManager.h"
#import "SFHFKeychainUtils.h"

@interface KeychainManager ()

@property (nonatomic) NSString *defaultUserName;
@property (nonatomic) dispatch_queue_t queue;
@property (nonatomic) NSNumberFormatter *formatter;

@end

@implementation KeychainManager

+ (KeychainManager *)sharedInstance {
    SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        // TODO: Change defaultUsernName and queue name
        self.defaultUserName = @"io.smartup.challenge.user";
        _queue = dispatch_queue_create("io.smartup.challenge.queue.keychainmanager", NULL);
	}
    
    return self;
}

- (void)clearKeychain {
    dispatch_sync(self.queue, ^{
        [self deleteStoredData];
    });
}

#pragma mark - Private methods

- (void)saveItem:(NSString *)item forUsername:(NSString *)username key:(NSString *)key {
    [SFHFKeychainUtils storeItem:item forUsername:username key:key updateExisting:YES error:nil];
}
- (void)saveData:(NSData *)pinData forUsername:(NSString *)username key:(NSString *)key {
    [SFHFKeychainUtils storeData:pinData forUsername:username key:key updateExisting:YES error:nil];
}

- (NSString *)itemForUsername:(NSString *)username key:(NSString *)key {
    return [SFHFKeychainUtils itemForUsername:username key:key error:nil];
}

- (NSData *)dataForUsername:(NSString *)username key:(NSString *)key {
    return [SFHFKeychainUtils dataForUsername:username key:key error:nil];
}

- (void)deleteItemForUsername:(NSString *)username key:(NSString *)key {
    [SFHFKeychainUtils deleteItemForUsername:username key:key error:nil];    
}

- (void)deleteStoredData {
    [SFHFKeychainUtils deleteKeychainData];
}

@end
