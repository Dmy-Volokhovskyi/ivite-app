protocol PaymentInteractorDelegate: AnyObject {
}

final class PaymentInteractor: BaseInteractor {
    weak var delegate: PaymentInteractorDelegate?
    
    var selectedOption: PaymentOption? = PaymentOption(title: "Large", detail: "100 invitations", price: 39.99, billingCycle: .monthly)
    
    let paymentOptions: [PaymentOption] = [
            PaymentOption(title: "Small", detail: "15 invitations", price: 9.99, billingCycle: .monthly),
            PaymentOption(title: "Medium", detail: "40 invitations", price: 79.99, billingCycle: .monthly),
            PaymentOption(title: "Large", detail: "100 invitations", price: 39.99, billingCycle: .monthly),
            PaymentOption(title: "Extra Large", detail: "500 invitations", price: 79.99, billingCycle: .monthly),
            PaymentOption(title: "Pro Member", detail: "Unlimited invitations", price: 99.99, billingCycle: .yearly)
        ]
}
