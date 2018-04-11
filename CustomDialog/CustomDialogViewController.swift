//
//  CustomDialogViewController.swift
//  CustomDialog
//
//  Created by hiraya.shingo on 2018/04/11.
//  Copyright © 2018 hiraya.shingo. All rights reserved.
//

import UIKit

class CustomDialogViewController: UIViewController, UIViewControllerTransitioningDelegate {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    @IBAction func okButtonDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func transparentButtonDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DialogPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DialogAnimationController(forPresented: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DialogAnimationController(forPresented: false)
    }
}

class DialogPresentationController: UIPresentationController {
    
    /// 呼び出し元のViewControllerの上に重ねるオーバーレイ
    private let overlayView = UIView()
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        // 表示トランジション開始前の処理
        overlayView.frame = containerView!.bounds
        overlayView.backgroundColor = .black
        overlayView.alpha = 0.0
        containerView!.insertSubview(overlayView, at: 0)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            self.overlayView.alpha = 0.5
        })
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        // 非表示トランジション開始前の処理
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            self.overlayView.alpha = 0.0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        
        // 非表示トランジション終了時の処理
        if completed {
            overlayView.removeFromSuperview()
        }
    }
    
    override var frameOfPresentedViewInContainerView : CGRect {
        return containerView!.bounds
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        /// レイアウト開始前の処理
        overlayView.frame = containerView!.bounds
        presentedView!.frame = frameOfPresentedViewInContainerView
    }
}

class DialogAnimationController : NSObject, UIViewControllerAnimatedTransitioning {
    
    let forPresented: Bool
    
    init(forPresented: Bool) {
        self.forPresented = forPresented
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if (forPresented) {
            presentAnimateTransition(transitionContext: transitionContext)
        } else {
            dismissAnimateTransition(transitionContext: transitionContext)
        }
    }
    
    func presentAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let viewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        containerView.addSubview(viewController.view)
        viewController.view.alpha = 0.0
        viewController.view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: [.curveEaseOut],
                       animations: {
                        viewController.view.alpha = 1.0
                        viewController.view.transform = CGAffineTransform.identity
        },
                       completion: { finished in
                        transitionContext.completeTransition(true)
        })
    }
    
    func dismissAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let viewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: {
                        viewController.view.alpha = 0.0
        },
                       completion: { finished in
                        transitionContext.completeTransition(true)
        })
    }
}
