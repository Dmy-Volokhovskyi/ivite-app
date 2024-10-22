//
//  DatePickerViewController.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 15/10/2024.
//

import UIKit

protocol DatePickerViewControllerDelegate: AnyObject {
    func didPickDate(_ date: Date)
}

final class DatePickerViewController: BaseViewController {
    private let datePickerHeader = IVHeaderLabel(text: "Pick a Date")
    private let datePicker = UIDatePicker()
    private let saveButton = UIButton(configuration: .primary(title: "Save"))
    
    weak var delegate: DatePickerViewControllerDelegate?
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = .white
        
        // Configure date picker
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .inline
//        datePicker.tintColor = . // Use your app's accent color
        
        saveButton.addTarget(self, action: #selector(didTouchSaveButton), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            datePickerHeader,
            datePicker,
            saveButton
        ].forEach({ view.addSubview($0) })
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        datePickerHeader.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 32, left: 16, bottom: .zero, right: 16), excludingEdge: .bottom)
        
        datePicker.autoPinEdge(.top, to: .bottom, of: datePickerHeader, withOffset: 12)
        datePicker.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        datePicker.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        saveButton.autoPinEdge(.top, to: .bottom, of: datePicker, withOffset: 24)
        saveButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        saveButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        saveButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 32, relation: .greaterThanOrEqual)
    }
    
    @objc private func didTouchSaveButton(_ sender: UIButton) {
        let selectedDate = datePicker.date
        delegate?.didPickDate(selectedDate)
        self.dismiss(animated: true)
    }
}
