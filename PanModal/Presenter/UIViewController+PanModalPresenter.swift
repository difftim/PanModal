//
//  UIViewController+PanModalPresenterProtocol.swift
//  PanModal
//
//  Copyright © 2019 Tiny Speck, Inc. All rights reserved.
//

#if os(iOS)
import UIKit

/**
 Extends the UIViewController to conform to the PanModalPresenter protocol
 */
extension UIViewController: PanModalPresenter {

    /**
     A flag that returns true if the topmost view controller in the navigation stack
     was presented using the custom PanModal transition

     - Warning: ⚠️ Calling `presentationController` in this function may cause a memory leak. ⚠️

     In most cases, this check will be used early in the view lifecycle and unfortunately,
     there's an Apple bug that causes multiple presentationControllers to be created if
     the presentationController is referenced here and called too early resulting in
     a strong reference to this view controller and in turn, creating a memory leak.
     */
    public var isPanModalPresented: Bool {
        return (transitioningDelegate as? PanModalPresentationDelegate) != nil
    }

    /**
     Configures a view controller for presentation using the PanModal transition

     - Parameters:
        - viewControllerToPresent: The view controller to be presented
        - sourceView: The view containing the anchor rectangle for the popover.
        - sourceRect: The rectangle in the specified view in which to anchor the popover.
        - completion: The block to execute after the presentation finishes. You may specify nil for this parameter.

     - Note: sourceView & sourceRect are only required for presentation on an iPad.
     */
    public func presentPanModal(_ viewControllerToPresent: PanModalPresentable.LayoutType,
                                sourceView: UIView? = nil,
                                sourceRect: CGRect = .zero,
                                completion: (() -> Void)? = nil) {

        /**
         Here, we deliberately do not check for size classes. More info in `PanModalPresentationDelegate`
         */
        let presentationDelegate = PanModalPresentationDelegate.default
        presentationDelegate.disableAppearanceTransition = viewControllerToPresent.disableAppearanceTransition
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewControllerToPresent.modalPresentationStyle = .popover
            viewControllerToPresent.popoverPresentationController?.sourceRect = sourceRect
            viewControllerToPresent.popoverPresentationController?.sourceView = sourceView ?? view
            viewControllerToPresent.popoverPresentationController?.delegate = presentationDelegate
        } else {
            viewControllerToPresent.modalPresentationStyle = .custom
            viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
            viewControllerToPresent.transitioningDelegate = presentationDelegate
        }

        present(viewControllerToPresent, animated: true, completion: completion)
    }

}
#endif
