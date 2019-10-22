//
//  ShadowCoelManager.h
//
//  Created by LEI on 4/4/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShadowCoel : NSObject
+ (NSString * _Nonnull)sharedGroupIdentifier;
+ (NSURL * _Nonnull)sharedUrl;
+ (NSURL * _Nonnull)sharedDatabaseUrl;
+ (NSUserDefaults * _Nonnull)sharedUserDefaults;

+ (NSURL * _Nonnull)sharedGeneralConfUrl;
+ (NSURL * _Nonnull)sharedSocksConfUrl;
+ (NSURL * _Nonnull)sharedProxyConfUrl;
+ (NSURL * _Nonnull)sharedHttpProxyConfUrl;
+ (NSURL * _Nonnull)sharedLogUrl;
+ (NSURL * _Nonnull)sharedTokenUrl;
@end
