//
//  PermissionManager.swift
//  Floney
//
//  Created by 남경민 on 2023/06/09.
//

import Foundation
import AVFoundation
import Photos

class PermissionManager : ObservableObject {
    @Published var permissionGranted = false
    
    /**
     * 카메라 권한을 요청합니다.
     */
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted {
                print("Camera: 권한 허용")
            } else {
                print("Camera: 권한 거부")
            }
        })
    }
    /**
     * 앨범 권한을 요청합니다.
     */
    func requestAlbumPermission(){
            PHPhotoLibrary.requestAuthorization( { status in
                switch status{
                case .authorized:
                    print("Album: 권한 허용")
                case .denied:
                    print("Album: 권한 거부")
                case .restricted, .notDetermined:
                    print("Album: 선택하지 않음")
                default:
                    break
                }
            })
        }

    /**
     * 오디오 권한을  요청합니다.
     */
    func requestAudioPermission(){
        AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (granted: Bool) in
            if granted {
                print("Audio: 권한 허용")
            } else {
                print("Audio: 권한 거부")
            }
        })
    }
    
}
