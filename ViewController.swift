
import UIKit
import Alamofire
import Reachability

class ViewController: UIViewController {
    
    @IBOutlet weak var FirstView: UIView!
    
    @IBOutlet weak var LabelEmail: UILabel!
    
    @IBOutlet weak var LabelPassword: UILabel!
    
    @IBOutlet weak var TxtEmail: UITextField!
    
    @IBOutlet weak var TxtPassword: UITextField!
    
    @IBOutlet weak var Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupReachability()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if let email = TxtEmail.text, !email.isEmpty {
            if isValidEmail(email) {
            } else {
                showAlert(message: "Invalid email format")
                return
            }
        } else {
            showAlert(message: "Email cannot be empty")
            return
        }
        
        if let password = TxtPassword.text, !password.isEmpty {
            if isValidPassword(password) {
                showSuccess(message: "Success! Email and password are valid.")
            } else {
                showAlert(message: "Invalid password format")
                return
            }
        } else {
            showAlert(message: "Password cannot be empty")
            return
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showSuccess(message: String) {
        let successAlert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        successAlert.addAction(okAction)
        present(successAlert, animated: true, completion: nil)
    }
    
    @IBAction func togglePasswordVisibility(_ sender: UIButton) {
        TxtPassword.isSecureTextEntry.toggle()
        let imageName = TxtPassword.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    func setupReachability() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: nil)
        do {
            let reachability = try Reachability()
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func reachabilityChanged(notification: Notification) {
    let reachability = notification.object as! Reachability
    if reachability.connection == .unavailable {
    DispatchQueue.main.async {
            self.showAlert(message: "You are offline. Please check your connection.")
            }
        }
    }
}



