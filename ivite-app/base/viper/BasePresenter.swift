//
//  BasePresenter.swift
//  ivite-app
//
//  Created by GoApps Developer on 01/09/2024.
//


protocol BasePresenter: BaseInteractorDelegate {
    associatedtype Router: BaseRouter
    associatedtype ViewInterface: BaseViewController
    
    var router: Router { get }
    var viewInterface: ViewInterface? { get set }
}
