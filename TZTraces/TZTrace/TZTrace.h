//
//  TZTrace.h
//
//  Created by Tomasz Zablocki on 17/09/12.
//  Copyright (c) 2012 iosmagic.com. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    TZTraceOutputConsole = 1,
    TZTraceOutputFile = 2,
    TZTraceOutputNetwork = 4,
    TZTraceOutputMax
};

enum {
    TZTraceLevelError = 1,
    TZTraceLevelWarning = 2,
    TZTraceLevelNotice = 4,
    TZTraceLevelMessage = 8,
    TZTraceLevelMax
};

@interface TZTrace : NSObject



@property (strong, nonatomic) NSMutableArray *tracesOfTypeError;
@property (strong, nonatomic) NSMutableArray *tracesOfTypeWarning;
@property (strong, nonatomic) NSMutableArray *tracesOfTypeNotice;
@property (strong, nonatomic) NSMutableArray *tracesOfTypeMessage;
@property (strong, nonatomic) NSMutableDictionary *allTraces;

@property (readwrite, atomic) int currentTraceOutput;
@property (readwrite, atomic) int currentTraceLevel;

@property (strong, nonatomic) NSString *tracePath;

+ (TZTrace *)sharedInstance;
- (TZTrace *)init;
- (void)trace:(NSString *)traceText forLevel:(int)level;
- (NSString *)tracePrefixForLevel:(int)level;
- (void)printAllTraces;
- (void)printAllTracesForLevels:(int)levels;

@end

