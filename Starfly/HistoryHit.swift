//
//  HistoryHit.swift
//  StarflyV2
//
//  Created by Neal Caffrey on 4/13/15.
//  Copyright (c) 2015 Neal Caffrey. All rights reserved.
//

import Foundation
import CoreData
@objc(HistoryHit)
class HistoryHit: NSManagedObject {
    var primitiveSectionIdentifier: String?
    var primitiveSectionId : String?
    @NSManaged var titleOfIt: String
    @NSManaged var arrangeIndex: NSNumber
    @NSManaged var faviconPath: String
    @NSManaged var urlOfIt: String
    @NSManaged var date: NSDate
    @NSManaged var time: String
    @NSManaged var visitsCount : Int16
    var sectionId: String{
        get {
            return self.time
        }
        set {
            
            self.willChangeValueForKey("sectionID")
            self.time = newValue
            self.didChangeValueForKey("sectionID")
            self.primitiveSectionIdentifier = nil
            
        }
    }
    
    
    
    
    

}
/*let dateToday = NSDate()
var dayToday : NSString = self.dataFormater.stringFromDate(dateToday)
var day : NSDate? = self.dataFormater.dateFromString(stringOfDay)
var dayStringd : NSString = self.dataFormater.stringFromDate(day!)
let calendar = NSCalendar.currentCalendar()

var dayAgo : NSDate? = calendar.dateByAddingUnit(.CalendarUnitDay, value: -6, toDate: NSDate(), options: nil)!
println(day)
if (dayAgo?.compare(day!) == NSComparisonResult.OrderedAscending) {
    self.dataFormater.dateFormat = "EEEE"
    var dayString : NSString = self.dataFormater.stringFromDate(day!)
    
    if dayStringd == dayToday {
        view.day?.text = "Today"
    }else{
        view.day?.text = dayString
    }
}else if (dayAgo?.compare(day!) == NSComparisonResult.OrderedSame ||  dayAgo?.compare(day!) == NSComparisonResult.OrderedDescending){
    self.dataFormater.dateFormat = "dd LLLL"
    var dayString : NSString = self.dataFormater.stringFromDate(day!)
    view.day?.text = dayString
}

/*NSCalendar *calendar = [NSCalendar currentCalendar];

NSDateComponents *components = [calendar components:(NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[self timeStamp]];
tmp = [NSString stringWithFormat:@"%d", ([components month] * 1000) + [components day]];
- (NSString *)sectionIdentifier
{
// Create and cache the section identifier on demand.

[self willAccessValueForKey:@"sectionIdentifier"];
NSString *tmp = [self primitiveSectionIdentifier];
[self didAccessValueForKey:@"sectionIdentifier"];

if (!tmp)
{
NSDate *dateToCompare = [self getUTCFormateDate:[self startDate]];
NSLog(@"********Date To Compare****** %@", dateToCompare);

NSCalendar* calendar = [NSCalendar currentCalendar];
NSDate* now = [NSDate date];
NSDateFormatter *format = [[NSDateFormatter alloc] init];
format.dateFormat = @"dd-MM-yyyy";
NSString *stringDate = [format stringFromDate:now];
NSDate *todaysDate = [format dateFromString:stringDate];

NSInteger differenceInDays =
[calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:dateToCompare] -
[calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:todaysDate];

NSString *sectionString;

if (differenceInDays == 0)
{
sectionString = kSectionIDToday;
}
else if (differenceInDays < 0)
{
sectionString = kSectionIDPast;
}
else if (differenceInDays > 0)
{
sectionString = kSectionIDUpcoming;
}

tmp = sectionString;
[self setPrimitiveSectionIdentifier:tmp];
}

return tmp;
}

-(NSDate *)getUTCFormateDate:(NSDate *)localDate
{
NSDateFormatter *dateFormatter;
if (!dateFormatter)
{
dateFormatter = [[NSDateFormatter alloc] init];
}
NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
[dateFormatter setTimeZone:timeZone];
[dateFormatter setDateFormat:@"yyyy-MM-dd"];
NSString *dateString = [dateFormatter stringFromDate:localDate];
NSDate *dateFromString = [[NSDate alloc] init];
dateFromString = [dateFormatter dateFromString:dateString];
return dateFromString;
}

#pragma mark - Time stamp setter

- (void)setStartDate:(NSDate *)newDate
{
// If the time stamp changes, the section identifier become invalid.
[self willChangeValueForKey:@"startDate"];
[self setPrimitiveStartDate:newDate];
[self didChangeValueForKey:@"startDate"];

[self setPrimitiveSectionIdentifier:nil];
}


#pragma mark - Key path dependencies

+ (NSSet *)keyPathsForValuesAffectingSectionIdentifier
{
// If the value of timeStamp changes, the section identifier may change as well.
return [NSSet setWithObject:@"startDate"];
}
*/*/