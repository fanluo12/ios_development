//
//  DetailView.swift
//  H4XOR News
//
//  Created by 罗帆 on 7/10/22.
//

import SwiftUI


struct DetailView: View {
    
    let url: String?
    
    var body: some View {
        WebView(urlString: url)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(url: "https://www/google.com")
    }
}


