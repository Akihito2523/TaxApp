//
//  ViewController.swift
//  TaxApp
//
//  Created by 鳥山彰仁 on 2022/10/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,
                      UITableViewDataSource, UITextFieldDelegate {
    
    /*　-- 変数の初期化 -- */
    var tax:Double = 0
    var addTax:Double = 0
    var taxArray:[Double] = []
    var addTaxString:String = ""
    let myUserDefaults = UserDefaults.standard
    
    /*　-- パーツの配置 -- */
    //ラベル
    @IBOutlet weak var taxlabel: UILabel!
    //テキストフィールド
    @IBOutlet weak var taxTextField: UITextField!
    //セグメント(10%,8%)
    @IBOutlet weak var taxSegment: UISegmentedControl!
    //テーブルビュー
    @IBOutlet weak var taxTableView: UITableView!
    //編集ボタンプロパティ
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    //編集ボタンメソッド
    @IBAction func editButtonClicked(_ sender: Any) {
        taxTableView.isEditing = !taxTableView.isEditing
        if taxTableView.isEditing {
            editButton.title = "終了"
        } else {
            editButton.title = "編集"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taxTextField.delegate = self
        taxTableView.delegate = self
        taxTableView.dataSource = self
        taxlabel.text = "0"
    }
    
    //UITextFieldの文字をtaxlabel.textに追加
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        taxlabel.text = textField.text
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //テキストフィールドにフォーカスされる
        taxTextField.becomeFirstResponder()
    }
    
    
    //追加ボタン
    @IBAction func taxButton(_ sender: Any){
        
        if taxTextField.text != "" && Int(taxTextField.text!) != nil {
            //if Double(taxTextField.text ?? "")
            // 10%であればindex番号は0
            if taxSegment.selectedSegmentIndex == 0 {
                taxCalculation(num: 1.1)
            } else {
                taxCalculation(num: 1.08)
            }
        } else {
            showAlert(message: "数字を入力してください")
            //taxTextFieldを空にする
            taxTextField.text = ""
            return
        }
        //テーブル全体の更新
        self.taxTableView.reloadData()
        print("インデックス番号は[\(taxSegment.selectedSegmentIndex)]")
    }
    
    // 消費税計算メソッド
    func taxCalculation(num:Double) {
        //taxTextFieldの中身をDoubleに変換
        //nilの場合0.0が入る
        tax = Double(taxTextField.text!) ?? 0
        //入力された値と(1.1か1.08)を掛け算し消費税をaddTaxに代入
        addTax = tax * Double(num)
        addTaxString = String(format: "%.0f", addTax)
        taxlabel.text = addTaxString
        //配列に消費税を追加
        taxArray.append(addTax)
        // forKeyを指定して保存
        myUserDefaults.set(taxArray, forKey: "calculated")
        //taxTextFieldの中身を空にする
        taxTextField.text = ""
        //taxlabelを0にする
        taxlabel.text = "0"
    }
    
    
    // メッセージアラート
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let close = UIAlertAction(title: "閉じる", style: .cancel, handler: nil)
        alert.addAction(close)
        present(alert, animated: true, completion: nil)
    }
    
    
    /*　-- tableView定義 -- */
    //セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taxArray.count
    }
    //UITableViewに表示させるセルを返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = "\(taxArray[indexPath.row])"
        return cell
    }
    //削除処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            taxArray.remove(at: indexPath.row)
            UserDefaults.standard.set(taxArray, forKey: "calculated")
            //TableView.reloadData()
            taxTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    //編集モードに切り替え
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        taxTableView.setEditing(editing, animated: animated)
        taxTableView.isEditing = editing
    }
    //並び替え時の処理
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let selectedItem = taxArray[sourceIndexPath.row]
        taxArray.remove(at: sourceIndexPath.row)
        taxArray.insert(selectedItem, at: destinationIndexPath.row)
    }
    //並び替えを可能にする
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
