//
//  URL+Extension.swift
//  STRemotePlayerExample
//
//  Created by xiudou on 2017/6/19.
//  Copyright © 2017年 CoderST. All rights reserved.
//

import UIKit

extension URL {
    // url -> sreamingUrl
    func streamingURL()->URL?{
        guard var compents = URLComponents(string: absoluteString) else { return nil}
        compents.scheme = "streaming"  // streaming
        return compents.url
    }
    
    // url -> http url
    func httpUrl()->URL?{
        guard var compents = URLComponents(string: absoluteString) else { return nil}
        compents.scheme = "http"
        return compents.url
    }
}
