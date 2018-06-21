//
//  ViewController.swift
//  Project1
//
//  Created by Sammy Eang on 12/20/17.
//  Copyright © 2017 Sammy Eang. All rights reserved.
//

import UIKit //This file wil reference the iOS user interface toolkit

//I want to create a new screen of data called ViewController, based on UIViewController (the default screen type, empty and white)
class ViewController: UITableViewController {

    //starts a block of code (method) and we need override because we want to change Apple's default behavior from UIViewController. viewDidLoad is called when the screen os loaded and ready to be customized. The 'super' means "tell Apple's function to run it's own code before I run mine"
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.largeTitleDisplayMode = .never
        
        title = "Storm Viewer"
        
        let fm = FileManager.default
        //FileManager.default is a data type that lets us work with the filesystem, we'll be using it to look for files
        let path = Bundle.main.resourcePath!
        //A constant path is set to the resource path of our app's bundle (a directory containing our compiled program and all our assets)
        let items = try! fm.contentsOfDirectory(atPath: path)
        //The items constant is an array of the names of all the files that were found in the resource directory for our app, set to the path we just declared in line 19
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
    }

    override func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    //tableview is the name we use to reference the table view inside the method/function and UITableView is the data type.
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    //IndexPath is a datatype which that contains both a section number and a row number. cellForRowAt is a method which is called when you need to provide a row. The let cell line creates a new constant, cell, so when we scroll through cells, new cells aren't all created, just recycled from top to bottom or vice versa.
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

