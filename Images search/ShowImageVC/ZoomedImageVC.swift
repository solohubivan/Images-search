//
//  ZoomedImageVC.swift
//  Images search
//
//  Created by Ivan Solohub on 14.03.2024.
//

import Foundation
import UIKit

class ZoomedImageViewController: UIViewController {

    private var mainImageView: UIImageView!
    private var scrollView: UIScrollView!

    private var zoomableImage: UIImage

    init(zoomableImage: UIImage) {
        self.zoomableImage = zoomableImage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    }
    
    // MARK: - setup UI
    
    private func setupUI() {
        setupScrollView()
        setupImageView()
        setupDoubleTapGesture()
        setupPanGesture()
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func setupImageView() {
        mainImageView = UIImageView(image: zoomableImage)
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.frame = scrollView.bounds
        mainImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mainImageView.isUserInteractionEnabled = true

        scrollView.addSubview(mainImageView)
        view.addSubview(scrollView)
    }
    
    private func setupDoubleTapGesture() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        mainImageView.addGestureRecognizer(doubleTapGesture)
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        mainImageView.addGestureRecognizer(panGesture)
    }

    // MARK: - actions
    
    @objc private func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            let center = recognizer.location(in: mainImageView)
            let zoomRect = CGRect(x: center.x, y: center.y, width: 1, height: 1)
            scrollView.zoom(to: zoomRect, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
    
    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: scrollView)

        switch recognizer.state {
        case .changed:
            if scrollView.contentOffset.y <= .zero && translation.y > .zero {
                view.alpha = 1 - translation.y / 100
            }
        case .ended:
            if scrollView.contentOffset.y <= .zero && translation.y > 100 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.alpha = 1.0
                }
            }
        default:
            break
        }
    }
}

// MARK: - extensions

extension ZoomedImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mainImageView
    }
}
