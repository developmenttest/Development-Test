//
//  TKTextboxToolbarHandeler.h
//  Trukit
//
//  Created by Chintan Dave on 06/05/14.
//  Copyright (c) 2014 zwt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZWTTextboxToolbarHandlerDelegate <NSObject>

@optional
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
- (void)textViewDidBeginEditing:(UITextView *)textView;
- (void)textViewDidEndEditing:(UITextView *)textView;

- (void)textboxHandlerButtonDoneTap:(UIView *)textBox;

@end

@interface ZWTTextboxToolbarHandler : NSObject

@property (nonatomic) NSInteger offset;

@property (nonatomic) BOOL showNextPrevious;

@property (strong, nonatomic) UIBarButtonItem *btnDone;

@property (nonatomic, strong) id<ZWTTextboxToolbarHandlerDelegate> delegate;

- (instancetype)initWithTextboxs:(NSArray *)textBoxs andScroll:(UIScrollView *)scroll NS_DESIGNATED_INITIALIZER;

- (void)btnDoneTap;

@end