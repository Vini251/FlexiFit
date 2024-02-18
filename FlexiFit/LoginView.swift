import SwiftUI


struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    //@Binding var isLoggedIn: Bool
    
    
    var body: some View {
        //NavigationView(){
            VStack {
                Text("FlexiFit")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 50)
                
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                VStack(spacing: 20) {
                    // Email Input Field
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.black)
                        TextField("Email", text: $email)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(7)
                    }
                    
                    // Password Input Field
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.black)
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    NavigationLink(destination: ContentView()){
                        LoginButtonContent()
                        
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
        }
        .padding()
    }
}

#Preview{
    LoginView()
}
