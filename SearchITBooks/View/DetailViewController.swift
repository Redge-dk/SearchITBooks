//
//  DetailViewController.swift
//  SearchITBooks
//
//  Created by Regina on 6/29/25.
//
import UIKit
import SafariServices

class DetailViewController: UIViewController {
	
	private var isbn13: String!
	private var bookTitle: String?
	
	func configure(with isbn13: String, and title: String) {
		self.isbn13 = isbn13
		self.bookTitle = title
	}
	
	private let viewModel = DetailViewModel()
	
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
	@IBOutlet weak var viewError: UIView!
	@IBOutlet weak var labelErrorMsg: UILabel!
	
	@IBOutlet weak var labelTitle: UILabel!
	@IBOutlet weak var labelSubTitle: UILabel!
	@IBOutlet weak var imageViewThumbnail: UIImageView!
	@IBOutlet weak var labelAuthors: UILabel!
	@IBOutlet weak var labelPublisher: UILabel!
	@IBOutlet weak var labelLanguage: UILabel!
	@IBOutlet weak var labelIsbn10: UILabel!
	@IBOutlet weak var labelIsbn13: UILabel!
	@IBOutlet weak var labelPages: UILabel!
	@IBOutlet weak var labelYear: UILabel!
	@IBOutlet weak var stackViewRating: UIStackView!
	@IBOutlet weak var labelPrice: UILabel!
	@IBOutlet weak var labelDesc: UILabel!
	@IBOutlet weak var textViewUrl: LinkedTextView!
	@IBOutlet weak var textViewPdf: LinkedTextView!
	@IBOutlet weak var stackViewPdf: UIStackView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.largeTitleDisplayMode = .never
		
		labelTitle.accessibilityIdentifier = "DetailLabelTitle"
		
		Task {
			await MainActor.run {
				loadingIndicator.startAnimating()
			}
			
			await viewModel.fetchDetail(isbn13: isbn13)
			if let error = viewModel.error {
				viewError.isHidden = false
				labelErrorMsg.text = error.localizedDescription
			} else if let book = viewModel.book, let detail = book.detail {
				let image = await ImageLoader.shared.load(from: book.image)
				await MainActor.run {
					bind(book: book, detail: detail, image: image)
					loadingIndicator.stopAnimating()
				}
			} else {
				await MainActor.run {
					loadingIndicator.stopAnimating()
				}
			}
		}
	}
	
	private func bind(book: BookInfo, detail: BookDetailInfo, image: UIImage?) {
		labelTitle.text = book.title
		labelSubTitle.text = book.subtitle
		imageViewThumbnail.image = image
		labelPrice.text = book.price
		if let rating = Double(detail.rating) {
			configureRatingView(stackViewRating, with: rating)
		}
		labelAuthors.text = detail.authors
		labelPublisher.text = detail.publisher
		labelYear.text = detail.year
		labelPages.text = detail.pages
		labelLanguage.text = detail.language
		labelIsbn10.text = detail.isbn10
		labelIsbn13.text = book.isbn13
		labelDesc.text = detail.desc
		textViewUrl.text = book.url
		if detail.pdf.isEmpty == false {
			let pdfText = detail.pdf.map { "\($0.key) : \($0.value)" }.joined(separator: "\n")
			textViewPdf.text = pdfText
			stackViewPdf.isHidden = false
		} else {
			stackViewPdf.isHidden = true
		}
	}
	
	private func configureRatingView(_ stackView: UIStackView, with rating: Double) {
		
		stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

		let fullStars = Int(rating)
		let hasHalfStar = rating - Double(fullStars) >= 0.5
		let emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0)
		
		let addStar: (String) -> UIImageView = { systemName in
			let imageView = UIImageView(image: UIImage(systemName: systemName))
			imageView.tintColor = .systemYellow
			imageView.contentMode = .scaleAspectFit
			imageView.translatesAutoresizingMaskIntoConstraints = false
			NSLayoutConstraint.activate([
				imageView.widthAnchor.constraint(equalToConstant: 16),
				imageView.heightAnchor.constraint(equalToConstant: 16)
			])
			return imageView
		}

		let starTypes = Array(repeating: "star.fill", count: fullStars)
					+ (hasHalfStar ? ["star.leadinghalf.filled"] : [])
					+ Array(repeating: "star", count: emptyStars)
		for name in starTypes {
			stackView.addArrangedSubview(addStar(name))
		}
	}
}

extension DetailViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		navigationItem.title = scrollView.contentOffset.y > labelTitle.frame.maxY ? bookTitle : nil
	}
}

extension DetailViewController: UITextViewDelegate {
	func textView(_ textView: UITextView, primaryActionFor textItem: UITextItem, defaultAction: UIAction) -> UIAction? {
		if case .link(let url) = textItem.content {
			return UIAction(title: "link") { [weak self] _ in
				guard let self else { return }
				let safariVC = SFSafariViewController(url: url)
				self.present(safariVC, animated: true)
			}
		}
		return nil
	}
}

class LinkedTextView: UITextView {

	override func awakeFromNib() {
		super.awakeFromNib()
		setupStyle()
	}

	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		setupStyle()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupStyle()
	}

	private func setupStyle() {
		textContainerInset = .zero
		textContainer.lineFragmentPadding = 0
		
		dataDetectorTypes = [.link]
		isEditable = false
		isSelectable = true
		isScrollEnabled = false

		linkTextAttributes = [
			.foregroundColor: UIColor.systemBlue,
			.underlineStyle: NSUnderlineStyle.single.rawValue
		]
	}
}


	
