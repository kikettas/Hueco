//
//  ProfileV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Swarkn
import FirebaseAuth

class ProfileV: UIViewController, UIPageViewControllerDelegate {
    
    let disposeBag = DisposeBag()
    var model:ProfileVMProtocol!
    var selectedTab:BehaviorSubject<Int>!
    
    @IBOutlet weak var pageControllerContainer: UIView!
    @IBOutlet weak var logoutButton:UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var ratingsCount: UILabel!
    @IBOutlet weak var userRating: RatingView!
    @IBOutlet weak var setttingsButton: UIButton!
    @IBOutlet weak var hostedProductsButton: UIButton!
    @IBOutlet weak var participantProductsButton: UIButton!
    
    convenience init(model:ProfileVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        selectedTab = BehaviorSubject(value: 0)
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("me", comment: "Profile tab title"), image: UIImage(named: "ic_profile_tab_unselected"), selectedImage: UIImage(named: "ic_profile_tab_selected"))
        self.title = NSLocalizedString("profile", comment: "Profile view title")
    }
}


// MARK: - UIViewController

extension ProfileV{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        setupAppNavBarStyle()
        profilePicture.setBorderAndRadius(color: UIColor.mainDarkGrey.cgColor, width: 0.5, cornerRadius: 5)
        
        ratingsCount.text = "(143)"
        
        AppManager.shared.userLogged.asObservable()
            .map{return $0?.nickname ?? ""}
            .bindTo(userName.rx.text)
            .addDisposableTo(disposeBag)
        
        AppManager.shared.userLogged.asObservable()
            .map{return $0?.avatar}
            .bindNext{ avatar in
                self.profilePicture.kf.setImage(with: URL(string: avatar ?? ""), placeholder:UIImage(named:"ic_avatar_placeholder"))
        }.addDisposableTo(disposeBag)
    
    
        AppManager.shared.userLogged.asObservable()
            .map{return $0?.rating}
            .bindNext{
                self.self.userRating.rating = $0!
            }
            .addDisposableTo(disposeBag)
        
        setPageController()
        
        setttingsButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext { [unowned self] in
                self.showSettingsMenu()
            }.addDisposableTo(disposeBag)
    }
    
    func showSettingsMenu(){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logOutAction = UIAlertAction(title: NSLocalizedString("log_out", comment: "Log out"), style: .default){[unowned self] _ in
            self.model.logOut() {[weak self] (success, error) in
                guard let `self` = self else {
                    return
                }
                if let error = error{
                    print(error)
                    return
                }
                Navigator.navigateToSearchTab(from: self)
            }
        }
        
        let editProfileAction = UIAlertAction(title: NSLocalizedString("edit_profile", comment: "Edit profile"), style: .default){[unowned self] _ in

        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){[unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        actionSheet.addAction(editProfileAction)
        actionSheet.addAction(logOutAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func setPageController(){
        let vc = ProfilePagingV(model:ProfilePagingVM(), viewControllerOrigin:self.pageControllerContainer.frame.origin)
        self.addChildViewController(vc)
        vc.view.frame = CGRect(x: 0, y: 0, width: pageControllerContainer.frame.size.width, height: pageControllerContainer.frame.size.height)
        self.pageControllerContainer.addSubview(vc.view)
        vc.delegate = self

        vc.didMove(toParentViewController: self)
        
        selectedTab.observeOn(MainScheduler.instance).map(){$0 == 0}.subscribe(onNext:{[unowned self] isHostSelected in
            self.hostedProductsButton.isSelected = isHostSelected
            self.participantProductsButton.isSelected = !isHostSelected
        }).addDisposableTo(disposeBag)
        
        hostedProductsButton.rx.tap.observeOn(MainScheduler.instance).bindNext {[unowned self] in
            if(vc.viewControllers?.first != vc.pages[0]){
                vc.setViewControllers([vc.pages[0]], direction: .reverse, animated: true, completion: nil)
                self.hostedProductsButton.isSelected = true
                self.participantProductsButton.isSelected = false
            }
        }.addDisposableTo(disposeBag)
        
        participantProductsButton.rx.tap.observeOn(MainScheduler.instance).bindNext {[unowned self] in
            if(vc.viewControllers?.first != vc.pages[1]){
                vc.setViewControllers([vc.pages[1]], direction: .forward, animated: true, completion: nil)
                self.participantProductsButton.isSelected = true
                self.hostedProductsButton.isSelected = false
            }
            }.addDisposableTo(disposeBag)
    }
}

// MARK: - UIPageViewControllerDelegate

extension ProfileV{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if pageViewController.viewControllers?.first is ProfileParticipantProductsV{
            self.selectedTab.onNext(1)
        }else{
            self.selectedTab.onNext(0)
        }
    }
}
