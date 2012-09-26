//
//  TZTrace.m
//
//  Created by Tomasz Zablocki on 17/09/12.
//  Copyright (c) 2012 iosmagic.com. All rights reserved.
//

#import "TZTrace.h"

@implementation TZTrace
@synthesize tracesOfTypeNotice;
@synthesize tracesOfTypeWarning;
@synthesize tracesOfTypeError;
@synthesize tracesOfTypeMessage;
@synthesize allTraces;
@synthesize currentTraceOutput;
@synthesize currentTraceLevel;
@synthesize tracePath;

- (TZTrace *)init
{
    // init self
    self = [super init];
    if (self == nil)
    {
        return nil;
    }
    
    // alloc arrays
    tracesOfTypeNotice = [[NSMutableArray alloc] init];
    tracesOfTypeWarning = [[NSMutableArray alloc] init];
    tracesOfTypeError = [[NSMutableArray alloc] init];
    tracesOfTypeMessage = [[NSMutableArray alloc] init];
    
    // connect arrays with enums
    allTraces = [NSMutableDictionary dictionaryWithCapacity:TZTraceLevelMax];
    [allTraces setObject:tracesOfTypeError forKey:[NSNumber numberWithInt:TZTraceLevelError]];
    [allTraces setObject:tracesOfTypeWarning forKey:[NSNumber numberWithInt:TZTraceLevelWarning]];
    [allTraces setObject:tracesOfTypeNotice forKey:[NSNumber numberWithInt:TZTraceLevelNotice]];
    [allTraces setObject:tracesOfTypeMessage forKey:[NSNumber numberWithInt:TZTraceLevelMessage]];
    
    // set default tracing level & output
    currentTraceLevel = TZTraceLevelError|TZTraceLevelMessage|TZTraceLevelNotice;
    currentTraceOutput = TZTraceOutputConsole|TZTraceOutputFile;
    
    // create path for writeing traces in case file is needed
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    tracePath = [[NSString alloc] initWithFormat:@"%@",[documentsDir stringByAppendingPathComponent:@"traces.txt"]];
    
    // create trace file
    [[NSFileManager defaultManager] createFileAtPath:tracePath contents:nil attributes:nil];
    return self;
}

+ (TZTrace *)sharedInstance
{
#ifndef TZTracesDisabled
    static TZTrace *traces=nil;
    if (traces == nil)
    {
        traces = [[TZTrace alloc] init];
        if (traces == nil)
        {
            return nil;
        }
    }
    return traces;
#else
    return nil;
#endif
}

- (void)trace:(NSString *)traceText forLevel:(int)level
{
    // 1. Make thread safe
    @synchronized(self)
    {
        // 2. Save trace
        [[allTraces objectForKey:[NSNumber numberWithInt:level]] addObject:traceText];
        
        // 2. Check whether we shall log it at all
        if (currentTraceLevel & level)
        {
            // 3. Log to specific output
            if (currentTraceOutput & TZTraceOutputConsole)
            {
                // 4. Log to console
                NSString *prefix = [self tracePrefixForLevel:level];
                NSLog(@"%@%@", prefix, traceText);
            }
            if (currentTraceOutput & TZTraceOutputFile)
            {
                // 5. Append trace to file
                NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:tracePath];
                if (fileHandler != nil)
                {
                    [fileHandler seekToEndOfFile];
                    NSString *prefix = [self tracePrefixForLevel:level];
                    NSString *newTraceText = [NSString stringWithFormat:@"%@%@\n", prefix, traceText];
                    [fileHandler writeData:[newTraceText dataUsingEncoding:NSUTF8StringEncoding]];
                    [fileHandler closeFile];
                }
                else
                {
                    NSLog(@"ERROR: Cannot write to trace.txt file.");
                }
            }
            if (currentTraceOutput & TZTraceOutputNetwork)
            {
                // todo: log to network
            }
        }
    }
}

- (NSString *)tracePrefixForLevel:(int)level
{
    switch(level)
    {
        case TZTraceLevelError:
            return @"ERROR: ";
        case TZTraceLevelWarning:
            return @"WARNING: ";
        case TZTraceLevelNotice:
            return @"NOTICE: ";
        case TZTraceLevelMessage:
            return @"MESSAGE: ";
        default:
            return @"ERROR: ";
    }
}

- (void)printAllTraces
{
    @synchronized(self)
    {
        NSLog(@"%@", @"All traces:");
        for (int idx = 1; idx < TZTraceLevelMax; idx *= 2)
        {
            NSString *prefix = [self tracePrefixForLevel:idx];
            for (NSString* trace in [allTraces objectForKey:[NSNumber numberWithInt:idx]])
            {
                NSLog(@"%@%@", prefix, trace);
            }
        }
    }
}

- (void)printAllTracesForLevels:(int)levels
{
    @synchronized(self)
    {
        NSLog(@"%@", @"All traces:");
        for (int idx = 1; idx < TZTraceLevelMax; idx *= 2)
        {
            if (idx & levels)
            {
                NSString *prefix = [self tracePrefixForLevel:idx];
                for (NSString* trace in [allTraces objectForKey:[NSNumber numberWithInt:idx]])
                {
                    NSLog(@"%@%@", prefix, trace);
                }
            }
        }
    }
}

@end
