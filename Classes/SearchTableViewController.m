//
//  SearchTableViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/07.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "SearchTableViewController.h"


@implementation SearchTableViewController

@synthesize searchTextField;
@synthesize searchInterstitial;


- (void)dealloc;
{
	self.searchTextField = nil;
	self.searchInterstitial = nil;
	
	[super dealloc];
}


- (id)initWithStyle:(UITableViewStyle)style 
{
	if (self = [super initWithStyle:style]) {
		self.title = @"Search";
	}
  return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
//	self.view.backgroundColor = [UIColor grayColor];

	// Create the UITextField that's going to mimick our UISearchBar.
	// It'll be completely blank... Because we're going to use an image to pretend
	// that it's the UISearchBar.
	self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0,0, 300, 44)];
	searchTextField.placeholder = @"Search";
	searchTextField.backgroundColor = [UIColor whiteColor];
	searchTextField.font = [UIFont systemFontOfSize:14];
	searchTextField.bounds = CGRectMake(0, 0, 240, 21);
	searchTextField.delegate = self;
	searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	
	searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	searchTextField.keyboardAppearance = UIKeyboardTypeDefault;
	searchTextField.returnKeyType = UIReturnKeySearch;
	searchTextField.enablesReturnKeyAutomatically = YES;






	self.navigationItem.titleView = searchTextField;
	[searchTextField release];
	
	
	// Lazy load...
	self.searchInterstitial = [[UIControl alloc] initWithFrame:CGRectMake(0, 64, 320, 480)];
	searchInterstitial.backgroundColor = [UIColor blackColor];
	searchInterstitial.hidden = YES;
	[searchInterstitial addTarget:self action:@selector(hideSearchKeyboardAndInterstitial) forControlEvents:UIControlEventTouchUpInside];
	[self.navigationController.view addSubview:searchInterstitial];
	[searchInterstitial release];
}







#pragma mark UITextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
	[searchTextField resignFirstResponder];
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
	if ([string length] > 0) { // we're adding
		[self setSearchInterstitialHidden:YES animated:NO];
	} else { // subtracting...
		[self setSearchInterstitialHidden:([textField.text length] == 1 ? NO : YES) animated:NO];
	}

	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
	// Is called everytime the textfield is tapped.
	if ([textField.text length] <= 0) {
		[self setSearchInterstitialHidden:NO animated:YES];
	}
}

- (BOOL)textFieldShouldClear:(UITextField *)textField;
{
	[self setSearchInterstitialHidden:NO animated:NO];
	return YES;
}


- (void)hideSearchKeyboardAndInterstitial;
{
	[self setSearchInterstitialHidden:YES animated:YES];
	[searchTextField resignFirstResponder];
}


- (void)setSearchInterstitialHidden:(BOOL)hidden animated:(BOOL)animated;
{
	if (animated) {
		
		if (hidden) {
		
			[UIView beginAnimations:@"hideInterstitial" context:nil];
			[UIView setAnimationDuration:0.3];
			[UIView setAnimationDelegate:self];
			searchInterstitial.alpha = 0;
			[UIView commitAnimations];

		} else {
		
			searchInterstitial.alpha = 0;
			searchInterstitial.hidden = NO;
			[UIView beginAnimations:@"showInterstitial" context:nil];
			[UIView setAnimationDuration:0.3];
			searchInterstitial.alpha = 0.8;
			[UIView commitAnimations];
			
		}
	} else {
	 searchInterstitial.hidden = hidden;
	}
}




@end

