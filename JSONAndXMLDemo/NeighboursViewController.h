//
//  NeighboursViewController.h
//  JSONAndXMLDemo
//
//  Created by Gabriel Theodoropoulos on 24/7/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NeighboursViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tblNeighbours;

@property (nonatomic, strong) NSString * geoNameId;

-(void)downloadNeighbourCountries;

//used to parse the xml data;
@property (nonatomic, strong) NSXMLParser * xmlParser;
//contain all of desired data after the parsing has finished
@property (nonatomic, strong) NSMutableArray * arrNeighbourData;
//temporarily store the two value we seek for each neighbour country until we add to array

@property (nonatomic, strong) NSMutableDictionary * dicTempDataStorage;
//store the found char of element of interest

@property (nonatomic, strong) NSMutableString * foundValue;
//assign with the name of element that is parsed at any moment

@property (nonatomic, strong) NSString  *currentElement;

@end
