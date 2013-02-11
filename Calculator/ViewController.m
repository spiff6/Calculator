//
//  ViewController.m
//  Calculator
//
//  Created by Spiff on 2/6/13.
//  Copyright (c) 2013 Tristan. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorBrain.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *history;
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation ViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain {
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}
- (IBAction)backspacePressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        NSUInteger length = self.display.text.length;
        if (length > 0) {
            length = length - 1;
            self.display.text = [self.display.text substringToIndex:length];
        }
        if (length == 0) {
            self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    }
}

- (IBAction)decimalPointEntered {
    NSRange range = [self.display.text rangeOfString:@"."];
    if (range.location == NSNotFound) {
        self.display.text = [self.display.text stringByAppendingString:@"."];
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed {
    NSString *value = self.display.text;
    //NSLog(@"Value: %@", value);
    self.history.text = [self.history.text stringByAppendingFormat:@" %@", value];
    //self.history.text = [self.history.text stringByAppendingString:value];
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = sender.currentTitle;
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.history.text = [self.history.text stringByAppendingFormat:@" %@", operation];
}

- (IBAction)clearPressed:(UIButton *)sender {
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.display.text = @"0";
    if ([sender.currentTitle isEqualToString:@"C"]) {
        self.history.text = @"";
        [self.brain clear];
    }
}

@end
