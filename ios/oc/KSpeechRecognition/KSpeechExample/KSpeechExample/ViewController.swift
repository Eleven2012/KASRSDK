//
//  ViewController.swift
//  KSpeechExample
//
//  Created by yulu kong on 2020/4/3.
//  Copyright © 2020 yulu kong. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

        
    //let recognizer = KSpeechRecognizer(language: .chinese, shouldReportPartialResults: true)

    @IBOutlet weak var logView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func recognitionButtonTapped(_ sender: UIButton) {
        let selected = !sender.isSelected
        sender.isSelected = selected
        if selected {
//            recognizer.start(resultHandler: { [weak self] (result) in
//                self?.outputLog("识别结果：\(result)")
//            }) { [weak self] (error) in
//                self?.outputLog("识别出错: \(error)")
//            }
        } else {
            //recognizer.stop()
        }
    }
    
    @IBAction func clearLog(_ sender: Any) {
        logView.text = nil
    }
    
    private func outputLog(_ message: String) {
        var stringBuffer = logView.text ?? ""
        stringBuffer.append(contentsOf: "\n\(message)")
        DispatchQueue.main.async {
            self.logView.text = stringBuffer
        }
    }


}

