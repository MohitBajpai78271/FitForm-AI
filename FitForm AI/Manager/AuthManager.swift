import Foundation
import FirebaseAuth
import GoogleSignIn
import Firebase

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
     @Published var isSignedIn = false
     @Published var userName: String = ""
     @Published var email: String = ""
     @Published var profilePhotoURL: URL?
     @Published var uid: String = ""
     
     init() {
         if let user = Auth.auth().currentUser {
             self.isSignedIn = true
             self.userName = user.displayName ?? ""
             self.email = user.email ?? ""
             self.profilePhotoURL = user.photoURL
             self.uid = user.uid
         }else {
             self.isSignedIn = false
         }
     }
     
    func signInWithGoogle(presentingViewController: UIViewController) {
       let clientID =  "979895248649-2rpgqccqrve49ds62hqq7cc3ssplb2ji.apps.googleusercontent.com"
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] result, error in
            guard error == nil else {
                print("Error during sign-in: \(error!.localizedDescription)")
                if let nsError = error as NSError? {
                    print("Error Code: \(nsError.code), \(nsError.localizedDescription)")
                }
                return
            }
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                print("Error: User or ID token is missing")
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let error = error {
                    print("Error during Firebase sign-in: \(error.localizedDescription)")
                    return
                }
                guard let self = self else { return }
                               self.isSignedIn = true
                               self.userName = authResult?.user.displayName ?? "No Name"
                               self.email = authResult?.user.email ?? "No Email"
                               self.profilePhotoURL = authResult?.user.photoURL
                               self.uid = authResult?.user.uid ?? ""
                               
                               print("Successfully signed in with Firebase")
                               print("Name: \(self.userName), Email: \(self.email), UID: \(self.uid), Photo URL: \(self.profilePhotoURL?.absoluteString ?? "No URL")")
            }
        }

    }
    
    // Method to sign out
    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            DispatchQueue.main.async {
                self.isSignedIn = false
                print("Successfully signed out")
            }
        } catch {
            print("Error during sign-out: \(error.localizedDescription)")
        }
    }
}
