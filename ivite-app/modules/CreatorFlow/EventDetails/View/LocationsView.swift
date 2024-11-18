//
//  LocationsView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 12/10/2024.
//

import UIKit

final class LocationsView: BaseView {
    private let model: EventDetailsViewModel
    private let locationsHeader = IVHeaderLabel(text: "Locations")
    private let contentStackView = UIStackView()
    
    // Entries for Location, City, State, and Zip
    private let locationEntry = EntryWithTitleView(title: "Location")
    private let locationTextField: IVTextField
    private let cityEntry = EntryWithTitleView(title: "City")
    private let cityTextField: IVTextField
    private let stateAndZipStackView = UIStackView()
    private let stateEntry = EntryWithTitleView(title: "State")
    private let stateTextField: IVTextField
    private let zipEntry = EntryWithTitleView(title: "Zip")
    private let zipTextField: IVTextField
    
    init(model: EventDetailsViewModel) {
        self.model = model
        self.locationTextField = IVTextField(text: model.location, placeholder: "Location")
        self.cityTextField = IVTextField(text: model.city, placeholder: "City")
        self.stateTextField = IVTextField(text: model.state, placeholder: "State")
        self.zipTextField = IVTextField(text: model.zipCode, placeholder: "Zip", validationType: .zipCode)

        super.init(frame: .zero)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        
        // Configure the stack view
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        
        stateAndZipStackView.spacing = 10
        stateAndZipStackView.distribution = .fillEqually
        
        // Set content views for each entry
        locationEntry.setContentView(locationTextField)
        cityEntry.setContentView(cityTextField)
        stateEntry.setContentView(stateTextField)
        zipEntry.setContentView(zipTextField)
        
        locationTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        zipTextField.delegate = self
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        // Add header and content to the view hierarchy
        addSubview(locationsHeader)
        addSubview(contentStackView)
        
        stateAndZipStackView.addArrangedSubview(stateEntry)
        stateAndZipStackView.addArrangedSubview(zipEntry)
        // Add each entry to the stack view
        [
            locationEntry,
            cityEntry,
            stateAndZipStackView
        ].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        // Pin the header and stack view to the top of the view
        locationsHeader.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        contentStackView.autoPinEdge(.top, to: .bottom, of: locationsHeader, withOffset: 16)
        contentStackView.autoPinEdge(toSuperviewEdge: .leading)
        contentStackView.autoPinEdge(toSuperviewEdge: .trailing)
        contentStackView.autoPinEdge(toSuperviewEdge: .bottom)
    }
}

extension LocationsView: IVTextFieldDelegate {
    func textFieldDidChange(_ textField: IVTextField) {
        // Update the model based on which text field triggered the change
        if textField === locationTextField {
            model.location = textField.text
        } else if textField === cityTextField {
            model.city = textField.text
        } else if textField === stateTextField {
            model.state = textField.text
        } else if textField === zipTextField {
            model.zipCode = textField.text
        }
    }
}
