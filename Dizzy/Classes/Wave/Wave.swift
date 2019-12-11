//
//  Wave.swift
//  Small World
//
//  Created by ジャティン on 2019/07/03.
//  Copyright © 2019 Crafts Inc. All rights reserved.
//

import UIKit
import CoreGraphics.CGBase

public typealias WavePath = UIBezierPath

public final class WaveView: UIView {

    // MARK: Public and IBInspectable properties
    /**
     Wave depth.
     - Depth range: 0.0 ... 1.0.
     - Default value is 0.37
     */
    @IBInspectable
    public var depth: CGFloat = WaveModel.Defaults.depth {
        didSet {
            waterWaveModel.depth = self.depth
        }
    }

    /**
     Wave amplitude
     - Set bigger than 0.0
     - Default value is 39.0
     */
    @IBInspectable
    public var amplitude: CGFloat = WaveModel.Defaults.amplitude {
        didSet {
            waterWaveModel.amplitude = self.amplitude
        }
    }

    /**
     Wave speed
     - Set bigger than 0.0
     - Default value is 0.009
     */
    @IBInspectable
    public var speed: CGFloat = WaveModel.Defaults.speed {
        didSet {
            waterWaveModel.speed = self.speed
        }
    }

    /**
     Wave Angular Velocity
     - Set bigger than 0.0
     - Default value is 0.37
     */
    @IBInspectable
    public var angularVelocity: CGFloat = WaveModel.Defaults.angularVelocity {
        didSet {
            waterWaveModel.angularVelocity = self.angularVelocity
        }
    }

    /**
     Animate State
     */
    public var isAnimating: Bool {
        return waterWaveModel.isAnimating
    }

    // MARK: Private properties
    private let waterWaveModel = WaveModel()

    // MARK: Initializations
    public init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: Layout Subviews
    override public func layoutSubviews() {
        super.layoutSubviews()
        waterWaveModel.frame = frame
    }

    // MARK: Public methods
    public func startAnimation() {
        waterWaveModel.start()
    }

    public func stopAnimation() {
        waterWaveModel.stop()
    }

    /**
     Add background color animation with 2 base colors
     - parameter fromColor:
     Starting Color.
     - parameter toColor:
     Finish Color.
     - parameter duration:
     Duration of animation in seconds.
     This specify animation duration from color to color.
     Default is 2.0.
     */
    public func addBackgroundColorAnimation(from fromColor: UIColor, to toColor: UIColor, duration: CFTimeInterval = 2.0) {
        let animation = CABasicAnimation(keyPath: "backgroundColor")

        animation.duration = duration

        animation.fromValue = fromColor.cgColor
        animation.toValue = toColor.cgColor

        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.autoreverses = true

        layer.add(animation, forKey: "backgroundColorAnimation")
    }

    // MARK: Private methods
    private func commonInit() {
        waterWaveModel.frame = self.frame
        waterWaveModel.delegate = self
    }
}

extension WaveView: WaveModelDelegate {
    public func waterWaveModel(_ waterWaveModel: WaveModel, didUpdate wavePath: UIBezierPath) {
        let shape = CAShapeLayer()
        shape.path = wavePath.cgPath
        self.layer.mask = shape
    }
}

public final class WaveModel {
    // MARK: Public properties
    /// Any class instance delegate who conforms to protocol CLWaterWaveModelDelegate
    public weak var delegate: WaveModelDelegate?

    /// Frame to calculate the wave
    public var frame: CGRect!

    /// Wave depth.
    /// - Depth range: 0.0 ... 1.0.
    /// - Default value is 0.37
    public var depth: CGFloat!

    /// Wave amplitude
    /// - Set bigger than 0.0
    /// - Default value is 39.0
    public var amplitude: CGFloat!

    /// Wave speed
    /// - Set bigger than 0.0
    /// - Default value is 0.009
    public var speed: CGFloat!

    /// Wave Angular Velocity
    /// - Set bigger than 0.0
    /// - Default value is 0.37
    public var angularVelocity: CGFloat!

    /// Animate State
    public private(set) var isAnimating = false

    // MARK: Private properties
    private var phase: CGFloat = 0
    private var displayLink: CADisplayLink!

    // MARK: Initializations
    public init() {
        setDefault()
    }

    public init(ownerFrame frame: CGRect) {
        self.frame = frame
        setDefault()
    }

    // MARK: Public methods
    /// Start to calculate the path
    public func start() {
        guard displayLink == nil, frame != nil, !isAnimating else {
            return
        }

        isAnimating = true

        displayLink = CADisplayLink(target: self, selector: #selector(wave))
        displayLink.add(to: .main, forMode: .default)
    }

    /// Stop to calculate
    public func stop() {
        guard displayLink != nil, isAnimating else {
            return
        }

        isAnimating = false

        displayLink.isPaused = true
        displayLink.invalidate()
        displayLink = nil
    }

    // MARK: Private methods
    private func setDefault() {
        self.amplitude = Defaults.amplitude
        self.speed = Defaults.speed
        self.angularVelocity = Defaults.angularVelocity
        self.depth = Defaults.depth
    }

    @objc private func wave() {
        phase += abs(speed)
        let path = createWaterWavePath()
        self.delegate?.waterWaveModel(self, didUpdate: path)
    }

    private func createWaterWavePath() -> WavePath {
        let path = WavePath()
        path.lineWidth = 1

        let waterHeightY = (1 - (abs(depth) > 1.0 ? 1.0 : abs(depth))) * frame.size.height

        path.move(to: CGPoint(x: 0, y: waterHeightY))

        var y = waterHeightY

        for x in stride(from: 0 as CGFloat, to: frame.size.width, by: +1 as CGFloat) {
            y = abs(amplitude) * sin(x / 180 * CGFloat.pi * abs(angularVelocity) + phase / CGFloat.pi * 4) + waterHeightY
            path.addLine(to: CGPoint(x: x, y: y))
        }

        path.addLine(to: CGPoint(x: frame.size.width, y: y))
        path.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height))
        path.addLine(to: CGPoint(x: 0, y: frame.size.height))
        path.close()

        return path
    }
}

public protocol WaveModelDelegate: class {
    func waterWaveModel(_ waterWaveModel: WaveModel, didUpdate wavePath: WavePath)
}

public extension WaveModel {
    enum Defaults {
        public static let amplitude: CGFloat = 39.0
        public static let speed: CGFloat = 0.009
        public static let angularVelocity: CGFloat = 0.37
        public static let depth: CGFloat = 0.37
    }
}
