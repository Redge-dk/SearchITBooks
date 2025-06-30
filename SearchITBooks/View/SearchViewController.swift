//
//  SearchViewController.swift
//  SearchITBooks
//
//  Created by Regina on 6/29/25.
//
import UIKit

class BookListCell: UITableViewCell {
	@IBOutlet weak var labelTitle: UILabel!
	@IBOutlet weak var labelSubTitle: UILabel!
	@IBOutlet weak var labelIsbn13: UILabel!
	@IBOutlet weak var labelPrice: UILabel!
	@IBOutlet weak var labelUrl: UILabel!
	
	func configure(with book: BookInfo) {
		labelTitle.text = book.title
		labelSubTitle.isHidden = book.subtitle.isEmpty
		labelSubTitle.text = book.subtitle
		labelIsbn13.text = book.isbn13
		labelPrice.text = book.price
		labelUrl.text = book.url
	}
}

class SearchViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	
	private let viewModel = SearchViewModel()

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "IT Books Search"
		requestData()
	}
	
	func requestData() {
		Task {
			for await _ in viewModel.$books.values {
				self.tableView.reloadData()
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail",
		   let destination = segue.destination as? DetailViewController,
		   let indexPath = tableView.indexPathForSelectedRow {
			
			let selectedBook = viewModel.books[indexPath.row]
			destination.configure(with: selectedBook.isbn13, and: selectedBook.title)
		}
	}
}

extension SearchViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text, text.isEmpty == false else { return }
		Task {
			await viewModel.search(keyword: text)
			searchBar.resignFirstResponder()
		}
	}

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText.isEmpty {
			viewModel.reset()
			tableView.reloadData()
		}
	}
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.books.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookListCell", for: indexPath) as? BookListCell else {
			return UITableViewCell()
		}
		let book = viewModel.books[indexPath.row]
		cell.configure(with: book)

		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("did select")
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		Task {
			await viewModel.loadNextPage(currentIndex: indexPath.row)
		}
	}
}
