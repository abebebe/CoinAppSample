//
//  ViewController.swift
//  CoinAppSample
//
//  Created by 阿部拓磨 on 2020/09/09.
//  Copyright © 2020 abetkma.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,CoinManagerDelegate {
    
    
    func didUpdatePrice(price: String, currency: String) {
        
        DispatchQueue.main.async {
         
            self.coinLabel.text = price
            self.currencyLabel.text = currency

        }
    }
    
    func didFailWithError(error: Error) {
        print("error")
    }
    
    
    
    @IBOutlet var coinLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
    }
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print(row,coinManager.currencyArray[row])
        
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
        
    }
}

