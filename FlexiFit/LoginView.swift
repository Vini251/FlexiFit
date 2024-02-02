import SwiftUI


struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var isLoggedIn: Bool
    
    
    var body: some View {
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
                
                // Sign In / Sign Up Button
                Button(action: {
                    // Perform login logic here
                    // For demonstration, always set isLoggedIn to true
                    isLoggedIn = true
                }) {
                    Text("Sign In / Sign Up")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider{
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false))
    }
}
