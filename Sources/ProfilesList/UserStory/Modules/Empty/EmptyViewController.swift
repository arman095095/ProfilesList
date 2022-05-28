//
//  File.swift
//  
//
//  Created by Арман Чархчян on 28.05.2022.
//

import Foundation
import DesignSystem
import UIKit

protocol EmptyViewStringFactoryProtocol {
    var title: String { get }
    var description: String { get }
    var buttonTitle: String { get }
}

protocol EmptyViewOutput: AnyObject {
    func initialLoad()
}

final class EmptyViewController: UIViewController {
    
    weak var output: EmptyViewOutput?
    private let titleLabel = UILabel()
    private let stringFactory: EmptyViewStringFactoryProtocol = ProfilesListStringFactory()
    private let button = ButtonsFactory.whiteLoadButton
    
    private lazy var mainStackView: UIStackView = {
        UIStackView(arrangedSubviews: [titleLabel, button])
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupActions()
    }
}

private extension EmptyViewController {
    func setupViews() {
        view.backgroundColor = .mainWhite()
        view.addSubview(mainStackView)
        mainStackView.spacing = 10
        mainStackView.axis = .vertical
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = stringFactory.title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        button.setTitle(stringFactory.buttonTitle, for: .normal)
    }
    
    func setupConstraints() {
        mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
    }
    
    func setupActions() {
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        button.loading()
        output?.initialLoad()
    }
}
