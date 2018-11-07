//
//  SearchViewController.m
//  IRTakeHome
//
//  Created by Chase Wang on 11/6/18.
//  Copyright © 2018 ocw. All rights reserved.
//

#import "SearchViewController.h"
#import "BookService.h"
#import "EBook.h"
#import "EBookViewController.h"

@interface SearchViewController ()

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSArray *searchResults;

@end

@implementation SearchViewController

#pragma mark - Properties

- (UISearchController *)searchController {
    if (_searchController == nil) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    }
    
    return _searchController;
}

#pragma mark - VC Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureTableView];
    [self configureSearchController];
}

- (void)configureTableView {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SearchResultCell"];
}

- (void)configureSearchController {
    self.searchController.searchResultsUpdater = self;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"Search for an eBook";
    
    self.navigationItem.searchController = self.searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    
    self.definesPresentationContext = YES;
}

- (void)resetSearchResults {
    self.searchResults = @[];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    EBook *eBook = self.searchResults[indexPath.row];
    
    NSString *bookTitleWithAuthors = [NSString stringWithFormat:@"%@ • %@", eBook.bookTitle, eBook.authors];
    cell.textLabel.text = bookTitleWithAuthors;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    
    if (indexPath.row >= self.searchResults.count) {
        [self resetSearchResults];
        return;
    }
    
    EBook *eBook = [self.searchResults objectAtIndex:indexPath.row];
    EBookViewController *viewController = [[EBookViewController alloc] initWithEBook:eBook];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *query = searchController.searchBar.text;
    
    if (query.length == 0) {
        [self resetSearchResults];
        return;
    }
    
    // in production, add throttling and caching for search results
    
    __weak typeof(self) weakSelf = self;
    [BookService getEBooksForSearchQuery:query
                             withHandler:^(NSArray * _Nullable eBooks, NSError * _Nullable error) {
                                 __strong typeof(self) strongSelf = weakSelf;
                                 
                                 if (error) {
                                     NSLog(@"Error %@", error.localizedDescription);
                                     return;
                                 }
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     strongSelf.searchResults = eBooks;
                                     [strongSelf.tableView reloadData];
                                 });
                             }];
}

@end
