//
//  AddScheduleViewController.swift
//  QuickveeApp
//
//  Created by Pallavi on 22/04/25.
//

import UIKit
import MaterialComponents

class AddScheduleViewController: UIViewController {
    
    
    @IBOutlet weak var startDateTextfield: MDCOutlinedTextField!
    @IBOutlet weak var endDateTextfield: MDCOutlinedTextField!
    @IBOutlet weak var startTimeTextfield: MDCOutlinedTextField!
    @IBOutlet weak var endTimeTextfield: MDCOutlinedTextField!
    @IBOutlet weak var noEndDateSwitch: UISwitch!
    @IBOutlet weak var fullDaySwitch: UISwitch!
    @IBOutlet weak var donotRepeatSwitch: UISwitch!
    @IBOutlet weak var fullDayStack: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var startTimeHeight: NSLayoutConstraint!
    @IBOutlet weak var endTimeHeight: NSLayoutConstraint!
    
    var arrOfDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    weak var delegate: AddScheduleDelegate?
    
    var endSwitch = "0"
    var fullSwitch = "0"
    var repeatSwitch = "0"
    var week = ""
    
    var schedule: AddSchedule?
    
    var weekDays = ["0", "0", "0", "0", "0", "0", "0"]
    
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setMode()
    }
    
    
    func setUI() {
        
        createCustomTextField(textField: startDateTextfield)
        createCustomTextField(textField: endDateTextfield)
        createCustomTextField(textField: startTimeTextfield)
        createCustomTextField(textField: endTimeTextfield)
        
        startDateTextfield.label.text = "Start Date"
        endDateTextfield.label.text = "End Date"
        startTimeTextfield.label.text = "Start Time"
        endTimeTextfield.label.text = "End Time"
        
        
        startDateTextfield.delegate = self
        endDateTextfield.delegate = self
        startTimeTextfield.delegate = self
        endTimeTextfield.delegate = self
        
        noEndDateSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        fullDaySwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        donotRepeatSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        let startDateImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        startDateImage.image = UIImage(named: "date_picker")
        startDateTextfield.trailingView = startDateImage
        startDateTextfield.trailingViewMode = .always
        
        let endDateImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        endDateImage.image = UIImage(named: "date_picker")
        endDateTextfield.trailingView = endDateImage
        endDateTextfield.trailingViewMode = .always
        
        let startTimeImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        startTimeImage.image = UIImage(named: "time_picker")
        startTimeTextfield.trailingView = startTimeImage
        startTimeTextfield.trailingViewMode = .always
        
        let endTimeImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        endTimeImage.image = UIImage(named: "time_picker")
        endTimeTextfield.trailingView = endTimeImage
        endTimeTextfield.trailingViewMode = .always
        
        
        cancelBtn.layer.cornerRadius = 10
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        
        addBtn.layer.cornerRadius = 10
        
    }
    
    func setMode() {
        
        if schedule == nil {
            
            let date = Date()
            let dateFormat = DateFormatter()
            dateFormat.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormat.dateFormat = "MM/dd/yyyy"
            
            startDateTextfield.text = dateFormat.string(from: date)
            endDateTextfield.text = ""
            startTimeTextfield.text = ""
            endTimeTextfield.text = ""
            
            noEndDateSwitch.isOn = false
            noEndDateSwitch.tintColor = UIColor(hexString: "#E2E2E2")
            noEndDateSwitch.thumbTintColor = .white
            
            fullSwitch = "1"
            fullDaySwitch.isOn = true
            fullDaySwitch.tintColor = UIColor(hexString: "#CCDFFF")
            fullDaySwitch.thumbTintColor = UIColor(hexString: "#0A64F9")
            startTimeTextfield.isHidden = true
            endTimeTextfield.isHidden = true
            startTimeHeight.constant = 0
            endTimeHeight.constant = 0
            
            repeatSwitch = "1"
            donotRepeatSwitch.isOn = true
            collectionView.isHidden = true
            donotRepeatSwitch.tintColor = UIColor(hexString: "#CCDFFF")
            donotRepeatSwitch.thumbTintColor = UIColor(hexString: "#0A64F9")
        }
        else {

            var sdate = ""
            
            if ToastClass.sharedToast.setCouponsDateFormat(dateStr: schedule?.start_date ?? "") == "" {
                
                let date = Date()
                let dateFormat = DateFormatter()
                dateFormat.timeZone = TimeZone(secondsFromGMT: 0)
                dateFormat.dateFormat = "MM/dd/yyyy"
                
                sdate = dateFormat.string(from: date)
            }
            else {
                sdate = ToastClass.sharedToast.setCouponsDateFormat(dateStr: schedule?.start_date ?? "")
            }
            startDateTextfield.text = sdate
            
//            let st = schedule?.start_time ?? ""
//            let et = schedule?.end_time ?? ""
//            
//            if st != "" {
//                let df1 = DateFormatter()
//                df1.dateFormat = "HH:mm:ss"
//                df1.locale = Locale(identifier: "en_GB")
//                
//                if let start = df1.date(from: st) {
//                    
//                    let end = df1.date(from: et)!
//                    
//                    let df2 = DateFormatter()
//                    df2.dateFormat = "hh:mm a"
//                    df2.locale = Locale(identifier: "en_US")
//                    
//                    startTimeTextfield.text = df2.string(from: start)
//                    endTimeTextfield.text = df2.string(from: end)
//                }
//                else {
//                    let df2 = DateFormatter()
//                    df2.dateFormat = "hh:mm a"
//                    df2.locale = Locale(identifier: "en_US")
//                    
//                    let start = df2.date(from: st)!
//                    let end = df2.date(from: et)!
//                    
//                    startTimeTextfield.text = df2.string(from: start)
//                    endTimeTextfield.text = df2.string(from: end)
//                }
//            }
//            else {
//                startTimeTextfield.text = ""
//                endTimeTextfield.text = ""
//            }
            
            if schedule?.no_end_date == "1" || schedule?.no_end_date == "<null>" {
                endSwitch = "1"
                noEndDateSwitch.isOn = true
                noEndDateSwitch.tintColor = UIColor(hexString: "#CCDFFF")
                noEndDateSwitch.thumbTintColor = UIColor(hexString: "#0A64F9")
                customEndDateTextField(textField: endDateTextfield)
                endDateTextfield.isUserInteractionEnabled = false
                endDateTextfield.trailingView?.alpha = 0.1
                endDateTextfield.text = ""
            }
            else {
                endSwitch = "0"
                noEndDateSwitch.isOn = false
                noEndDateSwitch.tintColor = UIColor(hexString: "#E2E2E2")
                noEndDateSwitch.thumbTintColor = .white
                createCustomTextField(textField: endDateTextfield)
                endDateTextfield.isUserInteractionEnabled = true
                endDateTextfield.trailingView?.alpha = 1
                
                var edate = ""
                if ToastClass.sharedToast.setCouponsDateFormat(dateStr: schedule?.end_date ?? "") == "" {
                    edate = schedule?.end_date ?? ""
                }
                else {
                    edate = ToastClass.sharedToast.setCouponsDateFormat(dateStr: schedule?.end_date ?? "")
                }
                endDateTextfield.text = edate
            }
            
            if schedule?.full_day == "1" || schedule?.full_day == "<null>" {
                fullSwitch = "1"
                fullDaySwitch.isOn = true
                fullDaySwitch.tintColor = UIColor(hexString: "#CCDFFF")
                fullDaySwitch.thumbTintColor = UIColor(hexString: "#0A64F9")
                startTimeTextfield.isHidden = true
                endTimeTextfield.isHidden = true
                startTimeHeight.constant = 0
                endTimeHeight.constant = 0
                
                startTimeTextfield.text = ""
                endTimeTextfield.text = ""
            }
            else {
                fullSwitch = "0"
                fullDaySwitch.isOn = false
                noEndDateSwitch.tintColor = UIColor(hexString: "#E2E2E2")
                noEndDateSwitch.thumbTintColor = .white
                startTimeTextfield.isHidden = false
                endTimeTextfield.isHidden = false
                startTimeHeight.constant = 53
                endTimeHeight.constant = 53
                
                let st = schedule?.start_time ?? ""
                let et = schedule?.end_time ?? ""
                
                if st != "" {
                    
                    let df1 = DateFormatter()
                    df1.dateFormat = "HH:mm:ss"
                    df1.locale = Locale(identifier: "en_GB")
                    
                    if let start = df1.date(from: st) {
                        
                        let end = df1.date(from: et)!
                        
                        let df2 = DateFormatter()
                        df2.dateFormat = "hh:mm a"
                        df2.locale = Locale(identifier: "en_US")
                        
                        startTimeTextfield.text = df2.string(from: start)
                        endTimeTextfield.text = df2.string(from: end)
                    }
                    else {
                        let df2 = DateFormatter()
                        df2.dateFormat = "hh:mm a"
                        df2.locale = Locale(identifier: "en_US")
                        
                        if let start = df2.date(from: st) {
                            
                            let end = df2.date(from: et)!
                            
                            startTimeTextfield.text = df2.string(from: start)
                            endTimeTextfield.text = df2.string(from: end)
                        }
                    }
                }
            }
            
            if schedule?.repeat_type == "1" || schedule?.repeat_type == "<null>" {
                repeatSwitch = "1"
                donotRepeatSwitch.isOn = true
                collectionView.isHidden = true
                donotRepeatSwitch.tintColor = UIColor(hexString: "#CCDFFF")
                donotRepeatSwitch.thumbTintColor = UIColor(hexString: "#0A64F9")
            }
            else {
                repeatSwitch = "0"
                donotRepeatSwitch.isOn = false
                collectionView.isHidden = false
                donotRepeatSwitch.tintColor = UIColor(hexString: "#E2E2E2")
                donotRepeatSwitch.thumbTintColor = .white
                
                let weekly_days = schedule?.weekly_days ?? ""
                
                var small_week = [String]()
                
                for day in arrOfDays {
                    if weekly_days.contains(day) {
                        small_week.append("1")
                    }
                    else {
                        small_week.append("0")
                    }
                }
                weekDays = small_week
                collectionView.isHidden = false
                collectionView.reloadData()
            }
        }
    }
    
    func noEndOn() {
        
        endSwitch = "1"
        noEndDateSwitch.isOn = true
        noEndDateSwitch.tintColor = UIColor(hexString: "#CCDFFF")
        noEndDateSwitch.thumbTintColor = UIColor(hexString: "#0A64F9")
        customEndDateTextField(textField: endDateTextfield)
        endDateTextfield.isUserInteractionEnabled = false
        endDateTextfield.trailingView?.alpha = 0.1
        endDateTextfield.text = ""
    }
    
    func noEndOff() {
        
        endSwitch = "0"
        noEndDateSwitch.isOn = false
        noEndDateSwitch.tintColor = UIColor(hexString: "#E2E2E2")
        noEndDateSwitch.thumbTintColor = .white
        createCustomTextField(textField: endDateTextfield)
        endDateTextfield.isUserInteractionEnabled = true
        endDateTextfield.trailingView?.alpha = 1
    }
    
    func fullDayOn() {
        
        fullSwitch = "1"
        fullDaySwitch.isOn = true
        startTimeTextfield.text = ""
        endTimeTextfield.text =  ""
        fullDaySwitch.tintColor = UIColor(hexString: "#CCDFFF")
        fullDaySwitch.thumbTintColor = UIColor(hexString: "#0A64F9")
        startTimeTextfield.isHidden = true
        endTimeTextfield.isHidden = true
        startTimeHeight.constant = 0
        endTimeHeight.constant = 0
    }
    
    func fullDayOff() {
        
        fullSwitch = "0"
        fullDaySwitch.isOn = false
        fullDaySwitch.tintColor = UIColor(hexString: "#E2E2E2")
        fullDaySwitch.thumbTintColor = .white
        startTimeTextfield.isHidden = false
        endTimeTextfield.isHidden = false
        startTimeHeight.constant = 53
        endTimeHeight.constant = 53
    }
    
    func repeatOn() {
        
        donotRepeatSwitch.isOn = true
        repeatSwitch = "1"
        donotRepeatSwitch.tintColor = UIColor(hexString: "#CCDFFF")
        donotRepeatSwitch.thumbTintColor = UIColor(hexString: "#0A64F9")
        weekDays = ["0", "0", "0", "0", "0", "0", "0"]
        collectionView.isHidden = true
        collectionView.reloadData()
    }
    
    func repeatOff() {
        
        donotRepeatSwitch.isOn = false
        repeatSwitch = "0"
        
        donotRepeatSwitch.tintColor = UIColor(hexString: "#E2E2E2")
        donotRepeatSwitch.thumbTintColor = .white
        
        let weekly_days = schedule?.weekly_days ?? ""
        
        var small_week = [String]()
        
        for day in arrOfDays {
            if weekly_days.contains(day) {
                small_week.append("1")
            }
            else {
                small_week.append("0")
            }
        }
        weekDays = small_week
        collectionView.isHidden = false
        collectionView.reloadData()
    }
    
    func getWeekdaysBetween(startDate: Date, endDate: Date) -> [String]? {
        
        let calendar = Calendar.current

        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        if let daysBetween = components.day, daysBetween < 7 {
            
            var weekdays: [String] = []

            var currentDate = startDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE"
            
            for _ in 0...daysBetween {
                let weekdayName = dateFormatter.string(from: currentDate)
                weekdays.append(weekdayName)
                if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                    currentDate = nextDate
                }
            }
            return weekdays
        } else {
            return nil
        }
    }
    
    
    @IBAction func backbtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        var destiny = 0
        
        let viewcontrollerArray = navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    @IBAction func noEndDateSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            noEndOn()
        }
        else {
            noEndOff()
        }
    }
    
    
    @IBAction func fullDaySwitchClick(_ sender: UISwitch) {
        
        if sender.isOn {
            fullDayOn()
        }
        else {
            fullDayOff()
        }
    }
    
    @IBAction func doNotRepeat(_ sender: UISwitch) {
        
        if sender.isOn {
            repeatOn()
        }
        else {
            repeatOff()
        }
    }
    
    
    
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        guard let start = startDateTextfield, start.text != "" else {
            ToastClass.sharedToast.showToast(message: "Enter a valid start date", font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
            return
        }
        
        let sDate = startDateTextfield.text ?? ""
        var eDate = ""
        
        if endSwitch == "1" {
            eDate = ""
        }
        else {
            guard let end = endDateTextfield, end.text != "", checkEndDate(start: startDateTextfield.text!, end: endDateTextfield.text!) else {
                ToastClass.sharedToast.showToast(message: "Enter a valid end date", font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
                return
            }
            eDate = end.text ?? ""
        }
        
        var sTime = ""
        var eTime = ""
        
        if fullSwitch == "1" {
            sTime = ""
            eTime = ""
        }
        else {
            guard let stime = startTimeTextfield, stime.text != "" else {
                ToastClass.sharedToast.showToast(message: "Enter a valid start time", font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
                return
            }
            
            guard let etime = endTimeTextfield, etime.text != "" else {
                ToastClass.sharedToast.showToast(message: "Enter a valid end time", font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
                return
            }
            
            if startDateTextfield.text == endDateTextfield.text {
                guard checkEndTime(start: startTimeTextfield.text!, end: endTimeTextfield.text!) else {
                    ToastClass.sharedToast.showToast(message: "Enter a valid end time", font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
                    return
                }
            }
            
            sTime = stime.text ?? ""
            eTime = etime.text ?? ""
        }
        
        var days = ""
        var dayData = [String]()
        
        if repeatSwitch == "1" {
            days = ""
        }
        else {
            
            if endSwitch == "0" {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                
                let startDate = dateFormatter.date(from: sDate)!
                let endDate = dateFormatter.date(from: eDate)!
                
                for i in 0..<weekDays.count {
                    
                    if weekDays[i] == "1" {
                        dayData.append(arrOfDays[i])
                    }
                }
                
                guard dayData.count > 0 else {
                    ToastClass.sharedToast.showToast(message: "Select atleast one day", font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
                    return
                }
                
                if let weekdays = getWeekdaysBetween(startDate: startDate, endDate: endDate) {
                    
                    guard dayData.allSatisfy({ weekdays.contains($0)}) else {
                        ToastClass.sharedToast.showToast(message: "Your settings dont match", font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
                        return
                    }
                }
                days = dayData.joined(separator: ", ")
            }
            
            else {
                for i in 0..<weekDays.count {
                    
                    if weekDays[i] == "1" {
                        dayData.append(arrOfDays[i])
                    }
                }
                
                guard dayData.count > 0 else {
                    ToastClass.sharedToast.showToast(message: "Select atleast one day", font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
                    return
                }
                days = dayData.joined(separator: ", ")
            }
        }
        
        
        let schedule = AddSchedule(start_date: sDate, end_date: eDate, no_end_date: endSwitch,
                                   full_day: fullSwitch, start_time: sTime,
                                   end_time: eTime, repeat_type: repeatSwitch,
                                   weekly_days: days, monthly_days: "")
        
        print(schedule)
        
        
        delegate?.setScheduleData(data: schedule)
        navigationController?.popViewController(animated: true)
    }
    
    func daysBetweenDates(startDate: String, endDate: String) -> Int? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let start = dateFormatter.date(from: startDate),
              let end = dateFormatter.date(from: endDate) else {
            return nil
        }

        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: start, to: end)
        
        return components.day
    }
    
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        
        textField.font = UIFont(name: "Manrope-Bold", size: 12.0)
        textField.setOutlineColor(.lightGray, for: .normal)
        textField.setOutlineColor(.lightGray, for: .editing)
        textField.setNormalLabelColor(.lightGray, for: .normal)
        textField.setNormalLabelColor(.lightGray, for: .editing)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .editing)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .normal)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .editing)
    }
    
    
    func customEndDateTextField(textField: MDCOutlinedTextField) {
        
        textField.font = UIFont(name: "Manrope-Bold", size: 12.0)
        textField.setOutlineColor(UIColor(hexString: "#EBEBEB"), for : .normal)
        textField.setOutlineColor(UIColor(hexString: "#EBEBEB"), for : .editing)
        textField.setNormalLabelColor(UIColor(hexString: "#EBEBEB"), for : .normal)
        textField.setNormalLabelColor(UIColor(hexString: "#EBEBEB"), for : .editing)
        textField.setOutlineColor(UIColor(hexString: "#EBEBEB"), for : .normal)
        textField.setOutlineColor(UIColor(hexString: "#EBEBEB"), for : .editing)
        textField.setFloatingLabelColor(UIColor(hexString: "#EBEBEB"), for : .normal)
        textField.setFloatingLabelColor(UIColor(hexString: "#EBEBEB"), for : .editing)
    }
    
}

extension AddScheduleViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        openDatePicker(textField: activeTextField)
    }
}

extension AddScheduleViewController {
    
    func openDatePicker(textField: UITextField) {
        
        let datePicker = UIDatePicker()
        var doneBtn = UIBarButtonItem()
        
        if activeTextField == startDateTextfield || activeTextField == endDateTextfield {
            datePicker.datePickerMode = .date
            doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dateDoneBtn))
        }
        else if activeTextField == startTimeTextfield || activeTextField == endTimeTextfield {
            datePicker.datePickerMode = .time
            datePicker.locale = Locale(identifier: "en_US")
            doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(timeDoneBtn))
        }
        
        datePicker.addTarget(self, action: #selector(datePickerHandler(datePicker:)), for: .valueChanged)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        textField.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([cancelBtn, doneBtn, flexibleBtn], animated: false)
        textField.inputAccessoryView = toolbar
    }
    
    @objc func dateDoneBtn() {
        
        if let datePicker = activeTextField.inputView as? UIDatePicker{
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MM/dd/yyyy"
            
            datePicker.minimumDate = Date()
            let starttime = dateFormat.string(from: datePicker.date)
            activeTextField.text = starttime
            activeTextField.resignFirstResponder()
        }
    }
    
    @objc func timeDoneBtn() {
        
        if let datePicker = activeTextField.inputView as? UIDatePicker{
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "hh:mm a"
            dateFormat.locale = Locale(identifier: "en_US")
            
            let starttime = dateFormat.string(from: datePicker.date)
            activeTextField.text = starttime
            activeTextField.resignFirstResponder()
        }
    }
    
    func checkEndDate(start: String, end: String) -> Bool {
        
        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormat.dateFormat = "MM/dd/yyyy"
        let sdate = dateFormat.date(from: start)!
        let edate = dateFormat.date(from: end)!
                
        if edate >= sdate {
            return true
        }
        else {
            return false
        }
    }
    
    
    func checkEndTime(start: String, end: String) -> Bool {
        
        let cal = Calendar.current
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "hh:mm a"
        dateFormat.locale = Locale(identifier: "en_US")
        
        let startTime = dateFormat.date(from: start)!
        let endTime = dateFormat.date(from: end)!
        
        let shour = cal.component(.hour, from: startTime)
        let smin = cal.component(.minute, from: startTime)
        
        let ehour = cal.component(.hour, from: endTime)
        let emin = cal.component(.minute, from: endTime)
        
        if shour < ehour {
            return true
        }
        else if shour == ehour {
            if smin < emin {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    

    @objc func cancelClick(textfield: UITextField) {
        activeTextField.resignFirstResponder()
    }
    
    @objc func datePickerHandler(datePicker: UIDatePicker) {
        print(datePicker.date)
    }
}

extension AddScheduleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOfDays.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "daycell", for: indexPath) as! DayCollectionViewCell
        
        if weekDays[indexPath.row] == "1" {
            cell.checkImage.image = UIImage(named: "check inventory")
        }
        else {
            cell.checkImage.image = UIImage(named: "uncheck inventory")
        }
        
        cell.dayLbl.text = arrOfDays[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let cell = collectionView.cellForItem(at: indexPath) as! DayCollectionViewCell
        
        if cell.checkImage.image == UIImage(named: "uncheck inventory") {
            cell.checkImage.image = UIImage(named: "check inventory")
            weekDays[indexPath.row] = "1"
        }
        else {
            cell.checkImage.image = UIImage(named: "uncheck inventory")
            weekDays[indexPath.row] = "0"
        }
    }
}

extension AddScheduleViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.size.width
        return CGSize(width: width/5, height: 44)
    }
}

struct AddSchedule {
    
    var start_date: String
    var end_date: String
    var no_end_date: String
    var full_day: String //1 or 0
    var start_time: String //hh:mm
    var end_time: String //hh:mm
    var repeat_type: String //0 none, 1 weekly, 2 monthly
    var weekly_days: String //"Monday"
    var monthly_days: String // 1,15
}
