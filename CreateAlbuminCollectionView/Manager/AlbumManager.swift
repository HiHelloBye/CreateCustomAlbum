import Foundation
import Photos

class AlbumManager {
        
    var albumName:String!
    var fail:Int!
    
    var assetsCollection:PHAssetCollection!
    
    func createAlbum(albumName:String) {
        let album = ViewController()
        
        for i in 0 ..< album.userAlbums.count {
            if albumName == album.userAlbums.object(at: i).localizedTitle  {

                self.fail = 0
                print("Album with same name exists")
                
                return
                
            }
        }
        
        func fetchAssetsCollectionForAlbum() -> PHAssetCollection! {
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
            
            let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            
            if let _: AnyObject = collection.firstObject {
                return collection.firstObject! as PHAssetCollection
            }
            
            return nil
        }
        
        if let assetCollection = fetchAssetsCollectionForAlbum() {
            self.assetsCollection = assetCollection
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
        }) { success, _ in
            if success {
                self.assetsCollection = fetchAssetsCollectionForAlbum()
            }
        }
        
        return
    }
}
