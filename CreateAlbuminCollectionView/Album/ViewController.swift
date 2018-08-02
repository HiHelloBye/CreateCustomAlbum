import UIKit
import Photos

extension Int {
    var stringValue:String {
        return "\(self)"
    }
}

class ViewController: UIViewController,PHPhotoLibraryChangeObserver {

    @IBOutlet weak var collectionView: UICollectionView!
   
    let imageManager        = PHCachingImageManager()
    var previousPreheatRect = CGRect.zero
    
    let photoManager = PhotoManager()
    let albumManager = AlbumManager()
    
    var userAlbums:PHFetchResult
        = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
    var collection:NSMutableArray!
    
    var bool:Bool = false

    override func viewDidLoad() {
        
        collectionView.dataSource = self
        collectionView.delegate   = self
        

        super.viewDidLoad()
        PHPhotoLibrary.shared().register(self)

        let photos = PHPhotoLibrary.authorizationStatus()
        
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                  
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } else {}
            })
        }
        
        // nibName is .swift file name
        let nibName = UINib(nibName: "CollectionViewCell", bundle: nil)
        // specific identifier
        collectionView.register(nibName, forCellWithReuseIdentifier: "collectionCell")
        
        //MARK:NavigationItem
        // for create custom album
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCustomAlbum))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //create custom album
    @objc func addCustomAlbum() {
        let alert = UIAlertController(title: "New Album", message: "please set new album name", preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title:"OK", style: .default)
        { (alertAction) in
            let customAlbumName = alert.textFields![0] as UITextField
            
            self.albumManager.createAlbum(albumName: customAlbumName.text!)
            
            if self.albumManager.fail == 0 as Int {
                let alert:UIAlertController = self.createSimpleAlert(title: "Fail", message: "Album with same name exists")
                self.present(alert, animated: true, completion: nil)
                
            }            
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "new album name"
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // for create album
    func createSimpleAlert (title:String, message:String) -> UIAlertController {
        
        let alert:UIAlertController  = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        return alert
    }
}

extension ViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userAlbums.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        
        let collection = userAlbums[indexPath.row]
       
        let title:String = collection.localizedTitle!
        
        let assetsFetchResult = PHAsset.fetchAssets(in: collection, options: nil)
        let asset = assetsFetchResult.lastObject

        
        if assetsFetchResult.count != 0 {
            bool = true
        }
        
        //if there is photo in album set count or "0"
        let count:String = bool ? assetsFetchResult.count.stringValue : "0"
        
        if asset != nil {
            cell.imageView.image = photoManager.getAssetThumbnail(asset: asset!, width: 200, height: 200)
        }
        
        //AlbumName
        cell.albumName.text = title
        //Photo count in specific album
        cell.count.text = count

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 243)
    }
    
    func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
    
    // change observe
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.sync {
            guard let changes = changeInstance.changeDetails(for: userAlbums)
                else { return }
            
            userAlbums = changes.fetchResultAfterChanges
            
            if changes.hasIncrementalChanges {
                guard let collectionView = self.collectionView else {
                    fatalError()
                }
                collectionView.performBatchUpdates({
                    if let inserted = changes.insertedIndexes, inserted.count > 0 {
                        collectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
                    }
                    if let changed = changes.changedIndexes, changed.count > 0 {
                        collectionView.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    changes.enumerateMoves { fromIndex, toIndex in
                        collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                to: IndexPath(item: toIndex, section: 0))
                    }
                })
            }
            else {
                collectionView!.reloadData()
            }
            resetCachedAssets()
        }
    }
}

