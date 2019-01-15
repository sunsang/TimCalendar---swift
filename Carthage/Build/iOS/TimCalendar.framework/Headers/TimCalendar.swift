//
//  TimCalendar.swift
//  TimCharge
//
//  Created by nice on 2018/12/27.
//  Copyright © 2018 Tim. All rights reserved.
//

import UIKit

public class TimCalendar: UIView , UICollectionViewDataSource, UICollectionViewDelegate{
    // 回调
    public var selectDate: ((_ date: Date) -> Void)?
    public var maxDate: Date {
        get {
            return maxDateValue
        }
        
        set {
            maxDateValue = newValue
            self.reloadMonthBtn()
        }
    }
    public var minDate: Date {
        get {
            return minDateValue
        }
        
        set {
            minDateValue = newValue
            self.reloadMonthBtn()
        }
    }
    
    public var currentDate: Date{
        get{
            return currentDateValue
        }
        set{
            currentDateValue = newValue
            self.currentDateLabel.text = String(TimCalendarTool.share.year(date: currentDateValue)!) + "-" + String(TimCalendarTool.share.month(date: currentDateValue)!)
            self.reloadMonthBtn()
        }
    }
    
    var currentSelectedDate: Date = Date.init()
    
    private lazy var headerView: UIView = self.initHeaderView()
    private lazy var titleView: UIView = self.initTitleView()
    private lazy var collectionView: UICollectionView = self.initCollectionView()
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = self.initFlowLayout()
    
    private var currentDateLabel: UILabel!
    private var leftMonthBtn: UIButton!
    private var rightMonthBtn: UIButton!
    private var currentDateValue: Date = Date.init()
    private var minDateValue: Date = Date.distantPast
    private var maxDateValue: Date = Date.distantFuture
    private var currentSelectedCell: TimCalendarCell?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* private */
    
    private func setUpUI() {

        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        
        self.addSubview(self.headerView)
        self.headerView.mas_makeConstraints { (make) in
            make?.top.equalTo()(self)?.offset()(10)
            make?.left.equalTo()(self)?.offset()(TimCalendarConfig.share.leftRightMargin)
            make?.centerX.equalTo()(self)
            make?.height.equalTo()(40)
        }
        
        self.addSubview(self.titleView)
        self.titleView.mas_makeConstraints { (make) in
            make?.left.right()?.equalTo()(self.headerView)
            make?.top.equalTo()(self.headerView.mas_bottom)?.offset()(10)
            make?.height.equalTo()(40)
        }
        
        self.collectionViewLayout.itemSize = CGSize.init(width: TimCalendarConfig.share.itemW, height: TimCalendarConfig.share.itemH)
        
        self.addSubview(self.collectionView)
        self.collectionView.mas_makeConstraints { (make) in
            make?.left.right()?.equalTo()(self.headerView)
            make?.top.equalTo()(self.titleView.mas_bottom)?.offset()(10)
            make?.bottom.equalTo()(self)?.offset()(-20)
            make?.height.equalTo()(TimCalendarConfig.share.itemH * 6)
        }
        
    }
    
    
    /* public */
    
    public func show(){
        
        
    }
    
    /* delegate & datasource */
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = TimCalendarTool.share.totalDaysThisMonth(date: self.currentDate) + TimCalendarTool.share.firstDayInFirstWeekThisMonth(date: self.currentDate)
        return items
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: TimCalendarCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TimCalendarCell
        
        if indexPath.row >= TimCalendarTool.share.firstDayInFirstWeekThisMonth(date: self.currentDate){
            cell.dateLabel.text = String(indexPath.row - TimCalendarTool.share.firstDayInFirstWeekThisMonth(date: self.currentDate) + 1)
            
            let date = TimCalendarTool.share.dateByday(day: indexPath.row - TimCalendarTool.share.firstDayInFirstWeekThisMonth(date: self.currentDate) + 1, date: self.currentDate)
            
            if TimCalendarTool.share.betweenOfDay(minDate: minDate, maxDate: maxDate, date: date){
                cell.dateLabel.textColor = .black
            } else{
                cell.dateLabel.textColor = .gray
            }
            
            if self.isToday(date: date){
                self.currentSelectedCell = cell
                cell.contentView.backgroundColor = .gray
            } else{
                cell.contentView.backgroundColor = .white
            }
            
        } else{
            cell.dateLabel.text = ""
        }
        
        return cell
    }
    
    // 6214 8501 1571 5929
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let date = TimCalendarTool.share.dateByday(day: indexPath.row - TimCalendarTool.share.firstDayInFirstWeekThisMonth(date: self.currentDate) + 1, date: self.currentDate)
        
        if !TimCalendarTool.share.betweenOfDay(minDate: minDate, maxDate: maxDate, date: date){
            return
        }
        
        self.currentSelectedCell?.contentView.backgroundColor = .white
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = .gray
        self.currentSelectedCell = cell as? TimCalendarCell
        self.currentSelectedDate = date
        
        if (self.selectDate != nil) {
            self.selectDate!(date)
        }
    }
    
    
    @objc private func lastMonth() {
        self.currentDate = TimCalendarTool.share.lastMonth(date: self.currentDate)
        self.collectionView.reloadData()
    }
    
    
    @objc private func nextMonth() {
        self.currentDate = TimCalendarTool.share.nextMonth(date: self.currentDate)
        self.collectionView.reloadData()
    }
    
    private func reloadMonthBtn() {
        let result = TimCalendarTool.share.betweenOfMonth(minDate: self.minDate, maxDate: self.maxDate, date: self.currentDate)
        self.leftMonthBtn.isEnabled = result[0]
        self.rightMonthBtn.isEnabled = result[1]
    }
    
    private func isToday(date: Date) -> Bool {
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let todayDate = dateFormatter.date(from: dateFormatter.string(from: self.currentSelectedDate))!
        let date = dateFormatter.date(from: dateFormatter.string(from: date))!
        
        return todayDate == date
    }
    
    
    /* Lazy */
    
    func initHeaderView() -> UIView {
        let view = UIView.init()
        let leftBtn = UIButton.init()
        view.addSubview(leftBtn)
        leftBtn.mas_makeConstraints { (make) in
            make?.left.top()?.bottom().equalTo()(view)
            make?.width.equalTo()(50)
        }
        leftBtn.setTitle("<", for: .normal)
        leftBtn.setTitleColor(.black, for: .normal)
        leftBtn.addTarget(self, action: #selector(lastMonth), for: .touchUpInside)
        leftBtn.setTitleColor(.gray, for: .disabled)
        self.leftMonthBtn = leftBtn
        
        let dateLabel = UILabel.init()
        view.addSubview(dateLabel)
        dateLabel.mas_makeConstraints { (make) in
            make?.centerX.centerY()?.equalTo()(view)
        }
        dateLabel.text = String(TimCalendarTool.share.year(date: self.currentDate)!) + "-" + String(TimCalendarTool.share.month(date: self.currentDate)!)
        self.currentDateLabel = dateLabel
        
        let rightBtn = UIButton.init()
        view.addSubview(rightBtn)
        rightBtn.mas_makeConstraints { (make) in
            make?.right.top()?.bottom().equalTo()(view)
            make?.width.equalTo()(50)
        }
        rightBtn.setTitle(">", for: .normal)
        rightBtn.setTitleColor(.black, for: .normal)
        rightBtn.setTitleColor(.gray, for: .disabled)
        rightBtn.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        self.rightMonthBtn = rightBtn
        
        return view
    }
    
    func initTitleView() -> UIView {
        let view = UIView.init()
        
        let weeks = ["一","二","三","四","五","六","日"]
        
        var last : MASViewAttribute = view.mas_left
        var lastLab : UILabel?
        
        for (index, weekStr) in weeks.enumerated() {
            
            let weekLab = UILabel.init()
            weekLab.text = weekStr
            weekLab.textColor = .black
            weekLab.textAlignment = .center
            weekLab.font = UIFont.systemFont(ofSize: 14)
            view.addSubview(weekLab)
            weekLab.mas_makeConstraints { (make) in
                make?.top.bottom()?.equalTo()(view)
                make?.left.equalTo()(last)
                if lastLab != nil{
                    make?.width.equalTo()(lastLab)
                }
                if index == 6{
                    make?.right.equalTo()(view)
                }
            }
            last = weekLab.mas_right
            lastLab = weekLab
        }
        return view
    }
    
    func initCollectionView() -> UICollectionView {
        
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: self.collectionViewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(TimCalendarCell.self, forCellWithReuseIdentifier:"cell")
        
        return collectionView
    }
    
    func initFlowLayout() -> UICollectionViewFlowLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }
}
