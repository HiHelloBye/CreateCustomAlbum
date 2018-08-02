# CreateCustomAlbum
Create Custom Album in UICollectionView

<img src = "https://user-images.githubusercontent.com/28393778/43570357-11ac9926-9675-11e8-9bc6-bc7d12bb9f26.gif" width="250" height="450"  />

For create custom album in app
**click navigation right bar buttom (+ button)**

To avoid albums of the same name
I write this code 

This is a normal paragraph:
    
    for i in 0 ..< album.userAlbums.count {
        if albumName == album.userAlbums.object(at: i).localizedTitle  {

        self.fail = 0
        print("Album with same name exists")

        return

        }
    }

If you want to allow this just **delete** this code 

