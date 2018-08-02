import Foundation
import Photos

class PhotoManager {
    
    let fetchOptions:PHFetchOptions = PHFetchOptions()
    
    //MARK: getCameraRoll
    func getCameraRoll() -> PHAssetCollection{
        let albums: PHFetchResult<PHAssetCollection>  =
            PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any , options: fetchOptions)
        
        for i in 0 ..< albums.count {
            
            let assetCollection:PHAssetCollection = albums[i]
            
            if assetCollection.localizedTitle == "Camera Roll" {
                return assetCollection
            }
            
            //print(assetsFetchResult.count) //앨범에 들은 사진 개수
        }
        return PHAssetCollection()
    }
    //end_of_getCameraRoll
    
    // MARK: getThumbnail
    func getAssetThumbnail(asset: PHAsset, width:Int, height:Int) ->UIImage {
        
        let manager   = PHImageManager.default()
        let option    = PHImageRequestOptions()
        var thumbnail = UIImage()
        
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: width, height: height), contentMode: .aspectFit, options: option, resultHandler: {(result, info) -> Void in
            thumbnail = result!
        })
        return thumbnail
    }
    //end_of_getThumbnail
 
    //MAKR:getAlbumByAlbumName
    func getAlbumByAlbumName(name:String) -> PHAssetCollection {
        
        let fetchOptions:PHFetchOptions = PHFetchOptions()
        let albums: PHFetchResult       = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        var assetCollection:PHAssetCollection?
        
        for i in 0 ..< albums.count {
            assetCollection  = albums[i]
            
            if assetCollection == nil {
                return PHAssetCollection()
            }
            else if assetCollection?.localizedTitle == name {
                return assetCollection!
            }
        }
        
        return PHAssetCollection()
    }
}

