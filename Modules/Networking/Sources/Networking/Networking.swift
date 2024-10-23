public protocol INetworkService: IChatGPTAPI { }

public final class NetworkService {
    public let chatGPTAPI: IChatGPTAPI
    
    public init() {
        self.chatGPTAPI = ChatGPTAPI()
    }
}
