//
//  NeighboursViewController.m
//  JSONAndXMLDemo
//
//  Created by Gabriel Theodoropoulos on 24/7/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "NeighboursViewController.h"
#import "AppDelegate.h"

@interface NeighboursViewController ()

@end

@implementation NeighboursViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // Make self the delegate and datasource of the table view.
    self.tblNeighbours.delegate = self;
    self.tblNeighbours.dataSource = self;
    
    [self downloadNeighbourCountries];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UITableView method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrNeighbourData.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.textLabel.text =[[self.arrNeighbourData objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text   =[[self.arrNeighbourData objectAtIndex:indexPath.row]objectForKey:@"toponymName"];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

-(void)downloadNeighbourCountries
{
    NSString * stringUrl    =[NSString stringWithFormat:@"http://api.geonames.org/neighbours?geonameId=%@&username=%@", self.geoNameId, kUsername];
    NSURL    * URL          =[NSURL URLWithString:stringUrl];
//    NSError  * error        ;
    [AppDelegate downloadDataFromURL:URL withComplationHandler:^(NSData *data){
        
        NSLog(@"%@",data);
        
        if (data != nil) {
            self.xmlParser  =[[NSXMLParser alloc]initWithData:data];
            self.xmlParser.delegate =self;
            
            self.foundValue = [[NSMutableString alloc]init];
            
            [self.xmlParser parse];
            
        }
        
    }];
}

#pragma XML Parse delegate method
-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    //init the neghbours data array
    self.arrNeighbourData   =[[NSMutableArray alloc]init];
}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    // when the parsing has been finished then simply reload the table view
    [self.tblNeighbours reloadData];
    
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"geoname"]) {
        self.dicTempDataStorage =[[NSMutableDictionary alloc]init];
        
    }
    self.currentElement = elementName;
    
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"%@",[parseError localizedDescription]);
    
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"geoname"]) {
        [self.arrNeighbourData addObject:[[NSDictionary alloc]initWithDictionary:self.dicTempDataStorage]];
        
    }
    else if ([elementName isEqualToString:@"name"])
    {
        [self.dicTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"name"];
        
    }
    else if ([elementName isEqualToString:@"toponymName"])
    {
        [self.dicTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"toponymName"];
        
    }
    
    [self.foundValue setString:@""];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([self.currentElement isEqualToString:@"name"] || [self.currentElement isEqualToString:@"toponymName"])
    {
        if (![string isEqualToString:@"\n"]) {
            [self.foundValue appendString:string];
        }
    }
}







































@end
