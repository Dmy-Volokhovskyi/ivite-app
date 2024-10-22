//
//  EventDetailsView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 11/10/2024.
//

import UIKit

protocol EventDetailsViewDelegate: AnyObject {
    func eventDetailsViewDidTapPickDate(_ view: EventDetailsView)
}

final class EventDetailsView: BaseView {
    private let model: EventDetailsViewModel
    private let eventDetailsTitleLabel = IVHeaderLabel(text: "Event Details")
    private let eventTitleTextFiel = IVTextField(placeholder: "Your event Title")
    private let eventTitleEntry = EntryWithTitleView(title: "Event Title", isRequired: true)
    private let dateTextControl: IVControl
    private let eventDateEntry = EntryWithTitleView(title: "Date/time", isRequired: true)
    private let timePickerStack = UIStackView()
    private let timePicker: IVControl
    #warning("Add timezone picker")
    private let timezonePicker = IVControl(text: "WST")
    
    weak var delegate: EventDetailsViewDelegate?
    
    init(model: EventDetailsViewModel) {
        self.model = model
        self.dateTextControl = IVControl(text: model.formattedDate(), placeholder: "dd/mm/yyyy")
        self.timePicker = IVControl(text: model.formattedTime(), placeholder: "00:00")
        super.init(frame: .zero)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        
        timePickerStack.spacing = 6
        
        eventTitleEntry.setContentView(eventTitleTextFiel)
        eventDateEntry.setContentView(dateTextControl)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            eventDetailsTitleLabel,
            eventTitleEntry,
            eventDateEntry,
            timePickerStack
        ].forEach({ addSubview($0) })
        
        timePickerStack.addArrangedSubview(timePicker)
        timePickerStack.addArrangedSubview(timezonePicker)
        
        dateTextControl.addTarget(self, action: #selector(didTouchDatePicker), for: .touchUpInside)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        eventDetailsTitleLabel.autoPinEdgesToSuperviewSafeArea(with: .zero,
                                                            excludingEdge: .bottom)
        eventTitleEntry.autoPinEdge(.top, to: .bottom, of: eventDetailsTitleLabel, withOffset: 16)
        eventTitleEntry.autoPinEdge(toSuperviewEdge: .leading)
        eventTitleEntry.autoPinEdge(toSuperviewEdge: .trailing)
        
        eventDateEntry.autoPinEdge(.top, to: .bottom, of: eventTitleEntry, withOffset: 12)
        eventDateEntry.autoPinEdge(toSuperviewEdge: .leading)
        eventDateEntry.autoPinEdge(toSuperviewEdge: .trailing)
        
        timePickerStack.autoPinEdge(.top, to: .bottom, of: eventDateEntry, withOffset: 6)
        timePickerStack.autoPinEdge(toSuperviewEdge: .leading)
        timePickerStack.autoPinEdge(toSuperviewEdge: .trailing)
        timePickerStack.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    @objc func didTouchDatePicker(_ sender: UIControl) {
        print("HellO! MDFK!")
        delegate?.eventDetailsViewDidTapPickDate(self)
    }
    
    public func updateTimeDate(with time: String, date: String) {
        dateTextControl.text = date
        timePicker.text = time
    }
}
