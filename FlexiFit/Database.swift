import Foundation
import Firebase
import FirebaseFirestoreSwift

let db = Firestore.firestore()

func createUser(userEmail: String,  completion: @escaping (Error?) -> Void) {
    let collection = "User"
    let document = userEmail
    
    let docRef = db.collection(collection).document(document)
    
    docRef.getDocument { documentSnapshot, error in
        if let error = error {
            print("Error fetching document: \(error)")
            completion(error)
            return
        }
        
        if let document = documentSnapshot, document.exists {
            // Document exists
            completion(nil)
        } else {
            // Document doesn't exist, create it
            let userData: [String: Any] = [
                "City": "Irvine",
                "DOB": "01_01_2000",
                "Email": userEmail,
                "Gym": true,
                "Preference": 0
            ]
            
            docRef.setData(userData) { error in
                if let error = error {
                    print("Error uploading: \(error)")
                    completion(error)
                } else {
                    print("Uploaded")
                    completion(nil)
                }
            }
        }
    }
}




func updateUserInfo(userEmail: String, fieldName: String, value: Any, completion: @escaping (Error?) -> Void) {
    let collection = "User"
    let document = userEmail
    let db = Firestore.firestore()
    let docRef = db.collection(collection).document(document)
    

    
    
    let updateField: [String: Any] = [fieldName: value]
    

    docRef.updateData(updateField) { error in
        completion(error)
    }


}


func createStats(userEmail: String, date: String, completion: @escaping (Error?) -> Void) {
    let statsCollection = "Stats"
    let documentID = date
    
    let statsDocumentRef = db.collection("User").document(userEmail).collection(statsCollection).document(documentID)
    

    statsDocumentRef.getDocument { documentSnapshot, error in
        if let error = error {
            print("Error fetching document: \(error)")
            completion(error)
            return
        }
        
        if let _ = documentSnapshot, documentSnapshot!.exists {
            print("Document Exists")
            completion(nil)
        } else {

            let initialStats: [String: Any] = [
                "ActiveCalories": 0,
                "CaloriesConsumed":0,
                "CardioMinutes": 0,
                "Height": 0,
                "Score": 0,
                "SleepTime": 0,
                "Steps": 0,
                "Weight": 0
            ]
            
            statsDocumentRef.setData(initialStats) { error in
                if let error = error {
                    print("Error creating document: \(error)")
                    completion(error)
                } else {
                    // Document created successfully
                    completion(nil)
                }
            }
        }
    }
}



func updateStatsForDate(userEmail: String, date: String, fieldName: String, value: Any, completion: @escaping (Error?) -> Void) {
    
    let db = Firestore.firestore()
    let statsRef = db.collection("User").document(userEmail).collection("Stats").document(date)
    
    
    let updateData: [String: Any] = [fieldName: value]
    

    statsRef.updateData(updateData) { error in
        completion(error)
    }
}
func getCurrentDate() -> String {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM_dd_yyyy"
    let dateString = dateFormatter.string(from: currentDate)
    return dateString
}
