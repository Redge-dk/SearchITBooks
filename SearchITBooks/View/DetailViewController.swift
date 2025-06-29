//
//  DetailViewController.swift
//  SearchITBooks
//
//  Created by Regina on 6/29/25.
//
import UIKit

class DetailViewController: UIViewController {

	private var isbn13: String!
	
	func configure(with isbn13: String, and title: String) {
		self.isbn13 = isbn13
		self.title = title
	}
	
	private let viewModel = DetailViewModel()

	@IBOutlet weak var labelTitle: UILabel!
	@IBOutlet weak var labelSubTitle: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var labelAuthors: UILabel!
	@IBOutlet weak var labelPublisher: UILabel!
	@IBOutlet weak var labelLanguage: UILabel!
	@IBOutlet weak var labelIsbn10: UILabel!
	@IBOutlet weak var labelIsbn13: UILabel!
	@IBOutlet weak var labelPages: UILabel!
	@IBOutlet weak var labelYear: UILabel!
	@IBOutlet weak var labelRating: UILabel!
	@IBOutlet weak var labelDesc: UILabel!
	@IBOutlet weak var labelPrice: UILabel!
	@IBOutlet weak var labelUrl: UILabel!
	@IBOutlet weak var labelPdf: UILabel?
	
	override func viewDidLoad() {
		super.viewDidLoad()

		viewModel.fetchDetail(isbn13: isbn13)
		Task {
			for await book in viewModel.$book.values {
				await MainActor.run {
					guard let book, let detail = book.detail else { return }
					labelTitle.text = book.title
					labelSubTitle.text = book.subtitle
					labelAuthors.text = "Authors : " + detail.authors
					labelPublisher.text = "Publisher : " + detail.publisher
					labelLanguage.text = "Language : " + detail.language
					labelIsbn10.text = "isbn 10 : " + detail.isbn10
					labelIsbn13.text = "isbn 13 : " + book.isbn13
					labelPages.text = "Pages : " + detail.pages
					labelYear.text = "Year : " + detail.year
					labelRating.text = "Rating : " + detail.rating
					labelDesc.text = "Desc : " + detail.desc
					labelPrice.text = "Price : " + book.price
					labelUrl.text = "Url : " + book.url
					if detail.pdf.isEmpty == false {
						let str: String = detail.pdf.reduce("Pdf") { partialResult, newValue in
							"\(partialResult)\n\(newValue.key): \(newValue.value)"
						}
						labelPdf?.text = str
						labelPdf?.isHidden = false
					} else {
						labelPdf?.isHidden = true
					}
				}
			}
		}
	}
}
