// import LASwift
import TensorFlow

public protocol PCATransformer: FitTransformer {
    var components: Matrix? { get }
}

public enum SvdSolver: String {
    case full
}

public struct PCA: PCATransformer {
    public let nComponents: Int
    let svdSolver: SvdSolver

    public var nSamples: Int?
    public var nFeatures: Int?
    public var noiseVariance: Float?
    public var components: Matrix?
    public var explainedVariance: Matrix?
    public var explainedVarianceRatio: Matrix?
    public var singularValues: Matrix?

    public init(nComponents: Int, svdSolver: String) throws {
        guard nComponents > 0 else {
            throw EstimatorError.notSupportedParameter("nComponents should be > 0")
        }
        self.nComponents = nComponents
        let svdSolverOpt = SvdSolver(rawValue: svdSolver)
        guard svdSolverOpt != nil else {
            throw EstimatorError.notSupportedParameter("not supported svd solver!")
        }
        self.svdSolver = svdSolverOpt!
    }

    // public func fit(data x: Matrix, labels y: Matrix) -> PCATransformer {
    public mutating func fit(data x: Tensor<Float>, labels y: Tensor<Float>) {
        // TODO: check if X is sparse matrix
        // TODO: validate data

        switch self.svdSolver {
        case .full:
            self.fitFull(X: x)
        }
        // return self
    }

    mutating func fitFull(X: Matrix) -> (u: Tensor<Float>, s: Tensor<Float>, v: Tensor<Float>) {
        let nSamples = X.shape[0]
        let nFeatures = X.shape[1]

        // center data
        let mean = X.mean(alongAxes: Tensor<Int32>(0))
        let centeredX = X - mean
        print(X)
        print(centeredX)

        // let (u, s, v) = _Raw.svd(center, fullMatrices: false)
        // print(Matrix(v.transposed())[0..., 0 ..< 3])
        let (U, S, V) = _Raw.svd(centeredX)

        // TODO: flip eigenvector's sign to enforce deterministic output
        let explainedVariance = pow(S, 2) / Float(nSamples - 1)
        let totalVar = explainedVariance.sum()
        let explainedVarianceRatio = explainedVariance / totalVar
        let singularValues = S

        if self.nComponents < min(nFeatures, nSamples) {
            self.noiseVariance = Float(explainedVariance[self.nComponents...].mean())
        } else {
            self.noiseVariance = 0.0
        }

        self.components = V.transposed()[0 ..< self.nComponents]
        // self.components = Matrix(V[0 ..< self.nComponents])
        self.nSamples = nSamples
        self.nFeatures = nFeatures
        self.explainedVariance = explainedVariance
        self.explainedVarianceRatio = explainedVarianceRatio
        self.singularValues = singularValues

        return (U, S, V)
    }

    // TODO:
    public func transform(X: Matrix) -> Matrix {
        return X
    }

    // TODO:
    public func fitTranform(X: Matrix) -> Matrix {
        return X
    }
}