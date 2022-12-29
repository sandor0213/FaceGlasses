//
//  GlassesModel.swift
//  FaceGlasses
//
//  Created by alexander_balogh on 29.12.2022.
//

import ARKit

struct GlassesModel {
    var title: String
    var scaleFactor: Float
    func defineScaleFloat3() -> simd_float3 {
        simd_float3(scaleFactor, scaleFactor, scaleFactor)
    }
}
