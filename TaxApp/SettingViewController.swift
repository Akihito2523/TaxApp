//
//  SettingViewController.swift
//  TaxApp
//
//  Created by 鳥山彰仁 on 2022/10/25.
//

import UIKit

class SettingViewController: UIViewController {
    
    /*　-- 変数の初期化 -- */
    var additionArray: [Double] = []
    var addition: Double = 0
    
    //合計ラベル
    @IBOutlet weak var taxTotalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UserDefaultsが空でなければ
        if UserDefaults.standard.object(forKey: "calculated") != nil {
            //UserDefaultsに入っている配列全てをadditionArrayに代入
            additionArray = UserDefaults.standard.object(forKey: "calculated") as! [Double]
            print("配列全ての中身\n\(additionArray)")
            //reduceで配列内を足し算し、additionに代入
            addition = additionArray.reduce(0) { $0 + $1 }
            print("配列中身の足し算結果\n\(addition)")
            //DoubleからString型に変換し、小数点を四捨五入する
            taxTotalLabel.text = String(format: "%.0f", addition)
        } else {
            //UserDefaultsが空であれば0を表示
            taxTotalLabel.text = "0"
        }
    }
}
