//
//  ViewController.m
//  TZTraces
//
//  Created by Tomasz Zablocki on 24/09/2012.
//  Copyright (c) 2012 Tomasz Zablocki. All rights reserved.
//

#import "ViewController.h"
#import "TZTrace.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[TZTrace sharedInstance] trace:@"viewDidLoad trace error" forLevel:TZTraceLevelError];
    [[TZTrace sharedInstance] trace:@"viewDidLoad trace warning" forLevel:TZTraceLevelWarning];
    [[TZTrace sharedInstance] trace:@"viewDidLoad trace notice" forLevel:TZTraceLevelNotice];
    [[TZTrace sharedInstance] trace:@"viewDidLoad trace message" forLevel:TZTraceLevelMessage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
