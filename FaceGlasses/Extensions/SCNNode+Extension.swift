//
//  SCNNode+Extension.swift
//  FaceGlasses
//
//  Created by alexander_balogh on 29.12.2022.
//

import SceneKit

extension SCNNode {
  
  func updatePosition(for vectors: [vector_float3]) {
    let newPos = vectors.reduce(vector_float3(), +) / Float(vectors.count)
    position = SCNVector3(newPos)
  }
}

