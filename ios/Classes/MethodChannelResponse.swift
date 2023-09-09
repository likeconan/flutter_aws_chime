//
//  MethodChannelResponse.swift
//  flutter_aws_chime
//
//  Created by Conan on 2023/9/9.
//

import Foundation

class MethodChannelResponse {
    let result: Bool
    let arguments: Any?

    init(result res: Bool, arguments args: Any?) {
        self.result = res
        self.arguments = args
    }

    func toFlutterCompatibleType() -> [String: Any?] {
        return ["result": result, "arguments": arguments]
    }
}

