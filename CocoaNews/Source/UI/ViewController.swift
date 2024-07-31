//
//  ViewController.swift
//  CocoaNews
//
//  Created by Raphael Martin on 29/07/24.
//

import UIKit

class ViewController: UIViewController {
    private var task: URLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.text = "Hello World!"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.backgroundColor = .white
        
        let endpoint = HeadlinesEndpoint()
        endpoint.category = .general
        
        task = NewsAPIClient().request(from: endpoint) { result in
            switch result {
            case .success(let data):
                print("Response: \(data)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

