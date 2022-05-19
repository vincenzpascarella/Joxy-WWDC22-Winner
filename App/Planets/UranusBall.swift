//
//  UranusBall.swift
//  WWDC22 Vincenzo Pascarella
//
//  Created by Vincenzo Pascarella on 23/04/22.
//

import Foundation
import RealityKit
import simd
import Combine

@available(iOS 13.0, macOS 10.15, *)
public enum UranusBall {

    public enum LoadRealityFileError: Error {
        case fileNotFound(String)
    }

    private static var streams = [Combine.AnyCancellable]()

    public static func loadBox() throws -> UranusBall.Box {
        guard let realityFileURL = Foundation.Bundle(for: UranusBall.Box.self).url(forResource: "UranusBall", withExtension: "reality") else {
            throw UranusBall.LoadRealityFileError.fileNotFound("UranusBall.reality")
        }

        let realityFileSceneURL = realityFileURL.appendingPathComponent("Box", isDirectory: false)
        let anchorEntity = try UranusBall.Box.loadAnchor(contentsOf: realityFileSceneURL)
        return createBox(from: anchorEntity)
    }

    public static func loadBoxAsync(completion: @escaping (Swift.Result<UranusBall.Box, Swift.Error>) -> Void) {
        guard let realityFileURL = Foundation.Bundle(for: UranusBall.Box.self).url(forResource: "UranusBall", withExtension: "reality") else {
            completion(.failure(UranusBall.LoadRealityFileError.fileNotFound("UranusBall.reality")))
            return
        }

        var cancellable: Combine.AnyCancellable?
        let realityFileSceneURL = realityFileURL.appendingPathComponent("Box", isDirectory: false)
        let loadRequest = UranusBall.Box.loadAnchorAsync(contentsOf: realityFileSceneURL)
        cancellable = loadRequest.sink(receiveCompletion: { loadCompletion in
            if case let .failure(error) = loadCompletion {
                completion(.failure(error))
            }
            streams.removeAll { $0 === cancellable }
        }, receiveValue: { entity in
            completion(.success(UranusBall.createBox(from: entity)))
        })
        cancellable?.store(in: &streams)
    }

    private static func createBox(from anchorEntity: RealityKit.AnchorEntity) -> UranusBall.Box {
        let box = UranusBall.Box()
        box.anchoring = anchorEntity.anchoring
        box.addChild(anchorEntity)
        return box
    }

    public class Box: RealityKit.Entity, RealityKit.HasAnchoring {

        public var ball: RealityKit.Entity? {
            return self.findEntity(named: "Ball")
        }



    }

}

