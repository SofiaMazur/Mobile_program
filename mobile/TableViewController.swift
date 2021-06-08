//
//  TableViewController.swift
//  Laba
//
//  Created by razur on 03.06.2021.
//

import UIKit

class TableViewController: UITableViewController {

    var recipes: Recipes?
    var films: Films?
    
    let recipesOrFilms = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if recipesOrFilms {
            sendRecipesRequest { (recipes) in
                self.recipes = recipes
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else {
            sendFilmsRequest { films in
                self.films = films
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage) -> Void) {
        
        func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
            URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        }
        
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                completion(UIImage(data: data)!)
            }
        }
    }
    
    func sendRecipesRequest(completion: @escaping (Recipes?) -> Void) {
                    
        let apiKey = "84eea4c7dfbc48b5bae5a4cc60628ba6"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.spoonacular.com"
        urlConstructor.path = "/recipes/complexSearch"
        urlConstructor.queryItems = [URLQueryItem(name: "apiKey", value: apiKey)]
        
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            let result = try? JSONDecoder().decode(Recipes.self, from: data!)
            completion(result ?? nil)
        }
        
        task.resume()
    }
    
    func sendFilmsRequest(completion: @escaping (Films?) -> Void) {
                    
        let apiKey = "ce5f874b2bf3fe1f5c508a9d84c8063a"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.themoviedb.org"
        urlConstructor.path = "/3/search/movie"
        urlConstructor.queryItems = [URLQueryItem(name: "api_key", value: apiKey), URLQueryItem(name: "query", value: "Jack")]
        
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            let result = try? JSONDecoder().decode(Films.self, from: data!)
            completion(result ?? nil)
        }
        
        task.resume()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recipesOrFilms {
            return recipes != nil ? recipes!.number : 0
        } else {
            return 10
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? Cell else { return UITableViewCell() }
        
        var text = ""
        var image = ""
        
        if recipesOrFilms {
            guard let recipe = recipes?.results[indexPath.row]
            else { return cell }
            
            text = recipe.title
            image = recipe.image
        } else {
            guard let film = films?.results[indexPath.row]
            else { return cell }
            
            text = film.title
            image = "https://image.tmdb.org/t/p/w500\(film.poster_path)"
            
        }
        
        cell.textView.text = text
        loadImage(from: URL(string: image)!) { (image) in
            cell.photoView.image = image
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let recipe = recipes?.results[indexPath.row]
        else { return}
        
        let id = recipe.id
        
        sendRecipeRequest(of: id) { recipe in
            
        }
    }
}
