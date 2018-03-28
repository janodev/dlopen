import UIKit

class ViewController: UIViewController
{
    private let theView = View()
    
    override func loadView() {
        view = theView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateLabel("Animating circle")
        theView.animateCircle(duration: 6)
        
        updateLabel("Loading frameworks")
        self.loadFrameworks()
    }
    
    func loadFrameworks(){
        updateLabel("Frameworks loading ---------")
        let loadQueue = DispatchQueue(label: "loadQueue")
        let waitQueue = DispatchQueue(label: "waitQueue")
        
        var busyCount = 0
        var totalCount = 0
        var totalCountWithPauses = 0
        let pauseMs = 700
        let busyThreshold = 200
        
        let semaphore = DispatchSemaphore(value: 1)
        let wait:(Int)->() = { waitMs in
            self.log(message: "wait 700ms")
            waitQueue.asyncAfter(deadline: DispatchTime.now() + .milliseconds(waitMs), execute: {
                semaphore.signal()
            })
            semaphore.wait()
        }
        
        loadQueue.async {
            let count = ViewController.frameworks.count - 1
            for i in 1...count {
                let name = ViewController.frameworks[i]
                let ms = ViewController.measureMillisecondsForTask {
                    dlopen("\(name).framework/\(name)", RTLD_LAZY)
                }
                self.updateLabel(String(format: "%02dms  %02d/%d %@", ms, i, count, name))
                busyCount = busyCount + Int(ms)
                totalCount = totalCount + Int(ms)
                totalCountWithPauses = totalCountWithPauses + Int(ms)
                if busyCount > busyThreshold {
                    wait(pauseMs)
                    totalCountWithPauses = totalCountWithPauses + pauseMs
                    busyCount = max(busyCount - pauseMs, 0)
                }
            }
            self.log(message: "Loading time: \(totalCount)")
            self.log(message: "Loading time plus pauses: \(totalCountWithPauses)")
        }
    }

    private func log(message: String){
        DispatchQueue.main.async {
            print(message)
        }
    }
    
    private func updateLabel(_ status: String){
        DispatchQueue.main.async {
            self.theView.update(status: status)
        }
        log(message: status)
    }
    
    private static func measureMillisecondsForTask(_ task: ()->()) -> UInt64 {
        let start = DispatchTime.now()
        task()
        let end = DispatchTime.now()
        return (end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000
    }
    
    private static let frameworks = [
        "AirshipAppExtensions",
        "AirshipKit",
        "Bolts",
        "BoltsSwift",
        "Braintree3DSecure",
        "BraintreeAmericanExpress",
        "BraintreeApplePay",
        "BraintreeCard",
        "BraintreeCore",
        "BraintreeDataCollector",
        "BraintreePayPal",
        "BraintreePaymentFlow",
        "BraintreeUI",
        "BraintreeUnionPay",
        "BraintreeVenmo",
        "FBSDKCoreKit",
        "FBSDKLoginKit",
        "FBSDKPlacesKit",
        "FBSDKShareKit",
        "FacebookCore",
        "FacebookLogin",
        "FacebookShare",
        "Koloda",
        "Locksmith",
        "MMMaterialDesignSpinner",
        "NVActivityIndicatorView",
        "ObjectMapper",
        "PayPalDataCollector",
        "PayPalOneTouch",
        "PayPalUtils",
        "Realm",
        "RealmSwift",
        "SVProgressHUD",
        "Stripe",
        "pop"
    ]
}
