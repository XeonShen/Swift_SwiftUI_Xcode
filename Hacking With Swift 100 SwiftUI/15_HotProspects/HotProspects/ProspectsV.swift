import SwiftUI
import SwiftData
import UserNotifications
import CodeScanner

struct ProspectsV: View {
    
//MARK: - Constants & Vars
    
    //SwiftData
    @Environment(\.modelContext) var modelContext
    @Query(sort: \ProspectsM.name) var prospects: [ProspectsM]
    
    @State private var isShowingScanner = false
    @State private var selectedProspects = Set<ProspectsM>()
    
    //data showing filter
    enum FilterType { case none, contacted, uncontacted }
    let filter: FilterType
    var title: String {
        switch filter {
        case .none: "Everyone"
        case .contacted: "Contacted"
        case .uncontacted: "Uncontacted"
        }
    }
    
//MARK: - Functions
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case . success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            modelContext.insert(
                ProspectsM(name: details[0], emailAddress: details[1], isContacted: false)
            )
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func delete() {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
    }
    
    func addNotification(for prospect: ProspectsM) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            //create a notification
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            //create a date
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            
            //create a trigger
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        //send notification if authorized, otherwise get permission first
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
//MARK: - Initializer
    
    init(filter: FilterType) {
        self.filter = filter
        //the Everyone Page has .none filter, thus it shows all the data
        //the Contacted people page has the .contacted filter, thus only related data will show up
        //the Uncontacted people page has the .uncontacted filter, same as above
        if filter != .none {
            let showContactOnly = filter == .contacted
            _prospects = Query(filter: #Predicate {
                $0.isContacted == showContactOnly
            }, sort: [SortDescriptor(\ProspectsM.name)])
        }
    }
    
//MARK: - Body
    
    var body: some View {
        NavigationStack {
            List(prospects, selection: $selectedProspects) { prospect in
                NavigationLink(destination: ProspectEditV(prospectToEdit: prospect)) {
                    VStack(alignment: .leading) {
                        if filter == .none {
                            if prospect.isContacted == true {
                                Image(systemName: "person.fill")
                            } else {
                                Image(systemName: "person")
                            }
                        }
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAddress)
                            .foregroundStyle(.secondary)
                    }
                }
                
                //create some swipeActions
                .swipeActions {
                    //delete single item
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        modelContext.delete(prospect)
                    }
                    
                    //mark uncontacted
                    if prospect.isContacted {
                        Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.blue)
                    } 
                    
                    //mark contacted & send notification
                    else {
                        Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.green)
                        
                        Button("Remind Me", systemImage: "bell") {
                            addNotification(for: prospect)
                        }
                        .tint(.orange)
                    }
                }
                
                //help Swift understand the VStack and swipeActions above represent a single prospect been selected
                .tag(prospect)
            }
            
            //navigation setting
            .navigationTitle(title)
            
            //Buttons for QRCode scanning, editMode, Delete multiple items
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Scan", systemImage: "qrcode.viewfinder") {
                        isShowingScanner = true
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                if selectedProspects.isEmpty == false {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Delete Selected", action: delete)
                    }
                }
            }
            
            //QRCode scanning sheet
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
            }
        }
    }
}

//MARK: - Preview

#Preview {
    ProspectsV(filter: .none)
        .modelContainer(for: ProspectsM.self)
}
