//
//  TimCalendarTool.swift
//  TimCharge
//
//  Created by nice on 2018/12/27.
//  Copyright © 2018 Tim. All rights reserved.
//

import UIKit

public class TimCalendarTool: NSObject {
    
    static let share = TimCalendarTool.init()
    
    func day(date: Date) -> NSInteger?{
        let components = NSCalendar.current.dateComponents([.day], from: date)
        
        return components.day
    }
    
    func month(date: Date) -> NSInteger? {
        let components = NSCalendar.current.dateComponents([.month], from: date)
        return components.month
    }
    
    func year(date: Date) -> NSInteger? {
        let components = NSCalendar.current.dateComponents([.year], from: date)
        return components.year
    }
    
    // 当月的天数
    func totalDaysThisMonth(date: Date) -> Int {
        let range = NSCalendar.current.range(of: .day, in: .month, for: date as Date)
        
        return (range?.count)!
    }
    
    // 当月的第一天是星期几
    func firstDayInFirstWeekThisMonth(date: Date) -> Int {
        var calendar = NSCalendar.current
        calendar.firstWeekday = 1
        
        var comp = calendar.dateComponents([.year, .month, .day], from: date as Date)
        comp.day = 1;
        
        let firstDayOfMonthDate = calendar.date(from: comp)
        let firstWeekday = calendar.ordinality(of: .weekday, in: .weekOfMonth, for: firstDayOfMonthDate!)
        return firstWeekday! - 1
    }
    
    func StringMonth(date: Date) -> String {
        var str = ""
        if (NSCalendar.current.component(.month, from: date) < 10) {
            str = "0" + "\(NSCalendar.current.component(.month, from: date as Date))"
        }
        else
        {
            str = "\(NSCalendar.current.component(.month, from: date as Date))"
        }
        
        return str;
    }
    
    func nextMonth(date: Date) -> Date{
        
        let dateComponents = NSDateComponents.init()
        let currentMonth = self.StringMonth(date: date)
        
        if(currentMonth == "12")
        {
            dateComponents.year = +1;
            dateComponents.month = -11;
        }
        else
        {
            dateComponents.month = +1;
        }
        
        return NSCalendar.current.date(byAdding: dateComponents as DateComponents, to: date as Date)!
    }
    
    func lastMonth(date: Date) -> Date{
        let dateComponents = NSDateComponents.init()
        let currentMonth = self.StringMonth(date: date)
        if(currentMonth == "01")
        {
            dateComponents.year = -1;
            dateComponents.month = +11;
        }
        else
        {
            dateComponents.month = -1;
        }
        
        return NSCalendar.current.date(byAdding: dateComponents as DateComponents, to: date as Date)!
    }
    
    func dateByday(day: Int, date: Date) -> Date {
        let calendar = NSCalendar.current
        var comp = calendar.dateComponents([.year, .month, .day], from: date)
        let newComp = NSDateComponents.init()
        newComp.day = day
        newComp.year = comp.year!
        newComp.month = comp.month!
        
        let formatter = DateFormatter.init()
        formatter.dateFormat = "YYYY-MM-dd"
        let string: String = "\(newComp.year)" + "-" + "\(newComp.month)" + "-" + "\(newComp.day)"
        
        return formatter.date(from: string)!
    }
    
    func betweenOfDay(minDate: Date, maxDate: Date, date: Date) -> Bool{
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateMin = dateFormatter.date(from: dateFormatter.string(from: minDate))!
        let dateMax = dateFormatter.date(from: dateFormatter.string(from: maxDate))!
        let date = dateFormatter.date(from: dateFormatter.string(from: date))!
        
        return (dateMin <= date && dateMax >= date)
    }
    
    func betweenOfMonth(minDate: Date, maxDate: Date, date: Date) -> [Bool]{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM"
        
        let dateMin = dateFormatter.date(from: dateFormatter.string(from: minDate))!
        let dateMax = dateFormatter.date(from: dateFormatter.string(from: maxDate))!
        let date = dateFormatter.date(from: dateFormatter.string(from: date))!
        
        return [dateMin <= self.lastMonth(date: date), dateMax >= self.nextMonth(date: date)]
    }
    
}


public class TimCalendarConfig: NSObject{
    
    static let share = TimCalendarConfig.init()
    
    let leftRightMargin: CGFloat = 30
    
    var itemW: CGFloat {
        get{
            return (UIScreen.main.bounds.size.width - 2 * leftRightMargin ) / 7.0
        }
    }
    
    var itemH: CGFloat{
        get{
            return itemW
        }
    }
    
}

