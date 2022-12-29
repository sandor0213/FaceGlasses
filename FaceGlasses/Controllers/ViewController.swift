//
//  ViewController.swift
//  FaceGlasses
//
//  Created by alexander_balogh on 29.12.2022.
//

import ARKit

final class ViewController: UIViewController {
    
    private struct Constant {
        static let faceTrackingNotSupportedText = "ARFaceTrackingConfiguration not supported"
        static let glassesNodeName = "glassesNode"
        static let faceNosePoint = 9
        static let objModelExtension = ".obj"
        static let colorsArray = [UIColor.red, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.magenta, UIColor.brown, UIColor.darkGray, UIColor.gray, UIColor.lightGray, UIColor.black, UIColor.orange, UIColor.purple, UIColor.white, UIColor.cyan, UIColor.link]
        static let glassesModelsArray = [GlassesModel(title: "1", scaleFactor: 0.0041), GlassesModel(title: "2", scaleFactor: 0.048), GlassesModel(title: "1", scaleFactor: 0.0041), GlassesModel(title: "2", scaleFactor: 0.048), GlassesModel(title: "1", scaleFactor: 0.0041), GlassesModel(title: "2", scaleFactor: 0.048), GlassesModel(title: "1", scaleFactor: 0.0041), GlassesModel(title: "2", scaleFactor: 0.048)]
    }
    
    private enum CellType: Int, CaseIterable {
        case glasses
        case colors
    }
    
    @IBOutlet private var sceneView: ARSCNView!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var settingCollectionView: UICollectionView!
    
    private var node: SCNNode?
    private var glassIndex = 0
    private var colorIndex = -1
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARFaceTrackingConfiguration.isSupported else {
            infoLabel.text = Constant.faceTrackingNotSupportedText
            return
        }
        
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        settingCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: NSCollectionLayoutSection.collectionLayoutSection)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device else {
                  return nil
              }
        
        DispatchQueue.main.async { [weak self] in
            self?.showGlassesSettings()
        }
        let faceGeometry = ARSCNFaceGeometry(device: device)
        node = SCNNode(geometry: faceGeometry)
        node?.geometry?.firstMaterial?.transparency = 0
        
        updateGlassesNodeSettings()
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
              let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
                  return
              }
        
        faceGeometry.update(from: faceAnchor.geometry)
        updateFeatures(for: node, using: faceAnchor)
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        CellType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == CellType.glasses.rawValue ? Constant.glassesModelsArray.count : section == CellType.colors.rawValue ? Constant.colorsArray.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case CellType.glasses.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingGlassCollectionViewCell.identifier, for: indexPath) as! SettingGlassCollectionViewCell
            let settingGlasses = SettingGlasses(imageTitle: Constant.glassesModelsArray[indexPath.item].title, isSelected: glassIndex == indexPath.item)
            cell.setup(settingGlasses)
            return cell
        case CellType.colors.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingColorCollectionViewCell.identifier, for: indexPath) as! SettingColorCollectionViewCell
            let settingColor = SettingColor(color: Constant.colorsArray[indexPath.item], isSelected: colorIndex == indexPath.item)
            cell.setup(settingColor)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingGlassCollectionViewCell.identifier, for: indexPath) as! SettingGlassCollectionViewCell
            return cell
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var oldIndexPath: IndexPath?
        switch indexPath.section {
        case CellType.glasses.rawValue:
            if glassIndex >= 0 {
                oldIndexPath = IndexPath(item: glassIndex, section: indexPath.section)
            }
            glassIndex = indexPath.item
        case CellType.colors.rawValue:
            if colorIndex >= 0 {
                oldIndexPath = IndexPath(item: colorIndex, section: indexPath.section)
            }
            colorIndex = indexPath.item
        default:
            break
        }
        updateGlassesNodeSettings()
        guard let oldIndexPath = oldIndexPath else {
            collectionView.reloadItems(at: [indexPath])
            return
        }
        collectionView.reloadItems(at: [oldIndexPath, indexPath])
    }
}

private extension ViewController {
    func reload() {
        
    }
    func showGlassesSettings() {
        infoLabel.isHidden = true
        settingCollectionView.isHidden = false
    }
    
    func updateFeatures(for node: SCNNode, using anchor: ARFaceAnchor) {
        let child = node.childNode(withName: Constant.glassesNodeName, recursively: false)
        let vertices = [anchor.geometry.vertices[Constant.faceNosePoint]]
        child?.updatePosition(for: vertices)
    }
    
    func updateGlassesNodeSettings() {
        node?.childNode(withName: Constant.glassesNodeName, recursively: false)?.removeFromParentNode()
        guard Constant.glassesModelsArray.indices.contains(glassIndex) else { return }
        let glassScene = SCNScene(named: "\(Constant.glassesModelsArray[glassIndex].title)\(Constant.objModelExtension)")
        guard let glassSceneNode: SCNNode = glassScene?.rootNode else { return }
        glassSceneNode.name = Constant.glassesNodeName
        glassSceneNode.simdScale = Constant.glassesModelsArray[glassIndex].defineScaleFloat3()
        
        if Constant.colorsArray.indices.contains(colorIndex) {
            glassSceneNode.childNodes.forEach({
                $0.geometry?.materials.forEach({ (material) in
                    material.diffuse.contents = Constant.colorsArray[colorIndex]
                })
            })
        }
        
        node?.addChildNode(glassSceneNode)
    }
}
