//
//  ViewController.swift
//  PageViewDemo
//
//  Created by yangqianhua on 2018/3/14.
//  Copyright © 2018年 yangqianhua. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func demo1Click(_ sender: Any) {
        let v = Demo1ViewController()
        self.navigationController?.pushViewController(v, animated: true)
    }
    
    @IBAction func demo2Click(_ sender: Any) {
        let v = Demo2ViewController()
        self.navigationController?.pushViewController(v, animated: true)
    }
    
    @IBAction func demo3Click(_ sender: Any) {
        let v = Demo3ViewController()
        self.navigationController?.pushViewController(v, animated: true)
    }
    
    @IBAction func demo4Click(_ sender: Any) {
        let v = Demo4ViewController()
        self.navigationController?.pushViewController(v, animated: true)
    }
    
    @IBAction func demo5Click(_ sender: Any) {
        let v = Demo5ViewController()
        self.navigationController?.pushViewController(v, animated: true)
    }
    
}

