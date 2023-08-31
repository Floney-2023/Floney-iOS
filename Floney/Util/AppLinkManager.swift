//
//  AppLinkManager.swift
//  Floney
//
//  Created by 남경민 on 2023/08/30.
//

import Foundation
import AppsFlyerLib
class AppLinkManager: ObservableObject {
    static let shared = AppLinkManager() // 싱글톤
    @Published var hasDeepLink = false
    @Published var inviteCode: String?
    
    func generateDeepLink(inviteCode: String) -> String {
        // 대시보드에서 Onelink 생성하면 주는 Short Link이다.
        // 예시로 써놨으며, 이 링크 뒤에 OG 태그를 파라미터로 붙이면 된다.
        let baseUrl = "https://floney.onelink.me/ex5G/6yxn0lwq"

        // og 태그에 넣을 데이터들이다.
        //let inviteCode = Keychain.getKeychainValue(forKey: .bookKey)

        // OG태그 데이터를 baseUrl 뒤에 파라미터로 넣는다.
        // 여기서 idx는 링크 클릭했을때 화면이동 시키기 위해서 필요하기 때문에 파라미터로 넘겨주었다.
        let urlToShare: String = "\(baseUrl)?inviteCode=\(inviteCode)"

        // url(string값)에 한글이 들어가 있으면 인코딩 시켜줘야한다.
        // title과 descript에 한글이 들어가있음.
        guard let encodedUrl = urlToShare.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return "no_link"}
        
        return encodedUrl
    }
}
