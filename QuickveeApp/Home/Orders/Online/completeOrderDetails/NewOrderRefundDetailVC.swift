//
//  NewOrderRefundDetailVC.swift
//  
//
//  Created by Pallavi on 24/09/24.
//


import Alamofire
import UIKit

class NewOrderRefundDetailVC: UIViewController {
    
    @IBOutlet weak var scrollContent: UIView!
    @IBOutlet weak var scrollContentHeight: NSLayoutConstraint!
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusHeight: NSLayoutConstraint!
    @IBOutlet weak var onlineOrderLbl: UILabel!
    @IBOutlet weak var onlineOrderTableView: UITableView!
    @IBOutlet weak var onlineOrderTableHeight: NSLayoutConstraint!
    @IBOutlet weak var refundProductTableView: UITableView!
    @IBOutlet weak var refundHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var refundProduct: UILabel!
    @IBOutlet weak var refundView: UIView!
    
    @IBOutlet weak var dotedLineView: UIView!
    @IBOutlet weak var belowOrderDetailView: UIView!
    
    //OrderDetail
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var orderIdValue: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var dateValueLbl: UILabel!
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var timeValueLbl: UILabel!
    @IBOutlet weak var orderTypeLbl: UILabel!
    @IBOutlet weak var ordertypeValueLbl: UILabel!
    @IBOutlet weak var totalItemsLbl: UILabel!
    @IBOutlet weak var totalItemsValueLbl: UILabel!
    
    
    // orderSummary
    
    @IBOutlet weak var orderSummaryLbl: UILabel!
    @IBOutlet weak var grossSaleValue: UILabel!
    @IBOutlet weak var belowGrossView: UIView!
    @IBOutlet weak var netSaleValue: UILabel!
    @IBOutlet weak var orderSummaryTableView: UITableView!
    @IBOutlet weak var belowSummaryView: UIView!
    @IBOutlet weak var netDashView: UIView!
    
    // tax
    @IBOutlet weak var taxTableView: UITableView!
    @IBOutlet weak var totalTaxUpperDashView: UIView!
    @IBOutlet weak var totalTaxValueLbl: UILabel!
    @IBOutlet weak var totalTaxBelowDashView: UIView!
    
    //Fees
    @IBOutlet weak var otherFeesView: UIView!
    @IBOutlet weak var otherFeesLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var FeesTableview: UITableView!
    @IBOutlet weak var upperFeesTotalDashView: UIView!
    @IBOutlet weak var belowFeesTotalDashView: UIView!
    @IBOutlet weak var totalFeesValueLbl: UILabel!
    
    //grandTotal
    @IBOutlet weak var grandTotalValueLbl: UILabel!
    
    // Tenders
    
    @IBOutlet weak var tendersTableView: UITableView!
    @IBOutlet weak var tendersTotalValueLbl: UILabel!
    
    //refund
    
    @IBOutlet weak var refundDetailView: UIView!
    @IBOutlet weak var refundLbl: UILabel!
    @IBOutlet weak var belowRefundDashView: UIView!
    @IBOutlet weak var refundBlueview: UIView!
    @IBOutlet weak var totalRefundedView: UIView!
    @IBOutlet weak var totalRefundedLbl: UILabel!
    @IBOutlet weak var refundDetailTable: UITableView!
    @IBOutlet weak var belowRefundDetailDashView: UIView!
    
    
    
    @IBOutlet weak var refundDetailViewHeight: NSLayoutConstraint!
    @IBOutlet weak var totalRefundedlblHeight: NSLayoutConstraint!
    @IBOutlet weak var totalRefundView: UIView!
    @IBOutlet weak var totalRefundHeight: NSLayoutConstraint!
    @IBOutlet weak var totalLbl: UILabel!
    
    @IBOutlet weak var refunFinaldTax: UILabel!
    @IBOutlet weak var refundFinalAmt: UILabel!
    
    @IBOutlet weak var grandTotalAfterRefund: UIView!
    @IBOutlet weak var GtAfterRefundHeight: NSLayoutConstraint!
    
    @IBOutlet weak var grandTotalLbl: UILabel!
    @IBOutlet weak var gtMinusTotalRefundLbl: UILabel!
    @IBOutlet weak var gtAfterRfnValueLbl: UILabel!
    
    @IBOutlet weak var belowRefundTotalDashView: UIView!
    @IBOutlet weak var belowRefundDetailTableDashHeight: NSLayoutConstraint!
    @IBOutlet weak var belowRefundTotalDashHeight: NSLayoutConstraint!
    
    @IBOutlet weak var loyaltyTableView: UITableView!
    @IBOutlet weak var loyaltyView: UIView!
    @IBOutlet weak var loyaltyViewHeight: NSLayoutConstraint!
    @IBOutlet weak var loyaltyLbl: UILabel!
    @IBOutlet weak var loyaltyBlue: UIView!
    @IBOutlet weak var totalLoyaltyValue: UILabel!
    @IBOutlet weak var loyaltyTotalView: UIView!
    @IBOutlet weak var loyaltyTotalLbl: UILabel!
    @IBOutlet weak var totalLoyaltyViewHeight: NSLayoutConstraint!
    @IBOutlet weak var belowLoyaltyDashView: UIView!
    
    // customerDetails
    @IBOutlet weak var belowCustomerView: UIView!
    
    
    @IBOutlet weak var customerId: UILabel!
    @IBOutlet weak var nameValueLbl: UILabel!
    @IBOutlet weak var phoneValueLbl: UILabel!
    @IBOutlet weak var emailValueLbl: UILabel!
    
    
    // table height
    @IBOutlet weak var onlineOrderheightView: NSLayoutConstraint!
    
    @IBOutlet weak var OrderSummaryTableHeifgt: NSLayoutConstraint!
    @IBOutlet weak var refundtableHeight: NSLayoutConstraint!
    @IBOutlet weak var taxTableHeight: NSLayoutConstraint!
    @IBOutlet weak var feesTableHeight: NSLayoutConstraint!
    @IBOutlet weak var tenderTableHeight: NSLayoutConstraint!
    @IBOutlet weak var refundedDetailTableHeight: NSLayoutConstraint!
    @IBOutlet weak var loyaltyTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var futureLBL: UILabel!
    
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var addressValueLbl: UILabel!
    
    
    var order_id: String?
    var live_status = ""
    var order_method = ""
    var grandTotal = ""
    var cash_grand = ""
    var netSale = ""
    var loyaltyAwarded = ""
    var loyaltyRemove = ""
    var taxTotal = ""
    var feesTotal = ""
    var loyalty_add = ""
    
    
    var orderDetail: OrderDetail?
    var couponCode: OrderCouponcode?
    
    var tenderHeight = [String]()
    var arrOfOrderSummary = [Grand]()
    var arrOfFees = [Grand]()
    var arrofTenders = [Grand]()
    var arrOfAuth = [Grand]()
    var arrOfTaxes = [Tax_Order_Summary]()
    var loyalArray = [Loyalty]()
    var arrOfTip = [TipNca]()
    
    var couponCodeArr = [OrderCouponcode]()
    
    var  arrofCartData = [CartdataRef]()
    var  arrofRefCartData = [CartdataRef]()
    
    var arrOfLoyalty = [GrandLoyalty]()
    var arrOfRefunDetails = [RefundDetail]()
    
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadingIndicator.isAnimating = true
        setupApi(order_id: order_id ?? "")
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        dotedLineView.addDashedBorder()
        belowGrossView.addDashedBorder()
        belowSummaryView.addDashedBorder()
        belowOrderDetailView.addDashedBorder()
        netDashView.addDashedBorder()
        totalTaxBelowDashView.addDashedBorder()
        totalTaxUpperDashView.addDashedBorder()
        upperFeesTotalDashView.addDashedBorder()
        belowFeesTotalDashView.addDashedBorder()
        belowRefundDashView.addDashedBorder()
        belowRefundDetailDashView.addDashedBorder()
        belowRefundTotalDashView.addDashedBorder()
        belowLoyaltyDashView.addDashedBorder()
        belowCustomerView.addDashedBorder()
    }
    
    func setTable() {
        
        topview.addBottomShadow()
        
        onlineOrderTableView.delegate = self
        onlineOrderTableView.dataSource = self
        refundProductTableView.delegate = self
        refundProductTableView.dataSource = self
        orderSummaryTableView.delegate = self
        orderSummaryTableView.dataSource = self
        taxTableView.delegate = self
        taxTableView.dataSource = self
        FeesTableview.delegate = self
        FeesTableview.dataSource = self
        tendersTableView.delegate = self
        tendersTableView.dataSource = self
        refundDetailTable.delegate = self
        refundDetailTable.dataSource = self
        loyaltyTableView.delegate = self
        loyaltyTableView.dataSource = self
    }
    
    func createDeliveryStatus() {
        
        let mainWidth = view.bounds.size.width
        let height = ((mainWidth/8) +  10)
        
        let status = UIView(frame: CGRect(x: 0, y: 0, width: mainWidth, height: height))
        
        let width = status.bounds.size.width
        let third = (mainWidth/2) - ((width/8)/2)
        
        
        let btn1 = UIButton(frame: CGRect(x: 20, y: (height - (width/8))/2, width: width/8, height: width/8))
        btn1.backgroundColor = UIColor.init(hexString: "#10C558")
        btn1.clipsToBounds = true
        btn1.setImage(UIImage(named: "Accepted"), for: .normal)
        btn1.layer.cornerRadius = (width/8) * 0.5
        
        let btn2 = UIButton(frame: CGRect(x: (third - (3 * (width/8) * 0.5)), y: (height - (width/8))/2, width: width/8, height: width/8))
        btn2.backgroundColor = UIColor.init(hexString: "#CECECE")
        btn2.clipsToBounds = true
        btn2.setImage(UIImage(named: "UPacking"), for: .normal)
        btn2.layer.cornerRadius = (width/8) * 0.5
        
        let btn3 = UIButton(frame: CGRect(x: ((mainWidth/2) - (width/8)/2), y: (height - (width/8))/2, width: width/8, height: width/8))
        btn3.backgroundColor = UIColor.init(hexString: "#CECECE")
        btn3.clipsToBounds = true
        btn3.setImage(UIImage(named: "UPacked"), for: .normal)
        btn3.layer.cornerRadius = (width/8) * 0.5
        
        let btn4 = UIButton(frame: CGRect(x: ((mainWidth - (3 * width/8))), y: (height - (width/8))/2, width: width/8, height: width/8))
        btn4.backgroundColor = UIColor.init(hexString: "#CECECE")
        btn4.clipsToBounds = true
        btn4.setImage(UIImage(named: "UShipped"), for: .normal)
        btn4.layer.cornerRadius = (width/8) * 0.5
        
        let btn5 = UIButton(frame: CGRect(x: (mainWidth - ((width/8) + 20)), y: (height - (width/8))/2, width: width/8, height: width/8))
        btn5.backgroundColor = UIColor.init(hexString: "#CECECE")
        btn5.clipsToBounds = true
        btn5.setImage(UIImage(named: "UDelivered"), for: .normal)
        btn5.layer.cornerRadius = (width/8) * 0.5
        
        let prog1 = UIProgressView(frame: CGRect(x: btn1.frame.maxX, y: ((width/8) * 0.5), width: (btn2.frame.minX - btn1.frame.maxX), height: 1))
        prog1.backgroundColor = UIColor.init(hexString: "#CECECE")
        prog1.progressTintColor =  UIColor.init(hexString: "#10C558")
        prog1.progressViewStyle = .bar
        prog1.setProgress(0.5, animated: true)
        
        let prog2 = UIProgressView(frame: CGRect(x: btn2.frame.maxX, y: ((width/8) * 0.5), width: (btn3.frame.minX - btn2.frame.maxX), height: 1))
        prog2.backgroundColor = UIColor.init(hexString: "#CECECE")
        prog2.progressViewStyle = .bar
        prog2.setProgress(0.0, animated: true)
        
        let prog3 = UIProgressView(frame: CGRect(x: btn3.frame.maxX, y: ((width/8) * 0.5), width: (btn4.frame.minX - btn3.frame.maxX), height: 1))
        prog3.backgroundColor = UIColor.init(hexString: "#CECECE")
        prog3.progressViewStyle = .bar
        prog3.setProgress(0.0, animated: true)
        
        let prog4 = UIProgressView(frame: CGRect(x: btn4.frame.maxX, y: ((width/8) * 0.5), width: (btn5.frame.minX - btn4.frame.maxX), height: 1))
        prog4.backgroundColor = UIColor.init(hexString: "#CECECE")
        prog4.progressViewStyle = .bar
        prog4.setProgress(0.0, animated: true)
        
        let lbl1 = UILabel(frame: CGRect(x: (btn1.frame.midX - ((width/8) * 0.5)), y: btn1.frame.maxY + 5, width: btn1.frame.size.width, height: 19))
        lbl1.text = "Accepted"
        lbl1.textAlignment = .center
        lbl1.font = UIFont(name: "Manrope-SemiBold", size: 10.0)
        lbl1.textColor = .black
        
        let lbl2 = UILabel(frame: CGRect(x: (third - (3 * (width/8) * 0.5)), y: btn2.frame.maxY + 5, width: btn2.frame.size.width, height: 19))
        lbl2.text = "Packing"
        lbl2.textAlignment = .center
        lbl2.font = UIFont(name: "Manrope-SemiBold", size: 10.0)
        lbl2.textColor = UIColor.init(hexString: "#CECECE")
        
        let lbl3 = UILabel(frame: CGRect(x: ((mainWidth/2) - (width/8)/2), y: btn3.frame.maxY + 5, width: btn3.frame.size.width, height: 19))
        lbl3.text = "Ready"
        lbl3.textAlignment = .center
        lbl3.font = UIFont(name: "Manrope-SemiBold", size: 10.0)
        lbl3.textColor = UIColor.init(hexString: "#CECECE")
        
        let lbl4 = UILabel(frame: CGRect(x: ((mainWidth - (3 * width/8))), y: btn4.frame.maxY + 5, width: btn4.frame.size.width, height: 19))
        lbl4.text = "Shipped"
        lbl4.textAlignment = .center
        lbl4.font = UIFont(name: "Manrope-SemiBold", size: 10.0)
        lbl4.textColor = UIColor.init(hexString: "#CECECE")
        
        let lbl5 = UILabel(frame: CGRect(x: (mainWidth - ((width/8) + 20)), y: btn5.frame.maxY + 5, width: btn5.frame.size.width, height: 19))
        lbl5.text = "Delivered"
        lbl5.textAlignment = .center
        lbl5.font = UIFont(name: "Manrope-SemiBold", size: 10.0)
        lbl5.textColor = UIColor.init(hexString: "#CECECE")
        
        
        status.addSubview(btn1)
        
        status.addSubview(btn2)
        status.addSubview(btn3)
        status.addSubview(btn4)
        status.addSubview(btn5)
        
        status.addSubview(prog1)
        status.addSubview(prog2)
        status.addSubview(prog3)
        status.addSubview(prog4)
        
        status.addSubview(lbl1)
        status.addSubview(lbl2)
        status.addSubview(lbl3)
        status.addSubview(lbl4)
        status.addSubview(lbl5)
        
        statusView.addSubview(status)
        statusHeight.constant = height + 20
        
        setUpDeliveryStatus(btn1: btn1, btn2: btn2, btn3: btn3, btn4: btn4, btn5: btn5,
                            prog1: prog1, prog2: prog2, prog3: prog3, prog4: prog4,
                            lbl1: lbl1, lbl2: lbl2, lbl3: lbl3, lbl4: lbl4, lbl5: lbl5)
        
    }
    
    
    func createPickupStatus() {
        
        let mainWidth = view.bounds.size.width
        let height = ((mainWidth/8) +  10)
        
        let status = UIView(frame: CGRect(x: 0, y: 0, width: mainWidth, height: height))
        
        let width = status.bounds.size.width
        let third = (mainWidth/2) - (1.5 * (width/8))
        let fourth = (mainWidth/2) + (0.5 * (width/8))
        
        
        let btn1 = UIButton(frame: CGRect(x: 30, y: (height - (width/8))/2, width: width/8, height: width/8))
        btn1.backgroundColor = UIColor.init(hexString: "#10C558")
        btn1.setImage(UIImage(named: "Accepted"), for: .normal)
        btn1.clipsToBounds = true
        btn1.layer.cornerRadius = (width/8) * 0.5
        
        
        let btn2 = UIButton(frame: CGRect(x: third, y: (height - (width/8))/2, width: width/8, height: width/8))
        btn2.backgroundColor = UIColor.init(hexString: "#CECECE")
        btn2.setImage(UIImage(named: "UPacking"), for: .normal)
        btn2.clipsToBounds = true
        btn2.layer.cornerRadius = (width/8) * 0.5
        
        let btn3 = UIButton(frame: CGRect(x: fourth, y: (height - (width/8))/2, width: width/8, height: width/8))
        btn3.backgroundColor = UIColor.init(hexString: "#CECECE")
        btn3.setImage(UIImage(named: "UPacked"), for: .normal)
        btn3.clipsToBounds = true
        btn3.layer.cornerRadius = (width/8) * 0.5
        
        let btn4 = UIButton(frame: CGRect(x: (mainWidth - ((width/8) + 30)), y: (height - (width/8))/2, width: width/8, height: width/8))
        btn4.backgroundColor = UIColor.init(hexString: "CECECE")
        btn4.setImage(UIImage(named: "UDelivered"), for: .normal)
        btn4.clipsToBounds = true
        btn4.layer.cornerRadius = (width/8) * 0.5
        
        
        let prog1 = UIProgressView(frame: CGRect(x: btn1.frame.maxX, y: ((width/8) * 0.5), width: (btn2.frame.minX - btn1.frame.maxX), height: 1))
        prog1.backgroundColor = UIColor.init(hexString: "#CECECE")
        prog1.progressTintColor =  UIColor.init(hexString: "#10C558")
        prog1.progressViewStyle = .bar
        prog1.setProgress(0.5, animated: true)
        
        let prog2 = UIProgressView(frame: CGRect(x: btn2.frame.maxX, y: ((width/8) * 0.5), width: (btn3.frame.minX - btn2.frame.maxX), height: 1))
        prog2.backgroundColor = UIColor.init(hexString: "#CECECE")
        prog2.progressViewStyle = .bar
        prog2.setProgress(0.0, animated: true)
        
        let prog3 = UIProgressView(frame: CGRect(x: btn3.frame.maxX, y: ((width/8) * 0.5), width: (btn4.frame.minX - btn3.frame.maxX), height: 1))
        prog3.backgroundColor = UIColor.init(hexString: "#CECECE")
        prog3.progressViewStyle = .bar
        prog3.setProgress(0.0, animated: true)
        
        
        let lbl1 = UILabel(frame: CGRect(x: (btn1.frame.midX - ((width/8) * 0.5)), y: btn1.frame.maxY + 5, width: btn1.frame.size.width, height: 19))
        lbl1.text = "Accepted"
        lbl1.textAlignment = .center
        lbl1.font = UIFont(name: "Manrope-SemiBold", size: 10.0)
        lbl1.textColor = .black
        
        let lbl2 = UILabel(frame: CGRect(x: third, y: btn2.frame.maxY + 5, width: btn2.frame.size.width, height: 19))
        lbl2.text = "Packing"
        lbl2.textAlignment = .center
        lbl2.font = UIFont(name: "Manrope-SemiBold", size: 10.0)
        lbl2.textColor = UIColor.init(hexString: "#CECECE")
        
        let lbl3 = UILabel(frame: CGRect(x: fourth, y: btn3.frame.maxY + 5, width: btn3.frame.size.width, height: 19))
        lbl3.text = "Ready"
        lbl3.textAlignment = .center
        lbl3.font = UIFont(name: "Manrope-SemiBold", size: 10.0)
        lbl3.textColor = UIColor.init(hexString: "#CECECE")
        
        let lbl4 = UILabel(frame: CGRect(x: (mainWidth - ((width/8) + 30)), y: btn4.frame.maxY + 5, width: btn4.frame.size.width, height: 19))
        lbl4.text = "Picked Up"
        lbl4.textAlignment = .center
        lbl4.font = UIFont(name: "Manrope-SemiBold", size: 10.0)
        lbl4.textColor = UIColor.init(hexString: "#CECECE")
        
        status.addSubview(btn1)
        status.addSubview(btn2)
        status.addSubview(btn3)
        status.addSubview(btn4)
        
        status.addSubview(prog1)
        status.addSubview(prog2)
        status.addSubview(prog3)
        
        status.addSubview(lbl1)
        status.addSubview(lbl2)
        status.addSubview(lbl3)
        status.addSubview(lbl4)
        
        statusView.addSubview(status)
        statusHeight.constant = height + 20
        
        
        setUpPickupStatus(btn1: btn1, btn2: btn2, btn3: btn3, btn4: btn4,
                          prog1: prog1, prog2: prog2, prog3: prog3,
                          lbl1: lbl1, lbl2: lbl2, lbl3: lbl3, lbl4: lbl4)
        
        
    }
    
    func setUpDeliveryStatus(btn1: UIButton, btn2: UIButton, btn3: UIButton, btn4: UIButton, btn5: UIButton,
                             prog1: UIProgressView, prog2: UIProgressView, prog3: UIProgressView, prog4: UIProgressView,
                             lbl1: UILabel,  lbl2: UILabel,  lbl3: UILabel,  lbl4: UILabel, lbl5: UILabel) {
        
        
        if live_status == "Refunded" {
            
            btn1.setImage(UIImage(named: "Accepted"), for: .normal)
            btn5.setImage(UIImage(named: "re 1"), for: .normal)
            btn1.backgroundColor = UIColor.init(hexString: "#10C558")
            btn5.backgroundColor = UIColor.init(hexString: "#FE5353")
            lbl5.textColor = UIColor.black
            lbl1.textColor = UIColor.init(hexString: "#CECECE")
            lbl5.text = "Refunded"
            
        }
        else if live_status == "Delivered" {
            btn1.setImage(UIImage(named: "Accepted"), for: .normal)
            btn2.setImage(UIImage(named: "Packing"), for: .normal)
            btn3.setImage(UIImage(named: "Packed"), for: .normal)
            btn4.setImage(UIImage(named: "Shippedonline"), for: .normal)
            btn5.setImage(UIImage(named: "Completed"), for: .normal)
            prog1.setProgress(1.0, animated: true)
            prog1.progressTintColor =  UIColor.init(hexString: "#10C558")
            prog2.setProgress(1.0, animated: true)
            prog2.progressTintColor =  UIColor.init(hexString: "#FFB303")
            prog3.setProgress(1.0, animated: true)
            prog3.progressTintColor =  UIColor.init(hexString: "#C520F5")
            prog4.setProgress(1.0, animated: true)
            prog4.progressTintColor =  UIColor.init(hexString: "##03CBFF")
            lbl5.textColor = UIColor.black
            lbl1.textColor = UIColor.init(hexString: "#CECECE")
            btn1.backgroundColor = UIColor.init(hexString: "#10C558")
            btn2.backgroundColor = UIColor.init(hexString: "#FFB303")
            btn3.backgroundColor = UIColor.init(hexString: "#C520F5")
            btn4.backgroundColor = UIColor.init(hexString: "#03CBFF")
            btn5.backgroundColor = UIColor.init(hexString: "#0A64F9")
            // paymentDetailValue.text = "Paid"
            
            
        }
        else if live_status == "Cancelled" {
            btn1.setImage(UIImage(named: "Accepted"), for: .normal)
            btn5.setImage(UIImage(named: "cancel"), for: .normal)
            btn1.backgroundColor = UIColor.init(hexString: "#10C558")
            btn5.backgroundColor = UIColor.init(hexString: "#F55353")
            lbl5.textColor = UIColor.black
            lbl1.textColor = UIColor.init(hexString: "#CECECE")
            lbl5.text = "Cancelled"
        }
        else {
            
        }
    }
    
    func setUpPickupStatus(btn1: UIButton, btn2: UIButton, btn3: UIButton, btn4: UIButton,
                           prog1: UIProgressView, prog2: UIProgressView, prog3: UIProgressView,
                           lbl1: UILabel,  lbl2: UILabel,  lbl3: UILabel,  lbl4: UILabel) {
        
        
        
        if live_status == "Refunded" {
            
            btn1.setImage(UIImage(named: "Accepted"), for: .normal)
            btn4.setImage(UIImage(named: "re 1"), for: .normal)
            btn1.backgroundColor = UIColor.init(hexString: "#10C558")
            btn4.backgroundColor = UIColor.init(hexString: "#FE5353")
            lbl4.textColor = UIColor.black
            lbl1.textColor = UIColor.init(hexString: "#CECECE")
            lbl4.text = "Refunded"
        }
        else if live_status == "Completed" {
            btn1.setImage(UIImage(named: "Accepted"), for: .normal)
            btn2.setImage(UIImage(named: "Packing"), for: .normal)
            btn3.setImage(UIImage(named: "Packed"), for: .normal)
            btn4.setImage(UIImage(named: "Completed"), for: .normal)
            
            btn1.backgroundColor = UIColor.init(hexString: "#10C558")
            btn2.backgroundColor = UIColor.init(hexString: "#FFB303")
            btn3.backgroundColor = UIColor.init(hexString: "#C520F5")
            btn4.backgroundColor = UIColor.init(hexString: "#0A64F9")
            
            prog1.setProgress(1.0, animated: true)
            prog1.progressTintColor =  UIColor.init(hexString: "#10C558")
            prog2.setProgress(1.0, animated: true)
            prog2.progressTintColor =  UIColor.init(hexString: "#FFB303")
            prog3.setProgress(1.0, animated: true)
            prog3.progressTintColor =  UIColor.init(hexString: "#C520F5")
            btn1.backgroundColor = UIColor.init(hexString: "#10C558")
            lbl1.textColor = UIColor.init(hexString: "#CECECE")
            lbl2.textColor = UIColor.init(hexString: "#CECECE")
            lbl3.textColor = UIColor.init(hexString: "#CECECE")
            lbl4.textColor = UIColor.black
            
        }
        else if live_status == "Cancelled" {
            
            btn1.setImage(UIImage(named: "Accepted"), for: .normal)
            btn4.setImage(UIImage(named: "cancel"), for: .normal)
            btn1.backgroundColor = UIColor.init(hexString: "#10C558")
            btn4.backgroundColor = UIColor.init(hexString: "#F55353")
            lbl4.textColor = UIColor.black
            lbl4.text = "Cancelled"
        }
        else {
            
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:Any] {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return [:]
    }
    
    
    func roundOf(item : String) -> Double {
        
        let refund = item
        let doub = Double(refund) ?? 0.00
        let div = (100 * doub) / 100
       
        return div
        
    }
    
    func calculateNetSale(subtotal: String, LPR: String, discount :String)  -> String {
        
        let sub = roundOf(item: subtotal)
        let lpr = roundOf(item: LPR)
        let dis = roundOf(item: discount)
        
        let net = sub - lpr - dis
        let netSale = String(format:"%.02f", net)
        return String(netSale)
    }
    
    func calculateGrandTotal(netSale: String, taxex: String, otherFees :String)  -> String {
        
        let net = roundOf(item: netSale)
        let t_tax = roundOf(item: taxex)
        let fees = roundOf(item: otherFees)
        
        
        let grand = net + t_tax + fees
        let grandTotal = String(format:"%.02f", grand)
        return String(grandTotal)
        
    }
    
    func grandRefundTotal(grand_total: String, refund_fAmt: String)  -> String {
        
        let gt = roundOf(item: grand_total)
        let refAmt = roundOf(item: refund_fAmt)
        
        
        let grand = gt - refAmt
        let grandRefundTotal = String(format:"%.02f", grand)
        return String(grandRefundTotal)
        
    }
    
    func  calaculateOtherFees(cash_back: String,del_fee: String,confees: String, tip: String ) -> String {
        
        let cash = roundOf(item: cash_back)
        let del = roundOf(item: del_fee)
        let conf = roundOf(item: confees)
        let tip = roundOf(item: tip)
        
        let otherFees = conf + tip + del + cash
        let fees = String(format:"%.02f", otherFees)
        return String(fees)
    }
   
    func calculateTotalPrice(p_price: String, bogoDis :String)  -> String {
        
        let p_rice = roundOf(item: p_price)
        let bogoDis = roundOf(item: bogoDis)
        
        let t_price = p_rice - bogoDis
       
        let final_price = String(format:"%.02f", t_price)
       
        return String(final_price)
    }
    
    func calculatecredit(amt: String , store_credit_amt_spent :String) -> String {
        
        let am = roundOf(item: amt)
        let scas = roundOf(item: store_credit_amt_spent)
        
        let credit_c = am - scas
        
        return String(credit_c)
    }
    
    func calstoreCreditOne(amt: String,store_credit:String) -> String {
        
        let am =  roundOf(item: amt)
        let sc = roundOf(item: store_credit)
        
        
        let store_c_one = am - sc
        let store_credit = String(format: "%.2f", store_c_one)
        return String(store_credit)
    }
    
    func calDisc(coupon_code: String,bogo_discount: String) -> String {
       
        let c_code =  roundOf(item: coupon_code)
        let bogo_disc = roundOf(item: bogo_discount)
        
        let Totaldisc =  c_code + bogo_disc
       
        let  total_discount = String(format: "%.2f", Totaldisc)
        
        return String(total_discount)
    }
    
    func calLoyaltyPointOne(amt: String) -> String {
        let am =  roundOf(item: amt)
        
        let loyalty_p_one = am
        
        let loyalty_point = String(format: "%.2f", loyalty_p_one)
        return String(loyalty_point)
    }
    
    func calStoreLoyltybothOne(amtgrandvalue: String,store_credit:String) -> String {
        let am =  roundOf(item: amtgrandvalue)
        
        let sc = roundOf(item: store_credit)
   
        let store_loyalty_one =  am - sc
        
        let store_loyalty = String(format: "%.2f", store_loyalty_one)
        return String(store_loyalty)
    }
    
    
    func calLoyAwardedAndRemove(additionRefund: String, loy_Awarded: String) -> String {
        let am =  roundOf(item: additionRefund)
        let sc = roundOf(item: loy_Awarded)
       
        
        var awarded = 0.00
        if Double(sc)  < 0.00 {
            awarded =  am + sc
        }
        else {
            awarded =  am - sc
        }
        
        
        
        let store_loyalty = String(format: "%.2f", awarded)
        return String(store_loyalty)
    }
    
    func calTotalTenders(card: [Grand]) -> String {
        
        var doub_amt = Double()
        
        for pay in card {
            let doub = Double(pay.cashValue) ?? 0.00
            doub_amt += doub
        }
        
        let tendes = String(format: "%.2f", doub_amt)
        
        return tendes
    }
    
    func calRefundTotal(card: [String]) -> String {
        
        var doub_amt = Double()
        
        for pay in card {
            let doub = Double(pay) ?? 0.00
            doub_amt += doub
        }
        
      
        let refAmt = String(format: "%.2f", doub_amt)
       
        return refAmt
    }
    
    func calRefundTaxTotal(card: [RefundDetail]) -> String {
        
        var doub_amt = Double()
        
        for pay in card {
            
            let doub = Double(pay.taxrefunded) ?? 0.00
            doub_amt += doub
        }
        
      
        let refTaxAmt = String(format: "%.2f", doub_amt)
      
        return refTaxAmt
    }
    
    func calAddLoylty(card: [Loyalty]) -> String {
        
        var doub_amt = Double()
        for pay in card {
            let doub = Double(pay.loyalty_points) ?? 0.00
            doub_amt += doub
        }
        let add_loyalty = String(format: "%.2f", doub_amt)
      
        return add_loyalty
        
    }
    
    func calTotalLoylty(loyalAwarded: String,loyltyRemove: String) -> String {
        
        let lp_awarded =  roundOf(item: loyalAwarded)
        let lp_Remove = roundOf(item: loyltyRemove)
        
        let add = lp_awarded + lp_Remove
        
        let TotalLoyalty =  lp_awarded - lp_Remove
      
        let  total_loyalty = String(format: "%.2f", TotalLoyalty)
        
        return String(total_loyalty)
    }
    
    
    func handleZero(cashValue : String) -> Bool   {
       
        let amtValue = Double(cashValue) ?? 0.00
      
        if  amtValue > 0.00{
            return true
        }
        else{
            return false
        }
    }
    
    func setupApi(order_id: String) {
        
        let url = AppURLs.ORDER_DETAILS
        
        let parameters : [String: Any] =
        
        ["merchant_id": UserDefaults.standard.string(forKey: "merchant_id")!,
         "order_id": order_id]
       
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    self.getResponseValues(response: json["result"])
                    print(json)
                    self.loadingIndicator.isAnimating = false
                }
                catch {
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getResponseValues(response: Any) {
        
        let responsevalues = response as! [String:Any]
        let orderMerch = responsevalues["order_detail"] as! [String: Any]
        
        let order = OrderDetail(admin_id: "\(orderMerch["admin_id"] ?? "")", adv_id: "\(orderMerch["adv_id"] ?? "")",
                                amt: "\(orderMerch["amt"] ?? "")", billing_add: "\(orderMerch["billing_add"] ?? "")",
                                billing_name: "\(orderMerch["billing_name"] ?? "")", card_type: "\(orderMerch["card_type"] ?? "")",
                                card_num: "\(orderMerch["card_num"] ?? "")",
                                cash_collected: "\(orderMerch["cash_collected"] ?? "")",
                                cash_discounting: "\(orderMerch["cash_discounting"] ?? "")",
                                cash_discounting_percentage: "\(orderMerch["cash_discounting_percentage"] ?? "")",
                                cashdiscount_refund_amount: "\(orderMerch["cashdiscount_refund_amount"] ?? "")", cash_back_fee: "\(orderMerch["cash_back_fee"] ?? "")",
                                con_fee: "\(orderMerch["con_fee"] ?? "")",
                                coupon_code: "\(orderMerch["coupon_code"] ?? "")" ,
                                customer_app_id: "\(orderMerch["customer_app_id"] ?? "")",
                                customer_email: "\(orderMerch["customer_email"] ?? "")",
                                customer_phone: "\(orderMerch["customer_phone"] ?? "")",
                                customer_id: "\(orderMerch["customer_id"] ?? "")",
                                customer_time: "\(orderMerch["customer_time"] ?? "")", cvvResult: "\(orderMerch["cvvResult"] ?? "")",
                                date_time: "\(orderMerch["date_time"] ?? "")",
                                del_fee: "\(orderMerch["del_fee"] ?? "")",
                                deliver_name: "\(orderMerch["deliver_name"] ?? "")",
                                delivery_addr: "\(orderMerch["delivery_addr"] ?? "")",
                                delivery_phn: "\(orderMerch["delivery_phn"] ?? "")", discount: "\(orderMerch["discount"] ?? "")",
                                dob: "\(orderMerch["dob"] ?? "")", driver_assigned: "\(orderMerch["driver_assigned"] ?? "")",
                                email: "\(orderMerch["email"] ?? "")", employee_id: "\(orderMerch["employee_id"] ?? "")",
                                failResult: "\(orderMerch["failResult"] ?? "")", id: "\(orderMerch["id"] ?? "")",
                                is_future: "\(orderMerch["is_future"] ?? "")", is_online: "\(orderMerch["is_online"] ?? "")",
                                is_outdoor: "\(orderMerch["is_outdoor"] ?? "")", is_partial_refund: "\(orderMerch["is_partial_refund"] ?? "")",
                                is_refunded: "\(orderMerch["is_refunded"] ?? "")", is_split_payment: "\(orderMerch["is_split_payment"] ?? "")",
                                is_tried: "\(orderMerch["is_tried"] ?? "")", kitchen_receipt: "\(orderMerch["kitchen_receipt"] ?? "")",
                                live_status: "\(orderMerch["live_status"] ?? "")", m_status: "\(orderMerch["m_status"] ?? "")",
                                mail_status: "\(orderMerch["mail_status"] ?? "")", mailtriggered: "\(orderMerch["mailtriggered"] ?? "")",
                                merchant_id: "\(orderMerch["merchant_id"] ?? "")", merchant_time: "\(orderMerch["merchant_time"] ?? "")",
                                order_id: "\(orderMerch["order_id"] ?? "")", order_method: "\(orderMerch["order_method"] ?? "")",
                                order_number: "\(orderMerch["order_number"] ?? "")", order_status: "\(orderMerch["order_status"] ?? "")",
                                order_time: "\(orderMerch["order_time"] ?? "")",
                                other_taxes: "\(orderMerch["other_taxes"] ?? "")",
                                other_taxes_desc: "\(orderMerch["other_taxes_desc"] ?? "")", other_taxes_rate_desc: "\(orderMerch["other_taxes_rate_desc"] ?? "")",
                                pax_details: "\(orderMerch["pax_details"] ?? "")",
                                payment_id: "\(orderMerch["payment_id"] ?? "")",
                                payment_result: "\(orderMerch["payment_result"] ?? "")",
                                print: "\(orderMerch["print"] ?? "")", refund_amount: "\(orderMerch["refund_amount"] ?? "")",
                                shift_setting: "\(orderMerch["shift_setting"] ?? "")", show_status: "\(orderMerch["show_status"] ?? "")",
                                smstriggerd: "\(orderMerch["smstriggerd"] ?? "")", subtotal: "\(orderMerch["subtotal"] ?? "")",
                                tax: "\(orderMerch["tax"] ?? "")", tax_rate: "\(orderMerch["tax_rate"] ?? "")",
                                tip: "\(orderMerch["tip"] ?? "")", tip_refund_amount: "\(orderMerch["tip_refund_amount"] ?? "")",
                                is_loyality:"\(orderMerch["is_loyality"] ?? "")",
                                is_store_credit: "\(orderMerch["is_store_credit"] ?? "")")
        
        
        
        orderDetail = order
        
        setOrderDetails(order: order)
        
        if responsevalues["merchant_details"] != nil {
            setMerchantDetails(merch: responsevalues["merchant_details"] as! [[String : Any]])
        }
        
        
        
        if  responsevalues["id_card_detail"] != nil {
            setIdentificationDetails(id: responsevalues["id_card_detail"] as! [String : Any] )
        }
        
       
        
        if responsevalues["cart_data"] != nil {
            setCartData(list: responsevalues["cart_data"] as! [[String : Any]])
        }
        
        
        if responsevalues["refund_data"] != nil {
            setRefundData(refund_data:responsevalues["refund_data"] as! [[String: Any]] )
        }
        
        
        if responsevalues["future_order_data"] != nil {
            setFutureData(futuredata: responsevalues["future_order_data"])
        }
        
        live_status = order.live_status
        order_method = order.order_method
        
        
        if order_method == "Pickup" || order_method == "pickup" {
            createPickupStatus()
            
        }else {
            
            createDeliveryStatus()
        }
        
        DispatchQueue.main.async {
       
            self.onlineOrderTableView.reloadData()
            self.refundProductTableView.reloadData()
            self.orderSummaryTableView.reloadData()
            self.FeesTableview.reloadData()
            self.taxTableView.reloadData()
            self.tendersTableView.reloadData()
            self.refundDetailTable.reloadData()
            self.loyaltyTableView.reloadData()
            
            let tenderArrHeight: CGFloat = self.tenderHeight.compactMap { CGFloat(Double($0) ?? 0) }.reduce(0, +)
            
            self.onlineOrderTableHeight.constant = CGFloat(150 * self.arrofCartData.count)
            self.refundtableHeight.constant = CGFloat(150 * self.arrofRefCartData.count)
            self.OrderSummaryTableHeifgt.constant = CGFloat(39 * self.arrOfOrderSummary.count)
            self.feesTableHeight.constant = CGFloat(62 * self.arrOfFees.count)
            self.taxTableHeight.constant = CGFloat(72 * self.arrOfTaxes.count)
            self.tenderTableHeight.constant = CGFloat(tenderArrHeight)
            self.refundedDetailTableHeight.constant = CGFloat(160 * self.arrOfRefunDetails.count)
            self.loyaltyTableHeight.constant = CGFloat(100 * self.loyalArray.count)
            
            let onlineOrderHeight =  self.onlineOrderTableHeight.constant
            let refundorderHeight =  self.refundtableHeight.constant
            let orderSummaryHeight =   self.OrderSummaryTableHeifgt.constant
            let taxheight =   self.taxTableHeight.constant
            let feesHeight = self.feesTableHeight.constant
            let tenderTHeight = self.tenderTableHeight.constant
            let loyaltyHeight = self.loyaltyTableHeight.constant
            let refundedDetailHeight = self.refundedDetailTableHeight.constant
        
            
            let height = onlineOrderHeight + refundorderHeight + orderSummaryHeight + taxheight + feesHeight + tenderTHeight + loyaltyHeight + refundedDetailHeight
            
            self.scrollContentHeight.constant = height + 1800
        }
    }
    
    
    func setOrderDetails(order: OrderDetail) {
        
        let formattedDate = ToastClass.sharedToast.setDateFormat(dateStr: order.date_time)
        
        
        let dateTime = formattedDate
        
        let dateComponents = dateTime.split(separator: " ")
      
        let date = String(dateComponents[0])
        let time = String(dateComponents[1])
        let timeaa = String(dateComponents[2])
    
        
        dateValueLbl.text = date
        timeValueLbl.text = "\(time) \(timeaa)"
        
        orderIdValue.text = order.order_id
        ordertypeValueLbl.text = order.order_method.uppercased()
        ordertypeValueLbl.textColor = UIColor(hexString: "#CE590B")
        
        nameValueLbl.text = order.deliver_name
        phoneValueLbl.text = order.delivery_phn
        emailValueLbl.text = order.email
        customerId.text = order.customer_id
        
        if order.order_method == "pickup" || self.order_method == "Pickup"  {
            addressLbl.isHidden = true
            addressValueLbl.isHidden = true
        }
        else {
            addressValueLbl.isHidden = false
            let add = order.delivery_addr
            let address = add.replacingOccurrences(of: "<br>", with: "")
            addressValueLbl.text = address
        }
        
        let gross = roundOf(item: order.subtotal)
        grossSaleValue.text = "$\(gross)"
        
        // fees
        
        var smallfees = [Grand]()
        
        let cash_back_fee = order.cash_back_fee
        let confees = order.con_fee
        let tip = order.tip
        let tip_refund = order.tip_refund_amount
        let del = order.del_fee
        
        
       
        smallfees.append(Grand(cash: "Convenience Fees", cashValue:  String(format: "%.02f", roundOf(item: confees))))
        //        if del != "0.0" && del != "0.00" && del != "-0.0" &&
        //            del != "-0.00" && del != "0" && del != "" {
        smallfees.append(Grand(cash: "Delivery Fees", cashValue: String(format: "%.02f", roundOf(item: del))))
        //   }
        
     
        
        if order.is_refunded == "1" {
            smallfees.append(Grand(cash: "Tip", cashValue:  String(format: "%.02f", roundOf(item: tip_refund))))
        }
        else {
            smallfees.append(Grand(cash: "Tip", cashValue:  String(format: "%.02f", roundOf(item: tip))))
        }
        
        
        
       
        arrOfFees = smallfees
        
        // tax
        
        //        let taxDesc = convertStringToDictionary(text: order.other_taxes_desc)
        //        var keystaxDesc = [String]()
        //        var valuetaxDesc = [String]()
        //
        //        for (k, v) in taxDesc {
        //
        //            keystaxDesc.append(k)
        //            valuetaxDesc.append("\(v)")
        //        }
        //        keystaxDesc.append("DefaultTax")
        //        valuetaxDesc.append(order.tax)
        //
        //        let tax_rate_desc =  convertStringToDictionary(text: order.other_taxes_rate_desc)
        //
        //        var keystax_rate_desc = [String]()
        //        var valuetax_rate_desc = [String]()
        //
        //
        //        for key in keystaxDesc {
        //            if let value = tax_rate_desc[key] {
        //                keystax_rate_desc.append(key)
        //                valuetax_rate_desc.append("\(value)")
        //            }
        //        }
        //
        //        valuetax_rate_desc.append(order.tax_rate)
        //
        //        arrTaxName = keystaxDesc
        //        arrTaxPrice = valuetaxDesc
        //        arrTaxPercentage = valuetax_rate_desc
        //
        //        print("arrTaxName:", arrTaxName)
        //        print("arrTaxPrice:", arrTaxPrice)
        //        print("arrTaxPercentage:", arrTaxPercentage)
        
        let  dictionary =  convertStringToDictionary(text: order.coupon_code)
        
        var small = [OrderCouponcode]()
        
        let c_code = OrderCouponcode(coupon_code: "\(dictionary["coupon_code"] ?? "")",
                                     coupon_code_amt: "\(dictionary["coupon_code_amt"] ?? "")",
                                     loyalty_point_earned: "\(dictionary["loyalty_point_earned"] ?? "")",
                                     loyalty_point_amt_earned: "\(dictionary["loyalty_point_amt_earned"] ?? "")",
                                     loyalty_point_amt_spent: "\(dictionary["loyalty_point_amt_spent"] ?? "")",
                                     loyalty_point_spent: "\(dictionary["loyalty_point_spent"] ?? "")",
                                     store_credit_amt_spent: "\(dictionary["store_credit_amt_spent"] ?? "")",
                                     bogo_discount: "\(dictionary["bogo_discount"] ?? "")" )
        
        small.append(c_code)
       
        couponCodeArr = small
    
        couponCode = c_code
        
      
        
        let coupon_code = c_code.coupon_code
        let coupon_code_amt = c_code.coupon_code_amt
        
        let points_earned = c_code.loyalty_point_earned
        let points_amt_earned = c_code.loyalty_point_amt_earned
        
        let points_amt_spent = c_code.loyalty_point_amt_spent
        
        let points_applied = c_code.loyalty_point_spent
        
        let store_credit = c_code.store_credit_amt_spent
        let points_applied_Round = String(format: "%.02f", roundOf(item: points_applied ))
        let bogo_discount = couponCode?.bogo_discount ?? ""
        
        
        
        
        var discount = calDisc(coupon_code: coupon_code_amt, bogo_discount: bogo_discount)
        
        let net = calculateNetSale(subtotal: order.subtotal, LPR: points_amt_spent, discount: discount)
        netSaleValue.text = "$\(net)"
        
        netSale = "\(net)"
        
        var fees = ""
        if order.is_refunded == "1" {
            fees = calaculateOtherFees(cash_back: order.cash_back_fee, del_fee: order.del_fee, confees: order.con_fee, tip: order.tip_refund_amount)
        }
        else {
            fees = calaculateOtherFees(cash_back: order.cash_back_fee, del_fee: order.del_fee, confees: order.con_fee, tip: order.tip)
        }
        
        totalFeesValueLbl.text =  "$\(fees)"
       
        feesTotal = "\(fees)"
        
        
        
        var smallarrSummary = [Grand]()
        
        smallarrSummary.append(Grand(cash: "Loyalty Points Redeemed (\(points_applied_Round))", cashValue: String(format: "%.02f", roundOf(item: points_amt_spent ))))
        smallarrSummary.append(Grand(cash: "Discount", cashValue: String(format: "%.02f", roundOf(item: discount))))
        
        arrOfOrderSummary = smallarrSummary
        
        
        var smallLoyalty = [GrandLoyalty]()
        
        //        if points_earned != "0.0" && points_earned != "0.00" && points_earned != "-0.0" &&
        //            points_earned != "-0.00" && points_earned != "0" && points_earned != "" &&  handleZero(cashValue: points_earned) {
        
        //  smallLoyalty.append(Grand(cash: "Awarded", cashValue: String(format: "%.02f", roundOf(item: points_earned))))
        // smallLoyalty.append(GrandLoyalty(cash: "Awarded", cashValue: points_earned, date: order.date_time))
        
        loyaltyAwarded = String(format: "%.02f", roundOf(item: points_earned))
        //     }
        
        arrOfLoyalty = smallLoyalty
    
        
        if order.is_refunded == "1" {
            
        }
        else {
            totalLoyaltyValue.text = loyaltyAwarded
        }
    }
    
    func setMerchantDetails(merch: [[String: Any]]) {
         
        for item in merch {
            
            let merch_detail = MerchantDetail(a_address_line_1: "\(item["a_address_line_1"] ?? "")",
                                              a_address_line_2: "\(item["a_address_line_2"] ?? "")",
                                              a_address_line_3: "\(item["a_address_line_3"] ?? "")",
                                              a_city: "\(item["a_city"] ?? "")", a_country: "\(item["a_country"] ?? "")",
                                              a_phone: "\(item["a_phone"] ?? "")", a_state: "\(item["a_state"] ?? "")",
                                              a_zip: "\(item["a_zip"] ?? "")", banner_img: "\(item["banner_img"] ?? "")",
                                              email: "\(item["email"] ?? "")", fb_url: "\(item["fb_url"] ?? "")",
                                              img: "\(item["img"] ?? "")", insta_url: "\(item["insta_url"] ?? "")",
                                              lat: "\(item["lat"] ?? "")", lng: "\(item["lng"] ?? "")",
                                              name: "\(item["name"] ?? "")", phone: "\(item["phone"] ?? "")",
                                              timeZone: "\(item["timeZone"] ?? "")")
            
        }
    }
    
    func setIdentificationDetails(id: [String: Any]) {
        
        
        let id_detail = IdentificationDetail(i_card_type: "\(id["i_card_type"] ?? "")", i_card_number: "\(id["i_card_number"] ?? "")",
                                             i_card_ex_date: "\(id["i_card_ex_date"] ?? "")", i_card_dob: "\(id["i_card_dob"] ?? "")",
                                             i_card_front_img: "\(id["i_card_front_img"] ?? "")", i_card_back_img: "\(id["i_card_back_img"] ?? "")")
    
    }
    
    func setCartData(list: Any) {
        
        let cart = list as! [[String: Any]]
        
        var smallcart = [CartdataRef]()
        var smallcartRef = [CartdataRef]()
        
        var taxCart = [CartdataRef]()
        
        
        for cartItem in cart {
            
            let cart_detail = CartdataRef(line_item_id: "\(cartItem["line_item_id"] ?? "")",
                                          variant_id: "\(cartItem["variant_id"] ?? "")",
                                          category_id: "\(cartItem["category_id"] ?? "")",
                                          cost_price: "\(cartItem["cost_price"] ?? "")",
                                          name: "\(cartItem["name"] ?? "")",
                                          is_bulk_price: "\(cartItem["is_bulk_price"] ?? "")",
                                          bulk_price_id: "\(cartItem["bulk_price_id"] ?? "")",
                                          qty: "\(cartItem["qty"] ?? "")",
                                          note: "\(cartItem["note"] ?? "")",
                                          userData: "\(cartItem["userData"] ?? "")",
                                          taxRates: "\(cartItem["taxRates"] ?? "")",
                                          default_tax_amount: "\(cartItem["default_tax_amount"] ?? "")",
                                          other_taxes_amount: "\(cartItem["other_taxes_amount"] ?? "")",
                                          other_taxes_desc: "\(cartItem["other_taxes_desc"] ?? "")",
                                          is_refunded: "\(cartItem["is_refunded"] ?? "")",
                                          refund_amount: "\(cartItem["refund_amount"] ?? "")",
                                          refund_qty: "\(cartItem["refund_qty"] ?? "")",
                                          id: "\(cartItem["id"] ?? "")",
                                          img: "\(cartItem["img"] ?? "")",
                                          price: "\(cartItem["price"] ?? "")",
                                          lp_discount_amt: "\(cartItem["lp_discount_amt"] ?? "")",
                                          coupon_code_amt: "\(cartItem["coupon_code_amt"] ?? "")",
                                          discount_amt: "\(cartItem["discount_amt"] ?? "")",
                                          discount_rate: "\(cartItem["discount_rate"] ?? "")",
                                          adjust_price: "\(cartItem["adjust_price"] ?? "")",
                                          bogo_discount: "\(cartItem["bogo_discount"] ?? "")",
                                          use_point: "\(cartItem["use_point"] ?? "")",
                                          earn_point: "\(cartItem["earn_point"] ?? "")",
                                          is_lottery: "\(cartItem["is_lottery"] ?? "")",
                                          is_adult: "\(cartItem["is_adult"] ?? "")",
                                          other_taxes_rate_desc: "\(cartItem["other_taxes_rate_desc"] ?? "")",
                                          other_taxes_refund_desc: "\(cartItem["other_taxes_refund_desc"] ?? "")",
                                          default_tax_refund_amount: "\(cartItem["default_tax_refund_amount"] ?? "")",
                                          other_taxes_refund_amount: "\(cartItem["other_taxes_refund_amount"] ?? "")",
                                          inventory_price: "\(cartItem["inventory_price"] ?? "")",
                                          vendor_id: "\(cartItem["vendor_id"] ?? "")",
                                          vendor_name: "\(cartItem["vendor_name"] ?? "")",
                                          brand_name: "\(cartItem["brand_name"] ?? "")",
                                          brand_id: "\(cartItem["brand_id"] ?? "")")
            
            //
            //            (note: "\(cartItem["note"] ?? "" )",
            //                                          price: "\(cartItem["price"] ?? "")",
            //                                          ref_qty: "\(cartItem["refund_qty"] ?? "")",
            //                                          qty: "\(cartItem["qty"] ?? "")",
            //                                          is_refunded: "\(cartItem["is_refunded"] ?? "")")
            
            taxCart.append(cart_detail)
            //
            
            
            if cart_detail.is_refunded == "1" {
                smallcartRef.append(cart_detail)
            }
            else if cart_detail.is_refunded == "2"{
                
            }
            else {
                smallcart.append(cart_detail)
            }
            
            
            
            //            if cart_detail.is_refunded == "1" {
            //
            //                if smallcartRef.count != 0 {
            //                    if smallcartRef.contains(where: { $0.note == cart_detail.note }) {
            //                        let index = smallcartRef.firstIndex(where: { $0.note == cart_detail.note }) ?? 0
            //                        let quantity = smallcartRef[index].refund_qty
            //                        print(quantity)
            //                        let newQty = (Int(quantity) ?? 0) + 1
            //                        smallcartRef[index].refund_qty = String(newQty)
            //                    }
            //                    else {
            //                        smallcartRef.append(cart_detail)
            //                    }
            //                }
            //                else {
            //                    smallcartRef.append(cart_detail)
            //                }
            //                refundProduct.text = "Refunded Item"
            //
            ////            }
            //            else if cart_detail.is_refunded == "2" {
            //
            //                if smallcartRef.count != 0 {
            //                    if smallcartRef.contains(where: { $0.note == cart_detail.note }) {
            //                        let index = smallcartRef.firstIndex(where: { $0.note == cart_detail.note }) ?? 0
            //                        let quantity = smallcartRef[index].refund_qty
            //                        print(quantity)
            //                        let newQty = (Int(quantity) ?? 0) + 1
            //                        smallcartRef[index].refund_qty = String(newQty)
            //                    }
            //                    else {
            //                        smallcartRef.append(cart_detail)
            //                    }
            //                }
            //                else {
            //                    smallcartRef.append(cart_detail)
            //                }
            //
            //                if smallcart.count != 0 {
            //                    if smallcart.contains(where: { $0.note == cart_detail.note }) {
            //                        let index = smallcart.firstIndex(where: { $0.note == cart_detail.note }) ?? 0
            //                        let quantity = smallcart[index].qty
            //                        print(quantity)
            //                        let newQty = (Int(quantity) ?? 0) + 1
            //                        smallcart[index].qty = String(newQty)
            //                    }
            //                    else {
            //                        smallcart.append(cart_detail)
            //                    }
            //                }
            //                else {
            //                    smallcart.append(cart_detail)
            //                }
            //                print(smallcart)
            ////            }
            //            else {
            //                if smallcart.count != 0 {
            //                    if smallcart.contains(where: { $0.note == cart_detail.note }) {
            //                        let index = smallcart.firstIndex(where: { $0.note == cart_detail.note }) ?? 0
            //                        let quantity = smallcart[index].qty
            //                        print(quantity)
            //                        let newQty = (Int(quantity) ?? 0) + 1
            //                        smallcart[index].qty = String(newQty)
            //                    }
            //                    else {
            //                        smallcart.append(cart_detail)
            //                    }
            //                }
            //                else {
            //                    smallcart.append(cart_detail)
            //                }
            //                onlineOrderLbl.text = "Online Order"
            //            }
        }
        
        arrofCartData = smallcart
        arrofRefCartData = smallcartRef
        
        
        let totalSmallCartQty = smallcart.reduce(0) { result, item in
            result + (Int(item.qty) ?? 0)
        }
        
        let totalSmallCartRefQty = smallcartRef.reduce(0) { result, item in
            result + (Int(item.refund_qty) ?? 0)
        }
        let grandTotalQty = totalSmallCartQty + totalSmallCartRefQty
        totalItemsValueLbl.text = "\(grandTotalQty)"
        
        
        
        let tax = orderDetail?.tax ?? "0.00"
        let tax_rate = orderDetail?.tax_rate ?? "0.00"
        let other_taxes = orderDetail?.other_taxes_desc ?? ""
        let other_tax = convertStringToDictionary(text: other_taxes)
        let other_taxes_rate = orderDetail?.other_taxes_rate_desc ?? ""
        let other_tax_rate = convertStringToDictionary(text: other_taxes_rate)
        
        var tax_order_sum_array = [Tax_Order_Summary]()
        tax_order_sum_array.append(Tax_Order_Summary(tax_name: "DefaultTax", tax_rate: tax_rate,
                                                     tax_amount: "", sale_due: String(format: "%.2f", roundOf(item: tax))))
        
        
        for (key, value) in other_tax {
            tax_order_sum_array.append(Tax_Order_Summary(tax_name: key, tax_rate: "",
                                                         tax_amount: "", sale_due: "\(value)"))
        }
      
        
        for (key, value) in other_tax_rate {
            if tax_order_sum_array.contains(where: {$0.tax_name == key}) {
                let index = tax_order_sum_array.firstIndex(where: {$0.tax_name == key}) ?? 0
                tax_order_sum_array[index].tax_rate = "\(value)"
            }
        }
       
        
        for item_cart in taxCart {
            
            let tax_def_pay = item_cart.default_tax_amount
            let tax_other_pay = item_cart.other_taxes_desc
            let price_pay = item_cart.price
            
            let price_pay_doub = Double(price_pay) ?? 0.00 //23.79
            if tax_def_pay != "" && tax_def_pay != "0" && tax_def_pay != "0.00" && tax_def_pay != "0.0" {
                let index = tax_order_sum_array.firstIndex(where: { $0.tax_name == "DefaultTax"}) ?? 0
                let amt = tax_order_sum_array[index].tax_amount
                var amt_doub = Double(amt) ?? 0.00
                amt_doub += price_pay_doub
                tax_order_sum_array[index].tax_amount = String(format: "%.2f", amt_doub)
            }
            
            let pay = convertStringToDictionary(text: tax_other_pay)
            if pay.count != 0 {
                for (key, value) in pay {
                    let index = tax_order_sum_array.firstIndex(where: { $0.tax_name == key}) ?? 0
                    let amt = tax_order_sum_array[index].tax_amount
                    var amt_doub = Double(amt) ?? 0.00
                    amt_doub += price_pay_doub
                    tax_order_sum_array[index].tax_amount = String(format: "%.2f", amt_doub)
                }
            }
            
        }
        
        var add = 0.00
        for price in tax_order_sum_array {
            let price_double = Double(price.sale_due) ?? 0.00
            add += price_double
        }
        totalTaxValueLbl.text = "$\(String(format: "%.2f", add))"
        taxTotal = "\(add)"
       
        arrOfTaxes = tax_order_sum_array
        
        
        let grand = calculateGrandTotal(netSale: netSale, taxex: taxTotal, otherFees:  feesTotal)
        
        grandTotalValueLbl.text = "$\(grand)"
        
      
        grandTotal = grand
        
        let orderPayment_Id = orderDetail?.payment_id ?? ""
        let orderAmt = orderDetail?.amt ?? ""
        
        let orderIsLoyalty = orderDetail?.is_loyality ?? ""
        let orderisStoreCredit = orderDetail?.is_store_credit ?? ""
        
        
        let coupon_code = couponCode?.coupon_code ?? ""
        let coupon_code_amt = couponCode?.coupon_code_amt ?? ""
        
        let points_earned = couponCode?.loyalty_point_earned ?? ""
        
        let points_amt_earned = couponCode?.loyalty_point_amt_earned ?? ""
        
        let points_amt_spent = couponCode?.loyalty_point_amt_spent ?? ""
        
        let points_applied = couponCode?.loyalty_point_spent ?? ""
        
        let store_credit = couponCode?.store_credit_amt_spent ?? ""
        let card_type = orderDetail?.card_type ?? ""
        
        let credit_card =  calculatecredit(amt: orderAmt, store_credit_amt_spent: store_credit)
        
        
        if orderIsLoyalty == "0" && orderisStoreCredit == "0"    {
            cash_grand = orderAmt
            
        }
        else if orderIsLoyalty == "0" && orderisStoreCredit == "1" {
            cash_grand = calstoreCreditOne(amt: orderAmt, store_credit: store_credit)
            
        }
        else if orderIsLoyalty == "1" &&  orderisStoreCredit == "0" {
            cash_grand = calLoyaltyPointOne(amt: grandTotal)
            
        }
        else if orderIsLoyalty == "1" && orderisStoreCredit == "1" {
            cash_grand = calStoreLoyltybothOne(amtgrandvalue: grandTotal,  store_credit: store_credit)
        }
        else {
            
        }
        
        // Tenders
        
        var smallArrTenders = [Grand]()
        var smallAuth = [Grand]()
        
        
        if points_amt_spent != "0.0" && points_amt_spent != "0.00" && points_amt_spent != "-0.0" &&
            points_amt_spent != "-0.00" && points_amt_spent != "0" && points_amt_spent != ""  {
            
            //            smallArrGrand.append(Grand(cash: "Points Applied", cashValue:"(-\(String(format: "%.02f", roundOf(item: points_app*/lied))))-$\(String(format: "%.02f", roundOf(item: points_amt_spent)))"))
        }
        
        if orderPayment_Id == "Cash" {
            
            if cash_grand != "0.0" && cash_grand != "0.00" && cash_grand != "-0.0" &&
                cash_grand != "-0.00" && cash_grand != "0" && cash_grand != "" && handleZero(cashValue: cash_grand)  {
                
                smallArrTenders.append(Grand(cash: "Cash", cashValue: String(format: "%.02f", roundOf(item: cash_grand))))
                smallAuth.append(Grand(cash: "Auth Code:", cashValue: ""))
            }
        }
        else {
            
            let cardnum = orderDetail?.card_num ?? ""
            let c_num = String(cardnum.suffix(4))
            
         
            if credit_card != "0.0" && credit_card != "0.00" && credit_card != "-0.0" &&
                credit_card != "-0.00" && credit_card != "0" && credit_card != "" && handleZero(cashValue: credit_card)  {
                
                if card_type.contains("debit"){
                    smallArrTenders.append(Grand(cash: "Debit Card: \(c_num)", cashValue: String(format: "%.02f", roundOf(item: credit_card))))
                    smallAuth.append(Grand(cash: "Auth Code:", cashValue: ""))
                }
                else {
                    smallArrTenders.append(Grand(cash: "Credit Card:\(c_num)", cashValue: String(format: "%.02f", roundOf(item: credit_card))))
                    smallAuth.append(Grand(cash: "Auth Code:", cashValue: ""))
                }
            }
        }
        
        if store_credit != "0.0" && store_credit != "0.00" && store_credit != "-0.0" &&
            store_credit != "-0.00" && store_credit != "0" && store_credit != "" && handleZero(cashValue: store_credit) {
            
            smallArrTenders.append(Grand(cash: "Store Credit", cashValue: String(format: "%.02f", roundOf(item: store_credit))))
            smallAuth.append(Grand(cash: "Auth Code:", cashValue: ""))
        }
        
        let total = calTotalTenders(card: smallArrTenders)
        
       
        tendersTotalValueLbl.text = "$\(total)"
        
        calculateHeightForTender(pay: smallArrTenders)
        arrofTenders = smallArrTenders
        arrOfAuth = smallAuth
        
        if arrofCartData.count == 0 {
            onlineOrderheightView.constant = 50
            refundHeightConstant.constant = 0
            refundProduct.isHidden = true
            onlineOrderLbl.isHidden = false
            onlineOrderLbl.text = "Refunded Products"
            
            refundLbl.isHidden = false
            belowRefundDashView.isHidden = false
            refundBlueview.isHidden = false
            refundDetailViewHeight.constant = 50
            totalRefundedlblHeight.constant = 40
            totalRefundHeight.constant = 40
            refunFinaldTax.isHidden = false
            refundFinalAmt.isHidden = false
            totalLbl.isHidden = false
            totalRefundedLbl.isHidden = false
            belowRefundDetailDashView.isHidden = false
            belowRefundTotalDashView.isHidden = false
            GtAfterRefundHeight.constant = 58
            gtAfterRfnValueLbl.isHidden = false
            grandTotalAfterRefund.isHidden = false
            grandTotalLbl.isHidden = false
            gtMinusTotalRefundLbl.isHidden = false
            belowRefundDetailTableDashHeight.constant = 3
            belowRefundTotalDashHeight.constant = 3
            
            
        }
        else if arrofRefCartData.count == 0 {
            onlineOrderheightView.constant = 50
            refundHeightConstant.constant = 0
            refundProduct.isHidden = true
            onlineOrderLbl.isHidden = false
            
            refundLbl.isHidden = true
            belowRefundDashView.isHidden = true
            refundBlueview.isHidden = true
            refundDetailViewHeight.constant = 0
            totalRefundedlblHeight.constant = 0
            totalRefundHeight.constant = 0
            refunFinaldTax.isHidden = true
            refundFinalAmt.isHidden = true
            totalLbl.isHidden = true
            totalRefundedLbl.isHidden = true
            belowRefundDetailDashView.isHidden = true
            belowRefundTotalDashView.isHidden = true
            GtAfterRefundHeight.constant = 0
            gtAfterRfnValueLbl.isHidden = true
            grandTotalAfterRefund.isHidden = true
            grandTotalLbl.isHidden = true
            gtMinusTotalRefundLbl.isHidden = true
            belowRefundDetailTableDashHeight.constant = 0
            belowRefundTotalDashHeight.constant = 0
        }
        else {
            
            onlineOrderheightView.constant = 50
            refundHeightConstant.constant = 50
            refundProduct.isHidden = false
            onlineOrderLbl.isHidden = false
            
            refundLbl.isHidden = false
            belowRefundDashView.isHidden = false
            refundBlueview.isHidden = false
            refundDetailViewHeight.constant = 50
            totalRefundedlblHeight.constant = 40
            totalRefundHeight.constant = 40
            refunFinaldTax.isHidden = false
            refundFinalAmt.isHidden = false
            totalLbl.isHidden = false
            totalRefundedLbl.isHidden = false
            belowRefundDetailDashView.isHidden = false
            belowRefundTotalDashView.isHidden = false
            GtAfterRefundHeight.constant = 58
            
            gtAfterRfnValueLbl.isHidden = false
            grandTotalAfterRefund.isHidden = false
            grandTotalLbl.isHidden = false
            gtMinusTotalRefundLbl.isHidden = false
            belowRefundDetailTableDashHeight.constant = 3
            belowRefundTotalDashHeight.constant = 3
            
        }
    }
    
    func calculateHeightForTender(pay: [Grand]) {
        
        var smalltenderHeight = [String]()
        
        for height in pay {
            
            if height.cash.contains("Credit Card:") || height.cash.contains("Debit Card:") {
                smalltenderHeight.append("80.33")
            }
            else {
                smalltenderHeight.append("62.33")
            }
        }
        tenderHeight = smalltenderHeight
        
    }
    
    func setRefundData(refund_data: Any) {
        
        let refund = refund_data as! [[String:Any]]
        
        var small = [RefundDetail]()
        var smallRefValues = [String]()
        var smallTip = [TipNca]()
        
        var smallrefundData = [RefundData]()
        var smallRemove = [Loyalty]()
        
        for ref in refund {
            
            
            let refund_pay = RefundData(refund_id: "\(ref["refund_id"] ?? "")",
                                        refunded_by_emp: "\(ref["refunded_by_emp"] ?? "")",
                                        amount: "\(ref["amount"] ?? "")",
                                        credit_amt: "\(ref["credit_amt"] ?? "")",
                                        giftcard_amt: "\(ref["giftcard_amt"] ?? "")",
                                        debit_amt: "\(ref["debit_amt"] ?? "")",
                                        cash_amt: "\(ref["cash_amt"] ?? "")",
                                        loyalty_point_amt: "\(ref["loyalty_point_amt"] ?? "")",
                                        store_credit_amt: "\(ref["store_credit_amt"] ?? "")",
                                        reason: "\(ref["reason"] ?? "")",
                                        created_at: "\(ref["created_at"] ?? "")",
                                        nca_amt: "\(ref["nca_amt"] ?? "")",
                                        tip_amt: "\(ref["tip_amt"] ?? "")",
                                        credit_refund_tax: "\(ref["credit_refund_tax"] ?? "")",
                                        debit_refund_tax: "\(ref["debit_refund_tax"] ?? "")",
                                        cash_refund_tax: "\(ref["cash_refund_tax"] ?? "")",
                                        store_credit_refund_tax: "\(ref["store_credit_refund_tax"] ?? "")",
                                        loyalty_point_refund_tax: "\(ref["loyalty_point_refund_tax"] ?? "")",
                                        gift_card_refund_tax: "\(ref["gift_card_refund_tax"] ?? "")",
                                        default_tax_rate: "\(ref["default_tax_rate"] ?? "")",
                                        reward_loyalty_refund_amt: "\(ref["reward_loyalty_refund_amt"] ?? "")",
                                        reward_loyalty_refund_point: "\(ref["reward_loyalty_refund_point"] ?? "")")
            
            
            
          //  let amt = refund_pay.amount
            let credt_amt = refund_pay.credit_amt
           // let gift_card_amt = refund_pay.gift_card_refund_tax
            let card_pay = refund_pay.debit_amt
            let cash_pay = refund_pay.cash_amt
           // let loyalty_amt = refund_pay.loyalty_point_amt
            let store_cred = refund_pay.store_credit_amt
           // let refund_reason = refund_pay.reason
            let create_date = refund_pay.created_at
            let tip_amt = refund_pay.tip_amt
            let nca_amt = refund_pay.nca_amt
            let credit_tax = refund_pay.credit_refund_tax
            let debit_tax = refund_pay.debit_refund_tax
            let cash_tax = refund_pay.cash_refund_tax
            let store_credit_tax = refund_pay.store_credit_refund_tax
            //let loyalty_point_tax = refund_pay.loyalty_point_refund_tax
           // let gift_card_tax = refund_pay.gift_card_refund_tax
           // let default_tax_rate = refund_pay.default_tax_rate
            
            //let reward_loyalty_refund_amt = refund_pay.reward_loyalty_refund_amt
            let reward_loyalty_refund_point = refund_pay.reward_loyalty_refund_point
            
          
            
            smallrefundData.append(refund_pay)
            var smallRef = [String]()
            
            // smallRef.append("Reason Of Refund")
            //smallRefValues.append(refund_reason)
            
            
            if credt_amt != "0.00" {
                smallRef.append("Credit Card")
                smallRefValues.append("\(String(format: "%.02f", roundOf(item: credt_amt)))")
                //  smallRefTax.append("$\(String(format: "%.02f", roundOf(item: credit_tax)))")
                small.append(RefundDetail(card: "Credit Card", amount:credt_amt , date: create_date, taxrefunded: credit_tax))
                smallTip.append(TipNca(tipAmt: tip_amt, ncaAmt: nca_amt))
            }
            else if credt_amt == "0.00" {
                let cardnum = orderDetail?.card_num ?? ""
                let c_num = String(cardnum.suffix(4))
                
                
                if tip_amt != "0.00" {
                    small.append(RefundDetail(card: "Credit Card:\(c_num)", amount:credt_amt , date: create_date, taxrefunded: (String(format: "%.02f", roundOf(item: credit_tax)))))
                }
                smallTip.append(TipNca(tipAmt: tip_amt, ncaAmt: nca_amt))
                
            }
            
            if card_pay != "0.00" {
                smallRef.append("Debit Card")
                smallRefValues.append("\(String(format: "%.02f", roundOf(item: card_pay)))")
                small.append(RefundDetail(card: "Credit Card", amount:card_pay , date: create_date, taxrefunded: debit_tax))
                smallTip.append(TipNca(tipAmt: tip_amt, ncaAmt: nca_amt))
            }
            
            if cash_pay != "0.00" {
                smallRef.append("Cash")
                smallRefValues.append("\(String(format: "%.02f", roundOf(item: cash_pay)))")
                small.append(RefundDetail(card: "Cash", amount: cash_pay, date: create_date, taxrefunded: cash_tax))
                smallTip.append(TipNca(tipAmt: tip_amt, ncaAmt: nca_amt))
            }
            
            if store_cred != "0.00" {
                smallRef.append("Store Credits")
                smallRefValues.append("\(String(format: "%.02f", roundOf(item: store_cred)))")
                small.append(RefundDetail(card: "Store Credits", amount:store_cred , date: create_date, taxrefunded: store_credit_tax))
                smallTip.append(TipNca(tipAmt: tip_amt, ncaAmt: nca_amt))
            }
            
            if tip_amt != "0.00" {
                smallRef.append("Tip")
                smallRefValues.append("\(String(format: "%.02f", roundOf(item: tip_amt)))")
                //  small.append(RefundDetail(card: "Tip", amount:tip_amt , date: create_date, taxrefunded: ""))
            }
            
            if nca_amt != "0.00" {
                smallRef.append("NCA")
                smallRefValues.append("\(String(format: "%.02f", roundOf(item: nca_amt)))")
                //   small.append(RefundDetail(card: "Store Credits", amount: nca_amt , date: create_date, taxrefunded: ""))
            }
            
            arrOfRefunDetails = small
            arrOfTip = smallTip
            
            
            
            
            if reward_loyalty_refund_point != "0.0" && reward_loyalty_refund_point != "0.00" && reward_loyalty_refund_point != "-0.0" &&
                reward_loyalty_refund_point != "-0.00" && reward_loyalty_refund_point != "0" && reward_loyalty_refund_point != ""  {
        
                smallRemove.append(Loyalty(loyalty_points: reward_loyalty_refund_point, loyalty_date: create_date))
                loyaltyRemove = String(format: "%.02f", roundOf(item: reward_loyalty_refund_point))
            }
        }
     
        let points_earned = couponCode?.loyalty_point_earned ?? "0.00"
        let remove = calAddLoylty(card: smallRemove)
        
        let remove_doub = Double(remove) ?? 0.00
        let earned_doub = Double(points_earned) ?? 0.00
        
        var award = 0.00
        
        award = remove_doub + earned_doub

        let loyalAward = String(format: "%.2f", roundOf(item: String(award)))
        
        var refund_loyal = [Loyalty]()
        
        if loyalAward != "0.0" && loyalAward != "0.00" && loyalAward != "-0.0" &&
            loyalAward != "-0.00" && loyalAward != "0" && loyalAward != "" && handleZero(cashValue: loyalAward) {
            
            refund_loyal.append(Loyalty(loyalty_points: String(format: "%.2f", roundOf(item: String(award))), loyalty_date: orderDetail?.date_time ?? ""))
            refund_loyal.append(contentsOf: smallRemove)
        }
        loyalArray = refund_loyal
        
        
        var total = 0.00
        if loyalArray.count != 0 {
            total = Double(loyalArray[0].loyalty_points) ?? 0.00
            let loy_total =   String(format: "%.2f", roundOf(item: String(total)))
            totalLoyaltyValue.text = loy_total
        }
        
        if loyalArray.count > 1 {
            for loyal in 1..<loyalArray.count {
                
                let award = Double(loyalArray[loyal].loyalty_points) ?? 0.00
                
                total -= award
            }
            if total < 0.00 {
                var value = String(total)
                if value.hasPrefix("-") {
                    value.removeFirst()
                }
                totalLoyaltyValue.text = String(format: "%.2f", roundOf(item: value))
            }
            else {
                totalLoyaltyValue.text = String(format: "%.2f", roundOf(item: String(total)))
            }
        }
   
        let totalRefund = calRefundTotal(card: smallRefValues)
     
        
        refundFinalAmt.text = "$\(totalRefund)"
        
        let totalRefundtax = calRefundTaxTotal(card:small )
       
        refunFinaldTax.text = "$\(totalRefundtax)"
        
        var grandRefund = grandRefundTotal(grand_total: grandTotal, refund_fAmt: "\(totalRefund)" )
       
        gtAfterRfnValueLbl.text = "$\(grandRefund)"
        
        if loyalArray.count == 0 {
            loyaltyLbl.isHidden = true
            loyaltyBlue.isHidden =  true
            loyaltyView.isHidden = true
            loyaltyTotalLbl.isHidden =  true
            loyaltyTableView.isHidden =  true
            totalLoyaltyValue.isHidden =  true
            loyaltyViewHeight.constant = 0
            totalLoyaltyViewHeight.constant = 0
        }
        else {
            loyaltyLbl.isHidden = false
            loyaltyBlue.isHidden =  false
            loyaltyView.isHidden = false
            loyaltyTotalLbl.isHidden =  false
            loyaltyTableView.isHidden =  false
            totalLoyaltyValue.isHidden =  false
            loyaltyViewHeight.constant = 60
            totalLoyaltyViewHeight.constant = 58
        }
    }
    
    func setFutureData(futuredata: Any) {
        
        let f_details = futuredata as! String
    
        
        let ordDate = ToastClass.sharedToast.setDateFormat(dateStr: f_details)
        futureLBL.text = "Future order- \(ordDate)"
        
        
        if f_details == "NOW" || f_details == "now" || f_details == "" {
            // futureOrder.isHidden = true
            futureLBL.isHidden = true
        }
        else {
            futureLBL.isHidden = false
        }
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        let viewcontrollerArray = navigationController?.viewControllers
        var destiny = 0
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    private func setupUI() {
        
        if #available(iOS 13.0, *) {
            
            overrideUserInterfaceStyle = .light
        }
        
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: view.centerXAnchor, constant: 0),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: view.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 40),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
}


extension NewOrderRefundDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == onlineOrderTableView {
            return 1
        }
        else if tableView == refundProductTableView {
            return 1
        }
        else if tableView == orderSummaryTableView {
            return 1
        }
        else  if tableView == taxTableView   {
            return 1
        }
        else  if tableView == FeesTableview {
            return 1
        }
        else if tableView == tendersTableView {
            return 1
        }
        else if tableView == refundDetailTable {
            return 1
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == onlineOrderTableView {
            return arrofCartData.count
        }
        else if tableView == refundProductTableView{
            return arrofRefCartData.count
        }
        else if tableView == orderSummaryTableView  {
            return arrOfOrderSummary.count
        }
        else  if tableView == taxTableView {
            return arrOfTaxes.count
        }
        else  if tableView == FeesTableview {
            return arrOfFees.count
        }
        else if tableView == tendersTableView {
            return arrofTenders.count
        }
        else if tableView == refundDetailTable {
            return arrOfRefunDetails.count
        }
        else {
            return loyalArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == onlineOrderTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedCartOnlineCell", for: indexPath) as! CompletedCartOnlineCell
            
            let cart = arrofCartData[indexPath.row]
            let note = cart.note.replacingOccurrences(of: "~", with: "\n")
            cell.name.text = note.replacingOccurrences(of: "Name-", with: "")
            
            let price = roundOf(item: arrofCartData[indexPath.row].inventory_price)
            cell.price.text = "$\(String(format: "%.2f", price))"
            
            cell.qty.text = "\(arrofCartData[indexPath.row].qty)x"
            
            var t_price = calculateTotalPrice(p_price: arrofCartData[indexPath.row].inventory_price , bogoDis: arrofCartData[indexPath.row].bogo_discount)
            
            cell.totalPrice.text = "$\(t_price)"
            
            if arrofCartData[indexPath.row].bogo_discount == "0.00" {
                cell.bogoDiscountLbl.text = ""
            }
            else {
               
                cell.bogoDiscountLbl.text = "BOGO Deal(-$\(arrofCartData[indexPath.row].bogo_discount))"
            }
            cell.bogoDiscountLbl.font = UIFont(name: "Manrope-Medium", size: 15.0)
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = selectedBackgroundView
            return cell
        }
        
        else if tableView == refundProductTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedCartRefundCell", for: indexPath) as! CompletedCartRefundCell
            
            let cart = arrofRefCartData[indexPath.row]
            let note = cart.note.replacingOccurrences(of: "~", with: "\n")
            cell.name.text = note.replacingOccurrences(of: "Name-", with: "")
            
            let in_price = roundOf(item: arrofRefCartData[indexPath.row].inventory_price)
           
            
            cell.price.text = "$\(String(format: "%.2f", in_price))"
            cell.qty.text = "\(arrofRefCartData[indexPath.row].refund_qty)x"
            
            var t_price = calculateTotalPrice(p_price: arrofRefCartData[indexPath.row].inventory_price , bogoDis: arrofRefCartData[indexPath.row].bogo_discount)
            
            cell.totalPrice.text = "$\(t_price)"
            
            
            if arrofRefCartData[indexPath.row].bogo_discount == "0.00" {
                cell.bogoDiscountLbl.text = ""
            }
            else {
               
                cell.bogoDiscountLbl.text = "BOGO Deal(-$\(arrofRefCartData[indexPath.row].bogo_discount))"
            }
            
            cell.bogoDiscountLbl.font = UIFont(name: "Manrope-Medium", size: 15.0)
            
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = selectedBackgroundView
            return cell
            
        }
        else if tableView == orderSummaryTableView  {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedOrderSummaryCell", for: indexPath) as! CompletedOrderSummaryCell
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = selectedBackgroundView
            cell.nameLbl.text = arrOfOrderSummary[indexPath.row].cash
            cell.valueLbl.text = "-$\(arrOfOrderSummary[indexPath.row].cashValue)"
            
            return cell
        }
        else if tableView == taxTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedTaxCell", for: indexPath) as! CompletedTaxCell
            let tax = arrOfTaxes[indexPath.row]
            cell.taxName.text = tax.tax_name
            let taxPercentage = roundOf(item: tax.tax_rate)
            cell.taxPercent.text = "\(String(format: "%.3f", taxPercentage))%"
            let taxPrice = roundOf(item: tax.sale_due)
            cell.taxvalue.text = "$\(String(format: "%.2f", taxPrice))"
            // let gross = roundOf(item: order.subtotal)
            let taxamt = roundOf(item: tax.tax_amount)
            cell.productTotalPrice.text = "$\(taxamt)"
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = selectedBackgroundView
            return cell
        }
        else if tableView == FeesTableview {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedFeesCell", for: indexPath) as! CompletedFeesCell
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = selectedBackgroundView
            
            cell.titleLbl.text = arrOfFees[indexPath.row].cash
            cell.valueLbl.text = "$\(arrOfFees[indexPath.row].cashValue)"
            
            return cell
        }
        else if tableView == tendersTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedTendersCell", for: indexPath) as! CompletedTendersCell
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = selectedBackgroundView
            
            cell.cardLbl.text = arrofTenders[indexPath.row].cash
            cell.cardValueLbl.text = "-$\(arrofTenders[indexPath.row].cashValue)"
            cell.authCodeLb.text = arrOfAuth[indexPath.row].cash

            
            if arrofTenders[indexPath.row].cash == "Cash" || arrofTenders[indexPath.row].cash == "Store Credit" {
                cell.authCodeLb.isHidden = true
                cell.authCodeTopContrain.constant = 0
                cell.authCodeBottomConstrain.constant = 0
            }
            else if arrofTenders[indexPath.row].cash == "Credit Card:" || arrofTenders[indexPath.row].cash == "Debit Card:"{
                cell.authCodeLb.isHidden = false
                cell.authCodeTopContrain.constant = 10
                cell.authCodeBottomConstrain.constant = 10
            }
            
            return cell
        }
        else if tableView == refundDetailTable {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedRefundDetailCell", for: indexPath) as! CompletedRefundDetailCell
            
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = selectedBackgroundView

            
            if arrOfRefunDetails[indexPath.row].card == "Cash" {
                cell.tipNcaRefundLbl.isHidden = true
            }
            else {
                cell.tipNcaRefundLbl.isHidden = false
            }
      
            cell.cardLbl.text = arrOfRefunDetails[indexPath.row].card
            // cell.dateLbl.text = arrOfRefunDetails[indexPath.row].date
            cell.taxRefunded.text =  "$\(arrOfRefunDetails[indexPath.row].amount)"
            cell.taxRefundedValueLbl.text = "$\(arrOfRefunDetails[indexPath.row].taxrefunded)"
            
            if cell.cardLbl.text == "Credit Card" {
                cell.AuthCodeLbl.isHidden = false
                cell.authcodeTopConstrain.constant = 10
                cell.authCodebottomConstraint.constant = 10
                cell.AuthCodeLbl.text =  "Auth Code: N/A"
            }
            else {
                cell.AuthCodeLbl.isHidden = true
                cell.authcodeTopConstrain.constant = 0
                cell.authCodebottomConstraint.constant = 0
            }
            
            
            let ordDate = ToastClass.sharedToast.setDateFormat(dateStr: arrOfRefunDetails[indexPath.row].date)
            cell.dateLbl.text = ordDate
            
           
            cell.tipNcaRefundLbl.text = "(Tip:- $\(arrOfTip[indexPath.row].tipAmt) NCA:- $\(arrOfTip[indexPath.row].ncaAmt))"
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedLoyaltyCell", for: indexPath) as! CompletedLoyaltyCell
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = selectedBackgroundView
            
            if indexPath.row == 0 {
                cell.awardedLbl.text = "Awarded"
                cell.awardedValue.textColor = UIColor(hexString: "#11C53B")
                cell.awardedValue.text = loyalArray[indexPath.row].loyalty_points
            }
            
            else {
              
                cell.awardedLbl.text = "Removed (Due to Refund \(indexPath.row))"
                cell.awardedValue.textColor = UIColor(hexString: "#E61F1F")
                cell.awardedValue.text = "-\(loyalArray[indexPath.row].loyalty_points)"
            }
            
            let ordDate = ToastClass.sharedToast.setDateFormat(dateStr:  loyalArray[indexPath.row].loyalty_date)
            cell.dateLoyaltyLbl.text = ordDate
            
            //cell.awardedValue.text = loyalArray[indexPath.row].loyalty_points
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == onlineOrderTableView  || tableView == refundProductTableView {
            return 150
        }
        else {
            return UITableView.automaticDimension
        }
    }
}


